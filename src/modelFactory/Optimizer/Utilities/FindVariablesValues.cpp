//
// Created by M.I.Alkoudsi on 22.08.19.
//

#include <PrintStmt.h>
#include "FindVariablesValues.h"
#include "Optimizer/Debug.h"
#include "FindVariablesAndFunctionsInStatement.h"
#include "FatalError.h"
#include "Logger/Logger.h"


DESCAM::FindVariablesValues::FindVariablesValues(const std::map<int, DESCAM::CfgNode *> &CFG,
                                               const std::set<std::string>& readVariablesSet) : readVariablesSet(
        readVariablesSet) {
    std::map<std::string, std::map<std::string, std::set<DESCAM::Expr *>>> compoundVariablesT;
    for (auto node: CFG) {
        auto statement = node.second->getStmt();
        if (statement != nullptr) {
            if (auto assignment = dynamic_cast<DESCAM::Assignment *>(statement)) {
                if (auto varOp = dynamic_cast<DESCAM::VariableOperand *>(assignment->getLhs())) {
                    if (this->readVariablesSet.find(varOp->getVariable()->getFullName()) !=
                        this->readVariablesSet.end()) { continue; }
                    if (varOp->getVariable()->isCompoundType() || varOp->getVariable()->isArrayType()) {
                        if(dynamic_cast<DESCAM::VariableOperand *>(assignment->getRhs())){
                        }else if (auto compoundValue = dynamic_cast<DESCAM::CompoundValue *>(assignment->getRhs())) {
                            addSubVariablesToValuesMap(varOp,compoundValue->getValues());
                        } else if (auto compoundExpression = dynamic_cast<DESCAM::CompoundExpr *>(assignment->getRhs())) {
                            addSubVariablesToValuesMap(varOp,compoundExpression->getValueMap());
                        } else if (auto arrayExpression = dynamic_cast<DESCAM::ArrayExpr *>(assignment->getRhs())) {
                            addSubVariablesToValuesMap(varOp,arrayExpression->getValueMap());
                        } else {
                            TERMINATE(
                                    "unexpected rhs of an assignment to a compound or array expression");
                        }
                    }
                    if(auto ternaryExpr = dynamic_cast<DESCAM::Ternary *>(assignment->getRhs())){
                        addValToVariableValuesMap(varOp->getVariable(), ternaryExpr->getTrueExpr());
                        addValToVariableValuesMap(varOp->getVariable(), ternaryExpr->getFalseExpr());
                    }else {
                        addValToVariableValuesMap(varOp->getVariable(), assignment->getRhs());
                    }
                }
            }
        }
    }

#ifdef DEBUG_FIND_VARIABLES_VALUES
    std::cout << "---------------Find Variables Values---------------" << std::endl;
    for(auto variable : this->variablesValuesMap)
        {   std::cout << "Variable " << variable.first << ": ";
            for(auto value : variable.second){
                std::cout << DESCAM::PrintStmt::toString(value)  << ", " ;
            }
            std::cout << std::endl;
        }
#endif
}

const std::map<std::string, std::set<DESCAM::Expr *>> &DESCAM::FindVariablesValues::getVariableValuesMap() const {
    return this->variablesValuesMap;
}

void DESCAM::FindVariablesValues::addValToVariableValuesMap(DESCAM::Variable *variable, DESCAM::Expr *rhs) {
    if (this->variablesValuesMap.find(variable->getFullName()) !=
        this->variablesValuesMap.end()) {
        bool valAlreadyInSet = false;
        for (auto val : this->variablesValuesMap.at(variable->getFullName())) {
            if (*val == *rhs) {
                valAlreadyInSet = true;
                break;
            }
        }
        if (!valAlreadyInSet) {
            this->variablesValuesMap.at(variable->getFullName()).insert(
                    rhs);
        }
    } else {
        std::set<DESCAM::Expr *> valuesSet;
        valuesSet.insert(rhs);
        this->variablesValuesMap.insert(std::make_pair(variable->getFullName(), valuesSet));
    }
}

template<class T>
void DESCAM::FindVariablesValues::addSubVariablesToValuesMap(DESCAM::VariableOperand *varOp,
                                                           const std::map<std::string, T *> &compoundValuesMap) {
    auto valItr = compoundValuesMap.begin();
    for (auto &subVar : varOp->getVariable()->getSubVarList()) {
        if (valItr == compoundValuesMap.end()) { break; }
        auto subVarVal = dynamic_cast<DESCAM::Expr*>((*valItr).second);
        valItr++;
        if (subVarVal) {
            addValToVariableValuesMap(subVar, subVarVal);
        }
    }
}
/*
void DESCAM::FindVariablesValues::addSubVariablesToValuesMap(
        DESCAM::VariableOperand* varOp,
        const std::map<std::string, DESCAM::Expr *> &compoundValuesMap) {
    auto valItr = compoundValuesMap.begin();
    for (auto &subVar : varOp->getVariable()->getSubVarList()) {
        if (valItr == compoundValuesMap.end()) { break; }
        auto subVarVal = (*valItr).second;
        valItr++;
        if (subVarVal) {
            addValToVariableValuesMap(subVar, subVarVal);
        }
    }
}
*/