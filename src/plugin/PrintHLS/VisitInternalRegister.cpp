//
// Created by johannes on 26.10.19.
//

#include "VisitInternalRegister.h"

using namespace SCAM;

VisitInternalRegister::VisitInternalRegister() :
    registers()
{
}

void VisitInternalRegister::run(Stmt *stmt) {
    stmt->accept(*this);
}

void VisitInternalRegister::visit(Assignment &node) {
    node.getRhs()->accept(*this);
}

void VisitInternalRegister::visit(VariableOperand &node) {
    registers.insert(node.getVariable());
}

void VisitInternalRegister::visit(Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}


void VisitInternalRegister::visit(Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void VisitInternalRegister::visit(UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void VisitInternalRegister::visit(Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void VisitInternalRegister::visit(FunctionOperand &node) {
    auto parameterMap = node.getParamValueMap();
    for (auto &parameter : parameterMap) {
        parameter.second->accept(*this);
    }
    for (auto stmt : node.getFunction()->getStmtList()) {
        stmt->accept(*this);
    }
}

void VisitInternalRegister::visit(Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void VisitInternalRegister::visit(Cast &node) {
    node.getSubExpr()->accept(*this);
}



