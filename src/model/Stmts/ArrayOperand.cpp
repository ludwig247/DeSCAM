//
// Created by tobias on 17.07.18.
//

#include <NodePeekVisitor.h>

#include <utility>
#include "ArrayOperand.h"

SCAM::ArrayOperand::ArrayOperand(Variable *arrayVar, SCAM::Expr *idx, StmtLocationInfo stmtLocationInfo) :
        idx(idx),
        operand(new VariableOperand(arrayVar)),
        Expr(arrayVar->getDataType()->getArrayType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

SCAM::ArrayOperand::ArrayOperand(SCAM::Operand *operand, SCAM::Expr *idx, StmtLocationInfo stmtLocationInfo):
        idx(idx),
        operand(operand),
        Expr(operand->getDataType()->getArrayType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    assert(operand != nullptr);
    assert(idx != nullptr);
    assert(operand->getDataType()->isArrayType());
}

void SCAM::ArrayOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::ArrayOperand::operator==(const SCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekArrayOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (ArrayOperand *) this;
    auto otherPtr = (const ArrayOperand *) &other;
    if (!((*thisPtr->idx) == (*otherPtr->idx))) return false;
    return (thisPtr->operand == otherPtr->operand);
}

SCAM::Expr *SCAM::ArrayOperand::getIdx() const {
    return idx;
}


SCAM::Operand * SCAM::ArrayOperand::getArrayOperand() const {
    return operand;
}



//std::string SCAM::ArrayOperand::getOperandName() const {
//    std::string name = this->arrayVar->getName()+"[" + "NOT_IMPLEMNETED" + "]";
//    return name;
//}
//
