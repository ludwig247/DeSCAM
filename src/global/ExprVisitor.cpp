//
// Created by tobias on 11.04.17.
//

#include <set>
#include "ExprVisitor.h"


SCAM::ExprVisitor::ExprVisitor(SCAM::Expr *expr):
    expr(expr),
    constVal(true),
    var(false),
    parameter(false),
    bitwise(false){

    expr->accept(*this);
}

void SCAM::ExprVisitor::visit(struct VariableOperand &node) {
    //this->usedVariables.insert(node.getVariable());
    this->usedOperands.insert(&node);
    this->usedVar.insert(node.getVariable());
    this->constVal = false;
    this->var = (this->usedOperands.size() == 1) && (this->usedVar.size() == 1);


}

void SCAM::ExprVisitor::visit(struct IntegerValue &node) {
    this->parameter = false;
    this->var = false;

}
void SCAM::ExprVisitor::visit(struct UnsignedValue &node) {
    this->parameter = false;
    this->var = false;

}
void SCAM::ExprVisitor::visit(struct BoolValue &node) {
    this->parameter = false;
    this->var = false;
}

void SCAM::ExprVisitor::visit(struct EnumValue &node) {
    this->parameter = false;
    this->var = false;
}

void SCAM::ExprVisitor::visit(SCAM::CompoundValue &node) {
    this->parameter = false;
    this->var = false;
}

void SCAM::ExprVisitor::visit(struct PortOperand &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct Assignment &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
}

void SCAM::ExprVisitor::visit(struct While &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct If &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct SectionOperand &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct SectionValue &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct ITE &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct Branch &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct Arithmetic &node) {
    if(node.getOperation() == "%") bitwise=true;
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);

}

void SCAM::ExprVisitor::visit(struct Logical &node) {

    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}
void SCAM::ExprVisitor::visit(struct Relational &node) {

    if(node.getOperation() != "==" && node.getOperation() != "!="){
        if(node.getLhs()->getDataType()->isUnsigned()) bitwise = true;
    }
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}


void SCAM::ExprVisitor::visit(struct Bitwise &node) {
    bitwise = true;
    node.getLhs()->accept(*this);
    node.getRhs()->accept(*this);
}

void SCAM::ExprVisitor::visit(struct Cast &node) {

    node.getSubExpr()->accept(*this);
}

void SCAM::ExprVisitor::visit(SCAM::SubSelect &node) {
    node.getOperand()->accept(*this);

}


void SCAM::ExprVisitor::visit(struct Read &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct Write &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct NBRead &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct NBWrite &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::ExprVisitor::visit(struct SyncSignal &node) {
    this->usedPorts.insert(node.getPort());
    this->usedSynchSignal.insert(node.getPort()->getSynchSignal());
    this->constVal = false;

}

void SCAM::ExprVisitor::visit(struct DataSignalOperand &node) {
    this->usedPorts.insert(node.getDataSignal()->getPort());
    this->usedOperands.insert(&node);
    this->usedDataSignal.insert(node.getDataSignal());
    this->constVal = false;
}

void SCAM::ExprVisitor::visit(SCAM::FunctionOperand &node) {
    for (auto &&param : node.getParamValueMap()) {
        param.second->accept(*this);
    }
    this->usedOperands.insert(&node);
}

bool SCAM::ExprVisitor::isConstVal(SCAM::Expr * expr){
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.constVal;
}

bool SCAM::ExprVisitor::isBitwise(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.bitwise;

}


std::set<SCAM::Operand *> SCAM::ExprVisitor::getUsedOperands(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedOperands;
}

SCAM::Operand *SCAM::ExprVisitor::getOperand(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    if(exprVisitor.usedOperands.size() != 1){
        throw std::runtime_error("Expr "+PrintStmt::toString(expr)+ " has more/less variables then 1");
    };
    return *exprVisitor.usedOperands.begin();
}

std::set<SCAM::Port *> SCAM::ExprVisitor::getUsedPorts(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedPorts;
}

std::set<SCAM::Variable *> SCAM::ExprVisitor::getUsedVariables(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedVar;
}

std::set<SCAM::SyncSignal *> SCAM::ExprVisitor::getUsedSynchSignals(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedSynchSignal;
}

std::set<SCAM::DataSignal *> SCAM::ExprVisitor::getUsedDataSignals(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.usedDataSignal;
}

bool SCAM::ExprVisitor::isVar(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.var;
}

void SCAM::ExprVisitor::visit(SCAM::CompoundExpr &node) {
    for(auto select: node.getValueMap()){
        select.second->accept(*this);
    }
}

void SCAM::ExprVisitor::visit(SCAM::ParamOperand &node) {
    this->usedOperands.insert(&node);
    this->constVal = false;
    this->parameter = true;
}


void SCAM::ExprVisitor::visit(SCAM::Return &node) {
    node.getReturnValue()->accept(*this);
}

bool SCAM::ExprVisitor::isParameter(SCAM::Expr *expr) {
    SCAM::ExprVisitor exprVisitor(expr);
    return exprVisitor.parameter;
}






