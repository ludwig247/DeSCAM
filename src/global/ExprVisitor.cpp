//
// Created by tobias on 11.04.17.
//

#include <set>
#include "ExprVisitor.h"
#include "FatalError.h"
#include "Logger/Logger.h"



DESCAM::ExprVisitor::ExprVisitor(DESCAM::Expr *expr) :
        expr(expr),
        constVal(true),
        var(false),
        parameter(false),
        bitwise(false) {

    expr->accept(*this);
}

void DESCAM::ExprVisitor::visit(struct VariableOperand &node) {
    //this->usedVariables.insert(node.getVariable());
    this->usedOperands.insert(&node);

    this->usedVar.insert(node.getVariable());
    this->constVal = false;
    this->var = (this->usedOperands.size() == 1) && (this->usedVar.size() == 1);

}

void DESCAM::ExprVisitor::visit(struct IntegerValue &node) {
    this->parameter = false;
    this->var = false;

}

void DESCAM::ExprVisitor::visit(struct UnsignedValue &node) {
    this->parameter = false;
    this->var = false;

}

void DESCAM::ExprVisitor::visit(struct BoolValue &node) {
    this->parameter = false;
    this->var = false;
}

void DESCAM::ExprVisitor::visit(struct EnumValue &node) {
    this->parameter = false;
    this->var = false;
}

void DESCAM::ExprVisitor::visit(DESCAM::CompoundValue &node) {
    this->parameter = false;
    this->var = false;
}

void DESCAM::ExprVisitor::visit(struct PortOperand &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(struct Assignment &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(struct UnaryExpr &node) {
    if(node.getOperation() == "~") this->bitwise = true;
    node.getExpr()->accept(*this);
}

void DESCAM::ExprVisitor::visit(struct While &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(struct If &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(struct SectionOperand &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(struct SectionValue &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(struct ITE &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(struct Branch &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(struct Arithmetic &node) {
    if (node.getOperation() == "%") bitwise = true;
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);

}

void DESCAM::ExprVisitor::visit(struct Logical &node) {

    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::ExprVisitor::visit(struct Relational &node) {

    if (node.getOperation() != "==" && node.getOperation() != "!=") {
        if (node.getLhs()->getDataType()->isUnsigned()) bitwise = true;
    }
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}


void DESCAM::ExprVisitor::visit(struct Bitwise &node) {
    bitwise = true;
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void DESCAM::ExprVisitor::visit(struct Cast &node) {

    node.getSubExpr()->accept(*this);
}

void DESCAM::ExprVisitor::visit(DESCAM::ArrayOperand &node) {
    this->constVal = false;
    this->parameter = false;
    this->var = true;
    //this->usedOperands.insert(&node);
    node.getIdx()->accept(*this);
    node.getArrayOperand()->accept(*this);
    this->usedOperands.insert(node.getArrayOperand());
    this->usedArrayOperands.insert(&node);
}

void DESCAM::ExprVisitor::visit(struct Read &node) {
    TERMINATE("ExprVisitor::Read not implemented");
}

void DESCAM::ExprVisitor::visit(DESCAM::Wait &node) {
    TERMINATE("not implemented");
}

void DESCAM::ExprVisitor::visit(DESCAM::Peek &node) {
    TERMINATE("ExprVisitor::visit: Peek-not implemented");
}

void DESCAM::ExprVisitor::visit(struct Write &node) {
    TERMINATE("ExprVisitor::Write: not implemented");
}

void DESCAM::ExprVisitor::visit(struct SyncSignal &node) {
    this->usedPorts.insert(node.getPort());
    this->usedSynchSignal.insert(node.getPort()->getSynchSignal());
    this->constVal = false;

}

void DESCAM::ExprVisitor::visit(struct DataSignalOperand &node) {
    this->usedPorts.insert(node.getDataSignal()->getPort());
    this->usedOperands.insert(&node);
    this->usedDataSignal.insert(node.getDataSignal());
    this->constVal = false;
}

void DESCAM::ExprVisitor::visit(DESCAM::FunctionOperand &node) {
    for (auto &&param : node.getParamValueMap()) {
        std::string test = PrintStmt::toString(param.second);
        param.second->accept(*this);
    }
    this->usedOperands.insert(&node);
    this->usedFunction.insert(node.getFunction());
}

bool DESCAM::ExprVisitor::isConstVal(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.constVal;
}

bool DESCAM::ExprVisitor::isBitwise(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.bitwise;

}

void DESCAM::ExprVisitor::visit(DESCAM::ArrayExpr &node) {
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
}

std::set<DESCAM::Operand *> DESCAM::ExprVisitor::getUsedOperands(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedOperands;
}

DESCAM::Operand *DESCAM::ExprVisitor::getOperand(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    if (exprVisitor.usedOperands.size() != 1) {
        TERMINATE("Expr " + PrintStmt::toString(expr) + " has more/less variables then 1");
    };
    return *exprVisitor.usedOperands.begin();
}

std::set<DESCAM::Port *> DESCAM::ExprVisitor::getUsedPorts(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedPorts;
}

std::set<DESCAM::Variable *> DESCAM::ExprVisitor::getUsedVariables(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedVar;
}

std::set<DESCAM::Function *> DESCAM::ExprVisitor::getUsedFunction(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedFunction;
}


std::set<DESCAM::SyncSignal *> DESCAM::ExprVisitor::getUsedSynchSignals(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedSynchSignal;
}

std::set<DESCAM::DataSignal *> DESCAM::ExprVisitor::getUsedDataSignals(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedDataSignal;
}

std::set<DESCAM::ArrayOperand *> DESCAM::ExprVisitor::getUsedArrayOperands(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedArrayOperands;
}

bool DESCAM::ExprVisitor::isVar(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.var;
}

void DESCAM::ExprVisitor::visit(DESCAM::CompoundExpr &node) {
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
}

std::set<DESCAM::Ternary *> DESCAM::ExprVisitor::getUsedTernaryOperators(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedTernary;
}

void DESCAM::ExprVisitor::visit(DESCAM::ParamOperand &node) {
    this->usedOperands.insert(&node);
    this->constVal = false;
    this->parameter = true;
}


void DESCAM::ExprVisitor::visit(DESCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

bool DESCAM::ExprVisitor::isParameter(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.parameter;
}

bool DESCAM::ExprVisitor::isTernary(DESCAM::Expr *expr) {
    DESCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.compare;
}


void DESCAM::ExprVisitor::visit(DESCAM::Notify &node) {
    this->usedPorts.insert(node.getPort());
    this->constVal = false;

}

void DESCAM::ExprVisitor::visit(struct TimePointOperand &node) {
    this->usedOperands.insert(&node);

    this->constVal = false;
    this->var = (this->usedOperands.size() == 1) && (this->usedVar.size() == 1);
}

void DESCAM::ExprVisitor::visit(DESCAM::Ternary &node) {
    this->constVal = false;
    this->compare = true;

    this->usedTernary.insert(&node);
    node.getCondition()->accept(*this);
    node.getTrueExpr()->accept(*this);
    node.getFalseExpr()->accept(*this);
}










