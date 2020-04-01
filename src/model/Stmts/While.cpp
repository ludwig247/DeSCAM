//
// Created by tobias on 06.11.15.
//

#include "While.h"

#include <utility>
#include "NodePeekVisitor.h"

SCAM::While::While(SCAM::Expr *conditionStmt, StmtLocationInfo stmtLocationInfo) :
        conditionStmt(conditionStmt) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

SCAM::Expr *SCAM::While::getConditionStmt() const {
    return this->conditionStmt;
}

void SCAM::While::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::While::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekWhile(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (While *) this;
    auto otherPtr = (const While *) &other;
    if (thisPtr->conditionStmt == otherPtr->conditionStmt) return true;
    if (*thisPtr->conditionStmt == *otherPtr->conditionStmt) return true;
    return false;
}
