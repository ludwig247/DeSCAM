//
// Created by tobias on 17.07.18.
//

#include <NodePeekVisitor.h>
#include <PrintStmt.h>
#include "FunctionOperand.h"

SCAM::FunctionOperand::FunctionOperand(SCAM::Function *function, const std::map<std::string, SCAM::Expr *> &paramValueMap) :
        paramValueMap(paramValueMap),
        function(function),
        Operand(function->getReturnType()) {

    if (function == nullptr) {
        throw std::runtime_error("Function is null");
    }
    for (auto &&param : paramValueMap) {
        const std::map<std::string, Parameter *> &funcParams = function->getParamMap();
        if (funcParams.find(param.first) == funcParams.end()) {
            throw std::runtime_error("Param: " + param.first + " is not a parameter of function " + function->getName() + "()");
        } else {
            if (funcParams.find(param.first)->second->getDataType() != param.second->getDataType()) {
                std::string error_message = "-E- Function: " + function->getName() +" Parameter have different datatypes:\n";
                error_message += "Param names: " + param.first + " : " + PrintStmt::toString(param.second) + "\n";
                error_message += "Param types: " + funcParams.find(param.first)->second->getDataType()->getName() + " : " + param.second->getDataType()->getName() + "\n";
                throw std::runtime_error(error_message);
            }
        }

    }
    assert(function != nullptr && "Function is null");
}


void SCAM::FunctionOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string SCAM::FunctionOperand::getOperandName() const {
    return function->getName();
}

SCAM::Function *SCAM::FunctionOperand::getFunction() const {
    return function;
}

const std::map<std::string, SCAM::Expr *> &SCAM::FunctionOperand::getParamValueMap() const {
    return paramValueMap;
}

bool SCAM::FunctionOperand::operator==(const SCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekFunctionOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (FunctionOperand *) this;
    auto otherPtr = (const FunctionOperand *) &other;
    if (thisPtr->function != otherPtr->function) return false;
    return (thisPtr->paramValueMap == otherPtr->paramValueMap);
}
