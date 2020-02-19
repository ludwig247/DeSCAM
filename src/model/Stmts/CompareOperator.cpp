//
// Created by tobias on 19.02.20.
//

#include <PrintStmt.h>
#include "CompareOperator.h"

SCAM::CompareOperator::CompareOperator(SCAM::Expr *condition, SCAM::Expr *trueExpr, SCAM::Expr *falseExpr):
    condition(condition),
    trueExpr(trueExpr),
    falseExpr(falseExpr),
    Expr(trueExpr->getDataType()){
;
    if(condition == nullptr) throw std::runtime_error("Condition is null");
    if(trueExpr == nullptr) throw std::runtime_error("TrueExpr is null");
    if(falseExpr == nullptr) throw std::runtime_error("FalseExpr is null");

    if(trueExpr->getDataType() != falseExpr->getDataType()){
        std::string message = PrintStmt::toString(trueExpr) +":" + trueExpr->getDataType()->getName() + ":" +  PrintStmt::toString(falseExpr) + ":" +  falseExpr->getDataType()->getName() + "\n";
        throw std::runtime_error(message + "Compare: TRUE(" + trueExpr->getDataType()->getName() + ") and FALSE(" + falseExpr->getDataType()->getName() + ") are not of the same datatype");
    }

}

void SCAM::CompareOperator::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::CompareOperator::operator==(const SCAM::Stmt &other) const {
    throw std::runtime_error("not implemented");
    return false;
}

SCAM::Expr *SCAM::CompareOperator::getCondition() const {
    return condition;
}

SCAM::Expr *SCAM::CompareOperator::getTrueExpr() const {
    return trueExpr;
}

SCAM::Expr *SCAM::CompareOperator::getFalseExpr() const {
    return falseExpr;
}
