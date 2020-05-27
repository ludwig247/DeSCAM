//
// Created by tobias on 06.11.15.
//

#include "While.h"

#include <utility>
#include "NodePeekVisitor.h"

DESCAM::While::While(DESCAM::Expr *conditionStmt, LocationInfo stmtLocationInfo) :
        conditionStmt(conditionStmt) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

DESCAM::Expr *DESCAM::While::getConditionStmt() const {
    return this->conditionStmt;
}

void DESCAM::While::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::While::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekWhile(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (While *) this;
    auto otherPtr = (const While *) &other;
    if (thisPtr->conditionStmt == otherPtr->conditionStmt) return true;
    if (*thisPtr->conditionStmt == *otherPtr->conditionStmt) return true;
    return false;
}
