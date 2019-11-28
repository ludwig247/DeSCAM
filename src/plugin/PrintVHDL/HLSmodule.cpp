//
// Created by johannes on 28.11.19.
//

#include <algorithm>

#include <boost/algorithm/string.hpp>
#include <ExprVisitor.h>

#include "NodePeekVisitor.h"
#include "HLSmodule.h"

HLSmodule::HLSmodule(PropertySuite *propertySuite, Module* module) :
        propertySuite(propertySuite),
        module(module),
        registerToOutputMap()
{
    // Save original commitment list
    for (const auto& operationProperty : propertySuite->getOperationProperties()) {
        originalCommitmentLists.push(operationProperty->getCommitmentList());
    }

    removeRedundantConditions();
    mapOutputRegistersToOutput();
}

HLSmodule::~HLSmodule() {
    // Load original commitment list
    for (const auto& operationProperty : propertySuite->getOperationProperties()) {
        operationProperty->setCommitmentList(originalCommitmentLists.front());
        originalCommitmentLists.pop();
    }
}

void HLSmodule::removeRedundantConditions()
{
    for (auto &function : module->getFunctionMap()) {
//        std::cout << "------ FUNCTION " << function.second->getName() << " --------" << std::endl;

        auto branches = function.second->getReturnValueConditionList();
        for (auto branch = branches.begin(); std::next(branch) != branches.end(); ++branch) {
            auto conditionList = branch->second;
//            for (auto cond : conditionList) {
//                std::cout << "Find Conditions: " << *cond << std::endl;
//            }
//            std::cout << std::endl;
            for (auto otherBranches = std::next(branch); otherBranches != branches.end(); ++otherBranches) {
                auto otherConditionList = otherBranches->second;
                for (auto &cond : otherConditionList) {
                    if (NodePeekVisitor::nodePeekUnaryExpr(cond) != nullptr) {
                        cond = (dynamic_cast<UnaryExpr * >(cond))->getExpr();
                    }
                }
//                for (auto cond : otherConditionList) {
//                    std::cout << *cond << std::endl;
//                }
                bool allFound = true;
                for (auto cond : conditionList) {
                    bool found = false;
                    for (auto otherCond : otherConditionList) {
                        if (*cond == *otherCond) {
                            found = true;
                        }
                    }
                    if (!found) {
                        allFound = false;
                    }
                }
                if (allFound) {
//                    std::cout << "All found!" << std::endl;
                    for (const auto &cond : conditionList) {
                        (otherBranches->second).erase(std::remove_if(
                                (otherBranches->second).begin(),
                                (otherBranches->second).end(),
                                [&cond](Expr *expr) {
                                    if (NodePeekVisitor::nodePeekUnaryExpr(expr) != nullptr) {
                                        return (*cond == *((dynamic_cast<UnaryExpr * >(expr))->getExpr()));
                                    }
                                    return false;
                                }), (otherBranches->second).end()
                        );
                    }
//                    std::cout << std::endl << "New List" << std::endl;
//                    for (auto cond : otherBranches->second) {
//                        std::cout << *cond << std::endl;
//                    }
//                } else {
//                    std::cout << "Not all found!" << std::endl;
                }
//                std::cout << std::endl << std::endl;
            }
//            std::cout << std::endl << std::endl;
        }
        function.second->setReturnValueConditionList(branches);
    }
}

void HLSmodule::mapOutputRegistersToOutput() {
    const auto& outputSet = getOutputs();
    auto candidates = getVariables();

    // If for every operation assignment of Variable equals assignment of DataSignal
    // we can map Variable -> DataSignal
    auto compareAssignments = [this](DataSignal* output) -> std::set<Variable*> {

        auto getOutputReg = [this](OperationProperty* operationProperty, Expr* expr, std::set<Variable*> &vars) -> void {
            for (const auto &commitment : operationProperty->getCommitmentList()) {
                if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                    Variable *var = (dynamic_cast<VariableOperand *>(commitment->getLhs()))->getVariable();
                    if (!(*expr == *commitment->getRhs())) {
                        auto pos = vars.find(var);
                        if (pos != vars.end()) {
                            vars.erase(pos);
                        }
                    }
                }
            }
        };

        auto candidates = getVariables();
        for (const auto& operationProperty : propertySuite->getOperationProperties()) {
            for (const auto &commitment : operationProperty->getCommitmentList()) {
                if (*(commitment->getLhs()) == *(commitment->getRhs())) {
                    continue;
                }
                if (NodePeekVisitor::nodePeekDataSignalOperand(commitment->getLhs())) {
                    const auto &dataSignal = dynamic_cast<DataSignalOperand *>(commitment->getLhs())->getDataSignal();
                    if (dataSignal == output) {
                        getOutputReg(operationProperty, commitment->getRhs(), candidates);
                    }
                }
            }
        }
        return candidates;
    };

    std::multimap<Variable*, DataSignal*> registerToOutput;
    for (const auto& output : outputSet) {
        const auto& outputReg = compareAssignments(output);
        if (outputReg.size() == 1) {
            registerToOutput.insert({*outputReg.begin(), output});
        } else {
            moduleOutputs.insert(output);
        }
    }

    const auto& parentMap = getParentMap(registerToOutput);
    registerToOutput.clear();

    for (const auto& parent : parentMap) {
        std::cout << parent.first->getFullName() << " -> " << parent.second->getFullName() << std::endl;
    }

    // If we can map multiple DataSignals to one Variable, we can replace these DataSignal by a new DataSignal
    // representing all these DataSignals
    std::map<DataSignal*, DataSignal*> oldToNewDataSignalMap;
    for (auto it = parentMap.cbegin(); it != parentMap.cend();) {
        Variable* reg = it->first;
        if (parentMap.count(reg) > 1) {
            std::vector<DataSignal*> outputs;
            do {
                outputs.emplace_back(it->second);
                ++it;
            } while (it != parentMap.cend() && reg == it->first);
            const auto& combinedDataSignal = getCombinedDataSignal(outputs);
            registerToOutputMap.insert({reg, combinedDataSignal});
            moduleOutputs.insert(combinedDataSignal);
            for (const auto& out : outputs) {
                oldToNewDataSignalMap.insert({out, combinedDataSignal});
            }
        } else {
            registerToOutputMap.insert({it->first, it->second});
            moduleOutputs.insert(it->second);
            ++it;
        }
    }
}

template<typename Key, typename Value>
std::map<Key *, Value *> HLSmodule::getSubVarMap(const std::map<Key *, Value *> map) {
    std::vector<Key* > keys;
    for (const auto& var : map) {
        if (var.first->isCompoundType()) {
            for (const auto& subVar : var.first->getSubVarList()) {
                keys.push_back(subVar);
            }
        } else {
            keys.push_back(var.first);
        }
    }
    std::vector<Value* > values;
    for (const auto& var : map) {
        if (var.second->isCompoundType()) {
            for (const auto& subVar : var.second->getSubVarList()) {
                values.push_back(subVar);
            }
        } else {
            values.push_back(var.second);
        }
    }
    std::map<Key *, Value *> subVarMap;
    for (std::size_t it = 0; it < keys.size(); ++it) {
        subVarMap.insert({keys.at(it), values.at(it)});
    }
    return subVarMap;
}

std::multimap<Variable*, DataSignal*> HLSmodule::getParentMap(const std::multimap<Variable*, DataSignal*> &multimap) {
    std::multimap<Variable*, DataSignal*> parentMap;
    std::set<std::pair<Variable*, DataSignal*>> uniquePairs;
    for (const auto& var : multimap) {
        if (var.first->isSubVar()) {
            if (uniquePairs.find({var.first->getParent(), var.second->getParent()}) == uniquePairs.end()) {
                parentMap.insert({var.first->getParent(), var.second->getParent()});
                uniquePairs.insert({var.first->getParent(), var.second->getParent()});
            }
        } else {
            if (uniquePairs.find({var.first, var.second}) == uniquePairs.end()) {
                parentMap.insert({var.first, var.second});
                uniquePairs.insert({var.first, var.second});
            }
        }
    }
    return parentMap;
}

bool HLSmodule::getCorrespondingRegisterName(const std::string& name, std::string& registerName) {
    std::map<std::string, std::string> names;
    for (const auto& item : outputToRegisterMap) {
        std::string outputName;
        if (item.first->isSubVar()) {
            outputName = item.first->getParent()->getName() + "_" + item.first->getName();
        } else {
            outputName = item.first->getName();
        }
        names.insert({outputName, item.second->getFullName()});
    }
    auto modifiedName = boost::algorithm::replace_all_copy(name, ".", "_");
    if (names.find(modifiedName) != names.end()) {
        registerName = names.at(modifiedName);
        return true;
    }
    return false;
}

std::set<DataSignal *> HLSmodule::getOutputs() {
    std::set<DataSignal*> outputSet;
    for (const auto &port : module->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            if (port.second->isCompoundType()) {
                for (const auto &subType : port.second->getDataSignal()->getSubVarList()) {
                    outputSet.insert(subType);
                }
            } else {
                outputSet.insert(port.second->getDataSignal());
            }
        }
    }
    return outputSet;
}

std::set<Variable *> HLSmodule::getVariables() {
    std::set<Variable* > variableSet;
    for (const auto &var : module->getVariableMap()) {
        if (var.second->isCompoundType()) {
            for (const auto &subVar : var.second->getSubVarList()) {
                variableSet.insert(subVar);
            }
        } else {
            variableSet.insert(var.second);
        }
    }

    // TODO: Not needed, if variableMap contains no unused variables anymore
    auto eraseIfFunction = [this](Variable* var) {
        for (const auto &operationProperties : propertySuite->getOperationProperties()) {
            for (const auto &commitment : operationProperties->getCommitmentList()) {
                if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                    Variable* var2 = (dynamic_cast<VariableOperand *>(commitment->getLhs()))->getVariable();
                    if (var->getFullName() == var2->getFullName()) {
                        return false;
                    }
                }
            }
        }
        return true;
    };

    for (auto var = variableSet.begin(); var != variableSet.end();) {
        if(eraseIfFunction(*var)) {
            variableSet.erase(var++);
        } else {
            ++var;
        }
    }

    return variableSet;
}

DataSignal* HLSmodule::getCombinedDataSignal(const std::vector<DataSignal*> &dataSignal) {

    std::string combinedName = dataSignal.front()->getFullName();
    for (auto it = std::next(dataSignal.begin()); it != dataSignal.end(); ++it) {
        std::string name1 = combinedName;
        std::string name2 = (*it)->getFullName();

        uint32_t m = combinedName.length();
        uint32_t n = (*it)->getFullName().length();

        uint32_t result = 0;
        uint32_t end = 0;
        uint32_t len[2][n];
        uint32_t currRow = 0;

        for (uint32_t i = 0; i <= m; i++) {
            for (uint32_t j = 0; j <= n; j++) {
                if (i == 0 || j == 0) {
                    len[currRow][j] = 0;
                } else if (name1[i - 1] == name2[j - 1]) {
                    len[currRow][j] = len[1 - currRow][j - 1] + 1;
                    if (len[currRow][j] > result) {
                        result = len[currRow][j];
                        end = i - 1;
                    }
                } else {
                    len[currRow][j] = 0;
                }
            }
            currRow = 1 - currRow;
        }
        combinedName = name1.substr(end - result + 1, result);
    }

    auto combinedDataSignal = new DataSignal(combinedName + "_sig", dataSignal.front()->getDataType());
    return combinedDataSignal;
}