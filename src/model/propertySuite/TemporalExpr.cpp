//
// Created by lucas on 16.01.20.
//

#include "TemporalExpr.h"


SCAM::TemporalExpr::TemporalExpr(Expr *timepoint, Stmt *statement) :
    statement(statement) {
    type = Type::AT;
    timepointList.push_back(timepoint);
    std::cout << *statement << std::endl;

}

SCAM::TemporalExpr::TemporalExpr(Expr *t_start, Expr *t_end, Stmt *statement) :
    statement(statement) {
    type = Type::DURING;
    timepointList.push_back(t_start);
    timepointList.push_back(t_end);
    std::cout << *statement << std::endl;

}

SCAM::TemporalExpr::Type SCAM::TemporalExpr::getType() const {
    return type;
}

SCAM::Stmt *SCAM::TemporalExpr::getStatement() const {
    return statement;
}

const std::vector<SCAM::Expr *> &SCAM::TemporalExpr::getTimepointList() const {
    return timepointList;
}

bool SCAM::TemporalExpr::isAt() {
    return (type == Type::AT);
}

bool SCAM::TemporalExpr::isDuring() {
    return (type == Type::DURING);
}

const std::string &SCAM::TemporalExpr::getFreezeAt() const {
    return freezeAt;
}

void SCAM::TemporalExpr::setFreezeAt(const std::string &freezeAt) {
    TemporalExpr::freezeAt = freezeAt;
}
