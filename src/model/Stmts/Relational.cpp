//
// Created by ludwig on 03.11.16.
//

#include "Relational.h"

#include <utility>
#include "PrintStmt.h"
#include "NodePeekVisitor.h"
#include "DescamException.h"

DESCAM::Relational::Relational(Expr *lhs, std::string operation, Expr *rhs, LocationInfo stmtLocationInfo) :
        lhs(lhs),
        operation(operation),
        rhs(rhs),
        Expr(DataTypes::getDataType("bool")) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (lhs->getDataType() != rhs->getDataType()) {
        std::string message = PrintStmt::toString(lhs) +":" + lhs->getDataType()->getName() + " " + operation + " " +  PrintStmt::toString(rhs) + ":" +  rhs->getDataType()->getName() + "\n";
        throw DESCAM::DescamException(message + "Relational: RHS(" + rhs->getDataType()->getName() + ") and LHS(" + lhs->getDataType()->getName() + ") are not of the same datatype",this->stmtLocationInfo);
    }
    if (operation == "==" || operation == "!=" || operation == ">" || operation == ">=" || operation == "<" || operation == "<=") {
        if ((operation == ">" || operation == ">=" || operation == "<" || operation == "<=")) {
            if (lhs->getDataType() != DataTypes::getDataType("int") && lhs->getDataType() != DataTypes::getDataType("unsigned"))
                throw DESCAM::DescamException("Relational: operands must be numeric",this->stmtLocationInfo);
        }
    } else throw DESCAM::DescamException("Relational: unsuported operator: " + operation,this->stmtLocationInfo);
}

DESCAM::Expr *DESCAM::Relational::getRhs() {
    return rhs;
}

DESCAM::Expr *DESCAM::Relational::getLhs() {
    return lhs;
}

std::string DESCAM::Relational::getOperation() {
    return operation;
}

void DESCAM::Relational::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::Relational::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekRelational(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Relational *) this;
    auto otherPtr = (const Relational *) &other;
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
    if ((thisPtr->operation == "==") || (thisPtr->operation == "!=")) {
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
