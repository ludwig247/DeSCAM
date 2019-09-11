//
// Created by tobias on 19.07.18.
//

#include <NodePeekVisitor.h>
#include <PrintStmt.h>
#include "Return.h"

SCAM::Return::Return(SCAM::Expr *returnValue):
    returnValue(returnValue){

    if(returnValue == nullptr){
        throw std::runtime_error(" Return value is null ");
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
    ostream <<PrintStmt::toString(this);
    return ostream;
}
