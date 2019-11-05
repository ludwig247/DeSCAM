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
    throw std::runtime_error("Not implemented");

}

std::ostream &SCAM::Wait::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}
