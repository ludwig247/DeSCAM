//
// Created by ludwig on 23.06.17.
//

#include <PrintStmt.h>

#include <utility>
#include "Bitwise.h"
#include "NodePeekVisitor.h"
#include "DescamException.h"

DESCAM::Bitwise::Bitwise(DESCAM::Expr *lhs, std::string operation, DESCAM::Expr *rhs, LocationInfo stmtLocationInfo) :
        lhs(lhs),
        operation(operation),
        rhs(rhs),
        Expr(lhs->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (operation != "<<" && operation != ">>" && operation != "&" && operation != "|" && operation != "^") {
        throw DESCAM::DescamException("Bitwise: " + operation + " not a bitwise op",this->stmtLocationInfo);
    } else if (lhs->getDataType() != rhs->getDataType()) {
        std::string msg = PrintStmt::toString(lhs) + operation + PrintStmt::toString(rhs);
        throw DESCAM::DescamException(msg + "Bitwise: LHS(" + lhs->getDataType()->getName() + ") and RHS(" + rhs->getDataType()->getName() + ") are not of the same datatype",this->stmtLocationInfo);
    } else if (lhs->getDataType()->getName() != "int" && lhs->getDataType()->getName() != "unsigned") throw DESCAM::DescamException("operands must be numeric",this->stmtLocationInfo);

}

DESCAM::Expr *DESCAM::Bitwise::getLhs() {
    return lhs;
}

DESCAM::Expr *DESCAM::Bitwise::getRhs() {
    return rhs;
}


std::string DESCAM::Bitwise::getOperation() {
    return operation;
}

void DESCAM::Bitwise::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

bool DESCAM::Bitwise::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekBitwise(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Bitwise *) this;
    auto otherPtr = (const Bitwise *) &other;
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
    if ((thisPtr->operation == "&") || (thisPtr->operation == "|") || (thisPtr->operation == "^")) {
        // in some cases nodes can be switched without affecting result
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
    }
    return false;
}
