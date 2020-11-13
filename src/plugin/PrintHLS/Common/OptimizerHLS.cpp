//
// Created by johannes on 27.10.19.
//

#include <algorithm>
#include <PrintHLS/Common/Utilities.h>
//#include <PrintHLS/VHDLWrapper/PrintStmtVHDL.h>
#include <Stmts/StmtCastVisitor.h>

#include "ExprVisitor.h"
#include "NodePeekVisitor.h"
#include "OptimizerHLS.h"
#include "PrintArrayStatements.h"
#include "PropertySuite.h"
#include "Utilities.h"

using namespace DESCAM::HLSPlugin;

OptimizerHLS::OptimizerHLS(std::shared_ptr<PropertySuite> propertyHelper, Module *module) :
        propertySuite(propertyHelper),
        module(module),
        registerToOutputMap(),
        outputToRegisterMap() {
    findUsedDataTypes();
    removeRedundantConditions();
    findVariables();
    mapOutputRegistersToOutput();
    simplifyCommitments();
    findOperationModuleSignals();
}

/*
 * Extracts enum, compound and array data types used in the design
 */
void OptimizerHLS::findUsedDataTypes() {

    auto fillTypeSets = [this](const DataType *dataType) {
        if (dataType->isEnumType()) {
            enumTypes.insert(dataType);
        } else if (dataType->isCompoundType()) {
            compoundTypes.insert(dataType);
        } else if (dataType->isArrayType()) {
            arrayTypes.insert(dataType);
        }
    };

    for (const auto &reg : propertySuite->getVisibleRegisters()) {
        fillTypeSets(reg->getDataType());
    }
    for (const auto &func : propertySuite->getFunctions()) {
        fillTypeSets(func->getReturnType());
    }
    for (const auto &port : module->getPorts()) {
        if (port.second->isCompoundType()) {
            for (const auto &subVar : port.second->getDataSignal()->getSubVarList()) {
                fillTypeSets(subVar->getDataType());
            }
        }
        fillTypeSets(port.second->getDataType());
    }
    for (const auto &var : module->getVariableMap()) {
        fillTypeSets(var.second->getDataType());
    }
}

/*
 * Iterates over all return values of a function, removing redundant conditions of previous branches
 *
 * TODO: Have this functionality implemented inside the FunctionFactory
 */
void OptimizerHLS::removeRedundantConditions() {

    for (auto &function : propertySuite->getFunctions()) {

        // Create a local modifiable copy
        auto branches = function->getReturnValueConditionList();

        // Iterate over all pairs of branches
        for (auto branch = branches.begin(); std::next(branch) != branches.end(); branch++) {
            auto const &conditionList = branch->second;
            for (auto otherBranch = std::next(branch); otherBranch != branches.end(); otherBranch++) {
                auto &otherConditionList = otherBranch->second;

                for (auto const &cond : conditionList) {
                    for (auto const &otherCond : otherConditionList) {

                        // Check, if the condition is negated
                        if (NodePeekVisitor::nodePeekUnaryExpr(otherCond) != nullptr) {
                            auto const otherCondExpr = NodePeekVisitor::nodePeekUnaryExpr(otherCond)->getExpr();

                            // Remove condition, if it is already covered by previous branches
                            if (*cond == *otherCondExpr) {
                                otherConditionList.erase(
                                        std::find(otherConditionList.begin(), otherConditionList.end(), otherCond));
                            }

                        }
                    }
                }

            }
        }

        function->setReturnValueConditionList(branches);
    }
}

/*
 * Create a set of all variables in the design
 *
 * Enum types create a variable for each sub type
 */
void OptimizerHLS::findVariables() {

    for (const auto &var : module->getVariableMap()) {
        if (var.second->isCompoundType()) {
            for (const auto &subVar : var.second->getSubVarList()) {
                variables.insert(subVar);
            }
        } else if (!(var.second->isArrayType()) &&
                   !(var.second->isSubVar() && var.second->getParent()->isArrayType())) {
            variables.insert(var.second);
        }
    }
}

/*
 * Creates a map of register-output pairs with equivalent behavior
 */
void OptimizerHLS::mapOutputRegistersToOutput() {
    // Check if there exists a variable that has the same assignments as the given DataSignal
    auto compareAssignments = [this](DataSignal *output) -> std::set<Variable *> {

        // Takes an operation property, expression and set of variables
        // Checks if there is a rhs in the commitments of the properties, that matches the given expression
        // If not, the lhs variable is removed from the given set
        auto getOutputReg = [](const std::shared_ptr<Property> &operationProperty,
                               Expr *expr,
                               std::set<Variable *> &vars) {
            for (const auto &commitment : operationProperty->getOperation()->getCommitmentsList()) {
                if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                    auto var = StmtCastVisitor<VariableOperand>(commitment->getLhs()).Get()->getVariable();
                    if (!(*expr == *commitment->getRhs())) {
                        auto pos = vars.find(var);
                        if (pos != vars.end()) {
                            vars.erase(pos);
                        }
                    }
                }
            }
        };

        // If the DataSignal under test maintains its value, the same has to be true for its variable counterpart
        auto checkForSelfAssignments = [](const std::shared_ptr<Property> &operationProperty,
                                          std::set<Variable *> &vars) {
            for (const auto &commitment : operationProperty->getOperation()->getCommitmentsList()) {
                if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                    auto var = StmtCastVisitor<VariableOperand>(commitment->getLhs()).Get()->getVariable();
                    if (!(*(commitment->getLhs()) == *(commitment->getRhs()))) {
                        auto pos = vars.find(var);
                        if (pos != vars.end()) {
                            vars.erase(pos);
                        }
                    }
                }
            }
        };

        auto candidates = variables;

        // If the given data signal is present in the commitment list, check for equal rhs expressions
        for (const auto &operationProperty : propertySuite->getOperationProperties()) {
            if (candidates.empty()) {
                break;
            }
            for (const auto &commitment : operationProperty->getOperation()->getCommitmentsList()) {
                // Find the data signal inside the property
                if (NodePeekVisitor::nodePeekDataSignalOperand(commitment->getLhs())) {
                    const auto &dataSignal = StmtCastVisitor<DataSignalOperand>(
                            commitment->getLhs()).Get()->getDataSignal();
                    if (dataSignal == output) {
                        if (*(commitment->getLhs()) == *(commitment->getRhs())) {
                            // Iterate over candidates and remove every candidate that does not keep its value
                            checkForSelfAssignments(operationProperty, candidates);
                        } else {
                            getOutputReg(operationProperty, commitment->getRhs(), candidates);
                        }
                    }
                }
            }
        }

        // Do the same for the reset property
        for (const auto &commitment : propertySuite->getResetProperty()->getOperation()->getCommitmentsList()) {
            if (NodePeekVisitor::nodePeekDataSignalOperand(commitment->getLhs())) {
                const auto &dataSignal = StmtCastVisitor<DataSignalOperand>(
                        commitment->getLhs()).Get()->getDataSignal();
                if (dataSignal == output) {
                    getOutputReg(propertySuite->getResetProperty(), commitment->getRhs(), candidates);
                }
            }
        }
        return candidates;
    };

    // Find used DataSignals
    std::set<DataSignal *> outputSet;
    for (const auto &property : propertySuite->getOperationProperties()) {
        for (const auto &commitment : property->getOperation()->getCommitmentsList()) {
            const auto &foundOutputs = ExprVisitor::getUsedDataSignals(commitment->getLhs());
            for (const auto &out : foundOutputs) {
                if (!(out->isSubVar() && out->getParent()->isArrayType())) {
                    outputSet.insert(out);
                }
            }
        }
    }

    // Check all variables for each DataSignal
    std::multimap<Variable *, DataSignal *> registerToOutput;
    for (const auto &output : outputSet) {
        const auto &outputReg = compareAssignments(output);
        if (outputReg.size() == 1) {
            registerToOutput.insert({*outputReg.begin(), output});
        }
    }

    // If compound types are in use, only the parent type gets a mapping
    for (const auto &mapping : registerToOutput) {
        if (mapping.first->isSubVar()) {
            if (registerToOutputMap.find(mapping.first->getParent()) == registerToOutputMap.end()) {
                registerToOutputMap.insert({mapping.first->getParent(), mapping.second->getParent()});
                outputToRegisterMap.insert({mapping.second->getParent(), mapping.first->getParent()});
            }
        } else {
            if (registerToOutputMap.find(mapping.first) == registerToOutputMap.end()) {
                registerToOutputMap.insert({mapping.first, mapping.second});
                outputToRegisterMap.insert({mapping.second, mapping.first});
            }
        }
    }

}

/*
 * Check if the given data signal has an output register
 */
bool OptimizerHLS::hasOutputReg(DataSignal *dataSignal) {
    const auto &subVarMap = getSubVarMap(outputToRegisterMap);
    return (outputToRegisterMap.find(dataSignal) != outputToRegisterMap.end() ||
            subVarMap.find(dataSignal) != subVarMap.end());
}

Variable *OptimizerHLS::getCorrespondingRegister(DataSignal *dataSignal) {
    const auto &subVarMap = getSubVarMap(outputToRegisterMap);
    if (outputToRegisterMap.find(dataSignal) != outputToRegisterMap.end()) {
        return outputToRegisterMap.at(dataSignal);
    } else {
        return subVarMap.at(dataSignal);
    }
}


void OptimizerHLS::simplifyCommitments() {
    for (auto &property : propertySuite->getOperationProperties()) {
        std::vector<Assignment *> assignments;
        for (const auto &commitment : property->getOperation()->getCommitmentsList()) {
            if (isSelfAssignments(commitment)) {
                continue;
            }
            auto newAssignment = commitment;
            auto replacedAssignment = replaceByOutputRegister(newAssignment);
            if (replacedAssignment.valid) {
                newAssignment = replacedAssignment.value;
            }
            if (!isDuplicate(newAssignment, assignments)) {
                assignments.push_back(newAssignment);
            }
        }

        simplifiedCommitments.insert({property, assignments});

        //property->setModifiedCommitmentList(std::move(assignments));
    }
}

bool OptimizerHLS::isSelfAssignments(Assignment *assignment) {
    return (*assignment->getLhs() == *assignment->getRhs());
}

optional OptimizerHLS::replaceByOutputRegister(Assignment *assignment) {
    if (auto operand = StmtCastVisitor<DataSignalOperand>(assignment->getLhs()).Get()) {
        auto dataSignal = operand->getDataSignal();
        for (const auto &subVar : getSubVarMap(registerToOutputMap)) {
            if (dataSignal == subVar.second) {
                auto newAssigment = new Assignment(new VariableOperand(subVar.first), assignment->getRhs());
                return {true, newAssigment};
            }
        }
    }
    return {false, nullptr};
}

bool OptimizerHLS::isDuplicate(Assignment *newAssignment, std::vector<Assignment *> const &assignmentList) {
    for (const auto &assignment : assignmentList) {
        if (*assignment == *newAssignment) {
            return true;
        }
    }
    return false;
}

template<typename Key, typename Value>
std::map<Key *, Value *> OptimizerHLS::getSubVarMap(const std::map<Key *, Value *> map) {
    std::vector<Key *> keys;
    for (const auto &var : map) {
        if (var.first->isCompoundType()) {
            for (const auto &subVar : var.first->getSubVarList()) {
                keys.push_back(subVar);
            }
        } else {
            keys.push_back(var.first);
        }
    }
    std::vector<Value *> values;
    for (const auto &var : map) {
        if (var.second->isCompoundType()) {
            for (const auto &subVar : var.second->getSubVarList()) {
                values.push_back(subVar);
            }
        } else {
            values.push_back(var.second);
        }
    }
    if (keys.size() > values.size()) {
        std::cout << "Terminating inside OptimizerHLS::getSubVarMap. To be fixed.\n";
    }
    std::map<Key *, Value *> subVarMap;
    for (std::size_t it = 0; it < keys.size(); ++it) {
        //FIXME: Segmentation fault if keys.size() > values.size()
        subVarMap.insert({keys.at(it), values.at(it)});
    }
    return subVarMap;
}

void OptimizerHLS::findOperationModuleSignals() {


    std::set<Variable *> assumptionVariables;

    for (auto &property : propertySuite->getOperationProperties()) {

        for (const auto &commitment : simplifiedCommitments.at(property)) {

            if (commitment == nullptr) {
                continue;
            }

            const auto out = ExprVisitor::getUsedDataSignals(commitment->getLhs());
            outputs.insert(out.begin(), out.end());

            const auto in = ExprVisitor::getUsedDataSignals(commitment->getRhs());
            inputs.insert(in.begin(), in.end());

            auto lhsVariables = ExprVisitor::getUsedVariables(commitment->getLhs());
            internalRegisterOut.insert(lhsVariables.begin(), lhsVariables.end());

            auto rhsVariables = ExprVisitor::getUsedVariables(commitment->getRhs());
            internalRegisterIn.insert(rhsVariables.begin(), rhsVariables.end());
        }

        for (const auto &assumption : property->getOperation()->getAssumptionsList()) {
            auto var = ExprVisitor::getUsedVariables(assumption);
            assumptionVariables.insert(var.begin(), var.end());
        }


    }

    // Remove constant Variable from Register Set
    auto it = internalRegisterIn.begin();
    while (it != internalRegisterIn.end()) {
        if (internalRegisterOut.find(*it) == internalRegisterOut.end()) {
            constantVariables.insert(*it);
            internalRegisterIn.erase(it++);
        } else {
            ++it;
        }
    }

    // Add variables only appear in assumptions to the Constant Set
    for (const auto &var : assumptionVariables) {
        if (internalRegisterOut.find(var) == internalRegisterOut.end()) {
            constantVariables.insert(var);
        }
    }

    // Check for constants only used inside functions
    for (const auto &function : module->getFunctionMap()) {
        std::set<Variable *> usedVariables;
        for (const auto &retVal : function.second->getReturnValueConditionList()) {
            for (const auto &cond : retVal.second) {
                const auto &foundVariables = ExprVisitor::getUsedVariables(cond);
                usedVariables.insert(foundVariables.begin(), foundVariables.end());
            }
            auto const &foundVariables = ExprVisitor::getUsedVariables(retVal.first->getReturnValue());
            usedVariables.insert(foundVariables.begin(), foundVariables.end());
        }
        for (const auto &var : usedVariables) {
            if (var->isConstant()) {
                constantVariables.insert(var);
            }
        }

    }

}

bool OptimizerHLS::isConstant(Variable *variable) const {
    return constantVariables.find(variable) != constantVariables.end();
}

std::set<Variable *> OptimizerHLS::getOutputRegister() {
    std::set<Variable *> outputRegister;
    for (const auto &reg : registerToOutputMap) {
        outputRegister.insert(reg.first);
    }
    return outputRegister;
}

std::vector<DataSignal *> OptimizerHLS::getConstantOutputs() {
    auto nonConstantOutputs = outputs;
    for (const auto &var : registerToOutputMap) {
        if (var.second->isCompoundType()) {
            for (auto &&subVar : var.second->getSubVarList()) {
                nonConstantOutputs.insert(subVar);
            }
        } else {
            nonConstantOutputs.insert(var.second);
        }
    }
    std::vector<DataSignal *> constantOutputs;
    for (const auto &port : module->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            auto outPort = port.second;
            if (outPort->getDataSignal()->isCompoundType()) {
                for (auto &&subVar : outPort->getDataSignal()->getSubVarList()) {
                    constantOutputs.push_back(subVar);
                }
            } else {
                constantOutputs.push_back(port.second->getDataSignal());
            }
        }
    }

    auto removeFunction = [&nonConstantOutputs](DataSignal *signal) -> bool {
        return nonConstantOutputs.find(signal) != nonConstantOutputs.end();
    };

    constantOutputs.erase(std::remove_if(constantOutputs.begin(),
                                         constantOutputs.end(),
                                         removeFunction),
                          constantOutputs.end());

/*    std::cout << "const:" << std::endl;
    for (const auto &out : constantOutputs) {
        std::cout << out->getFullName() << std::endl;
    }
    std::cout << std::endl;
    std::cout << "non-const:" << std::endl;
    for (const auto &out : nonConstantOutputs) {
        std::cout << out->getFullName() << std::endl;
    }
    std::cout << std::endl;
*/

    return constantOutputs;
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
        for (const auto &operationProperty: propertySuite->getOperationProperties()) {
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

const std::map<std::shared_ptr<Property>, std::vector<Assignment *>> &OptimizerHLS::getSimplifiedCommitments() const {
    return simplifiedCommitments;
}

std::vector<DESCAM::Assignment *> OptimizerHLS::getNotifyStatements(std::shared_ptr<Property> property) const {
    std::vector<DESCAM::Assignment *> assignmentList;
    auto temporalExprs = property->getCommitmentList();
    for (auto temporalExpr : temporalExprs) {
        auto timePoint = PrintStmt::toString(temporalExpr->getTimepointList().back());
        if (timePoint != "t_end" && temporalExpr->isDuring()) {
            continue;
        }
        if (NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement())) {
            auto statement = StmtCastVisitor<Assignment>(temporalExpr->getStatement()).Get();
            if (NodePeekVisitor::nodePeekNotify(statement->getLhs())) {
                assignmentList.push_back(statement);
            }
        }
    }
    return assignmentList;
}

std::vector<DESCAM::Assignment *> OptimizerHLS::getResetStatements() {
    std::vector<DESCAM::Assignment *> assignmentList;
    auto temporalExprs = propertySuite->getResetProperty()->getCommitmentList();
    for (auto temporalExpr : temporalExprs) {
        if (NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement())) {
            auto statement = StmtCastVisitor<Assignment>(temporalExpr->getStatement()).Get();
            assignmentList.push_back(statement);
        }
    }
    return assignmentList;
}

/*
 * Takes a bitwise operation and tries to express it as a bit slicing expression
 *
 * Since bit slicing is not part of descam, it has to be expressed by using the logical and operator.
 * Rewriting it makes the generated code much more readable.
 * E.g. x & "0000 0000 0011 1111" -> x(5 downto 0)
 *
 * If unsuccessful, an empty string is returned
 */
/*std::string OptimizerHLS::sliceBitwise(Bitwise &operation) {

    if (operation.getOperation() == "&") {

        const auto lhsConstant = (NodePeekVisitor::nodePeekIntegerValue(operation.getLhs()) != nullptr) ||
                                 (NodePeekVisitor::nodePeekUnsignedValue(operation.getLhs()) != nullptr);
        const auto rhsConstant = (NodePeekVisitor::nodePeekIntegerValue(operation.getRhs()) != nullptr) ||
                                 (NodePeekVisitor::nodePeekUnsignedValue(operation.getRhs()) != nullptr);

        // Ensure exactly one value is constant
        if (lhsConstant == rhsConstant) {
            return "";
        }

        const auto &constant = (lhsConstant ? operation.getLhs() : operation.getRhs());
        const auto &variable = (rhsConstant ? operation.getLhs() : operation.getRhs());

        auto constantValue = 0;
        if (constant->getDataType()->isInteger()) {
            constantValue = NodePeekVisitor::nodePeekIntegerValue(constant)->getValue();
        } else if (constant->getDataType()->isUnsigned()) {
            constantValue = NodePeekVisitor::nodePeekUnsignedValue(constant)->getValue();
        } else {
            throw std::runtime_error("OptimizerHLS::sliceBitwise - Unknown data type for variable \'constant\'");
        }

        std::stringstream ss;
        auto offset = 0;
        if ((NodePeekVisitor::nodePeekVariableOperand(variable) != nullptr)
            || (NodePeekVisitor::nodePeekDataSignalOperand(variable) != nullptr)
            || (NodePeekVisitor::nodePeekParamOperand(variable) != nullptr)) {
            ss << DESCAM::HLSPlugin::VHDLWrapper::PrintStmtVHDL::toString(variable);
        } else if (NodePeekVisitor::nodePeekBitwise(variable) != nullptr) {

            // Only consider the case "var >> const"
            const auto &subOperation = NodePeekVisitor::nodePeekBitwise(variable);
            if (!(subOperation->getOperation() == ">>")) {
                return "";
            }

            const auto subLhsConstant = (NodePeekVisitor::nodePeekIntegerValue(subOperation->getLhs()) != nullptr) ||
                                        (NodePeekVisitor::nodePeekUnsignedValue(subOperation->getLhs()) != nullptr);
            const auto subRhsConstant = (NodePeekVisitor::nodePeekIntegerValue(subOperation->getRhs()) != nullptr) ||
                                        (NodePeekVisitor::nodePeekUnsignedValue(subOperation->getRhs()) != nullptr);

            // Ensure right value is constant, left is not
            if (!(!subLhsConstant && subRhsConstant)) {
                return "";
            }

            const auto &subConstant = subOperation->getRhs();
            const auto &subVariable = subOperation->getLhs();

            if (subConstant->getDataType()->isInteger()) {
                offset = NodePeekVisitor::nodePeekIntegerValue(subConstant)->getValue();
            } else if (subConstant->getDataType()->isUnsigned()) {
                offset = NodePeekVisitor::nodePeekUnsignedValue(subConstant)->getValue();
            } else {
                throw std::runtime_error("OptimizerHLS::sliceBitwise - Unknown data type for variable \'subConstant\'");
            }

            if ((NodePeekVisitor::nodePeekVariableOperand(subVariable) != nullptr)
                || (NodePeekVisitor::nodePeekDataSignalOperand(subVariable) != nullptr)
                || (NodePeekVisitor::nodePeekParamOperand(subVariable) != nullptr)) {
                ss << DESCAM::HLSPlugin::VHDLWrapper::PrintStmtVHDL::toString(subVariable);
            } else {
                return "";
            }

        } else {
            return "";
        }

        auto sliceIndices = Utilities::findBlockOfSetBits(constantValue);

        ss << "(";
        if ((sliceIndices.first < sliceIndices.second) || (sliceIndices.second != 0)) {
            return "";
        } else if (sliceIndices.first == sliceIndices.second) {
            ss << (sliceIndices.first + offset);
        } else {
            ss << (sliceIndices.first + offset) << " downto " << (sliceIndices.second + offset);
        }
        ss << ")";

        return ss.str();

    }

    return "";
}*/






















