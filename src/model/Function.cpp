//
// Created by tobias on 17.07.18.
//

#include "Function.h"
#include "FatalError.h"
#include "Logger/Logger.h"


SCAM::Function::Function(std::string name, SCAM::DataType *returnType, const std::map<std::string, Parameter *> &paramMap) :
        returnType(returnType),
        paramMap(paramMap),
        AbstractNode(name) {
    if (returnType->isCompoundType()) {
        TERMINATE(" Function " + name + "() unallowed return type: " + returnType->getName() + " only built-in types allowed");
    }

    for (auto &&param : paramMap) {
        if (param.second == nullptr) {
            TERMINATE("Parameter " + param.first + " is not initialized");
        }
    }
}

SCAM::Function::~Function() {
}


SCAM::DataType *SCAM::Function::getReturnType() const {
    return returnType;
}

void SCAM::Function::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);

}

const std::map<std::string, SCAM::Parameter *> &SCAM::Function::getParamMap() const {
    return paramMap;
}

const std::vector<SCAM::Stmt *> &SCAM::Function::getStmtList() const {
    return stmtList;
}

void SCAM::Function::setStmtList(const std::vector<SCAM::Stmt *> &stmtList) {
    Function::stmtList = stmtList;
}

const std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> &SCAM::Function::getReturnValueConditionList() const {
    return returnValueConditionList;
}

void SCAM::Function::setReturnValueConditionList(
        const std::vector<std::pair<SCAM::Return *, std::vector<SCAM::Expr *>>> &returnValueConditionList) {
    Function::returnValueConditionList = returnValueConditionList;
}

SCAM::Function::Function(SCAM::Function *function) : AbstractNode(function->getName()) {
    this->stmtList = function->getStmtList();
    this->returnValueConditionList = function->getReturnValueConditionList();
    this->paramMap = function->getParamMap();
    this->returnType = function->getReturnType();
}



