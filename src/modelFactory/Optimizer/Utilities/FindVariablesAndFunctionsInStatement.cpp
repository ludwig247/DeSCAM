//
// Created by M.I.Alkoudsi on 10.09.19.
//

#include "FindVariablesAndFunctionsInStatement.h"


SCAM::FindVariablesAndFunctionsInStatement::FindVariablesAndFunctionsInStatement(SCAM::Stmt *stmt) : hasFunction(false) {
    if (stmt) {
        stmt->accept(*this);
    }
}

SCAM::FindVariablesAndFunctionsInStatement::FindVariablesAndFunctionsInStatement(SCAM::Expr *expr) : hasFunction(false) {
    if (expr) {
        expr->accept(*this);
    }
}

const std::set<std::string> &SCAM::FindVariablesAndFunctionsInStatement::getVariablesInStmtSet() const {
    return this->variablesInStmtSet;
}

bool SCAM::FindVariablesAndFunctionsInStatement::hasFunctions() {
    return this->hasFunction;
}

const std::map<std::string, SCAM::FunctionOperand *> &SCAM::FindVariablesAndFunctionsInStatement::getFunctionsInStmtMap() const {
    return this->functionsInStmtMap;
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::VariableOperand &node) {
    this->variablesInStmtSet.insert(node.getVariable()->getFullName());
    this->varOpInStmtSet.insert(&node);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::Assignment &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::If &node) {
    node.getConditionStmt()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::Read &node) {
    node.getVariableOperand()->accept(*this);
    node.getStatusOperand()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::Write &node) {
    node.getValue()->accept(*this);
    node.getStatusOperand()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::Cast &node) {
    node.getSubExpr()->accept(*this);
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::FunctionOperand &node) {
    this->hasFunction = true;
    this->functionsInStmtMap.insert(std::make_pair(node.getFunction()->getName(), &node));
    for (auto subVar: node.getParamValueMap()) {
        subVar.second->accept(*this);
    }
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::ArrayOperand &node) {
    node.getIdx()->accept(*this);
    this->variablesInStmtSet.insert(node.getArrayOperand()->getOperandName());
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::CompoundExpr &node) {
    for (auto subVar: node.getValueMap()) {
        subVar.second->accept(*this);
    }
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::ArrayExpr &node) {
    for (auto subVar: node.getValueMap()) {
        subVar.second->accept(*this);
    }
}

const std::set<SCAM::VariableOperand *> &SCAM::FindVariablesAndFunctionsInStatement::getVarOpInStmtSet() const {
    return this->varOpInStmtSet;
}


