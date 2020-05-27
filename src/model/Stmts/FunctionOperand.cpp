//
// Created by tobias on 17.07.18.
//

#include <NodePeekVisitor.h>
#include <PrintStmt.h>

#include <utility>
#include "FunctionOperand.h"
#include "DescamException.h"

DESCAM::FunctionOperand::FunctionOperand(DESCAM::Function *function, const std::map<std::string, DESCAM::Expr *> &paramValueMap, LocationInfo stmtLocationInfo) :
        paramValueMap(paramValueMap),
        function(function),
        Operand(function->getReturnType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (function == nullptr) {
        throw DESCAM::DescamException("Function is null",this->stmtLocationInfo);
    }
    for (auto &&param : paramValueMap) {
        const std::map<std::string, Parameter *> &funcParams = function->getParamMap();
        if (funcParams.find(param.first) == funcParams.end()) {
            throw DESCAM::DescamException("Param: " + param.first + " is not a parameter of function " + function->getName() + "()",this->stmtLocationInfo);
        } else {
            if (funcParams.find(param.first)->second->getDataType() != param.second->getDataType()) {
                std::string error_message = "-E- Function: " + function->getName() +" Parameter have different datatypes:\n";
                error_message += "Param names: " + param.first + " : " + PrintStmt::toString(param.second) + "\n";
                error_message += "Param types: " + funcParams.find(param.first)->second->getDataType()->getName() + " : " + param.second->getDataType()->getName() + "\n";
                throw DESCAM::DescamException(error_message,this->stmtLocationInfo);
            }
        }

    }
    assert(function != nullptr && "Function is null");
}


void DESCAM::FunctionOperand::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string DESCAM::FunctionOperand::getOperandName() const {
    return function->getName();
}

DESCAM::Function *DESCAM::FunctionOperand::getFunction() const {
    return function;
}

const std::map<std::string, DESCAM::Expr *> &DESCAM::FunctionOperand::getParamValueMap() const {
    return paramValueMap;
}

bool DESCAM::FunctionOperand::operator==(const DESCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekFunctionOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (FunctionOperand *) this;
    auto otherPtr = (const FunctionOperand *) &other;
    if (thisPtr->function != otherPtr->function) return false;
    return (thisPtr->paramValueMap == otherPtr->paramValueMap);
}

void DESCAM::FunctionOperand::setParamValueMap(const std::map<std::string, DESCAM::Expr *> &paramValueMap) {
    FunctionOperand::paramValueMap = paramValueMap;
}
