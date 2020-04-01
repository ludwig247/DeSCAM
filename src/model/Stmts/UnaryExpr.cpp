//
// Created by ludwig on 05.11.15.
//

#include "UnaryExpr.h"

#include <utility>
#include "NodePeekVisitor.h"
#include "StmtException.h"


SCAM::UnaryExpr::UnaryExpr(std::string operation, SCAM::Expr *expr, StmtLocationInfo stmtLocationInfo) :
        expr(expr),
        operation(operation),
        Expr(expr->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (!(operation == "not" || operation == "-"|| operation == "~") ) {
        throw SCAM::StmtException("UnaryExpr: unsuported operator: " + operation,this->stmtLocationInfo);
    }
}

SCAM::Expr *SCAM::UnaryExpr::getExpr() {
    return this->expr;
}

void SCAM::UnaryExpr::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}


std::string SCAM::UnaryExpr::getOperation() {
    return this->operation;
}

bool SCAM::UnaryExpr::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekUnaryExpr(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (UnaryExpr *) this;
    auto otherPtr = (const UnaryExpr *) &other;
    if (thisPtr->operation != otherPtr->operation) return false;
    if (thisPtr->expr == otherPtr->expr) return true;
    if (*thisPtr->expr == *otherPtr->expr) return true;
    return false;
}
