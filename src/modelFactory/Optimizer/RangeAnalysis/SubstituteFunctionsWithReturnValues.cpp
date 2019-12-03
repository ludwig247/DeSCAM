//
// Created by M.I.Alkoudsi on 10.09.19.
//
#include "SubstituteFunctionsWithReturnValues.h"

/*
 * example:
 * {
 * ...
 * x = div(y,z)
 * ...
 * }
 * int div(int arg1, int arg2){
 * return arg1 / arg2;
 * }
 * arg1 / arg2 replaces div(y,z) in the newVariableValuesMap
 */

SCAM::SubstituteFunctionsWithReturnValues::SubstituteFunctionsWithReturnValues(
        const std::map<std::string, std::set<SCAM::Expr *>> &variablesValuesMap) : functionHasRecursion(false) {
    for (const auto &var : variablesValuesMap) {
        for (auto val : var.second) {
            if (val != nullptr) {
                val->accept(*this);
                if (this->functionHasRecursion) {
                    this->variablesWithRecrusiveFunctions.insert(var.first);
                    this->functionHasRecursion = false;
                    this->functionReturnsSubstitutionMap.clear();
                    continue;
                }
                if (!this->functionReturnsSubstitutionMap.empty()) {
                    //substitute functions in val with their return values and add the resulting expressions to the lhs variable
                    std::set<SCAM::Expr *> newExpressionsSet = substituteFunctionsWithTheirReturns(val,
                                                                                                   this->functionReturnsSubstitutionMap);
                    for (auto newExpression : newExpressionsSet) {
                        addValToVarValMap(var.first, newExpression);
                    }
                    this->functionReturnsSubstitutionMap.clear();
                }
            }
        }
    }
    //construct the new variableValuesMap
    this->newVariablesValuesMap = this->variableValuesOfReturnsMap;
    for (const auto &var : variablesValuesMap) {
        for (auto val : var.second) {
            if (val != nullptr) {
                SCAM::FindVariablesAndFunctionsInStatement variablesInStmtFinder(val);
                if (variablesInStmtFinder.hasFunctions()) {
                    continue;
                } else {
                    if (this->newVariablesValuesMap.find(var.first) != this->newVariablesValuesMap.end()) {
                        this->newVariablesValuesMap.at(var.first).insert(val);
                        bool isValAlreadyInSet = false;
                        for (auto valAlreadyInSet : this->newVariablesValuesMap.at(var.first)) {
                            if (*val == *valAlreadyInSet) {
                                isValAlreadyInSet = true;
                                break;
                            }
                        }
                        if (!isValAlreadyInSet) {
                            this->newVariablesValuesMap.at(var.first).insert(val);
                        }
                    } else {
                        std::set<SCAM::Expr *> valuesSet;
                        valuesSet.insert(val);
                        this->newVariablesValuesMap.insert(std::make_pair(var.first, valuesSet));
                    }
                }
            }
        }
    }
}

const std::map<std::string, std::set<SCAM::Expr *>> &
SCAM::SubstituteFunctionsWithReturnValues::getNewVariableValuesMap() const {
    return this->newVariablesValuesMap;
}

const std::set<std::string> &SCAM::SubstituteFunctionsWithReturnValues::getVariablesWithRecrusiveFunctions() const {
    return this->variablesWithRecrusiveFunctions;
}

void SCAM::SubstituteFunctionsWithReturnValues::addValToVarValMap(const std::string &varName, SCAM::Expr *expr) {
    if (this->variableValuesOfReturnsMap.find(varName) !=
        this->variableValuesOfReturnsMap.end()) {
        bool isValAlreadyInSet = false;
        for (auto valAlreadyInSet : this->variableValuesOfReturnsMap.at(varName)) {
            if (*expr == *valAlreadyInSet) {
                isValAlreadyInSet = true;
                break;
            }
        }
        if (!isValAlreadyInSet) {
            this->variableValuesOfReturnsMap.at(varName).insert(expr);
        }
    } else {
        std::set<SCAM::Expr *> valuesSet;
        valuesSet.insert(expr);
        this->variableValuesOfReturnsMap.insert(std::make_pair(varName, valuesSet));
    }
}

void SCAM::SubstituteFunctionsWithReturnValues::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void SCAM::SubstituteFunctionsWithReturnValues::visit(struct Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);

}

void SCAM::SubstituteFunctionsWithReturnValues::visit(struct Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::SubstituteFunctionsWithReturnValues::visit(struct Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::SubstituteFunctionsWithReturnValues::visit(struct Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::SubstituteFunctionsWithReturnValues::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
}

void SCAM::SubstituteFunctionsWithReturnValues::visit(SCAM::FunctionOperand &node) {
    SCAM::Expr *functionOp = &node;
    for (const auto &returnPath : node.getFunction()->getReturnValueConditionList()) {
        auto returnVal = returnPath.first->getReturnValue();
        SCAM::FindVariablesAndFunctionsInStatement visf(returnVal);
        if (visf.hasFunctions()) {
            auto functionsInStmtMap = visf.getFunctionsInStmtMap();
            for (const auto &function: functionsInStmtMap) {
                if (function.first == node.getFunction()->getName()) {
                    this->functionHasRecursion = true;
                    return;
                }
            }
            auto nestedReturnValSet = substituteReturnValuesOfNestedFunctions(returnVal, functionsInStmtMap);
            if (this->functionHasRecursion) {
                return;
            } else {
                for (const auto &returnVal: nestedReturnValSet) {
                    addValToFunctionReturnsSubstitutionMap(functionOp, returnVal, this->functionReturnsSubstitutionMap);
                }
            }
        } else {
            addValToFunctionReturnsSubstitutionMap(functionOp, returnVal, this->functionReturnsSubstitutionMap);
        }
    }
}

void SCAM::SubstituteFunctionsWithReturnValues::addValToFunctionReturnsSubstitutionMap(SCAM::Expr *functionOp,
                                                                                       SCAM::Expr *returnVal,
                                                                                       std::map<SCAM::Expr *, std::vector<SCAM::Expr *>> &functionReturnsSubstitutionMap) {
    if (functionReturnsSubstitutionMap.find(functionOp) == functionReturnsSubstitutionMap.end()) {
        std::vector<SCAM::Expr *> returnValuesVector;
        returnValuesVector.push_back(returnVal);
        functionReturnsSubstitutionMap.insert(std::make_pair(functionOp, returnValuesVector));
    } else {
        functionReturnsSubstitutionMap.at(functionOp).push_back(returnVal);
    }
}

std::set<SCAM::Expr *>
SCAM::SubstituteFunctionsWithReturnValues::substituteReturnValuesOfNestedFunctions(SCAM::Expr *returnValWithFunctions,
                                                                                   const std::map<std::string, FunctionOperand *> &functionsInStmtMap) {
    std::map<SCAM::Expr *, std::vector<SCAM::Expr *>> substitutionMap;
    for (const auto &pair : functionsInStmtMap) {
        SCAM::Expr *function = pair.second;
        std::set<SCAM::Expr *> returnsSet;
        for (const auto &returnPath : pair.second->getFunction()->getReturnValueConditionList()) {
            auto returnVal = returnPath.first->getReturnValue();
            SCAM::FindVariablesAndFunctionsInStatement visf(returnVal);
            if (visf.hasFunctions()) {
                auto functionsInStmtMap = visf.getFunctionsInStmtMap();
                for (const auto &func: functionsInStmtMap) {
                    if (func.first == pair.second->getFunction()->getName()) {
                        this->functionHasRecursion = true;
                        returnsSet.clear();
                        return returnsSet;
                    }
                }
                auto nestedReturnSet = substituteReturnValuesOfNestedFunctions(returnVal, functionsInStmtMap);
                if (this->functionHasRecursion) {
                    returnsSet.clear();
                    return returnsSet;
                } else {
                    for (const auto &returnVal: nestedReturnSet) {
                        addValToFunctionReturnsSubstitutionMap(function, returnVal, substitutionMap);
                    }
                }
            } else {
                addValToFunctionReturnsSubstitutionMap(function, returnVal, substitutionMap);
            }
        }
        return substituteFunctionsWithTheirReturns(returnValWithFunctions, substitutionMap);
    }
}


std::set<SCAM::Expr *>
SCAM::SubstituteFunctionsWithReturnValues::substituteFunctionsWithTheirReturns(SCAM::Expr *toBeSubstitutedExpr,
                                                                               const std::map<SCAM::Expr *, std::vector<SCAM::Expr *>> &functionReturnsSubstitutionMap) {
    std::set<SCAM::Expr *> substitutedValuesVector;
    int numberOfFunctions = functionReturnsSubstitutionMap.size();
    auto pairItr = functionReturnsSubstitutionMap.begin();
    int CurrentFunction = 0;
    std::vector<int> currentReturnValueIndex(numberOfFunctions, 0);
    std::stack<SCAM::Expr *> valueSubstitutionStack;
    valueSubstitutionStack.push(toBeSubstitutedExpr);

    while (!valueSubstitutionStack.empty()) {
        SCAM::Expr *currentFunction = (*pairItr).first;
        auto valptr = functionReturnsSubstitutionMap.at(currentFunction).begin();
        for (int i = 0; i < currentReturnValueIndex[CurrentFunction]; i++) { valptr++; }
        if (valptr != functionReturnsSubstitutionMap.at(currentFunction).end()) {
            SCAM::Expr *expression = valueSubstitutionStack.top();
            auto newExpression = SCAM::ExpressionSubstitution::substituteExpr(expression, currentFunction, *valptr);
            currentReturnValueIndex[CurrentFunction] += 1;
            if (CurrentFunction ==
                (numberOfFunctions - 1)) { //we currently have the last function in the functionReturnsSubstitutionMap

                substitutedValuesVector.insert(newExpression);
            } else {
                CurrentFunction += 1;
                pairItr++;
                valueSubstitutionStack.push(newExpression);
            }
        } else {
            currentReturnValueIndex[CurrentFunction] = 0;
            CurrentFunction -= 1;
            pairItr--;
            valueSubstitutionStack.pop();
        }
    }
    return substitutedValuesVector;
}


void SCAM::SubstituteFunctionsWithReturnValues::visit(struct ArrayOperand &node) {
    node.getIdx()->accept(*this);
}




