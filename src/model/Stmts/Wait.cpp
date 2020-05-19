//
// Created by tobias on 29.04.19.
//

#include <PrintStmt.h>

#include <utility>
#include "Wait.h"
#include "DescamException.h"

DESCAM::Wait::Wait(LocationInfo stmtLocationInfo) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

void DESCAM::Wait::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::Wait::operator==(const DESCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekWait(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Wait *) this;
    auto otherPtr = (const Wait *) &other;
    return thisPtr->getStateName() == otherPtr->getStateName();
}

std::ostream &DESCAM::Wait::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}

const std::string &DESCAM::Wait::getStateName() const {
    return stateName;
}

void DESCAM::Wait::setStateName(const std::string &stateName) {
    Wait::stateName = stateName;
}
