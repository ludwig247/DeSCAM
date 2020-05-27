//
// Created by tobias on 19.02.20.
//

#include <PrintStmt.h>

#include <utility>
#include "Ternary.h"
#include "DescamException.h"
#include "FatalError.h"
#include "Logger/Logger.h"


DESCAM::Ternary::Ternary(DESCAM::Expr *condition, DESCAM::Expr *trueExpr, DESCAM::Expr *falseExpr,
                       LocationInfo stmtLocationInfo) :
        condition(condition),
        trueExpr(trueExpr),
        falseExpr(falseExpr),
        Expr(trueExpr->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (condition == nullptr) TERMINATE("Condition is null");
    if (trueExpr == nullptr) TERMINATE("TrueExpr is null");
    if (falseExpr == nullptr) TERMINATE("FalseExpr is null");

    if (trueExpr->getDataType() != falseExpr->getDataType()) {
        std::string message = PrintStmt::toString(trueExpr) + ":" + trueExpr->getDataType()->getName() + ":" +
                              PrintStmt::toString(falseExpr) + ":" + falseExpr->getDataType()->getName() + "\n";
        throw DESCAM::DescamException(message + "Compare: TRUE(" + trueExpr->getDataType()->getName() + ") and FALSE(" +
                                   falseExpr->getDataType()->getName() +
                                   ") are not of the same datatype", this->stmtLocationInfo);
    }

}

void DESCAM::Ternary::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::Ternary::operator==(const DESCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekTernary(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Ternary *) this;
    auto otherPtr = (const Ternary *) &other;

    auto is_equal = [](Expr *a, Expr *b) -> bool {
        return (*a) == (*b);
    };

    bool conditions = is_equal(thisPtr->getCondition(), otherPtr->getCondition());
    bool trueExprs = is_equal(thisPtr->getTrueExpr(), otherPtr->getTrueExpr());
    bool falseExprs = is_equal(thisPtr->getFalseExpr(), otherPtr->getFalseExpr());
    return conditions && trueExprs && falseExprs;
}

DESCAM::Expr *DESCAM::Ternary::getCondition() const {
    return condition;
}

DESCAM::Expr *DESCAM::Ternary::getTrueExpr() const {
    return trueExpr;
}

DESCAM::Expr *DESCAM::Ternary::getFalseExpr() const {
    return falseExpr;
}

void DESCAM::Ternary::setTrivialTrue() {
    this->condition = new BoolValue(true);

}

void DESCAM::Ternary::setTrivialFalse() {
    this->condition = new BoolValue(false);

}
