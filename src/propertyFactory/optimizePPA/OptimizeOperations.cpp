//
// Created by tobias on 26.10.17.
//

#include <PrintStmt.h>
#include "OptimizeOperations.h"
#include "ExprVisitor.h"

SCAM::OptimizeOperations::OptimizeOperations(const std::map<int, State *> &stateMap, SCAM::Module *module) :
        newStateMap(stateMap),
        module(module) {
    removeVariables();
}

void SCAM::OptimizeOperations::removeVariables() {
    // mark all variables for removal initially
    for (auto var: module->getVariableMap()) {
        if (var.second->isCompoundType()) {
            for (auto subVar: var.second->getSubVarList()) {
                removeVars.insert(std::make_pair(subVar, true));
            }
        } else removeVars.insert(std::make_pair(var.second, true));
    }

    for (auto state: newStateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            //Check assumptions for usage
            for (auto ass: op->getAssumptionList()) {
                for (auto usedVar: ExprVisitor::getUsedVariables(ass)) {
                    removeVars.at(usedVar) = false;
                }
            }
            //Check commitment for usage
            for (auto comm: op->getCommitmentList()) {
                if (PrintStmt::toString(comm->getLhs()) == PrintStmt::toString(comm->getRhs())) {
                    continue;
                }
                for (auto usedVar: ExprVisitor::getUsedVariables(comm->getRhs())) {
                    //Variable *var = this->module->getVariable(usedVar->getFullName());
                    removeVars.at(usedVar) = false;
                }
            }
        }
    }

    //SubVars: are only allowed to be removed if all other subvars are marked for removal, too.
    for (auto var: removeVars) {
        if(!var.second) continue;
        if (var.first->isSubVar()) {
            bool remove = true;
            //Is every subvar marked for removal?
            for (auto subar : var.first->getParent()->getSubVarList()) {
                if (!removeVars.at(subar)) remove = false;
                break;
            }
            //No? mark all other for non removal;
            if (!remove) {
                for (auto subar : var.first->getParent()->getSubVarList()) {
                    removeVars.at(subar) = false;
                }
            }
        }
    }

    for(auto var: removeVars){
        if(!var.second){
            this->stateVarMap.insert(std::make_pair(var.first->getFullName(),var.first));
        }
    }


    //Remove all usage for this variable from statemap
    for (auto var: removeVars) {
        if (var.second) {
            //std::cout << " removing: " << var.first->getFullName() << std::endl;
            for (auto state: newStateMap) {
                for (auto op: state.second->getOutgoingOperationList()) {
                    std::vector<Assignment *> newCommList;
                    for (auto comm: op->getCommitmentList()) {
                        if (ExprVisitor::getOperand(comm->getLhs())->getOperandName() != var.first->getFullName()) {
                            newCommList.push_back(comm);
                        }
                    }
                    op->setCommitmentList(newCommList);
                }
            }
        }
    }


}

const std::map<int, SCAM::State *> &SCAM::OptimizeOperations::getNewStateMap() const {
    return newStateMap;
}

const std::map<std::string, SCAM::Variable *> &SCAM::OptimizeOperations::getStateVarMap() const {
    return stateVarMap;
}

const std::map<std::string, SCAM::Variable *> &SCAM::OptimizeOperations::getStateTopVarMap() const {
    return stateTopVarMap;
}



