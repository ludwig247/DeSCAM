//
// Created by tobias on 23.10.15.
//

#include "Assignment.h"
#include "PrintStmt.h"
#include <iostream>
#include "NodePeekVisitor.h"

SCAM::Assignment::Assignment(SCAM::Expr *lhs, SCAM::Expr *rhs) :
        lhs(lhs),
        rhs(rhs) {
    if (lhs == nullptr && rhs != nullptr) {
        throw std::runtime_error("Assignment: LHS is null");
    } else if (lhs != nullptr && rhs == nullptr) {
        throw std::runtime_error("Assignment: RHS is null");
    } else if (lhs == nullptr && rhs == nullptr) {
        throw std::runtime_error("Assignment: RHS && LHS is null");
    }

    if (lhs->getDataType() != rhs->getDataType()) {
        std::cout << "ERROR: " << lhs->getDataType()->getName() << " != " << rhs->getDataType()->getName();
        std::cout << " in assignment: " << PrintStmt::toString(lhs) << " = " << PrintStmt::toString(rhs) << std::endl;
        throw std::runtime_error("Assignment: differnt DataTypes not allowed!");
    }
}

SCAM::Expr *SCAM::Assignment::getLhs() {
    return this->lhs;
}

SCAM::Expr *SCAM::Assignment::getRhs() {
    return this->rhs;
}

void SCAM::Assignment::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::Assignment::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekAssignment(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Assignment *) this;
    auto otherPtr = (const Assignment *) &other;
    if (thisPtr->lhs == otherPtr->lhs) {
        if (thisPtr->rhs == otherPtr->rhs) return true;
        if (*thisPtr->rhs == *otherPtr->rhs) return true;
    }
    if (thisPtr->rhs == otherPtr->rhs) {
        if (*thisPtr->lhs == *otherPtr->lhs) return true;
    }
    if ((*thisPtr->lhs == *otherPtr->lhs) && (*thisPtr->rhs == *otherPtr->rhs))
        return true;
    return false;
}

std::ostream &SCAM::Assignment::print(std::ostream &ostream) const {
        ostream <<PrintStmt::toString(this);
        return ostream;
}


