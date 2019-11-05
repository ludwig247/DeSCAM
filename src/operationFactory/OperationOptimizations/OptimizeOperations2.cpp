//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 4/17/19.
//

#include <ExprVisitor.h>
#include "OptimizeOperations2.h"

namespace SCAM {

    SCAM::OptimizeOperations2::OptimizeOperations2(const std::vector<SCAM::Operation2 *> &opList, SCAM::Module *module) :
    operationsList(opList) {
        // mark all variables for removal initially
        for (auto var: module->getVariableMap()) {
            if (var.second->isCompoundType() || var.second->isArrayType()) {
                for (auto subVar: var.second->getSubVarList()) {
                    removeVars.insert(std::make_pair(subVar, true));
                }
            } else removeVars.insert(std::make_pair(var.second, true));
        }

        for (auto op : operationsList) {
            //Check assumptions for usage
            for (auto ass: op->getAssumptionsList()) {
                for (auto usedVar: ExprVisitor::getUsedVariables(ass)) {
                    if(usedVar->isArrayType()){
                        for(auto subVar: usedVar->getSubVarList()){
                            removeVars.at(subVar) = false;
                        }
                    }else removeVars.at(usedVar) = false;

                }
            }
            //Check commitment for usage
            for (auto comm: op->getCommitmentsList()) {
                if (PrintStmt::toString(comm->getLhs()) == PrintStmt::toString(comm->getRhs())) {
                    continue;
                }
                for (auto usedVar: ExprVisitor::getUsedVariables(comm->getRhs())) {
                    if (usedVar->isCompoundType() || usedVar->isArrayType()) {
                        for (auto subVar: usedVar->getSubVarList()) {
                            removeVars.at(subVar) = false;
                        }
                    } else   removeVars.at(usedVar) = false;
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

        //FIXME: removing subVars of array is not correct. check example TestArray05
        for(auto var: removeVars){
            if(!var.second){
                this->varMap.insert(std::make_pair(var.first->getFullName(),var.first));
            }
            else {
                std::cout << "\tRemove Variable: " << var.first->getFullName() << std::endl;
            }
        }


        //Remove all usage for this variable from operations
        for (auto var: removeVars) {
            if (var.second) {
                for (auto op : operationsList) {
                    std::vector<Assignment *> newCommList;
                    for (auto comm: op->getCommitmentsList()) {
                        std::string lhsOperandName = ExprVisitor::getOperand(comm->getLhs())->getOperandName();
                        if ( lhsOperandName != var.first->getFullName()) {
                            newCommList.push_back(comm);
                        }
                    }
                    op->setCommitmentsList(newCommList);
                }
            }
        }
    }

    const std::map<std::string, Variable*> OptimizeOperations2::getNewVarMap() const {
        return this->varMap;
    }

    const std::vector<SCAM::Operation2 *> SCAM::OptimizeOperations2::getOperationsList() const {
        return this->operationsList;
    }

}