//
// Created by lucas on 16.01.20.
//

#include "TemporalExpr.h"


DESCAM::TemporalExpr::TemporalExpr(Expr *timepoint, Stmt *statement) :
    statement(statement) {
    type = Type::AT;
    timepointList.push_back(timepoint);

}

DESCAM::TemporalExpr::TemporalExpr(Expr *t_start, Expr *t_end, Stmt *statement) :
    statement(statement) {
    type = Type::DURING;
    timepointList.push_back(t_start);
    timepointList.push_back(t_end);

}

DESCAM::TemporalExpr::Type DESCAM::TemporalExpr::getType() const {
    return type;
}

DESCAM::Stmt *DESCAM::TemporalExpr::getStatement() const {
    return statement;
}

const std::vector<DESCAM::Expr *> &DESCAM::TemporalExpr::getTimepointList() const {
    return timepointList;
}

bool DESCAM::TemporalExpr::isAt() {
    return (type == Type::AT);
}

bool DESCAM::TemporalExpr::isDuring() {
    return (type == Type::DURING);
}

const std::string &DESCAM::TemporalExpr::getFreezeAt() const {
    return freezeAt;
}

void DESCAM::TemporalExpr::setFreezeAt(const std::string &freezeAt) {
    TemporalExpr::freezeAt = freezeAt;
}
