//
// Created by tobias on 17.07.18.
//

#include "Function.h"
#include "FatalError.h"
#include "Logger/Logger.h"


DESCAM::Function::Function(std::string name, DESCAM::DataType *returnType, const std::map<std::string, Parameter *> &paramMap, LocationInfo locationInfo) :
        returnType(returnType),
        paramMap(paramMap),
        AbstractNode(name,locationInfo) {
    if (returnType->isCompoundType()) {
        TERMINATE(" Function " + name + "() unallowed return type: " + returnType->getName() + " only built-in types allowed");
    }

    for (auto &&param : paramMap) {
        if (param.second == nullptr) {
            TERMINATE("Parameter " + param.first + " is not initialized");
        }
    }
}

DESCAM::Function::~Function() {
}


DESCAM::DataType *DESCAM::Function::getReturnType() const {
    return returnType;
}

void DESCAM::Function::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);

}

const std::map<std::string, DESCAM::Parameter *> &DESCAM::Function::getParamMap() const {
    return paramMap;
}

const std::vector<DESCAM::Stmt *> &DESCAM::Function::getStmtList() const {
    return stmtList;
}

void DESCAM::Function::setStmtList(const std::vector<DESCAM::Stmt *> &stmtList) {
    Function::stmtList = stmtList;
}

const std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> &DESCAM::Function::getReturnValueConditionList() const {
    return returnValueConditionList;
}

void DESCAM::Function::setReturnValueConditionList(
        const std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *>>> &returnValueConditionList) {
    Function::returnValueConditionList = returnValueConditionList;
}

DESCAM::Function::Function(DESCAM::Function *function) : AbstractNode(function->getName()) {
    this->stmtList = function->getStmtList();
    this->returnValueConditionList = function->getReturnValueConditionList();
    this->paramMap = function->getParamMap();
    this->returnType = function->getReturnType();
    this->setLocationInfo(function->getLocationInfo());
}



