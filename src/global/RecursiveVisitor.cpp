//
// Created by tobias on 31.03.20.
//

#include <stdexcept>
#include "RecursiveVisitor.h"
#include "FatalError.h"
#include "Logger/Logger.h"


void DESCAM::RecursiveVisitor::visit(struct VariableOperand &node) {
    //LEAF NODE
}

void DESCAM::RecursiveVisitor::visit(struct IntegerValue &node) {
    //LEAF NODE
}

void DESCAM::RecursiveVisitor::visit(struct UnsignedValue &node) {
    //LEAF NODE
}

void DESCAM::RecursiveVisitor::visit(struct BoolValue &node) {
    //LEAF NODE
}

void DESCAM::RecursiveVisitor::visit(struct EnumValue &node) {
    //LEAF NODE
}

void DESCAM::RecursiveVisitor::visit(DESCAM::CompoundValue &node) {
    //LEAF NODE
}

void DESCAM::RecursiveVisitor::visit(struct PortOperand &node) {
    //LEAF NODE
}

void DESCAM::RecursiveVisitor::visit(struct Assignment &node) {
    node.getRhs()->accept(*this);
    node.getLhs()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct While &node) {
    node.getConditionStmt()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct SectionOperand &node) {
    TERMINATE("not implemented");
}

void DESCAM::RecursiveVisitor::visit(struct SectionValue &node) {
    TERMINATE("not implemented");
}

void DESCAM::RecursiveVisitor::visit(struct ITE &node) {
    node.getConditionStmt()->accept(*this);
    for (auto stmt: node.getIfList()) {
        stmt->accept(*this);
    }
    for (auto stmt: node.getElseList()) {
        stmt->accept(*this);
    }
}

void DESCAM::RecursiveVisitor::visit(struct Branch &node) {
    node.getConditionStmt()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}


void DESCAM::RecursiveVisitor::visit(struct Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(DESCAM::ArrayOperand &node) {
    node.getIdx()->accept(*this);
    node.getArrayOperand()->accept(*this);
}


void DESCAM::RecursiveVisitor::visit(struct Read &node) {
    node.getStatusOperand()->accept(*this);
    node.getVariableOperand()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(DESCAM::Wait &node) {
}

void DESCAM::RecursiveVisitor::visit(DESCAM::Peek &node) {

}

void DESCAM::RecursiveVisitor::visit(struct Write &node) {
    node.getStatusOperand()->accept(*this);
    node.getValue()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(struct SyncSignal &node) {
}

void DESCAM::RecursiveVisitor::visit(struct DataSignalOperand &node) {
}

void DESCAM::RecursiveVisitor::visit(DESCAM::FunctionOperand &node) {
    for (auto &&param : node.getParamValueMap()) {
        param.second->accept(*this);
    }
}

void DESCAM::RecursiveVisitor::visit(DESCAM::ArrayExpr &node) {
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
}

void DESCAM::RecursiveVisitor::visit(DESCAM::CompoundExpr &node) {
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
}

void DESCAM::RecursiveVisitor::visit(DESCAM::ParamOperand &node) {
}

void DESCAM::RecursiveVisitor::visit(DESCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void DESCAM::RecursiveVisitor::visit(DESCAM::Notify &node) {
}

void DESCAM::RecursiveVisitor::visit(struct TimePointOperand &node) {
}

void DESCAM::RecursiveVisitor::visit(DESCAM::Ternary &node) {
    node.getCondition()->accept(*this);
    node.getTrueExpr()->accept(*this);
    node.getFalseExpr()->accept(*this);
}

DESCAM::RecursiveVisitor::RecursiveVisitor(DESCAM::Stmt *stmt) {
    stmt->accept(*this);
}


