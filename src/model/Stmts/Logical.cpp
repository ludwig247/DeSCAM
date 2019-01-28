//
// Created by ludwig on 03.11.16.
//

#include "Logical.h"
#include "NodePeekVisitor.h"
SCAM::Logical::Logical(SCAM::Expr *lhs, std::string operation, SCAM::Expr *rhs) :
        lhs(lhs),
        rhs(rhs),
        operation(operation),
        Expr(lhs->getDataType()) {
    if (lhs->getDataType() != rhs->getDataType())
        throw std::runtime_error("Logical: RHS(" + rhs->getDataType()->getName() + ") and LHS(" + lhs->getDataType()->getName() + ") are not of the same datatype");
    if (lhs->getDataType()->getName() != "bool") throw std::runtime_error("operands must be boolean");
    if (!(operation == "and" || operation == "nand" || operation == "or" || operation == "nor" || operation == "xor" || operation == "xnor")) {
        throw std::runtime_error("Logical: unsuported operator");
    }
}

SCAM::Expr *SCAM::Logical::getRhs() {
    return rhs;
}

SCAM::Expr *SCAM::Logical::getLhs() {
    return lhs;
}

std::string SCAM::Logical::getOperation() const {
    return operation;
}

void SCAM::Logical::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

bool SCAM::Logical::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekLogical(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Logical *) this;
    auto otherPtr = (const Logical *) &other;
    if (thisPtr->operation != otherPtr->operation) return false;
    if (thisPtr->lhs == otherPtr->lhs) {
        if (thisPtr->rhs == otherPtr->rhs) return true;
        if (*thisPtr->rhs == *otherPtr->rhs) return true;
    }
    if (thisPtr->rhs == otherPtr->rhs) {
        if (*thisPtr->lhs == *otherPtr->lhs) return true;
    }
    if ((*thisPtr->lhs == *otherPtr->lhs) &&
        (*thisPtr->rhs == *otherPtr->rhs))
        return true;
    // nodes can be switched without affecting result
    if (thisPtr->lhs == otherPtr->rhs) {
        if (thisPtr->rhs == otherPtr->lhs) return true;
        if (*thisPtr->rhs == *otherPtr->lhs) return true;
    }
    if (thisPtr->rhs == otherPtr->lhs) {
        if (*thisPtr->lhs == *otherPtr->rhs) return true;
    }
    if ((*thisPtr->lhs == *otherPtr->rhs) &&
        (*thisPtr->rhs == *otherPtr->lhs))
        return true;
    return false;
}
