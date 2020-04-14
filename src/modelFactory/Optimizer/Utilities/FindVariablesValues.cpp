//
// Created by M.I.Alkoudsi on 22.08.19.
//

#include <PrintStmt.h>
#include "FindVariablesValues.h"
#include "Optimizer/Debug.h"
#include "FindVariablesAndFunctionsInStatement.h"

SCAM::FindVariablesValues::FindVariablesValues(const std::map<int, SCAM::CfgNode *> &CFG,
                                               const std::set<std::string>& readVariablesSet) : readVariablesSet(
        readVariablesSet) {
    std::map<std::string, std::map<std::string, std::set<SCAM::Expr *>>> compoundVariablesT;
    for (auto node: CFG) {
        auto statement = node.second->getStmt();
        if (statement != nullptr) {
            if (auto assignment = dynamic_cast<SCAM::Assignment *>(statement)) {
                if (auto varOp = dynamic_cast<SCAM::VariableOperand *>(assignment->getLhs())) {
                    if (this->readVariablesSet.find(varOp->getVariable()->getFullName()) !=
                        this->readVariablesSet.end()) { continue; }
                    if (varOp->getVariable()->isCompoundType() || varOp->getVariable()->isArrayType()) {
                        if(dynamic_cast<SCAM::VariableOperand *>(assignment->getRhs())){
                        }else if (auto compoundValue = dynamic_cast<SCAM::CompoundValue *>(assignment->getRhs())) {
                            addSubVariablesToValuesMap(varOp,compoundValue->getValues());
                        } else if (auto compoundExpression = dynamic_cast<SCAM::CompoundExpr *>(assignment->getRhs())) {
                            addSubVariablesToValuesMap(varOp,compoundExpression->getValueMap());
                        } else if (auto arrayExpression = dynamic_cast<SCAM::ArrayExpr *>(assignment->getRhs())) {
                            addSubVariablesToValuesMap(varOp,arrayExpression->getValueMap());
                        } else {
                            throw std::runtime_error(
                                    "unexpected rhs of an assignment to a compound or array expression");
                        }
                    }
                    if(auto ternaryExpr = dynamic_cast<SCAM::Ternary *>(assignment->getRhs())){
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
                std::cout << SCAM::PrintStmt::toString(value)  << ", " ;
            }
            std::cout << std::endl;
        }
#endif
}

const std::map<std::string, std::set<SCAM::Expr *>> &SCAM::FindVariablesValues::getVariableValuesMap() const {
    return this->variablesValuesMap;
}

void SCAM::FindVariablesValues::addValToVariableValuesMap(SCAM::Variable *variable, SCAM::Expr *rhs) {
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
        std::set<SCAM::Expr *> valuesSet;
        valuesSet.insert(rhs);
        this->variablesValuesMap.insert(std::make_pair(variable->getFullName(), valuesSet));
    }
}

template<class T>
void SCAM::FindVariablesValues::addSubVariablesToValuesMap(SCAM::VariableOperand *varOp,
                                                           const std::map<std::string, T *> &compoundValuesMap) {
    auto valItr = compoundValuesMap.begin();
    for (auto &subVar : varOp->getVariable()->getSubVarList()) {
        if (valItr == compoundValuesMap.end()) { break; }
        auto subVarVal = dynamic_cast<SCAM::Expr*>((*valItr).second);
        valItr++;
        if (subVarVal) {
            addValToVariableValuesMap(subVar, subVarVal);
        }
    }
}
/*
void SCAM::FindVariablesValues::addSubVariablesToValuesMap(
        SCAM::VariableOperand* varOp,
        const std::map<std::string, SCAM::Expr *> &compoundValuesMap) {
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