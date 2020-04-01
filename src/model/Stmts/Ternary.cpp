//
// Created by tobias on 19.02.20.
//

#include <PrintStmt.h>

#include <utility>
#include "Ternary.h"

SCAM::Ternary::Ternary(SCAM::Expr *condition, SCAM::Expr *trueExpr, SCAM::Expr *falseExpr, StmtLocationInfo stmtLocationInfo):
    condition(condition),
    trueExpr(trueExpr),
    falseExpr(falseExpr),
    Expr(trueExpr->getDataType()){
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if(condition == nullptr) throw std::runtime_error("Condition is null");
    if(trueExpr == nullptr) throw std::runtime_error("TrueExpr is null");
    if(falseExpr == nullptr) throw std::runtime_error("FalseExpr is null");

    if(trueExpr->getDataType() != falseExpr->getDataType()){
        std::string message = PrintStmt::toString(trueExpr) +":" + trueExpr->getDataType()->getName() + ":" +  PrintStmt::toString(falseExpr) + ":" +  falseExpr->getDataType()->getName() + "\n";
        throw std::runtime_error(message + "Compare: TRUE(" + trueExpr->getDataType()->getName() + ") and FALSE(" + falseExpr->getDataType()->getName() + ") are not of the same datatype");
    }

}

void SCAM::Ternary::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::Ternary::operator==(const SCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekTernary(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Ternary *) this;
    auto otherPtr = (const Ternary *) &other;

    auto is_equal = [] (Expr * a, Expr * b)-> bool {
        return (*a) == (*b);
    };

   bool conditions =  is_equal(thisPtr->getCondition() ,otherPtr->getCondition()) ;
   bool trueExprs = is_equal(thisPtr->getTrueExpr(),otherPtr->getTrueExpr());
   bool falseExprs = is_equal(thisPtr->getFalseExpr(), otherPtr->getFalseExpr());
   return conditions && trueExprs && falseExprs;
}

SCAM::Expr *SCAM::Ternary::getCondition() const {
    return condition;
}

SCAM::Expr *SCAM::Ternary::getTrueExpr() const {
    return trueExpr;
}

SCAM::Expr *SCAM::Ternary::getFalseExpr() const {
    return falseExpr;
}

void SCAM::Ternary::setTrivialTrue() {
    this->condition = new BoolValue(true);

}

void SCAM::Ternary::setTrivialFalse() {
    this->condition = new BoolValue(false);

}
