//
// Created by tobias on 06.11.15.
//

#include "If.h"

#include <utility>
#include "NodePeekVisitor.h"

SCAM::If::If(SCAM::Expr *conditionStmt, LocationInfo stmtLocationInfo) :
        conditionStmt(conditionStmt) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);

}

SCAM::Expr *SCAM::If::getConditionStmt() const {
    return this->conditionStmt;
}

void SCAM::If::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::If::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekIf(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (If *) this;
    auto otherPtr = (const If *) &other;
    if (thisPtr->conditionStmt == otherPtr->conditionStmt) return true;
    if (*thisPtr->conditionStmt == *otherPtr->conditionStmt) return true;
    return false;
}


bool SCAM::If::hasElseStmt() {
    return false;
}


