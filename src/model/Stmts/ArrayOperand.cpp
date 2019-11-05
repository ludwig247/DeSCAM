//
// Created by tobias on 17.07.18.
//

#include <NodePeekVisitor.h>
#include "ArrayOperand.h"

SCAM::ArrayOperand::ArrayOperand(Variable *arrayVar, SCAM::Expr *idx) :
        idx(idx),
        arrayVar(arrayVar),
        Expr(arrayVar->getDataType()->getArrayType()) {
    assert(arrayVar != nullptr);
    assert(idx != nullptr);
    assert(arrayVar->getDataType()->isArrayType());

}

//SCAM::ArrayOperand::ArrayOperand(SCAM::Operand *operand, std::string sub):
//        sub(sub),
//        operand(operand),
//        Expr(operand->getDataType()->getSubVarMap().find(sub)->second) {
//    if (!operand->getDataType()->isCompoundType() && !operand->getDataType()->isArrayType()) {
//        throw std::runtime_error("Expr for ArrayOperand has to be a compound type");
//    }
//}

void SCAM::ArrayOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::ArrayOperand::operator==(const SCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekArrayOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (ArrayOperand *) this;
    auto otherPtr = (const ArrayOperand *) &other;
    if (!((*thisPtr->idx) == (*otherPtr->idx))) return false;
    return (thisPtr->arrayVar == otherPtr->arrayVar);
}

SCAM::Expr *SCAM::ArrayOperand::getIdx() const {
    return idx;
}


SCAM::Variable *SCAM::ArrayOperand::getArrayVar() const {
    return arrayVar;
}

//std::string SCAM::ArrayOperand::getOperandName() const {
//    std::string name = this->arrayVar->getName()+"[" + "NOT_IMPLEMNETED" + "]";
//    return name;
//}
//
