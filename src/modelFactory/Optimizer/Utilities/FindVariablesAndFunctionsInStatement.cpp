//
// Created by M.I.Alkoudsi on 10.09.19.
//

#include "FindVariablesAndFunctionsInStatement.h"


SCAM::FindVariablesAndFunctionsInStatement::FindVariablesAndFunctionsInStatement(SCAM::Stmt *stmt,const std::set<std::string>& readVariablesSet) : hasFunction(false), hasReadVariables(false),isVariableFromFunctionParameters(false), isVariableFromFunctionBody(false), readVariablesSet(readVariablesSet) {
    if (stmt) {
        stmt->accept(*this);
    }
}

SCAM::FindVariablesAndFunctionsInStatement::FindVariablesAndFunctionsInStatement(SCAM::Expr *expr,const std::set<std::string>& readVariablesSet) : hasFunction(false), hasReadVariables(false),isVariableFromFunctionParameters(false), isVariableFromFunctionBody(false) {
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
    if(!this->isVariableFromFunctionBody) {
        this->variablesInStmtSet.insert(node.getVariable()->getFullName());
        this->varOpInStmtSet.insert(&node);
    }if(!this->isVariableFromFunctionParameters){
        if(this->readVariablesSet.find(node.getVariable()->getFullName())!=this->readVariablesSet.end()){
            this->hasReadVariables = true;
        }
    }
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

bool SCAM::FindVariablesAndFunctionsInStatement::hasReadVariable() {
    return this->hasReadVariables;
}

void SCAM::FindVariablesAndFunctionsInStatement::visit(SCAM::CompareOperator &node) {
    node.getCondition()->accept(*this);
    node.getTrueExpr()->accept(*this);
    node.getFalseExpr()->accept(*this);

}


