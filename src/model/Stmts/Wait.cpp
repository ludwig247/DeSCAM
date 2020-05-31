//
// Created by tobias on 29.04.19.
//

#include <PrintStmt.h>
#include "Wait.h"

SCAM::Wait::Wait() {

}

void SCAM::Wait::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::Wait::operator==(const SCAM::Stmt &other) const {
    //TODO: implement == for wait
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekWait(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Wait *) this;
    auto otherPtr = (const Wait *) &other;
    return thisPtr->getStateName() == otherPtr->getStateName();
    throw std::runtime_error("Not implemented");

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
