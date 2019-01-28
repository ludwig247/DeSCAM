//
// Created by tobias on 20.09.17.
//

#include <queue>
#include <stack>
#include <list>
#include <algorithm>
#include "OptimizeSlave.h"

SCAM::OptimizeSlave::OptimizeSlave(const std::map<int, State *> &stateMap, SCAM::Module *module,
                                   const std::map<Operation *, SCAM::Path *> &operationPathMap) :
        newStateMap(stateMap),
        operationPathMap(operationPathMap),
        module(module) {
    std::cout << "Optimize Slave" << std::endl;
    if (isSlave()) {
        //Module definition
        if (!checkModuleIO()) throw std::runtime_error("Module is only allowed to be either slave_in,slave_out,master_in,master_out");
        //All slaves have to be used
        if (!allSlavesUsed()) throw std::runtime_error("All slave ports of the module have to be used within behavioral description");

        //Check whether implementation follows the rules for MasterSlave components
        for (auto &&item :stateMap) {
            if (!item.second->isInit() && item.second->getCommPort()->getInterface()->isSlave()) {
                if (!sequenceCheck(item.second, item.second, {}, {})) {
                    std::string msg = "Sequence starting from state: " + item.second->print();
                    msg += "is not following the requirments for using slave ports";
                    throw std::runtime_error(msg);
                }
            }
        }
        //Merge sequences together in one state
        mergeSequences(this->findInputSequences());

        //Remove unreachable states
        cleanUpStateMap();
    }

    this->module->getFSM()->setStateMap(this->newStateMap);
    this->module->getFSM()->setOperationPathMap(this->operationPathMap);

}

void SCAM::OptimizeSlave::cleanUpStateMap() {
    std::set<SCAM::State *> states_for_deleting;
    for (auto state: this->newStateMap) {
        if (state.second->isInit()) continue;
        if (state.second->getIncomingOperationList().empty()) {
            states_for_deleting.insert(state.second);
        }
    }
    for (auto &&state_del : states_for_deleting) {
        this->newStateMap.erase(state_del->getStateId());
    }
}

/**
 * @param stateMap
 * @param module
 * @return true, if all slave_ports of the modules are used
 *
 */
bool SCAM::OptimizeSlave::allSlavesUsed() const {
    for (auto port: module->getPorts()) {
        if (!port.second->getInterface()->isSlave()) continue;
        bool isCorrect = false;
        for (auto state: newStateMap) {
            if (state.second->isInit()) continue;
            if (state.second->getCommPort() == port.second) {
                isCorrect = true;
                break;
            }
        }
        if (!isCorrect) return false;
    }
    return true;
}

/**
 * @brief Checks, whether no slave port is used twice in a sequence
 * @param current
 * @param start
 * @param visitedStates
 * @param visitedPorts
 * @return true, if module is correctly implemented
 */
bool SCAM::OptimizeSlave::sequenceCheck(State *current, State *start, std::set<State *> visitedStates, std::set<Port *> visitedPorts) {

    auto interface = current->getCommPort()->getInterface();
    //Blocking read/write -> false
    if (interface->isBlocking()) return false;
        //If master is present this means the state needs to remain -> reading in every cycle is not possible
    else if (interface->isMaster()) return false;

    else if (interface->isSlave()) {
        //Among all paths between two communication states for a slave port each other slave port is only allowed to be used once
        if (current->getCommPort() != start->getCommPort()) {
            //If port is already used among the path -> return false
            if (!visitedPorts.insert(current->getCommPort()).second) return false;
        }
    } else throw std::runtime_error("Unknown interface: " + interface->getName());

    //Stop if state is visited twice
    if (current == start) {
        //First call of checkInput: visitedStates is empty
        if (!visitedStates.insert(current).second) return true;
    } else {
        //Catches loops
        if (!visitedStates.insert(current).second) return false;
        else if (current->getCommPort() == start->getCommPort()) return true;
    }
    //Continue with successorss
    for (auto outgoing: current->getOutgoingOperationList()) {
        if (!sequenceCheck(outgoing->getNextState(), start, visitedStates, visitedPorts)) return false;
    }
    return true;
}

/**
 * @return module is only allowed to be either slave_in or slave_out
 */
bool SCAM::OptimizeSlave::checkModuleIO() const {
    for (auto port: module->getPorts()) {
        if (port.second->getInterface()->isBlocking()) return false;
    }
    return true;
}

const std::map<int, SCAM::State *> &SCAM::OptimizeSlave::getNewStateMap() const {
    return newStateMap;
}

void SCAM::OptimizeSlave::mergeStateIntoNextstate(SCAM::State *pState) {
    //std::cout << "Merging ... " + pState->print() << std::endl;

    std::set<Operation *> opertations_for_deleting;
    std::vector<std::pair<Path *, std::pair<State *, State *> > > addOperations;

    for (auto outgoing: pState->getOutgoingOperationList()) {
        auto nextstate = outgoing->getNextState();
        for (auto outgoing_nextstate: nextstate->getOutgoingOperationList()) {
            //std::cout << "Merge: " << op_in->getOp_id() << "," << op_out->getOp_id() << std::endl;
            //Create a new path with stmts from the incoming + outgoing paths
            Path *newPath = new Path(pState->getSection());
            Path *p1 = this->operationPathMap.at(outgoing);
            Path *p2 = this->operationPathMap.at(outgoing_nextstate);
            auto commCond1 = p1->getCommunicationConditionList();
            auto commCond2 = p2->getCommunicationConditionList();
            commCond1.insert(commCond1.end(), commCond2.begin(), commCond2.end());
            newPath->setCommunicationConditionList(commCond1);
            //Nextstate: If selfloop: p1->p1, p1->p2 otherwise
            newPath->setSubSection(p1->getSubState());
            newPath->setNextSection(p2->getNextSection());
            newPath->setSubNext(p2->getSubNext());

            for (auto stmt: p1->getStmtList()) newPath->addStmt(stmt);
            for (auto stmt: p2->getStmtList()) newPath->addStmt(stmt);

            //Propertaget values and optimize
            ValuePropagation valuePropagation = ValuePropagation(this->module);
            valuePropagation.propagatePath(newPath);
            newPath = ConditionOptimizer::optimize(newPath, this->module);
            newPath = DataPathOptimizer::optimize(newPath, this->module);

            //Mark op_in and op_out for deletion from the state
            opertations_for_deleting.insert(outgoing);
            opertations_for_deleting.insert(outgoing_nextstate);
            //It's possible to create unreachable paths, those should not be added as an operations
            if (!SCAM::CleanUpPaths::isPathUnreachable(newPath)) {
                for (auto commStmt: nextstate->getCommStmtSet()) {
                    pState->addCommStmt(commStmt);
                }
                addOperations.push_back(std::make_pair(newPath, std::make_pair(pState, outgoing_nextstate->getNextState())));
            }
        }
    }
    cleanUp(opertations_for_deleting, addOperations);


}

void SCAM::OptimizeSlave::cleanUp(const std::set<SCAM::Operation *> &opertations_for_deleting,
                                  const std::vector<std::pair<SCAM::Path *, std::pair<SCAM::State *, SCAM::State *>>> &addOperations) {
    //Remove marked operations from the states
    for (auto op: opertations_for_deleting) {
        op->getState()->removeOutgoingOperation(op);
        op->getNextState()->removeIncomingOperation(op);
    }
    //Add new operations to the state
    for (auto make: addOperations) {
        SCAM::Operation *newOp = new SCAM::Operation(make.second.first, make.second.second);
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
}

/** \brief computes the operation sequences
 *
 * Nextstate of init operation is the first communication.
 * From here on the first sequence of shared inputs/outputs is computed until the intial input is reached.
 * Assume we start with an input s1, followed by an shared output s2 and input s3.
 * After s3 is read, the next operation has to be s1 again.
 * Either it's the inital s1 or the start of a new sequence.
 * If all paths lead to the inital s1, we are done the operationSequence vector will have one entry with (s1,s2,s3)
 * If this is not the case there will be an entry for each possible trace in the operation Sequence,
 * A sequence will always start with s1 and end with s3
 */
std::vector<std::vector<SCAM::State *>> SCAM::OptimizeSlave::findInputSequences() {
    //Find inital operation
    assert(this->newStateMap.find(-1) != this->newStateMap.end() && "Init not part of statemap!");
    auto initalOperation = this->newStateMap.at(-1)->getOutgoingOperationList().front();
    assert(initalOperation != nullptr && "Init Operation is null!");


    std::list<State *> stack;
    std::set<State *> visited;
    std::vector<State *> sequence; //Current sequence of states
    std::vector<std::vector<State *> > sequenceList; //Stores all possible sequecnes

    //Initial communication is:
    auto initalState = initalOperation->getNextState();
    auto initalSlavePort = findSlavePort(initalState);
    stack.push_front(initalState);
    visited.insert(initalState);

    //Iterative DFS
    while (!stack.empty()) {
        auto source = stack.front();
        stack.pop_front();
        auto source_port = findSlavePort(source);
        //
        if (source_port == initalSlavePort) {
            sequenceList.push_back(sequence);
            sequence.clear();
        }
        sequence.push_back(source);

        for (auto op: source->getOutgoingOperationList()) {
            if (visited.find(op->getNextState()) == visited.end()) {
                visited.insert(op->getNextState());
                stack.push_front(op->getNextState());
            }
        }
    }
    //Last sequence is not stored, yet.
    sequenceList.push_back(sequence);

    //First item is always the empty list, because the first source is the initalState and thus the sequence is pushed
    sequenceList.erase(sequenceList.begin());
    if (!isEverySequenceCorrect(sequenceList)) {
        int i = 0;
        std::cout << "Port after reset:" << initalSlavePort->getName() << std::endl;
        for (auto sequecne: sequenceList) {
            std::cout << "SEQ" << i << ":" << std::endl;
            i++;
            for (auto comm: sequecne) {
                std::cout << "\t" << comm->getCommPort()->getName() << std::endl;
            }
        }
        throw std::runtime_error("Slave ports have to be always read/writen in the same order!");
    }
    return sequenceList;

}


SCAM::Port *SCAM::OptimizeSlave::findSlavePort(SCAM::State *state) const {
    assert(state->getCommStmt()->getPort() != nullptr && "State without port, probably INIT");
    for (auto commStmt: state->getCommStmtSet()) {
        if (commStmt->getPort()->getInterface()->isSlave()) return commStmt->getPort();
    }
    throw std::runtime_error("No slave port found!");
}

//! Sequences must follow exactly the same port ordering
bool SCAM::OptimizeSlave::isEverySequenceCorrect(const std::vector<std::vector<SCAM::State *>> &sequenceList) const {
    assert(sequenceList.size() != 0 && "SequenceList is empty");
    auto sequence_base = sequenceList.at(0);
    for (int i = 1; i < sequenceList.size(); ++i) {
        auto sequence_step = sequenceList.at(i);
        if (sequence_base.size() != sequence_step.size()) return false;
        for (int j = 0; j < sequence_base.size(); ++j) {
            auto slave1 = findSlavePort(sequence_base.at(j));
            auto slave2 = findSlavePort(sequence_step.at(j));
            if (slave1 != slave2) {
                return false;
            }
        }
    }

    /*
    std::cout << "sequence list: size " << sequenceList.size() << std::endl;
    for (auto sequence1: sequenceList) {
        std::cout << "outer" << std::endl;
        for (auto sequence2: sequenceList) {
            std::cout << "inner" << std::endl;
            for (int i = 0; i < sequence1.size(); ++i) {
                std::cout << "inner inner " << std::endl;
                if (sequence1.size() > sequence2.size()) return false;
                auto slave1 = findSlavePort(sequence1.at(i));
                auto slave2 = findSlavePort(sequence2.at(i));
                std::cout << "not stuck" << std::endl;
                if (slave1 != slave2) {
                    return false;
                }
            }
        }
    }
    */
    return true;
}


//! For every sequece a new state has to be created and all operations within the sequence have to be merged together.
void SCAM::OptimizeSlave::mergeSequences(const std::vector<std::vector<SCAM::State *>> &sequenceList) {
    for (auto sequence: sequenceList) {
        auto first_state = sequence.front();
        for (int i = 0; i < sequence.size() - 1; i++) {
            mergeStateIntoNextstate(sequence.front());
        }
    }
}

bool SCAM::OptimizeSlave::isSlave() const {
    for (auto port: module->getPorts()) {
        if (port.second->getInterface()->isSlave()) return true;
    }
    return false;
}

