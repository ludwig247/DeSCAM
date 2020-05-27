//
// Created by tobias on 19.07.18.
//

#include <NodePeekVisitor.h>
#include <PrintStmt.h>

#include <utility>
#include "Return.h"
#include "DescamException.h"

DESCAM::Return::Return(DESCAM::Expr *returnValue, LocationInfo stmtLocationInfo) :
        returnValue(returnValue) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (returnValue == nullptr) {
        throw DESCAM::DescamException(" Return value is null ",this->stmtLocationInfo);
    }

}

void DESCAM::Return::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

DESCAM::Expr *DESCAM::Return::getReturnValue() const {
    return returnValue;
}

void DESCAM::Return::setReturnValue(DESCAM::Expr *returnValue) {
    Return::returnValue = returnValue;
}

bool DESCAM::Return::operator==(const DESCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekReturn(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Return *) this;
    auto otherPtr = (const Return *) &other;
    return (*thisPtr->returnValue == *otherPtr->returnValue);
}

std::ostream &DESCAM::Return::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}
