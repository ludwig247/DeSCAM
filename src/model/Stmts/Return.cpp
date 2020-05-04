//
// Created by tobias on 19.07.18.
//

#include <NodePeekVisitor.h>
#include <PrintStmt.h>

#include <utility>
#include "Return.h"
#include "StmtException.h"

SCAM::Return::Return(SCAM::Expr *returnValue, LocationInfo stmtLocationInfo) :
        returnValue(returnValue) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (returnValue == nullptr) {
        throw SCAM::StmtException(" Return value is null ",this->stmtLocationInfo);
    }

}

void SCAM::Return::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

SCAM::Expr *SCAM::Return::getReturnValue() const {
    return returnValue;
}

void SCAM::Return::setReturnValue(SCAM::Expr *returnValue) {
    Return::returnValue = returnValue;
}

bool SCAM::Return::operator==(const SCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekReturn(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Return *) this;
    auto otherPtr = (const Return *) &other;
    return (*thisPtr->returnValue == *otherPtr->returnValue);
}

std::ostream &SCAM::Return::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}
