//
// Created by M.I.Alkoudsi on 10.09.19.
//

#include "FindVariablesAndFunctionsInStatement.h"


DESCAM::FindVariablesAndFunctionsInStatement::FindVariablesAndFunctionsInStatement(DESCAM::Stmt *stmt,const std::set<std::string>& readVariablesSet) : hasFunction(false), hasReadVariables(false),isVariableFromFunctionParameters(false), isVariableFromFunctionBody(false), readVariablesSet(readVariablesSet) {
    if (stmt) {
        stmt->accept(*this);
    }
}

DESCAM::FindVariablesAndFunctionsInStatement::FindVariablesAndFunctionsInStatement(DESCAM::Expr *expr,const std::set<std::string>& readVariablesSet) : hasFunction(false), hasReadVariables(false),isVariableFromFunctionParameters(false), isVariableFromFunctionBody(false) {
    if (expr) {
        expr->accept(*this);
    }
}

const std::set<std::string> &DESCAM::FindVariablesAndFunctionsInStatement::getVariablesInStmtSet() const {
    return this->variablesInStmtSet;
}

bool DESCAM::FindVariablesAndFunctionsInStatement::hasFunctions() {
    return this->hasFunction;
}

const std::map<std::string, DESCAM::FunctionOperand *> &DESCAM::FindVariablesAndFunctionsInStatement::getFunctionsInStmtMap() const {
    return this->functionsInStmtMap;
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::VariableOperand &node) {
    if(!this->isVariableFromFunctionBody) {
        this->variablesInStmtSet.insert(node.getVariable()->getFullName());
        this->varOpInStmtSet.insert(&node);
    }if(!this->isVariableFromFunctionParameters){
        if(this->readVariablesSet.find(node.getVariable()->getFullName())!=this->readVariablesSet.end()){
            this->hasReadVariables = true;
        }
    }
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Assignment &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::If &node) {
    node.getConditionStmt()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Read &node) {
    node.getVariableOperand()->accept(*this);
    node.getStatusOperand()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Write &node) {
    node.getValue()->accept(*this);
    node.getStatusOperand()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Cast &node) {
    node.getSubExpr()->accept(*this);
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::FunctionOperand &node) {
    this->hasFunction = true;
    this->functionsInStmtMap.insert(std::make_pair(node.getFunction()->getName(), &node));
    this->isVariableFromFunctionParameters = true;
    for (auto subVar: node.getParamValueMap()) {
        subVar.second->accept(*this);
    }
    this->isVariableFromFunctionParameters = false;
    this->isVariableFromFunctionBody = true;
    for(auto returnConditionListPair: node.getFunction()->getReturnValueConditionList()) {
    returnConditionListPair.first->getReturnValue()->accept(*this);
    }
    this->isVariableFromFunctionBody = false;
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::ArrayOperand &node) {
    node.getIdx()->accept(*this);
    this->variablesInStmtSet.insert(node.getArrayOperand()->getOperandName());
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::CompoundExpr &node) {
    for (auto subVar: node.getValueMap()) {
        subVar.second->accept(*this);
    }
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::ArrayExpr &node) {
    for (auto subVar: node.getValueMap()) {
        subVar.second->accept(*this);
    }
}

const std::set<DESCAM::VariableOperand *> &DESCAM::FindVariablesAndFunctionsInStatement::getVarOpInStmtSet() const {
    return this->varOpInStmtSet;
}

bool DESCAM::FindVariablesAndFunctionsInStatement::hasReadVariable() {
    return this->hasReadVariables;
}

void DESCAM::FindVariablesAndFunctionsInStatement::visit(DESCAM::Ternary &node) {
    node.getCondition()->accept(*this);
    node.getTrueExpr()->accept(*this);
    node.getFalseExpr()->accept(*this);

}


