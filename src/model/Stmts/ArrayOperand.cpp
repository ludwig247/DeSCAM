//
// Created by tobias on 17.07.18.
//

#include <NodePeekVisitor.h>

#include <utility>
#include "ArrayOperand.h"

DESCAM::ArrayOperand::ArrayOperand(Variable *arrayVar, DESCAM::Expr *idx, LocationInfo stmtLocationInfo) :
    idx_(idx),
    operand_(new VariableOperand(arrayVar)),
    Expr(arrayVar->getDataType()->getArrayType()) {
  this->stmtLocationInfo = std::move(stmtLocationInfo);
}

DESCAM::ArrayOperand::ArrayOperand(DESCAM::Operand *operand, DESCAM::Expr *idx, LocationInfo stmtLocationInfo) :
    idx_(idx),
    operand_(operand),
    Expr(operand->getDataType()->getArrayType()) {
  this->stmtLocationInfo = std::move(stmtLocationInfo);
  assert(operand != nullptr);
  assert(idx != nullptr);
  assert(operand->getDataType()->isArrayType());
}

void DESCAM::ArrayOperand::accept(DESCAM::StmtAbstractVisitor &visitor) {
  visitor.visit(*this);
}

bool DESCAM::ArrayOperand::operator==(const DESCAM::Stmt &other) const {
  if (this == &other) return true;
  if (NodePeekVisitor::nodePeekArrayOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
  auto thisPtr = (ArrayOperand *) this;
  auto otherPtr = (const ArrayOperand *) &other;
  if (!((*thisPtr->idx_) == (*otherPtr->idx_))) return false;
  return (thisPtr->operand_ == otherPtr->operand_);
}

DESCAM::Expr *DESCAM::ArrayOperand::getIdx() const {
  return idx_;
}

DESCAM::Operand *DESCAM::ArrayOperand::getArrayOperand() const {
  return operand_;
}



//std::string DESCAM::ArrayOperand::getOperandName() const {
//    std::string name = this->arrayVar->getName()+"[" + "NOT_IMPLEMNETED" + "]";
//    return name;
//}
//
