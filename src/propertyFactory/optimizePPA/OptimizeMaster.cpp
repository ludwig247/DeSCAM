//

#include "OptimizeMaster.h"

SCAM::OptimizeMaster::OptimizeMaster(const std::map<int, State *> &stateMap, SCAM::Module *module,
                                     const std::map<Operation *, SCAM::Path *> &operationPathMap) : module(module) {
//    std::cout << "Optimize Master" << std::endl;
    //Create new states in order to keep the original stateMap
    for (auto state: stateMap) {
        auto new_state = new State(*state.second);
        newStateMap.insert(std::make_pair(state.first, new_state));
    }

    // New states are still pointing to the operations of the old stateMap
    // Create new operations for the new stateMap
    for (auto state: stateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            auto state_new = newStateMap.at(op->getState()->getStateId());
            auto nextState_new = newStateMap.at(op->getNextState()->getStateId());
            auto op_new = new Operation(*op, state_new, nextState_new);
            //Update operationPathMap;
            auto path = operationPathMap.at(op);
            this->operationPathMap.insert(std::make_pair(op_new, path));
        }
    }
    simplify();
}

void SCAM::OptimizeMaster::simplify() {
    while (true) {
        //Continue until non of the states is marked removable
        auto state = findNextStateToRemove();
        if (state == nullptr) break;
        //std::cout << "Merging state:" << state->print() << std::endl;
        mergeOperations(state);
        cleanUpStateMap(state);
    }

    //Sanity check: Are now multiple paths from init possible?
    //Source of error: Use of a shared_in among the path from init to first blocking comm after reset
    for (auto &&state : newStateMap) {
        if (state.second->isInit()) {
            if (state.second->getOutgoingOperationList().size() != 1) {
                std::string number = std::to_string(state.second->getOutgoingOperationList().size());
                for (auto wrong_path: state.second->getOutgoingOperationList()) {
                    std::cout << wrong_path->print() << std::endl;
                }
                throw std::runtime_error(number + " paths from init after optimization possible");
            }
        }
    }
    this->module->getFSM()->setStateMap(this->newStateMap);
    this->module->getFSM()->setOperationPathMap(this->operationPathMap);
}


bool SCAM::OptimizeMaster::isBlockingForwards(SCAM::State *current, SCAM::State *start, std::set<State *> visited) {
    auto interface = current->getCommStmt()->getPort()->getInterface();
    if (current->getCommStmt()->getPort()->getInterface()->isSlave()) {
        return false;
    } else if (current->getCommStmt()->getPort()->getInterface()->isMaster()) {
        //Current already in set?
        if (!visited.insert(current).second) {
            if (current->getCommPort() == start->getCommPort()) {
                return true;
            }
            return false;
        } else {
            if (current != start && current->getCommPort() == start->getCommPort()) return true;
            for (auto op: current->getOutgoingOperationList()) {
                if (isBlockingForwards(op->getNextState(), start, visited)) return true;
            }
            return false;
        }

    } else if (interface->isBlocking()) {
        return false;
    } else {
        throw std::runtime_error("Should not get here");
    }
}

bool SCAM::OptimizeMaster::isBlockingBackwards(SCAM::State *current, SCAM::State *start, std::set<State *> visited) {
    if (current->isInit()) return false;
    auto interface = current->getCommStmt()->getPort()->getInterface();
    if (current->getCommStmt()->getPort()->getInterface()->isSlave()) {
        return false;
    } else if (current->getCommStmt()->getPort()->getInterface()->isMaster()) {
        //Current already in set?
        if (!visited.insert(current).second) {
            if (current->getCommPort() == start->getCommPort()) return true;
            return false;
        } else {
            if (current != start && current->getCommPort() == start->getCommPort())return true;
            for (auto op: current->getIncomingOperationList()) {
                if (isBlockingBackwards(op->getState(), start, visited)) return true;
            }
            return false;
        }
    } else if (interface->isBlocking()) {
        return false;
    } else {
        throw std::runtime_error("Should not get here");
    }
}

SCAM::State *SCAM::OptimizeMaster::findNextStateToRemove() {
    for (auto state: newStateMap) {
        //If state is an always Read port and direction == out
        //Check whether there is a loop to the state without reaching a control state on any other path
        if (state.second->isInit()) continue;
        auto interface = state.second->getCommPort()->getInterface();
        if (interface->isMaster()) {
            bool isMergeAble = !isBlockingForwards(state.second, state.second, std::set<State *>()) &&
                               !isBlockingBackwards(state.second, state.second, std::set<State *>());
            //std::cout << state.second->print() << " is  " << isMergeAble << std::endl;
            if (isMergeAble) return state.second;
        }
    }
    return nullptr;
}

void SCAM::OptimizeMaster::mergeOperations(SCAM::State *state) {
    for (auto op_in: state->getIncomingOperationList()) {
        for (auto op_out: state->getOutgoingOperationList()) {

            //std::cout << "Merge: " << op_in->getOp_id() << "," << op_out->getOp_id() << std::endl;
            //Create a new path with stmts from the incoming + outgoing paths
            Path *newPath = new Path(op_in->getState()->getSection());
            Path *p1 = this->operationPathMap.at(op_in);
            Path *p2 = this->operationPathMap.at(op_out);
            auto commCond1 = p1->getCommunicationConditionList();
            auto commCond2 = p2->getCommunicationConditionList();
            commCond1.insert(commCond1.end(), commCond2.begin(), commCond2.end());
            newPath->setCommunicationConditionList(commCond1);
            newPath->setSubSection(p1->getSubState());
            newPath->setNextSection(p2->getNextSection());
            newPath->setSubNext(p2->getSubNext());
            for (auto stmt: p1->getStmtList()) newPath->addStmt(stmt);
            for (auto stmt: p2->getStmtList()) newPath->addStmt(stmt);

            //Propertaget values and optimize
            ValuePropagation valuePropagation = ValuePropagation(this->module);
            valuePropagation.propagatePath(newPath);
            ConditionOptimizer::optimize(newPath, this->module);
            DataPathOptimizer::optimize(newPath, this->module);

            //Mark op_in and op_out for deletion from the state
            this->opertations_for_deleting.insert(op_in);
            this->opertations_for_deleting.insert(op_out);
            //It's possible to create unreachable paths, those should not be added as an operation
            if (!SCAM::CleanUpPaths::isPathUnreachable(newPath)) {
                //Add communication to start state
                this->addOperations.push_back(
                        std::make_pair(newPath, std::make_pair(op_in->getState(), op_out->getNextState())));
            }
        }
    }
}

void SCAM::OptimizeMaster::cleanUpStateMap(SCAM::State *state) {
    //Remove marked operations from the states
    for (auto op: this->opertations_for_deleting) {
        op->getState()->removeOutgoingOperation(op);
        op->getNextState()->removeIncomingOperation(op);
    }
    //Add new operations to the state
    for (auto make: this->addOperations) {
        Operation *newOp = new Operation(make.second.first, make.second.second);
        this->operationPathMap.insert(std::make_pair(newOp, make.first));
        for (auto cond: make.first->getConditionList()) {
            newOp->addAssumption(cond);
        }
        for (auto stmt: make.first->getDataPathList()) {
            newOp->addCommitment(stmt);
        }
        for (auto stmt: make.first->getCommunicationConditionList()) {
            newOp->addAssumption(stmt);
        }
    }
    //State is removed from the state map (all operations from and to this are already removed -> unreachable)
    this->newStateMap.erase(state->getStateId());

    // Clean up lists
    this->opertations_for_deleting.clear();
    this->addOperations.clear();

}


const std::map<int, SCAM::State *> &SCAM::OptimizeMaster::getNewStateMap() const {
    return newStateMap;
}

const std::map<SCAM::Operation *, SCAM::Path *> &SCAM::OptimizeMaster::getOperationPathMap() const {
    return operationPathMap;
}


