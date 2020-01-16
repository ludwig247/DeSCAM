//
// Created by lucas on 16.01.20.
//

#include "TimeExprOperand.h"

SCAM::TimeExprOperand::TimeExprOperand(TimeExpr *timeExpr) :
        timeExpr(timeExpr), Operand(timeExpr->getDataType()) {

}

SCAM::TimeExpr *SCAM::TimeExprOperand::getTimeExpr() {
    return this->timeExpr;
}

void SCAM::TimeExprOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string SCAM::TimeExprOperand::getOperandName() const {
    return this->timeExpr->getName();
}

bool SCAM::TimeExprOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekTimeExprOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (TimeExprOperand *) this;
    auto otherPtr = (const TimeExprOperand *) &other;
    return (thisPtr->timeExpr == otherPtr->timeExpr);
}