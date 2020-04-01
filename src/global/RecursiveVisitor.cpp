//
// Created by tobias on 31.03.20.
//

#include <stdexcept>
#include "RecursiveVisitor.h"

void SCAM::RecursiveVisitor::visit(struct VariableOperand &node) {
    //LEAF NODE
}

void SCAM::RecursiveVisitor::visit(struct IntegerValue &node) {
    //LEAF NODE
}

void SCAM::RecursiveVisitor::visit(struct UnsignedValue &node) {
    //LEAF NODE
}

void SCAM::RecursiveVisitor::visit(struct BoolValue &node) {
    //LEAF NODE
}

void SCAM::RecursiveVisitor::visit(struct EnumValue &node) {
    //LEAF NODE
}

void SCAM::RecursiveVisitor::visit(SCAM::CompoundValue &node) {
    //LEAF NODE
}

void SCAM::RecursiveVisitor::visit(struct PortOperand &node) {
    //LEAF NODE
}

void SCAM::RecursiveVisitor::visit(struct Assignment &node) {
    node.getRhs()->accept(*this);
    node.getLhs()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct While &node) {
    node.getConditionStmt()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct If &node) {
    node.getConditionStmt()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct SectionOperand &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::RecursiveVisitor::visit(struct SectionValue &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::RecursiveVisitor::visit(struct ITE &node) {
    node.getConditionStmt()->accept(*this);
    for (auto stmt: node.getIfList()) {
        stmt->accept(*this);
    }
    for (auto stmt: node.getElseList()) {
        stmt->accept(*this);
    }
}

void SCAM::RecursiveVisitor::visit(struct Branch &node) {
    node.getConditionStmt()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct Arithmetic &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct Logical &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct Relational &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}


void SCAM::RecursiveVisitor::visit(struct Bitwise &node) {
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(SCAM::ArrayOperand &node) {
    node.getIdx()->accept(*this);
    node.getArrayOperand()->accept(*this);
}


void SCAM::RecursiveVisitor::visit(struct Read &node) {
    node.getStatusOperand()->accept(*this);
    node.getVariableOperand()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(SCAM::Wait &node) {
}

void SCAM::RecursiveVisitor::visit(SCAM::Peek &node) {

}

void SCAM::RecursiveVisitor::visit(struct Write &node) {
    node.getStatusOperand()->accept(*this);
    node.getValue()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(struct SyncSignal &node) {
}

void SCAM::RecursiveVisitor::visit(struct DataSignalOperand &node) {
}

void SCAM::RecursiveVisitor::visit(SCAM::FunctionOperand &node) {
    for (auto &&param : node.getParamValueMap()) {
        param.second->accept(*this);
    }
}

void SCAM::RecursiveVisitor::visit(SCAM::ArrayExpr &node) {
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
}

void SCAM::RecursiveVisitor::visit(SCAM::CompoundExpr &node) {
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
}

void SCAM::RecursiveVisitor::visit(SCAM::ParamOperand &node) {
}

void SCAM::RecursiveVisitor::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

void SCAM::RecursiveVisitor::visit(SCAM::Notify &node) {
}

void SCAM::RecursiveVisitor::visit(struct TimePointOperand &node) {
}

void SCAM::RecursiveVisitor::visit(SCAM::Ternary &node) {
    node.getCondition()->accept(*this);
    node.getTrueExpr()->accept(*this);
    node.getFalseExpr()->accept(*this);
}


