//
// Created by tobias on 17.07.18.
//

#include <NodePeekVisitor.h>
#include "SubSelect.h"

SCAM::SubSelect::SubSelect(SCAM::Operand *operand, std::string sub) :
        sub(sub),
        operand(operand),
        Expr(operand->getDataType()->getSubVarMap().find(sub)->second) {
    if (!operand->getDataType()->isCompoundType()) {
        throw std::runtime_error("Expr for SubSelect has to be a compound type");
    }
}

SCAM::Operand* SCAM::SubSelect::getOperand() const {
    return operand;
}

std::string SCAM::SubSelect::getSub() const {
    return sub;
}

void SCAM::SubSelect::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

bool SCAM::SubSelect::operator==(const SCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekSubSelect(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (SubSelect *) this;
    auto otherPtr = (const SubSelect *) &other;
    if (thisPtr->sub != otherPtr->sub) return false;
    return (*thisPtr->operand == *otherPtr->operand);
}
