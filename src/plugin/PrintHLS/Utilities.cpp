//
// Created by johannes on 27.10.19.
//

#include <memory>
#include <algorithm>
#include "Utilities.h"
#include "VisitInternalRegister.h"
#include "InputRegisterVisitor.h"
#include "NodePeekVisitor.h"
#include "PrintFunctionStatements.h"

Utilities::Utilities(PropertySuite *propertySuite, Module* module) :
    propertySuite(propertySuite),
    module(module),
    regs(),
    registerToOutputMap()
{
    mapOutputRegistersToOutput();
    setRegisters();
    removeRedundantConditions();
    getStmtType();
    simplifyCommitments();
}

void Utilities::setRegisters() {
    auto visitInternalRegister = std::make_unique<VisitInternalRegister>();
    for (auto operationProperty : propertySuite->getOperationProperties()) {
        for (auto commitment : operationProperty->getCommitmentList()) {
            if (*(commitment->getLhs()) == *(commitment->getRhs())) {
                continue;
            }
            visitInternalRegister->run(commitment);
        }
    }
    for (const auto &internalReg : visitInternalRegister->getRegs()) {
        auto it = registerToOutputMap.find(internalReg);
        if (it == registerToOutputMap.end()) {
            regs.insert(internalReg);
        } else {
            regsReplaceByOutput.insert(internalReg);
        }
    }
    std::cout << std::endl << "REGISTERS:\n";
    for (auto reg : regs) {
        std::cout << reg->getName() << std::endl;
    }
    std::cout << std::endl;
}

void Utilities::getStmtType() {
    for (auto port : module->getPorts()) {
        if (port.second->getInterface()->isInput() && port.second->isArrayType()) {
            for (const auto &operationProperty : propertySuite->getOperationProperties()) {
                std::size_t counter = 0;
                for (auto commitment : operationProperty->getCommitmentList()) {
                    if (*(commitment->getLhs()) == *(commitment->getRhs())) {
                        continue;
                    }
                    if (InputRegisterVisitor::getStmtTypes(commitment->getRhs(), port.second)) {
                        counter++;
                    }
                }
                std::cout << operationProperty->getName() << ": " << port.second->getName() << ": Number of Subtypes "
                          << counter << std::endl;
            }
        }
    }
}

void Utilities::removeRedundantConditions()
{
    for (auto &function : module->getFunctionMap()) {
//        std::cout << "------ FUNCTION " << function.second->getName() << " --------" << std::endl;

        auto branches = function.second->getReturnValueConditionList();
        for (auto branch = branches.begin(); std::next(branch) != branches.end(); ++branch) {
            auto conditionList = branch->second;
            for (auto cond : conditionList) {
//                std::cout << "Find Conditions: " << *cond << std::endl;
            }
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
                auto test = otherBranches->second;
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

void Utilities::mapOutputRegistersToOutput() {
    std::set<DataSignal*> outputSet;
    for (const auto &port : module->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            if (port.second->isCompoundType()) {
                for (const auto &subType : port.second->getDataSignal()->getSubVarList()) {
//                    std::cout << "Port: " << subType->getFullName() << std::endl;
                    outputSet.insert(subType);
                }
            } else {
//                std::cout << "Port: " << port.second->getName() << std::endl;
                outputSet.insert(port.second->getDataSignal());
            }
        }
    }

    std::set<Variable* > candidates;
    for (const auto &var : module->getVariableMap()) {
        if (var.second->isCompoundType()) {
            for (const auto &subVar : var.second->getSubVarList()) {
                candidates.insert(subVar);
            }
        } else {
            candidates.insert(var.second);
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

    for (auto candidate = candidates.begin(); candidate != candidates.end();) {
        if(eraseIfFunction(*candidate)) {
            candidates.erase(candidate++);
        } else {
            ++candidate;
        }
    }

    for (const auto& output : outputSet) {
        std::cout << "Port: " << output->getFullName() <<  " -> ";
        getRHSExpr(output, candidates);
    }
}

void Utilities::getRHSExpr(DataSignal* dataSignal, std::set<Variable*> candidates) {
    for (const auto &operationProperties : propertySuite->getOperationProperties()) {
        Expr* expr = nullptr;
        for (const auto &commitment : operationProperties->getCommitmentList()) {
            if (*(commitment->getLhs()) == *(commitment->getRhs())) {
                continue;
            }
            if (NodePeekVisitor::nodePeekDataSignalOperand(commitment->getLhs())) {
                if (dataSignal->getFullName() == PrintFunctionStatements::toString(commitment->getLhs())) {
//                    std::cout << operationProperties->getName() << ": ";
//                    std::cout << PrintFunctionStatements::toString(commitment->getRhs()) << " -> ";
                    expr = commitment->getRhs();
                }
            }
        }
        if (expr) {
            for (const auto& commitment : operationProperties->getCommitmentList()) {
                std::string lhs = PrintFunctionStatements::toString(commitment->getLhs());
                if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                    Variable *var = (dynamic_cast<VariableOperand *>(commitment->getLhs()))->getVariable();
                    if (!(*expr == *commitment->getRhs())) {
                        auto pos = candidates.find(var);
                        if (pos != candidates.end()) {
                            candidates.erase(pos);
                        }
//                        std::cout << PrintFunctionStatements::toString(commitment->getLhs()) << std::endl;
                    }
                }
            }
        }
    }
    for (const auto& candidate : candidates) {
        std::cout << candidate->getFullName() << " ";
    }
    std::cout << std::endl;

    if (candidates.size() == 1) {
        registerToOutputMap.insert({*(candidates.begin()), dataSignal});
        outputToRegisterMap.insert({dataSignal, *(candidates.begin())});
        outputRegisters.insert(*(candidates.begin()));
    }
}

void Utilities::simplifyCommitments() {

    auto equalLHSFunction = [](const std::set<Expr* > &lhsSet, Assignment* commitment) -> bool {
        for (const auto& lhs : lhsSet) {
            if (*lhs == *commitment->getLhs())
                return true;
        }
        return false;
    };

    for (const auto &operationProperties : propertySuite->getOperationProperties()) {
        std::vector<Assignment *> assignments;
        std::set<Expr* > lhsSet;
        for (const auto &commitment : operationProperties->getCommitmentList()) {
            if (*commitment->getLhs() == *commitment->getRhs()) {
                continue;
            }
            if (NodePeekVisitor::nodePeekVariableOperand(commitment->getLhs())) {
                auto var = (dynamic_cast<VariableOperand* >(commitment->getLhs()))->getVariable();
                if (regsReplaceByOutput.find(var) != regsReplaceByOutput.end()) {
                    auto newAssignment = new SCAM::Assignment(
                            new DataSignalOperand(registerToOutputMap.at(var)),commitment->getRhs()
                    );
                    if (equalLHSFunction(lhsSet, newAssignment)) {
                        continue;
                    }
                    assignments.push_back(newAssignment);
                    lhsSet.insert(newAssignment->getLhs());
                    continue;
                }
                if (registerToOutputMap.find(var) != registerToOutputMap.end()) {
                    continue;
                }
            }
            if (NodePeekVisitor::nodePeekVariableOperand(commitment->getRhs())) {
                auto var = (dynamic_cast<VariableOperand* >(commitment->getRhs()))->getVariable();
                if (registerToOutputMap.find(var) != registerToOutputMap.end()) {
                    continue;
                }
            }
            if (equalLHSFunction(lhsSet, commitment)) {
                continue;
            }
            lhsSet.insert(commitment->getLhs());
            assignments.push_back(commitment);
        }
        operationProperties->setCommitmentList(assignments);
    }
}

std::set<Variable *> Utilities::getOutputRegisterParents() {
    std::set<Variable* > parentVariables;
    for (const auto& var : outputRegisters) {
        if (var->isSubVar()) {
            parentVariables.insert(var->getParent());
        } else {
            parentVariables.insert(var);
        }
    }
    return parentVariables;
}

std::map<DataSignal*, Variable*> Utilities::getParentMap() {
    std::map<DataSignal*, Variable*> parentMap;
    for (const auto& vars : outputToRegisterMap) {
        if (vars.first->isSubVar()) {
            parentMap.insert({vars.first->getParent(), vars.second->getParent()});
        } else {
            parentMap.insert({vars.first, vars.second});
        }
    }
    return parentMap;
}

std::string Utilities::convertDataType(const std::string& type) {
    if (type == "int") {
        return "ap_int<32>";
    } else if (type == "unsigned") {
        return "ap_uint<32>";
    } else {
        return type;
    }
}

std::string Utilities::typeToString(StmtType type) {
    switch (type) {
        case StmtType::ARITHMETIC:
            return "arithmetic";
        case StmtType::RELATIONAL:
            return "relational";
        case StmtType::LOGICAL:
            return "logical";
        case StmtType::BITWISE:
            return "bitwise";
        case StmtType::VARIABLE_OPERAND:
            return "variable operand";
        case StmtType::DATA_SIGNAL_OPERAND:
            return "data signal operand";
        case StmtType::ENUM_VALUE:
            return "enum value";
        case StmtType::UNARY_EXPR:
            return "unary expr";
        case StmtType::INTEGER_VALUE:
            return "integer value";
        case StmtType::UNSIGNED_VALUE:
            return "unsigned value";
        case StmtType::ARRAY_OPERAND:
            return "array operand";
        case StmtType::PARAM_OPERAND:
            return "param operand";
        case StmtType::ASSIGNMENT:
            return "assignment";
        case StmtType::UNKNOWN:
            return "unknown type";
    }
}

std::string Utilities::subTypeBitwiseToString(SubTypeBitwise type) {
    switch (type) {
        case SubTypeBitwise::BITWISE_AND:
            return "&";
        case SubTypeBitwise::BITWISE_OR:
            return "|";
        case SubTypeBitwise::BITWISE_XOR:
            return "^";
        case SubTypeBitwise::LEFT_SHIFT:
            return "<<";
        case SubTypeBitwise::RIGHT_SHIFT:
            return ">>";
        case SubTypeBitwise::UNKNOWN:
            return "unknown operation";
    }
}
