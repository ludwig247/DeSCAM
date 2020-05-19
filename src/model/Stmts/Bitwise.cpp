//
// Created by ludwig on 23.06.17.
//

#include <PrintStmt.h>

#include <utility>
#include "Bitwise.h"
#include "NodePeekVisitor.h"
#include "DescamException.h"

SCAM::Bitwise::Bitwise(SCAM::Expr *lhs, std::string operation, SCAM::Expr *rhs, LocationInfo stmtLocationInfo) :
        lhs(lhs),
        operation(operation),
        rhs(rhs),
        Expr(lhs->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (operation != "<<" && operation != ">>" && operation != "&" && operation != "|" && operation != "^") {
        throw SCAM::DescamException("Bitwise: " + operation + " not a bitwise op",this->stmtLocationInfo);
    } else if (lhs->getDataType() != rhs->getDataType()) {
        std::string msg = PrintStmt::toString(lhs) + operation + PrintStmt::toString(rhs);
        throw SCAM::DescamException(msg + "Bitwise: LHS(" + lhs->getDataType()->getName() + ") and RHS(" + rhs->getDataType()->getName() + ") are not of the same datatype",this->stmtLocationInfo);
    } else if (lhs->getDataType()->getName() != "int" && lhs->getDataType()->getName() != "unsigned") throw SCAM::DescamException("operands must be numeric",this->stmtLocationInfo);

}

SCAM::Expr *SCAM::Bitwise::getLhs() {
    return lhs;
}

SCAM::Expr *SCAM::Bitwise::getRhs() {
    return rhs;
}


std::string SCAM::Bitwise::getOperation() {
    return operation;
}

void SCAM::Bitwise::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

bool SCAM::Bitwise::operator==(const Stmt &other) const {
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
