//
// Created by ludwig on 05.11.15.
//

#include "UnaryExpr.h"
#include "NodePeekVisitor.h"


SCAM::UnaryExpr::UnaryExpr(std::string operation, SCAM::Expr *expr) :
        expr(expr),
        operation(operation),
        Expr(expr->getDataType()) {
    if (!(operation == "not" || operation == "-")) {
        throw std::runtime_error("UnaryExpr: unsuported operator: " + operation);
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
