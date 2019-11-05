//
// Created by tobias on 20.05.16.
//

#include <PrintStmt.h>
#include "Arithmetic.h"
#include "NodePeekVisitor.h"

SCAM::Arithmetic::Arithmetic(SCAM::Expr *lhs, std::string operation, SCAM::Expr *rhs) :
        lhs(lhs),
        operation(operation),
        rhs(rhs),
        Expr(lhs->getDataType()) {
    if (lhs->getDataType() != rhs->getDataType()) {
        std::cout << PrintStmt::toString(lhs) << operation << PrintStmt::toString(rhs) << std::endl;
        throw std::runtime_error("Arithmetic: LHS(" + lhs->getDataType()->getName() + ") and RHS(" + rhs->getDataType()->getName() + ") are not of the same datatype");
    }
    if (lhs->getDataType()->getName() != "int" && lhs->getDataType()->getName() != "unsigned") throw std::runtime_error("operands must be numeric");
    if (!(operation == "+" || operation == "-" || operation == "*" || operation == "/" || operation == "%")) {
        throw std::runtime_error("Arithmetic: unsuported operator");
    }
}

SCAM::Expr *SCAM::Arithmetic::getRhs() const {
    return this->rhs;
}

SCAM::Expr *SCAM::Arithmetic::getLhs() const {
    return this->lhs;
}

std::string SCAM::Arithmetic::getOperation() {
    return this->operation;
}

void SCAM::Arithmetic::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::Arithmetic::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekArithmetic(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Arithmetic *) this;
    auto otherPtr = (const Arithmetic *) &other;
    if (thisPtr->operation != otherPtr->operation) return false;
    if (thisPtr->lhs == otherPtr->lhs) {
        if (thisPtr->rhs == otherPtr->rhs) return true;
        if (*thisPtr->rhs == *otherPtr->rhs) return true;
    }
    if (thisPtr->rhs == otherPtr->rhs) {
        if (*thisPtr->lhs == *otherPtr->lhs) return true;
    }
    if ((*thisPtr->lhs == *otherPtr->lhs) && (*thisPtr->rhs == *otherPtr->rhs)) return true;
    if ((thisPtr->operation == "+") || (thisPtr->operation == "*")) {
        // in some cases nodes can be switched without affecting result
        if (thisPtr->lhs == otherPtr->rhs) {
            if (thisPtr->rhs == otherPtr->lhs) return true;
            if (*thisPtr->rhs == *otherPtr->lhs) return true;
        }
        if (thisPtr->rhs == otherPtr->lhs) {
            if (*thisPtr->lhs == *otherPtr->rhs) return true;
        }
        if ((*thisPtr->lhs == *otherPtr->rhs) && (*thisPtr->rhs == *otherPtr->lhs)) return true;
    }
    if (thisPtr->operation == "-") {
        // -a-b is equal to -b-a
        NodePeekVisitor thisNodePeek(thisPtr->getLhs());
        NodePeekVisitor otherNodePeek(otherPtr->getLhs());
        if (thisNodePeek.nodePeekUnaryExpr() && (thisNodePeek.nodePeekUnaryExpr()->getOperation() == "-") &&
            otherNodePeek.nodePeekUnaryExpr() && (otherNodePeek.nodePeekUnaryExpr()->getOperation() == "-")) {
            if (thisNodePeek.nodePeekUnaryExpr()->getExpr() == otherPtr->rhs) {
                if (thisPtr->rhs == otherNodePeek.nodePeekUnaryExpr()->getExpr()) return true;
                if (*thisPtr->rhs == *otherNodePeek.nodePeekUnaryExpr()->getExpr()) return true;
            }
            if (thisPtr->rhs == otherNodePeek.nodePeekUnaryExpr()->getExpr()) {
                if (*thisNodePeek.nodePeekUnaryExpr()->getExpr() == *otherPtr->rhs) return true;
            }
            if ((*thisNodePeek.nodePeekUnaryExpr()->getExpr() == *otherPtr->rhs) &&
                (*thisPtr->rhs == *otherNodePeek.nodePeekUnaryExpr()->getExpr()))
                return true;
        }
    }
    return false;
}
