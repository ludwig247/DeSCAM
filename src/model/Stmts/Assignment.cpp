//
// Created by tobias on 23.10.15.
//

#include "Assignment.h"
#include "PrintStmt.h"
#include <iostream>
#include <utility>
#include "NodePeekVisitor.h"
#include "DescamException.h"

DESCAM::Assignment::Assignment(DESCAM::Expr *lhs, DESCAM::Expr *rhs, LocationInfo stmtLocationInfo) :
        lhs(lhs),
        rhs(rhs) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (lhs == nullptr && rhs != nullptr) {
        throw DESCAM::DescamException("Assignment: LHS is null",this->stmtLocationInfo);
    } else if (lhs != nullptr && rhs == nullptr) {
        throw DESCAM::DescamException("Assignment: RHS is null",this->stmtLocationInfo);
    } else if (lhs == nullptr && rhs == nullptr) {
        throw DESCAM::DescamException("Assignment: RHS && LHS is null",this->stmtLocationInfo);
    }

    if (lhs->getDataType() != rhs->getDataType()) {
        std::stringstream ss;
        ss << "ERROR: " << lhs->getDataType()->getName() << " != " << rhs->getDataType()->getName();
        ss << " in assignment: " << PrintStmt::toString(lhs) << " = " << PrintStmt::toString(rhs) << std::endl;
        ss << "Assignment: different DataTypes not allowed!";
        throw DESCAM::DescamException(ss.str(),this->stmtLocationInfo);
    }

    if (NodePeekVisitor::nodePeekArrayOperand(lhs)) {
        std::string msg = "LHS of assignment: It is not allowed to assign a value to an array with non-const index";
        msg += " in assignment: " + PrintStmt::toString(lhs) + " = " + PrintStmt::toString(rhs);
        throw DESCAM::DescamException(msg,this->stmtLocationInfo);
    }
    if (NodePeekVisitor::isConstTypeNode(lhs)) {
        std::string msg = "LHS of assignment has to be a variable";
        msg += " in assignment: " + PrintStmt::toString(lhs) + " = " + PrintStmt::toString(rhs);
        throw DESCAM::DescamException(msg,this->stmtLocationInfo);
    }
}

DESCAM::Expr *DESCAM::Assignment::getLhs() {
    return this->lhs;
}

DESCAM::Expr *DESCAM::Assignment::getRhs() {
    return this->rhs;
}

void DESCAM::Assignment::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::Assignment::operator==(const Stmt &other) const {
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
    return (*thisPtr->lhs == *otherPtr->lhs) && (*thisPtr->rhs == *otherPtr->rhs);
}

std::ostream &DESCAM::Assignment::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}


