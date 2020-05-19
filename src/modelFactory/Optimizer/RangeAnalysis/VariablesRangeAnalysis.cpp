//
// Created by M.I.Alkoudsi on 10.09.19.
//

#include "VariablesRangeAnalysis.h"
#include "Optimizer/Debug.h"


SCAM::VariablesRangeAnalysis::VariablesRangeAnalysis(const std::map<int, SCAM::CfgNode *>& CFG,
                                                     const std::map<std::string, std::set<SCAM::Expr *>>& variablesValuesMap,
                                                     const std::set<std::string>& variablesThatHaveReadSet) : CFG(CFG),
                                                                                                              variablesValuesMap(
                                                                                                                      variablesValuesMap),
                                                                                                              variablesThatHaveReadSet(
                                                                                                                      variablesThatHaveReadSet) {
#ifdef DEBUG_RANGE_ANALYSIS
    std::cout << "valuesMap" << std::endl;
    for (auto var : this->variablesValuesMap) {
        std::cout << "variable " << var.first << " :" << std::endl;
        for (auto val : var.second) {
            std::cout << " " << PrintStmt::toString(val) << " ";
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
#endif
    //removing bool & enum vars, values with counters variables, and adding variables with counter values to the toBeAnalysedCounterVariablesSet
    std::map<std::string, std::set<SCAM::Expr *>> integerAndUnsignedVariablesWithNoCounterValuesMap;
    for (auto var : this->variablesValuesMap) {
        if ((*var.second.begin())->getDataType()->isBoolean() ||
            (*var.second.begin())->getDataType()->isEnumType()) { continue; }
        else if ((*var.second.begin())->getDataType()->isInteger()) {
            this->variablesDataTypesMap.insert(std::make_pair(var.first, "int"));
        } else if ((*var.second.begin())->getDataType()->isUnsigned()) {
            this->variablesDataTypesMap.insert(std::make_pair(var.first, "unsigned"));
        }
        std::set<SCAM::Expr *> valuesSet;
        bool assignedByReadVar = false;
        for (auto val : var.second) {
            SCAM::FindVariablesAndFunctionsInStatement fvf(val, this->variablesThatHaveReadSet);
            if(fvf.hasReadVariable()){
                assignedByReadVar = true;
            }
            SCAM::DetectCounterVariable counterDetector(var.first, val);
            if (counterDetector.isCounterVariable()) {
                this->toBeAnalysedCounterVariablesSet.insert(var.first);
            } else {
                valuesSet.insert(val);
            }
        }
        if(!assignedByReadVar) {
            integerAndUnsignedVariablesWithNoCounterValuesMap.insert(std::make_pair(var.first, valuesSet));
        }
    }
    this->variablesValuesMap = integerAndUnsignedVariablesWithNoCounterValuesMap;
#ifdef DEBUG_RANGE_ANALYSIS
    std::cout << "valuesMap without bool and enum variables and values containing read variables" << std::endl;
    for (auto var : this->variablesValuesMap) {
        std::cout << "variable " << var.first << " :" << std::endl;
        for (auto val : var.second) {
            std::cout << " " << PrintStmt::toString(val) << " ";
        }
        std::cout << std::endl;
    }

    std::cout << "toBeAnalysedCounterVariablesSet" << std::endl;
    for (auto var : this->toBeAnalysedCounterVariablesSet) {
        std::cout << " " << var << ", ";
    }
    std::cout << std::endl;
#endif
    //get values from relational expressions
    SCAM::FindVariablesValuesInRelationalExpressions valuesFromRelationalExpr(this->CFG);
    for (auto varName : valuesFromRelationalExpr.getDifficultToAnalyseVariablesSet()) {
        this->difficultToAnalyzeVariablesSet.insert(varName);
    }
    for (auto var : valuesFromRelationalExpr.getVariableValuesFromRelationalExpressionsMap()) {
        if (this->variablesValuesMap.find(var.first) != this->variablesValuesMap.end()) {
            for (auto valFromRelationalExpressions : var.second) {
                bool isValAlreadyInSet = false;
                for (auto valAlreadyInSet : this->variablesValuesMap.at(var.first)) {
                    if (*valFromRelationalExpressions == *valAlreadyInSet) {
                        isValAlreadyInSet = true;
                        break;
                    }
                }
                if (!isValAlreadyInSet) {
                    this->variablesValuesMap.at(var.first).insert(valFromRelationalExpressions);
                }
            }
        }
    }
#ifdef DEBUG_RANGE_ANALYSIS
    std::cout << "valuesMap with values from relational expressions" << std::endl;
    for (auto var : this->variablesValuesMap) {
        std::cout << "variable " << var.first << " :" << std::endl;
        for (auto val : var.second) {
            std::cout << " " << PrintStmt::toString(val) << " ";
        }
        std::cout << std::endl;
    }

    std::cout << "difficultToAnalyzeVariablesSet after FindVariablesValuesInRelationalExpressions" << std::endl;
    for (auto var : this->difficultToAnalyzeVariablesSet) {
        std::cout << " " << var << ", ";
    }
    std::cout << std::endl;
#endif

    //get values from functionsReturnsSubstition
    SCAM::SubstituteFunctionsWithReturnValues functionsReturnsSubstitution(this->variablesValuesMap);
    for (auto varName : functionsReturnsSubstitution.getVariablesWithRecrusiveFunctions()) {
        this->difficultToAnalyzeVariablesSet.insert(varName);
    }

    this->variablesValuesMap = functionsReturnsSubstitution.getNewVariableValuesMap();


#ifdef DEBUG_RANGE_ANALYSIS
    std::cout << "valuesMap with values from functionsReturnsSubstition" << std::endl;
    for (auto var : this->variablesValuesMap) {
        std::cout << "variable " << var.first << " :" << std::endl;
        for (auto val : var.second) {
            std::cout << " " << PrintStmt::toString(val) << " ";
        }
        std::cout << std::endl;
    }

    std::cout << "difficultToAnalyzeVariablesSet after functionsReturnsSubstition" << std::endl;
    for (auto var : this->difficultToAnalyzeVariablesSet) {
        std::cout << " " << var << ", ";
    }
    std::cout << std::endl;
#endif

    //analyze counter variables and add those that take the whole range of int/unsigned to difficultToAnalyzeVariableSet
    SCAM::AnalyzeCounterVariables counterVariablesAnalysis(this->toBeAnalysedCounterVariablesSet, this->CFG);
    for (auto var : counterVariablesAnalysis.getMarginalValuesMap()) {
        if (var.second != "Limited") {
            if (this->difficultToAnalyzeVariablesSet.find(var.first) ==
                this->difficultToAnalyzeVariablesSet.end()) {
                this->difficultToAnalyzeVariablesSet.insert(var.first);
            }
        }
    }

#ifdef DEBUG_RANGE_ANALYSIS
    std::cout << "counter variables analysis" << std::endl;
    for (auto var : counterVariablesAnalysis.getMarginalValuesMap()) {
        std::cout << "variable " << var.first << " :" << var.second << std::endl;
    }
    std::cout << "difficultToAnalyzeVariablesSet" << std::endl;
    for (auto var : this->difficultToAnalyzeVariablesSet) {
        std::cout << var << " ";
    }
    std::cout << std::endl;
#endif


    if (!this->difficultToAnalyzeVariablesSet.empty()) {
        //remove difficult to analyze variables
        std::map<std::string, std::set<SCAM::Expr *>> variableValuesMapWithoutDifficultToAnalyzeVariables;
        for (auto pair : this->variablesValuesMap) {
            if (this->difficultToAnalyzeVariablesSet.find(pair.first) != this->difficultToAnalyzeVariablesSet.end() ||
                this->variablesThatHaveReadSet.find(pair.first) != this->variablesThatHaveReadSet.end()) { continue; }
            variableValuesMapWithoutDifficultToAnalyzeVariables.insert(std::make_pair(pair.first, pair.second));
        }
        this->variablesValuesMap = variableValuesMapWithoutDifficultToAnalyzeVariables;
    }


#ifdef DEBUG_RANGE_ANALYSIS

    std::cout << "valuesMap after removing difficult to analyze variables" << std::endl;
    for (auto var : this->variablesValuesMap) {
        std::cout << "variable " << var.first << " :" << std::endl;
        for (auto val : var.second) {
            std::cout << " " << PrintStmt::toString(val) << " ";
        }
        std::cout << std::endl;
    }
#endif

    //substitute all variables in variablesValuesMap with all their values
    while (bool MoreSubstitutionNeeded = true) {
        std::map<std::string, std::set<SCAM::Expr *>> substitutedVariableValuesMap;
        for (auto pair : this->variablesValuesMap) {
            std::set<SCAM::Expr *> substitutedValuesSet;
            for (auto variableValue : pair.second) {
                SCAM::FindVariablesAndFunctionsInStatement variablesInStmtFinder(variableValue,this->variablesThatHaveReadSet);
                if (variablesInStmtFinder.hasFunctions()) {
                    substitutedValuesSet.clear();
                    break;
                }
                std::set<std::string> variablesInValue = variablesInStmtFinder.getVariablesInStmtSet();
                if (variablesInValue.empty()) {
                    substitutedValuesSet.insert(variableValue);
                } else {
                    std::map<std::string, std::set<SCAM::Expr *>> substitutionMap;
                    bool noReadOrDifficultVariables = true;
                    for (auto variable : variablesInValue) {
                        if (this->difficultToAnalyzeVariablesSet.find(variable) !=
                            this->difficultToAnalyzeVariablesSet.end() ||
                            this->variablesThatHaveReadSet.find(variable) != this->variablesThatHaveReadSet.end()) {
                            substitutedValuesSet.clear();
                            noReadOrDifficultVariables = false;
                            break;
                        }
                        if (this->toBeAnalysedCounterVariablesSet.find(variable) !=
                            this->toBeAnalysedCounterVariablesSet.end()) {
                            if (this->variablesThatAssignedCounterVariablesMap.find(variable) !=
                                this->variablesThatAssignedCounterVariablesMap.end()) {
                                this->variablesThatAssignedCounterVariablesMap.at(variable).insert(pair.first);
                            } else {
                                std::set<std::string> variablesThatAreAssignedCounterVariablesSet;
                                variablesThatAreAssignedCounterVariablesSet.insert(pair.first);
                                this->variablesThatAssignedCounterVariablesMap.insert(
                                        std::make_pair(variable, variablesThatAreAssignedCounterVariablesSet));
                            }
                        }
                    }
                    if (noReadOrDifficultVariables) {//substitute each variable inside variablevalue with all its possible values
                        for (auto variable : variablesInValue) {
                            if (this->variablesValuesMap.find(variable) != this->variablesValuesMap.end()) {
                                substitutionMap.insert(
                                        std::make_pair(variable, this->variablesValuesMap.at(variable)));
                                auto substitutedExpressionSet = substituteVariablesWithValues(variableValue,
                                                                                              substitutionMap);
                                for (auto expr : substitutedExpressionSet) {
                                    if (expr != nullptr) {
                                        substitutedValuesSet.insert(expr);
                                    } else { TERMINATE("substitution error!"); }
                                }
                            } else {
                                substitutedValuesSet.clear();
                                break;
                            }
                        }
                    }
                }
            }
            if (!substitutedValuesSet.empty()) {
                substitutedVariableValuesMap.insert(std::make_pair(pair.first, substitutedValuesSet));
            }
        }
        if (this->variablesValuesMap == substitutedVariableValuesMap) {
            break;
        }
        this->variablesValuesMap = substitutedVariableValuesMap;
    }

#ifdef DEBUG_RANGE_ANALYSIS
    std::cout << "valuesMap after substitution" << std::endl;
    for (auto var : this->variablesValuesMap) {
        std::cout << "variable " << var.first << " :" << std::endl;
        for (auto val : var.second) {
            std::cout << " " << PrintStmt::toString(val) << " ";
        }
        std::cout << std::endl;
    }
#endif
    //translate all variable values into z3 expressions and simplify them
    for (auto var : this->variablesValuesMap) {
        std::vector<int> intValuesVector;
        std::vector<unsigned int> unsignedValuesVector;
        for (auto val : var.second) {
            try {
                z3::context contxt;
                SCAM::ExprTranslator translator(&contxt);
                z3::expr z3Expr(contxt);
                z3Expr = translator.translate(val);
//              std::cout << "before simplification z3Expr is" << z3Expr << std::endl;
                z3Expr = z3Expr.simplify();
//              std::cout << "after simplification z3Expr is" << z3Expr << std::endl;
                if (this->variablesDataTypesMap.at(var.first) == "int") {
                    intValuesVector.push_back(z3Expr.get_numeral_int());
                } else if (this->variablesDataTypesMap.at(var.first) == "unsigned") {
                    unsignedValuesVector.push_back(z3Expr.get_numeral_uint());
                } else {
                    intValuesVector.clear();
                    unsignedValuesVector.clear();
                }

            }
            catch (z3::exception e) {
                intValuesVector.clear();
                unsignedValuesVector.clear();
                break;
            }
            catch (std::runtime_error tre) {
                intValuesVector.clear();
                unsignedValuesVector.clear();
                break;
            }
        }
        //sort values and check biggest and smallest value
        if (!intValuesVector.empty()) {
//            std::sort(intValuesVector.begin(), intValuesVector.end());
#ifdef DEBUG_RANGE_ANALYSIS
            std::cout << "int values vector after sorting" << std::endl;
            std::cout << "variable " << var.first << " : ";
            for (auto val : intValuesVector) {
                std::cout << " " << val << " ";
            }
            std::cout << std::endl;
#endif
//            int largestValue = intValuesVector.back();
            int largestValue = *std::max_element(intValuesVector.begin(), intValuesVector.end());
            if (largestValue == 0) {
                this->variableBitWidthMap.insert(std::make_pair(var.first, 2));
            } else {
                if (largestValue < 0) { largestValue *= -1; }
                this->variableBitWidthMap.insert(std::make_pair(var.first, SCAM::GlobalUtilities::getRequiredBits(largestValue) + 1));
            }
            bool canBeUnsigned = true;
            for (auto val : intValuesVector) {
                if (val < 0) {
                    canBeUnsigned = false;
                    break;
                }
            }
            if (canBeUnsigned) {
               std::string msg = "Variable " + var.first + " can be unsigned!";
                LocationInfo locationInfo;
                auto sl = SCAM::LoggerMsg::SeverityLevel::Info;
                auto vt = SCAM::LoggerMsg::ViolationType::NA;
                auto pl = SCAM::Logger::getCurrentProcessedLocation();
                SCAM::LoggerMsg lmsg(msg, locationInfo,sl,vt,pl);
                SCAM::Logger::addMsg(lmsg);
            }

        } else if (!unsignedValuesVector.empty()) {

//            std::sort(unsignedValuesVector.begin(), unsignedValuesVector.end());
#ifdef DEBUG_RANGE_ANALYSIS
            std::cout << "unsigned values vector after sorting" << std::endl;
            std::cout << "variable " << var.first << " : ";
            for (auto val : unsignedValuesVector) {
                std::cout << " " << val << " ";
            }
            std::cout << std::endl;
#endif
//            unsigned int largestValue = unsignedValuesVector.back();
            unsigned int largestValue = *std::max_element(unsignedValuesVector.begin(), unsignedValuesVector.end());
            if (largestValue == 0) {
                this->variableBitWidthMap.insert(std::make_pair(var.first, 1));
            } else {
                this->variableBitWidthMap.insert(std::make_pair(var.first, SCAM::GlobalUtilities::getRequiredBits(largestValue)));
            }
        }
    }

    for (auto counterVariable_VariablesPair : this->variablesThatAssignedCounterVariablesMap) {
        for (auto variable : counterVariable_VariablesPair.second) {
            this->variableBitWidthMap.at(variable) = this->variableBitWidthMap.at(counterVariable_VariablesPair.first);
        }
    }

}

const std::map<std::string, int> &SCAM::VariablesRangeAnalysis::getVariableBitWidthMap() const {
    return this->variableBitWidthMap;
}

std::set<SCAM::Expr *> SCAM::VariablesRangeAnalysis::substituteVariablesWithValues(SCAM::Expr *toBeSubstitutedExpr,
                                                                                   const std::map<std::string, std::set<SCAM::Expr *>> &substitutionMap) {
    std::set<SCAM::Expr *> substitutedValuesVector;
    int numberOfVariables = substitutionMap.size();
    auto pairItr = substitutionMap.begin();
    int CurrentVariable = 0;
    std::vector<int> currentValueIndex(numberOfVariables, 0);
    std::stack<SCAM::Expr *> valueStack;
    valueStack.push(toBeSubstitutedExpr);

    while (!valueStack.empty()) {
        std::string currentVarName = (*pairItr).first;
        auto valptr = substitutionMap.at(currentVarName).begin();
        for (int i = 0; i < currentValueIndex[CurrentVariable]; i++) { valptr++; }
        if (valptr != substitutionMap.at(currentVarName).end()) {
            SCAM::Expr *expression = valueStack.top();
            SCAM::ValueSubstitution valueSubstitution;
            SCAM::Expr *newExpression = valueSubstitution.substituteExpr(expression,
                                                                         currentVarName,
                                                                         *valptr);
            if (newExpression == nullptr) { TERMINATE("substitutionError!"); }
            currentValueIndex[CurrentVariable] += 1;
            if (CurrentVariable ==
                (numberOfVariables - 1)) { //we currently have the last variable in the substitution map

                substitutedValuesVector.insert(newExpression);
            } else {
                CurrentVariable += 1;
                pairItr++;
                valueStack.push(newExpression);
            }
        } else {
            currentValueIndex[CurrentVariable] = 0;
            CurrentVariable -= 1;
            pairItr--;
            valueStack.pop();
        }
    }
    return substitutedValuesVector;
}


