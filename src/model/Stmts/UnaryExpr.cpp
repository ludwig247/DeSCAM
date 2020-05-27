//
// Created by ludwig on 05.11.15.
//

#include "UnaryExpr.h"

#include <utility>
#include "NodePeekVisitor.h"
#include "DescamException.h"


DESCAM::UnaryExpr::UnaryExpr(std::string operation, DESCAM::Expr *expr, LocationInfo stmtLocationInfo) :
        expr(expr),
        operation(operation),
        Expr(expr->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (!(operation == "not" || operation == "-"|| operation == "~") ) {
        throw DESCAM::DescamException("UnaryExpr: unsuported operator: " + operation,this->stmtLocationInfo);
    }
}

DESCAM::Expr *DESCAM::UnaryExpr::getExpr() {
    return this->expr;
}

void DESCAM::UnaryExpr::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}


std::string DESCAM::UnaryExpr::getOperation() {
    return this->operation;
}

bool DESCAM::UnaryExpr::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekUnaryExpr(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (UnaryExpr *) this;
    auto otherPtr = (const UnaryExpr *) &other;
    if (thisPtr->operation != otherPtr->operation) return false;
    if (thisPtr->expr == otherPtr->expr) return true;
    if (*thisPtr->expr == *otherPtr->expr) return true;
    return false;
}
