//
// Created by johannes on 27.10.19.
//

#include <algorithm>

#include "ExprVisitor.h"
#include "NodePeekVisitor.h"
#include "Optimizer.h"
#include "PrintArrayStatements.h"

using namespace SCAM::HLSPlugin::HLS;

Optimizer::Optimizer(PropertySuite *propertySuite, Module* module) :
    propertySuite(propertySuite),
    module(module),
    registerToOutputMap(),
    outputToRegisterMap()
{
    // Save original commitment list
    for (const auto& operationProperty : propertySuite->getOperationProperties()) {
        originalCommitmentLists.push(operationProperty->getCommitmentList());
    }

    removeRedundantConditions();
    mapOutputRegistersToOutput();
    replaceVariables();
    arraySlicing();
}

Optimizer::~Optimizer() {
    // Load original commitment list
    for (const auto& operationProperty : propertySuite->getOperationProperties()) {
        operationProperty->setCommitmentList(originalCommitmentLists.front());
        originalCommitmentLists.pop();
    }
}

bool Optimizer::hasOutputReg(DataSignal* dataSignal) {
    const auto& subVarMap = getSubVarMap(outputToRegisterMap);
    return (outputToRegisterMap.find(dataSignal) != outputToRegisterMap.end() ||
            subVarMap.find(dataSignal) != subVarMap.end());
}

Variable* Optimizer::getCorrespondingRegister(DataSignal* dataSignal) {
    const auto& subVarMap = getSubVarMap(outputToRegisterMap);
    if (outputToRegisterMap.find(dataSignal) != outputToRegisterMap.end()) {
        return outputToRegisterMap.at(dataSignal);
    } else {
        return subVarMap.at(dataSignal);
    }
}

void Optimizer::removeRedundantConditions()
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

void Optimizer::mapOutputRegistersToOutput() {
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
            outputToRegisterMap.insert({combinedDataSignal, reg});
            moduleOutputs.insert(combinedDataSignal);
            for (const auto& out : outputs) {
                oldToNewDataSignalMap.insert({out, combinedDataSignal});
                moduleToTopSignalMap.insert({combinedDataSignal, outputs});
            }
        } else {
            registerToOutputMap.insert({it->first, it->second});
            outputToRegisterMap.insert({it->second, it->first});
            moduleOutputs.insert(it->second);
            ++it;
        }
    }
    replaceDataSignals(oldToNewDataSignalMap);
}

void Optimizer::replaceDataSignals(const std::map<DataSignal *, DataSignal *> &dataSignalMap) {
    const auto& subVarMap = getSubVarMap(dataSignalMap);

    std::cout << "Replace DataSignal by new DataSignal" << std::endl;
    for (const auto& subVar : subVarMap) {
        std::cout << subVar.first->getFullName() << " -> " << subVar.second->getFullName() << std::endl;

        for (const auto& property : propertySuite->getOperationProperties()) {
            std::vector<Assignment* > assignments;
            for (const auto& commitment : property->getCommitmentList()) {
                if (NodePeekVisitor::nodePeekDataSignalOperand(commitment->getLhs())) {
                    auto dataSignal = dynamic_cast<DataSignalOperand*>(commitment->getLhs())->getDataSignal();
                    if (dataSignal == subVar.first) {
                        assignments.emplace_back(
                                new SCAM::Assignment(new DataSignalOperand(subVar.second), commitment->getRhs()));
                        continue;
                    }
                }
                assignments.emplace_back(commitment);
            }
            property->setCommitmentList(assignments);
        }
    }
}

void Optimizer::replaceVariables() {
    const auto& subVarMap = getSubVarMap(registerToOutputMap);

    std::cout << "Replace OutputRegister by DataSignal" << std::endl;
    for (const auto& subVar : subVarMap) {
        std::cout << subVar.first->getFullName() << " -> " << subVar.second->getFullName() << std::endl;

        for (const auto& property : propertySuite->getOperationProperties()) {
            std::vector<Assignment* > assignments;
            for (const auto& commitment : property->getCommitmentList()) {
                // Remove if LHS == RHS
                if (*(commitment->getLhs()) == *(commitment->getRhs())) {
                    continue;
                }
                // Replace OutputRegister by DataSignal
                if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                    auto dataSignal = dynamic_cast<VariableOperand*>(commitment->getLhs())->getVariable();
                    if (dataSignal == subVar.first) {
                        assignments.emplace_back(
                                new SCAM::Assignment(new DataSignalOperand(subVar.second), commitment->getRhs()));
                        continue;
                    }
                }
                // Remove assignments with OutputRegister at RHS
                const auto& varSet = ExprVisitor::getUsedVariables(commitment->getRhs());
                if (varSet.find(subVar.first) != varSet.end()) {
                    continue;
                }
                assignments.emplace_back(commitment);
            }
            property->setCommitmentList(assignments);
        }
    }

    // Remove duplicate assignments
    for (const auto& property : propertySuite->getOperationProperties()) {
        std::vector<Assignment* > assignments;

        auto equalAssignments = [&assignments](Assignment* commitment) -> bool {
            for (const auto& assignment : assignments) {
                if (*assignment == *commitment) {
                    return true;
                }
            }
            return false;
        };

        for (const auto& commitment : property->getCommitmentList()) {
            if(!equalAssignments(commitment)) {
                assignments.push_back(commitment);
            }
        }
        property->setCommitmentList(assignments);
    }
}

template<typename Key, typename Value>
std::map<Key *, Value *> Optimizer::getSubVarMap(const std::map<Key *, Value *> map) {
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

std::multimap<Variable*, DataSignal*> Optimizer::getParentMap(const std::multimap<Variable*, DataSignal*> &multimap) {
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

std::set<DataSignal *> Optimizer::getOutputs() {
    std::set<DataSignal *> outputSet;
    for (const auto& property : propertySuite->getOperationProperties()) {
        for (const auto& commitment : property->getCommitmentList()) {
            if (*commitment->getLhs() == *commitment->getRhs()) {
                continue;
            }
            const auto& outputs = ExprVisitor::getUsedDataSignals(commitment->getLhs());
            outputSet.insert(outputs.begin(), outputs.end());
        }
    }
    for (const auto& moduleSignal : moduleToTopSignalMap) {
        outputSet.insert(moduleSignal.first);
        for (const auto& topSignal : moduleSignal.second) {
            const auto& it = outputSet.find(topSignal);
            if (it != outputSet.end()) {
                outputSet.erase(it);
            }
        }
    }
    return outputSet;
}

std::set<DataSignal *> Optimizer::getInputs() {
    std::set<DataSignal *> inputSet;
    for (const auto& property : propertySuite->getOperationProperties()) {
        for (const auto& commitment : property->getCommitmentList()) {
            if (*commitment->getLhs() == *commitment->getRhs()) {
                continue;
            }
            const auto& inputs = ExprVisitor::getUsedDataSignals(commitment->getRhs());
            inputSet.insert(inputs.begin(), inputs.end());
        }
    }
//    for (const auto &arrayPort : arrayPorts) {
//        for (unsigned int i = 0; i < arrayPort.second.size(); ++i) {
//            auto dataSignalCopy = new DataSignal(
//                    arrayPort.first->getName() + "_" + std::to_string(i),
//                    arrayPort.first->getDataType());
//            inputSet.insert(dataSignalCopy);
//        }
//    }
    return inputSet;
}

std::set<Variable *> Optimizer::getVariables() {
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

DataSignal* Optimizer::getCombinedDataSignal(const std::vector<DataSignal*> &dataSignal) {

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

    auto combinedDataSignal = new DataSignal(
            combinedName + "_sig",
            dataSignal.front()->getDataType(),
            dataSignal.front()->getInitialValue(),
            nullptr,
            dataSignal.front()->getPort());
    return combinedDataSignal;
}

std::set<Variable*> Optimizer::getInternalRegisterIn()
{
    std::set<Variable *> varsIn;
    for (const auto &operationProperties : propertySuite->getOperationProperties()) {
        for (const auto &commitment : operationProperties->getCommitmentList()) {
            if (*commitment->getLhs() == *commitment->getRhs()) {
                continue;
            }
            auto foundVars = ExprVisitor::getUsedVariables(commitment->getRhs());
            varsIn.insert(foundVars.begin(), foundVars.end());
        }
    }

    auto varsOut = getInternalRegisterOut();

    auto it = varsIn.begin();
    while(it != varsIn.end()) {
        if (varsOut.find(*it) == varsOut.end()) {
            varsIn.erase(it++);
        } else {
            ++it;
        }
    }

    return varsIn;
}

std::set<Variable*> Optimizer::getInternalRegisterOut()
{
    std::set<Variable *> vars;
    for (const auto operationProperties : propertySuite->getOperationProperties()) {
        for (const auto commitment : operationProperties->getCommitmentList()) {
            if (*commitment->getLhs() == *commitment->getRhs()) {
                continue;
            }
            auto foundVars = ExprVisitor::getUsedVariables(commitment->getLhs());
            vars.insert(foundVars.begin(), foundVars.end());
        }
    }
    return vars;
}

bool Optimizer::isConstant(Variable *variable) {
    auto internalRegister = getInternalRegisterOut();
    return internalRegister.find(variable) == internalRegister.end();
}

std::set<Port *> Optimizer::setArrayPorts()
{
    std::set<Port *> ports;
    for (const auto &port : module->getPorts()) {
        if (port.second->isArrayType()) {
            ports.insert(port.second);
        }
    }
    return ports;
}

void Optimizer::arraySlicing() {
    const auto ports = setArrayPorts();

    for (const auto &port : ports) {
        std::list<Expr *> expressions;
        for (const auto &operationProperty: propertySuite->getOperationProperties()) {
            for (const auto &commitment :  operationProperty->getCommitmentList()) {
                const auto foundExpressions = PrintArrayStatements::getArrayExprs(commitment->getRhs(), port);
                for (const auto &foundExpression : foundExpressions) {
                    bool alreadyFound = false;
                    for (const auto &expression : expressions) {
                        if (*foundExpression == *expression) {
                            alreadyFound = true;
                        }
                    }
                    if (!alreadyFound) {
                        expressions.push_back(foundExpression);
                    }
                }
            }
        }
        for (const auto &expression : expressions) {
            std::cout << *expression << std::endl;
        }
        arrayPorts.insert({port, expressions});
    }
}

//    for (const auto& state : propertySuite->getStates()) {
//        auto successorProperties = propertySuite->getSuccessorProperties(state);
//        std::sort(successorProperties.begin(), successorProperties.end(), [](const AbstractProperty* prop1, const AbstractProperty* prop2) {
//            return (prop1->getAssumptionList().size() < prop2->getAssumptionList().size());
//        });
//        for (auto property = successorProperties.begin(); property != successorProperties.end(); ++property) {
//            auto assumptionList = (*property)->getAssumptionList();
//            for (auto assumption : assumptionList) {
//                std::cout << "Find Conditions: " << *assumption << std::endl;
//            }
//            std::cout << std::endl;
//            for (auto otherProperty = std::next(property); otherProperty != successorProperties.end(); ++otherProperty) {
//                auto otherAssumptionList = (*otherProperty)->getAssumptionList();
//                for (auto &assumption : otherAssumptionList) {
//                    if (NodePeekVisitor::nodePeekUnaryExpr(assumption) != nullptr) {
//                        assumption = (dynamic_cast<UnaryExpr * >(assumption))->getExpr();
//                    }
//                }
//                for (auto assumption : otherAssumptionList) {
//                    std::cout << *assumption << std::endl;
//                }
//                bool allFound = true;
//                for (auto assumption : assumptionList) {
//                    bool found = false;
//                    for (auto otherAssumption : otherAssumptionList) {
//                        if (*assumption == *otherAssumption) {
//                            found = true;
//                        }
//                    }
//                    if (!found) {
//                        allFound = false;
//                    }
//                }
//                if (allFound) {
//                    std::cout << "All found!" << std::endl;
//                    for (const auto &assumption : assumptionList) {
//                        (otherAssumptionList).erase(std::remove_if(
//                                otherAssumptionList.begin(),
//                                otherAssumptionList.end(),
//                                [&assumption](Expr *expr) {
//                                    if (NodePeekVisitor::nodePeekUnaryExpr(expr) != nullptr) {
//                                        return (*assumption == *((dynamic_cast<UnaryExpr * >(expr))->getExpr()));
//                                    }
//                                    return false;
//                                }), otherAssumptionList.end()
//                        );
//                    }
//                    std::cout << std::endl << "New List" << std::endl;
//                    for (auto assumption : otherAssumptionList) {
//                        std::cout << *assumption << std::endl;
//                    }
//                } else {
//                    std::cout << "Not all found!" << std::endl;
//                }
//                std::cout << std::endl << std::endl;
//            }
//            std::cout << std::endl << std::endl;
//        }
//    }