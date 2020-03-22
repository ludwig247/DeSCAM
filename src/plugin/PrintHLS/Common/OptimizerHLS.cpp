//
// Created by johannes on 27.10.19.
//

#include <algorithm>

#include "ExprVisitor.h"
#include "NodePeekVisitor.h"
#include "OptimizerHLS.h"
#include "PrintArrayStatements.h"
#include "PropertySuiteHelper.h"
#include "PropertyHelper.h"

using namespace SCAM::HLSPlugin;

OptimizerHLS::OptimizerHLS(std::shared_ptr<PropertySuiteHelper>& propertyHelper, Module* module) :
        propertySuiteHelper(propertyHelper),
        module(module),
        registerToOutputMap(),
        outputToRegisterMap()
{
    removeRedundantConditions();
    findVariables();
    mapOutputRegistersToOutput();
    modifyCommitmentLists();
    findOperationModuleSignals();
    // arraySlicing();
}

bool OptimizerHLS::hasOutputReg(DataSignal* dataSignal) {
    const auto& subVarMap = getSubVarMap(outputToRegisterMap);
    return (outputToRegisterMap.find(dataSignal) != outputToRegisterMap.end() || subVarMap.find(dataSignal) != subVarMap.end());
}

bool OptimizerHLS::hasMultipleOutputs(DataSignal *dataSignal) const {
    return (moduleToTopSignalMap.find(dataSignal) != moduleToTopSignalMap.end());
}

Variable* OptimizerHLS::getCorrespondingRegister(DataSignal* dataSignal) {
    const auto& subVarMap = getSubVarMap(outputToRegisterMap);
    if (outputToRegisterMap.find(dataSignal) != outputToRegisterMap.end()) {
        return outputToRegisterMap.at(dataSignal);
    } else {
        return subVarMap.at(dataSignal);
    }
}

void OptimizerHLS::removeRedundantConditions()
{
    for (auto &function : module->getFunctionMap()) {
        auto branches = function.second->getReturnValueConditionList();
        for (auto branch = branches.begin(); std::next(branch) != branches.end(); ++branch) {
            auto conditionList = branch->second;
            for (auto otherBranches = std::next(branch); otherBranches != branches.end(); ++otherBranches) {
                auto otherConditionList = otherBranches->second;
                for (auto &cond : otherConditionList) {
                    if (NodePeekVisitor::nodePeekUnaryExpr(cond) != nullptr) {
                        cond = (dynamic_cast<UnaryExpr * >(cond))->getExpr();
                    }
                }
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
                }
            }
        }
        function.second->setReturnValueConditionList(branches);
    }
}

void OptimizerHLS::mapOutputRegistersToOutput() {
    // If for every operation the assignment of a Variable equals the assignment of a DataSignal
    // we can map Variable -> DataSignal
    auto compareAssignments = [this](DataSignal* output) -> std::set<Variable*> {

        auto getOutputReg = [this](Property* operationProperty, Expr* expr, std::set<Variable*> &vars) -> void {
            for (const auto &commitment : operationProperty->getOperation()->getCommitmentsList()) {
                if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                    Variable* var = (dynamic_cast<VariableOperand*>(commitment->getLhs()))->getVariable();
                    if (!(*expr == *commitment->getRhs())) {
                        auto pos = vars.find(var);
                        if (pos != vars.end()) {
                            vars.erase(pos);
                        }
                    }
                }
            }
        };

        auto candidates = variables;
        for (const auto& operationProperty : propertySuiteHelper->getOperationProperties()) {
            for (const auto &commitment : operationProperty->getOperation()->getCommitmentsList()) {
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
        for (const auto& commitment : propertySuiteHelper->getResetProperty()->getOperation()->getCommitmentsList()) {
            if (NodePeekVisitor::nodePeekDataSignalOperand(commitment->getLhs())) {
                const auto &dataSignal = dynamic_cast<DataSignalOperand *>(commitment->getLhs())->getDataSignal();
                if (dataSignal == output) {
                    getOutputReg(propertySuiteHelper->getResetProperty(), commitment->getRhs(), candidates);
                }
            }
        }
        return candidates;
    };

    std::set<DataSignal *> outputSet;
    for (const auto& property : propertySuiteHelper->getOperationProperties()) {
        for (const auto& commitment : property->getOperation()->getCommitmentsList()) {
            const auto& foundOutputs = ExprVisitor::getUsedDataSignals(commitment->getLhs());
            for (const auto& out : foundOutputs) {
                if (!(out->isSubVar() && out->getParent()->isArrayType())) {
                    outputSet.insert(out);
                }
            }
        }
    }

    std::multimap<Variable*, DataSignal*> registerToOutput;
    for (const auto& output : outputSet) {
        const auto& outputReg = compareAssignments(output);
        if (outputReg.size() == 1) {
            registerToOutput.insert({*outputReg.begin(), output});
        }
    }

    const auto parentMap = getParentMap(registerToOutput);

    // If we can map multiple DataSignals to one Variable, we can replace these DataSignal by a new DataSignal
    // representing all these DataSignals
    for (auto it = parentMap.cbegin(); it != parentMap.cend();) {
        Variable* reg = it->first;
        if (parentMap.count(reg) > 1) {
            std::vector<DataSignal*> outputSet;
            do {
                outputSet.emplace_back(it->second);
                ++it;
            } while (it != parentMap.cend() && reg == it->first);

            auto combinedDataSignal = getCombinedDataSignal(outputSet);
            registerToOutputMap.insert({reg, combinedDataSignal});
            outputToRegisterMap.insert({combinedDataSignal, reg});

            for (const auto& out : outputSet) {
                oldToNewDataSignalMap.insert({out, combinedDataSignal});
                moduleToTopSignalMap.insert({combinedDataSignal, outputSet});
            }
        } else {
            registerToOutputMap.insert({it->first, it->second});
            outputToRegisterMap.insert({it->second, it->first});
            ++it;
        }
    }
}

void OptimizerHLS::modifyCommitmentLists() {
    for (auto &&property : propertySuiteHelper->getOperationProperties()) {
        std::vector<Assignment *> assignments;
        for (const auto& commitment : property->getOperation()->getCommitmentsList()) {
            if (isSelfAssignments(commitment)) {
                continue;
            }
            auto newAssignment = commitment;
            auto replacedAssignment = replaceDataSignals(newAssignment);
            if (replacedAssignment) {
                newAssignment = replacedAssignment.get();
            }
            replacedAssignment = replaceByOutputRegister(newAssignment);
            if (replacedAssignment) {
                newAssignment = replacedAssignment.get();
            }
            if (!isDuplicate(newAssignment, assignments)) {
                assignments.push_back(newAssignment);
            }
        }
        property->setModifiedCommitmentList(std::move(assignments));
    }
}

bool OptimizerHLS::isSelfAssignments(Assignment* assignment) {
    return (*assignment->getLhs() == *assignment->getRhs());
}

boost::optional<Assignment *> OptimizerHLS::replaceDataSignals(Assignment* assignment) {
    if (NodePeekVisitor::nodePeekDataSignalOperand(assignment->getLhs())) {
        auto dataSignal = dynamic_cast<DataSignalOperand *>(assignment->getLhs())->getDataSignal();
        for (const auto subVar : getSubVarMap(oldToNewDataSignalMap)) {
            if (dataSignal == subVar.first) {
                auto newAssignment = new Assignment(new DataSignalOperand(subVar.second), assignment->getRhs());
                return newAssignment;
            }
        }
    }
    return boost::none;
}

boost::optional<Assignment *> OptimizerHLS::replaceByOutputRegister(Assignment* assignment) {
    if (NodePeekVisitor::nodePeekDataSignalOperand(assignment->getLhs())) {
        auto dataSignal = dynamic_cast<DataSignalOperand *>(assignment->getLhs())->getDataSignal();
        for (const auto& subVar : getSubVarMap(registerToOutputMap)) {
            if (dataSignal == subVar.second) {
                auto newAssigment = new Assignment(new VariableOperand(subVar.first), assignment->getRhs());
                return newAssigment;
            }
        }
    }
    return boost::none;
}

bool OptimizerHLS::isDuplicate(Assignment *newAssignment, std::vector<Assignment *> const& assignmentList) {
    for (const auto& assignment : assignmentList) {
        if (*assignment == *newAssignment) {
            return true;
        }
    }
    return false;
}

template<typename Key, typename Value>
std::map<Key *, Value *> OptimizerHLS::getSubVarMap(const std::map<Key *, Value *> map) {
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

template <typename T>
std::set<T *> OptimizerHLS::getParents(const std::set<T *> &subVars) {
    std::set<T *> parents;
    for (const auto& var : subVars) {
        if (var->isSubVar()) {
            if (parents.find(var->getParent()) == parents.end()) {
                parents.insert(var->getParent());
            }
        } else {
            if (parents.find(var) == parents.end()) {
                parents.insert(var);
            }
        }
    }
    return parents;
}

std::multimap<Variable*, DataSignal*> OptimizerHLS::getParentMap(const std::multimap<Variable*, DataSignal*> &multimap) {
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

void OptimizerHLS::findOperationModuleSignals() {
    std::set<Variable *> assumptionVariables;
    for (const auto& property : propertySuiteHelper->getOperationProperties()) {
        for (const auto& commitment : property->getModifiedCommitmentList()) {
            const auto out = ExprVisitor::getUsedDataSignals(commitment->getLhs());
            outputs.insert(out.begin(), out.end());

            const auto in = ExprVisitor::getUsedDataSignals(commitment->getRhs());
            inputs.insert(in.begin(), in.end());

            auto lhsVariables = ExprVisitor::getUsedVariables(commitment->getLhs());
            internalRegisterOut.insert(lhsVariables.begin(), lhsVariables.end());

            auto rhsVariables = ExprVisitor::getUsedVariables(commitment->getRhs());
            internalRegisterIn.insert(rhsVariables.begin(), rhsVariables.end());
        }
        for (const auto& assumption : property->getOperation()->getAssumptionsList()) {
            auto var = ExprVisitor::getUsedVariables(assumption);
            assumptionVariables.insert(var.begin(), var.end());
        }
    }

    // Remove constant Variable from Register Set
    auto it = internalRegisterIn.begin();
    while(it != internalRegisterIn.end()) {
        if (internalRegisterOut.find(*it) == internalRegisterOut.end()) {
            constantVariables.insert(*it);
            internalRegisterIn.erase(it++);
        } else {
            ++it;
        }
    }

    // Add variables only appear in assumptions to the Constant Set
    for (const auto& var : assumptionVariables) {
        if (internalRegisterOut.find(var) == internalRegisterOut.end()) {
            constantVariables.insert(var);
        }
    }
}

void OptimizerHLS::findVariables() {
    for (const auto &var : module->getVariableMap()) {
        if (var.second->isCompoundType()) {
            for (const auto& subVar : var.second->getSubVarList()) {
                variables.insert(subVar);
            }
        } else if (!var.second->isArrayType()) {
            if (!(var.second->isSubVar() && var.second->getParent()->isArrayType())) {
                variables.insert(var.second);
            }
        }
    }

    auto eraseIfFunction = [this](Variable  *var) {
        for (const auto &operationProperties : propertySuiteHelper->getOperationProperties()) {
            for (const auto &commitment : operationProperties->getOperation()->getCommitmentsList()) {
                if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                    Variable* var2 = (dynamic_cast<VariableOperand*>(commitment->getLhs()))->getVariable();
                    if (var->getFullName() == var2->getFullName()) {
                        return false;
                    }
                }
            }
        }
        return true;
    };

    for (auto var = variables.begin(); var != variables.end();) {
        if(eraseIfFunction(*var)) {
            variables.erase(var++);
        } else {
            ++var;
        }
    }
}

bool OptimizerHLS::isConstant(Variable *variable) const {
    return constantVariables.find(variable) != constantVariables.end();
}

std::set<Variable*> OptimizerHLS::getOutputRegister() {
    std::set<Variable *> outputRegister;
    for (const auto& reg : registerToOutputMap) {
        outputRegister.insert(reg.first);
    }
    return outputRegister;
}

DataSignal* OptimizerHLS::getCombinedDataSignal(const std::vector<DataSignal*> &dataSignal) {
    std::string combinedName = dataSignal.front()->getFullName();
    for (auto it = std::next(dataSignal.begin()); it != dataSignal.end(); ++it) {
//        std::string name1 = combinedName;
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
                } else if (combinedName[i - 1] == name2[j - 1]) {
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

        combinedName = combinedName.substr(end - result + 1, result);

        if (combinedName.empty()) {
            combinedName = dataSignal.front()->getName() + "_combined";
            break;
        }
    }

    auto combinedDataSignal = new DataSignal(
            combinedName + "_sig",
            dataSignal.front()->getDataType(),
            nullptr,
            nullptr,
            dataSignal.front()->getPort());

    return combinedDataSignal;
}

void OptimizerHLS::arraySlicing() {
    std::set<Port *> ports;
    for (const auto &port : module->getPorts()) {
        if (port.second->isArrayType()) {
            ports.insert(port.second);
        }
    }

    for (const auto &port : ports) {
        std::list<Expr *> expressions;
        for (const auto &operationProperty: propertySuiteHelper->getOperationProperties()) {
            for (const auto &commitment :  operationProperty->getOperation()->getCommitmentsList()) {
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
