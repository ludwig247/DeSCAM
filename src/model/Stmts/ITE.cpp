//
// Created by tobias on 17.02.16.
//

#include "ITE.h"

#include <utility>
#include "NodePeekVisitor.h"

DESCAM::ITE::ITE(DESCAM::Expr *conditionStmt, LocationInfo stmtLocationInfo) : If(conditionStmt, std::move(stmtLocationInfo)) {
}

void DESCAM::ITE::addIfList(DESCAM::Stmt *stmt) {
    this->ifList.push_back(stmt);

}

void DESCAM::ITE::addElseList(DESCAM::Stmt *stmt) {
    this->elseList.push_back(stmt);
}

void DESCAM::ITE::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}


void DESCAM::ITE::setIfList(const std::vector<DESCAM::Stmt *> &ifList) {
    ITE::ifList = ifList;
}

void DESCAM::ITE::setElseList(const std::vector<DESCAM::Stmt *> &elseList) {
    ITE::elseList = elseList;
}

const std::vector<DESCAM::Stmt *> &DESCAM::ITE::getIfList() const {
    return ifList;
}

const std::vector<DESCAM::Stmt *> &DESCAM::ITE::getElseList() const {
    return elseList;
}

bool DESCAM::ITE::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekITE(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (ITE *) this;
    auto otherPtr = (const ITE *) &other;
    if (thisPtr->getConditionStmt() != otherPtr->getConditionStmt()) return false;
    if (thisPtr->ifList != otherPtr->ifList) return false;
    if (thisPtr->elseList == otherPtr->elseList) return true;
    return false;
}


