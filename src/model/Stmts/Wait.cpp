//
// Created by tobias on 29.04.19.
//

#include <PrintStmt.h>

#include <utility>
#include "Wait.h"
#include "StmtException.h"

SCAM::Wait::Wait(StmtLocationInfo stmtLocationInfo) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

void SCAM::Wait::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::Wait::operator==(const SCAM::Stmt &other) const {
    //TODO: implement == for wait
    throw SCAM::StmtException("== Not implemented",this->stmtLocationInfo);

}

std::ostream &SCAM::Wait::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}

const std::string &SCAM::Wait::getStateName() const {
    return stateName;
}

void SCAM::Wait::setStateName(const std::string &stateName) {
    Wait::stateName = stateName;
}
