//
// Created by M.I.Alkoudsi on 22.08.19.
//

#include "FindVariablesValues.h"
#include "Optimizer/Debug.h"

SCAM::FindVariablesValues::FindVariablesValues(const std::map<int, SCAM::CfgNode *> &CFG,
                                               std::set<std::string> readVariablesSet) : readVariablesSet(std::move(
        readVariablesSet)) {
    std::map<std::string, std::map<std::string, std::set<SCAM::Expr *>>> compoundVariablesT;
    for (auto node: CFG) {
        auto statement = node.second->getStmt();
        if (statement != nullptr) {
            if (auto assignment = dynamic_cast<SCAM::Assignment*>(statement)) {
                if (auto varOp = dynamic_cast<SCAM::VariableOperand*>(assignment->getLhs())) {
                    if (this->readVariablesSet.find(varOp->getVariable()->getFullName()) !=
                        this->readVariablesSet.end()) { continue; }
                    if (varOp->getVariable()->isCompoundType() || varOp->getVariable()->isArrayType()) {
                        if (auto compoundValue = dynamic_cast<SCAM::CompoundValue*>(assignment->getRhs())) {
                            for (auto subVar : varOp->getVariable()->getSubVarList()) {
                                auto subVarVal = dynamic_cast<SCAM::Expr *>(compoundValue->getValues().at(
                                        subVar->getName()));
                                if (subVarVal != nullptr) {
                                    addValToVariableValuesMap(subVar, subVarVal);
                                } else {
                                    throw std::runtime_error("subVar " + subVar->getFullName() + " is not an Expr!");
                                }
                            }
                        } else {
                            throw std::runtime_error(
                                    "direct assignment to compound expressions or arrays was not expected!");
                        }
                    }
                    addValToVariableValuesMap(varOp->getVariable(), assignment->getRhs());
                }
            }
        }
    }
#ifdef DEBUG_FIND_VARIABLES_VALUES
    std::cout << "---------------Find Variables Values---------------" << std::endl;
    for(auto variable : this->variablesValuesMap)
        {   std::cout << "Variable " << variable.first << ": ";
            for(auto value : variable.second){
                std::cout << value  << ", " ;
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
