//
// Created by lucas on 16.01.20.
//

#include "TemporalExpr.h"

SCAM::TemporalExprType SCAM::TemporalExpr::getType() const {
    return type;
}

void SCAM::TemporalExpr::setType(SCAM::TemporalExprType newType) {
    TemporalExpr::type = newType;
}

SCAM::Stmt *SCAM::TemporalExpr::getStatement() const {
    return statement;
}

void SCAM::TemporalExpr::setStatement(SCAM::Stmt *newStatement) {
    TemporalExpr::statement = newStatement;
}

const std::vector<SCAM::Expr *> &SCAM::TemporalExpr::getTiming() const {
    return timeExprs;
}

void SCAM::TemporalExpr::setTiming(SCAM::Expr *timeExpr) {
    if (isAt()) {
        timeExprs.clear();
        timeExprs.push_back(timeExpr);
    } else {
        throw std::runtime_error("Only one time point for a DURING expression provided.");
    }
}

void SCAM::TemporalExpr::setTiming(SCAM::Expr *timeExpr1, SCAM::Expr *timeExpr2) {
    if (isDuring()) {
        timeExprs.clear();
        timeExprs.push_back(timeExpr1);
        timeExprs.push_back(timeExpr2);
    } else {
        throw std::runtime_error("Two time point for an AT expression provided.");
    }
}

bool SCAM::TemporalExpr::isAt() {
    return (type == AT);
}

bool SCAM::TemporalExpr::isDuring() {
    return (type == DURING);
}
