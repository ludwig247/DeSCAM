//
// Created by tobias on 31.01.20.
//

#include <CreatePropertySuite.h>
#include <ExprVisitor.h>
#include "TrueOperation.h"
#include <algorithm>
#include "FatalError.h"
#include "Logger/Logger.h"


SCAM::TrueOperation::TrueOperation(SCAM::Module const *module) :
//stateMap(module->getFSM()->getStateMap()),
        module(module) {
    //Step 1: find all cycles starting from the start state
    auto start = this->getStartState(module->getFSM()->getStateMap());
    findCylces(start, start, {});
    //std::cout << printCycles() << std::endl;

    //Step 2: create "composed" PropertySuite
    //TODO: next step add timepoints to freezevars
    //createPropertySuite();
    //TODO: check output with hardware
}

const std::vector<std::vector<const SCAM::Operation *>> &SCAM::TrueOperation::getCycleMap() const {
    return cycleMap;
}


void SCAM::TrueOperation::setRightHook() {

}

void SCAM::TrueOperation::findCylces(State *current, State *start, const std::vector<const Operation *> &opList) {
    this->loop_detection++;
    if (this->loop_detection == 0xFFFF - 1) TERMINATE(" loop "); //TODO: show trace of loop
    for (auto operation: current->getOutgoingOperationsList()) {
        if (operation->IsWait()) continue;
        auto newOpList = opList;
        newOpList.push_back(operation);
        if (operation->getNextState() == start) {
            this->cycleMap.push_back(newOpList);
        } else findCylces(operation->getNextState(), start, newOpList);
    }
    return;
}

SCAM::State *SCAM::TrueOperation::getStartState(const std::map<int, State *> &stateMap) const {
    //Init state should always be index 0
    State *initState = stateMap.at(0);
    assert(initState->getName() == "init_0" && "Wrong state");
    return initState->getOutgoingOperationsList().back()->getNextState();
}

std::string SCAM::TrueOperation::printCycles() const {

    std::stringstream ss;
    int i = 0;
    for (const auto &cycle : cycleMap) {
        ss << "Cycle #" << i++ << std::endl;
        int j = cycle.size() - 1;
        for (auto op: cycle) {
            ss << "op_" << op->getId() << "[" << op->getState()->getName() << ":" << op->getNextState()->getName() << "]";
            if (j-- != 0) {
                ss << "->";
            } else {
                ss << std::endl;
            }
        }
    }
    return ss.str();
}

const std::set<SCAM::SyncSignal *> &SCAM::TrueOperation::getSyncSignals() const {
    return syncSignals;
}

const std::set<SCAM::Variable *> &SCAM::TrueOperation::getVariables() const {
    return variables;
}

const std::set<SCAM::DataSignal *> &SCAM::TrueOperation::getDataSignals() const {
    return dataSignals;
}

void SCAM::TrueOperation::findFreezeVars(std::vector<const Operation *> cycle) {
    //Reset everything from previos operations
    this->variablesTimepoints.clear();
    this->variables.clear();
    this->dataSignalsTimepoints.clear();
    this->dataSignals.clear();
    this->syncSignalTimepoints.clear();
    this->syncSignals.clear();
    //Find all free vars for this cycle
    for (auto op: cycle) {
        for (auto &&assignment : op->getCommitmentsList()) {
            //Sync signals
            auto newSyncSignals = ExprVisitor::getUsedSynchSignals(assignment->getRhs());
            syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
            for (auto signal: newSyncSignals) {
                syncSignalTimepoints.insert(std::make_pair(signal, op->getState()));
            }

            //Datasignals
            auto newDataSignals = ExprVisitor::getUsedDataSignals(assignment->getRhs());
            dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
            for (auto signal: newDataSignals) {
                dataSignalsTimepoints.insert(std::make_pair(signal, op->getState()));
            }
            auto lhsExpr = *ExprVisitor::getUsedVariables(assignment->getLhs()).begin();
            if (lhsExpr == nullptr || isRequired(lhsExpr, op, cycle)) {
                if (lhsExpr == nullptr || isRequired2(lhsExpr, op, cycle)) {
                    auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                    for (auto var: newVariables) {
                        variables.insert(var);
                        variablesTimepoints.insert(std::make_pair(var, op->getState()));
                    }
                }
            }
        }
    }
}


/***
 * \brief Algorithm checks whether a visible register is needed for completness or not
 *
 * Algorithm starts at the current operation. If the variable is used in the current or any subsequent operatin, then
 * it is needed for completion, otherwise not.
 *
 * @param var
 * @param currentOperation
 * @param cycle
 * @return
 */
bool SCAM::TrueOperation::isRequired(Variable *var, const Operation *currentOperation, const std::vector<const Operation *> &cycle) {

    //Start iterating from currentOperation
    auto it = std::find(begin(cycle), end(cycle), currentOperation);

    //Iterate through set and search for usages of the variable
    for (auto iterator = it; iterator != cycle.end(); ++iterator) {
        for (auto assignment: (*iterator)->getCommitmentsList()) {
            if (PrintStmt::toString(assignment->getLhs()) == var->getFullName()) {
                auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                const bool isInSet = newVariables.find(var) != newVariables.end();
                const bool isEqual = *assignment->getRhs() == *assignment->getLhs();
                if (!isInSet or !isEqual) return true;
            }
        }
    }
    return false;
}

bool SCAM::TrueOperation::isRequired2(Variable *const &var, const Operation *op, std::vector<const Operation *> &cycle) {
    //Start iterating from currentOperation

    //Check operation: Is there already an assignment?
    for (auto assignment: op->getCommitmentsList()) {
        if (PrintStmt::toString(assignment->getLhs()) == var->getFullName()) {
            auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
            //const bool isInSet = newVariables.find(var) != newVariables.end();
            const bool isEqual = *assignment->getRhs() == *assignment->getLhs();
            if (!isEqual) {
                return true;
            }
        }
    }
    auto it = std::find(begin(cycle), end(cycle), op)++;

    //Iterate through set and search for usages of the variable
    for (auto iterator = it; iterator != cycle.end(); ++iterator) {
        for (auto assignment: (*iterator)->getCommitmentsList()) {
            if (PrintStmt::toString(assignment->getLhs()) == var->getFullName()) {
                auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                const bool isInSet = newVariables.find(var) != newVariables.end();
                const bool isEqual = *assignment->getRhs() == *assignment->getLhs();

                if (!isEqual) {
                    if (!isInSet) return false;
                    else return true;
                }
            }
        }
    }
    return false;
}

const std::map<SCAM::SyncSignal *, SCAM::State *> &SCAM::TrueOperation::getSyncSignalTimepoints() const {
    return syncSignalTimepoints;
}

const std::map<SCAM::Variable *, SCAM::State *> &SCAM::TrueOperation::getVariablesTimepoints() const {
    return variablesTimepoints;
}

const std::map<SCAM::DataSignal *, SCAM::State *> &SCAM::TrueOperation::getDataSignalsTimepoints() const {
    return dataSignalsTimepoints;
}



