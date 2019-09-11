//
// Created by ludwig on 03.11.16.
//

#include "Relational.h"
#include "PrintStmt.h"
#include "NodePeekVisitor.h"
SCAM::Relational::Relational(Expr *lhs, std::string operation, Expr *rhs) :
        lhs(lhs),
        operation(operation),
        rhs(rhs),
        Expr(DataTypes::getDataType("bool")) {
    if (lhs->getDataType() != rhs->getDataType()){
        std::string message = PrintStmt::toString(lhs) + lhs->getDataType()->getName()  + operation + PrintStmt::toString(rhs) + rhs->getDataType()->getName() + "\n" ;
        throw std::runtime_error(message+"Relational: RHS("+rhs->getDataType()->getName()+") and LHS("+ lhs->getDataType()->getName()+") are not of the same datatype");
    }
    if (operation  == "==" || operation == "!=" || operation == ">" || operation == ">=" || operation == "<" || operation == "<=") {
        if ((operation == ">" || operation == ">=" || operation == "<" || operation == "<=")) {
            if (lhs->getDataType() != DataTypes::getDataType("int") && lhs->getDataType() != DataTypes::getDataType("unsigned") ) throw std::runtime_error("Relational: operands must be numeric");
        }
    } else throw std::runtime_error("Relational: unsuported operator: " + operation);
}

SCAM::Expr *SCAM::Relational::getRhs() {
    return rhs;
}

SCAM::Expr *SCAM::Relational::getLhs() {
    return lhs;
}

std::string SCAM::Relational::getOperation() {
    return operation;
}

void SCAM::Relational::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::Relational::operator==(const Stmt &other) const {
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
