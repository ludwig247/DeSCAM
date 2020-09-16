//
// Created by ludwig on 03.11.16.
//

#include <PrintStmt.h>

#include <utility>
#include "Logical.h"
#include "NodePeekVisitor.h"
#include "DescamException.h"

DESCAM::Logical::Logical(DESCAM::Expr *lhs, std::string operation, DESCAM::Expr *rhs, LocationInfo stmtLocationInfo) :
        lhs(lhs),
        rhs(rhs),
        operation(operation),
        Expr(lhs->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (lhs->getDataType() != rhs->getDataType()){
        std::string message = PrintStmt::toString(lhs) +":" + lhs->getDataType()->getName() + " " + operation + " " +  PrintStmt::toString(rhs) + ":" +  rhs->getDataType()->getName() + "\n";
        throw DESCAM::DescamException(message + "Logical: RHS(" + rhs->getDataType()->getName() + ") and LHS(" + lhs->getDataType()->getName() + ") are not of the same datatype",this->stmtLocationInfo);
    }

    if (lhs->getDataType()->getName() != "bool") throw DESCAM::DescamException("operands must be boolean",this->stmtLocationInfo);
    if (!(operation == "and" || operation == "nand" || operation == "or" || operation == "nor" || operation == "xor" || operation == "xnor")) {
        throw DESCAM::DescamException("Logical: unsuported operator",this->stmtLocationInfo);
    }
}

DESCAM::Expr *DESCAM::Logical::getRhs() {
    return rhs;
}

DESCAM::Expr *DESCAM::Logical::getLhs() {
    return lhs;
}

std::string DESCAM::Logical::getOperation() const {
    return operation;
}

void DESCAM::Logical::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

bool DESCAM::Logical::operator==(const Stmt &other) const {
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
