//
// Created by tobias on 01.04.20.
//

#include "TernaryOptimizer.h"

SCAM::TernaryOptimizer::TernaryOptimizer(SCAM::Stmt *stmt){
    stmt->accept(*this);
}

void SCAM::TernaryOptimizer::visit(struct VariableOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct IntegerValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct UnsignedValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct BoolValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct EnumValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::CompoundValue &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct PortOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct Assignment &node) {
    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if( (*node.getRhs() == *rhs) && (*node.getLhs() == *lhs) ){
        this->stmt = &node;
    }else{
        this->stmt = new Assignment(lhs,rhs);
    }
}

void SCAM::TernaryOptimizer::visit(struct UnaryExpr &node) {
    node.getExpr()->accept(*this);
    auto unaryExpr = this->expr;

    if( (*node.getExpr() == *unaryExpr)){
        this->expr = &node;
    }else{
        this->expr = new UnaryExpr(node.getOperation(),unaryExpr);
    }
}

void SCAM::TernaryOptimizer::visit(struct While &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct If &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct SectionOperand &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct SectionValue &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct ITE &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct Branch &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::TernaryOptimizer::visit(struct Arithmetic &node) {

    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if( (*node.getRhs() == *rhs) && (*node.getLhs() == *lhs) ){
        this->expr = &node;
    }else{
        this->expr = new Arithmetic(lhs,node.getOperation(),rhs);
    }

}

void SCAM::TernaryOptimizer::visit(struct Logical &node) {
    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if( (*node.getRhs() == *rhs) && (*node.getLhs() == *lhs) ){
        this->expr = &node;
    }else{
        this->expr = new Logical(lhs,node.getOperation(),rhs);
    }
}

void SCAM::TernaryOptimizer::visit(struct Relational &node) {
    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if( (*node.getRhs() == *rhs) && (*node.getLhs() == *lhs) ){
        this->expr = &node;
    }else{
        this->expr = new Relational(lhs,node.getOperation(),rhs);
    }
}


void SCAM::TernaryOptimizer::visit(struct Bitwise &node) {
    node.getRhs()->accept(*this);
    auto rhs = this->expr;

    node.getLhs()->accept(*this);
    auto lhs = this->expr;

    if( (*node.getRhs() == *rhs) && (*node.getLhs() == *lhs) ){
        this->expr = &node;
    }else{
        this->expr = new Bitwise(lhs,node.getOperation(),rhs);
    }
}

void SCAM::TernaryOptimizer::visit(struct Cast &node) {
    node.getSubExpr()->accept(*this);
    auto unaryExpr = this->expr;

    if( (*  node.getSubExpr() == *unaryExpr)){
        this->expr = &node;
    }else{
        this->expr = new Cast(unaryExpr,node.getDataType());
    }
}

void SCAM::TernaryOptimizer::visit(SCAM::ArrayOperand &node) {
    node.getIdx()->accept(*this);
    auto idx = this->expr;

    if( (*node.getIdx() == *idx)){
        this->expr = &node;
    }else{
        this->expr = new ArrayOperand(node.getArrayOperand(),idx);
    }
}


void SCAM::TernaryOptimizer::visit(struct Read &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::TernaryOptimizer::visit(SCAM::Wait &node) {
    throw std::runtime_error("not implemented");
}

void SCAM::TernaryOptimizer::visit(SCAM::Peek &node) {
        this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct Write &node) {
    throw std::runtime_error("not implemented");
}

SCAM::Stmt *SCAM::TernaryOptimizer::getStmt() const {
    return stmt;
}

void SCAM::TernaryOptimizer::visit(struct SyncSignal &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct DataSignalOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::FunctionOperand &node) {
    //TODO
    std::cout << "-W-" << node << " not optmized" << std::endl;
    for (auto &&param : node.getParamValueMap()) {
        param.second->accept(*this);
    }
}

void SCAM::TernaryOptimizer::visit(SCAM::ArrayExpr &node) {
    //TODO
    std::cout << "-W-" << node << " not optmized" << std::endl;
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
}

void SCAM::TernaryOptimizer::visit(SCAM::CompoundExpr &node) {
    std::cout << "-W-" << node << " not optmized" << std::endl;
    for (auto select: node.getValueMap()) {
        select.second->accept(*this);
    }
}

void SCAM::TernaryOptimizer::visit(SCAM::ParamOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::Return &node) {
    std::cout << "-W-" << node << " not optmized" << std::endl;
    node.getReturnValue()->accept(*this);
}

void SCAM::TernaryOptimizer::visit(SCAM::Notify &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(struct TimePointOperand &node) {
    this->expr = &node;
}

void SCAM::TernaryOptimizer::visit(SCAM::Ternary &node) {
    node.getTrueExpr()->accept(*this);
    auto trueExpr = this->expr;
    node.getFalseExpr()->accept(*this);
    auto falseExpr = this->expr;
    node.getCondition()->accept(*this);
    auto condExpr = this->expr;

    if(*condExpr == BoolValue(true)){
        this->expr = trueExpr;
    }else if(*condExpr == BoolValue(false)){
        this->expr = falseExpr;
    }else{
        if(*node.getTrueExpr() == *trueExpr && *node.getFalseExpr() == *falseExpr && *node.getCondition() == *condExpr ){
            this->expr = &node;
        }else{
            this->expr = new Ternary(condExpr,trueExpr,falseExpr);
        }
    }
}

SCAM::Expr *SCAM::TernaryOptimizer::getExpr() const {
    return expr;
}
