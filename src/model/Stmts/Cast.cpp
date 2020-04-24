//
// Created by ludwig on 22.03.18.
//

#include <PrintStmt.h>
#include "Cast.h"
#include "NodePeekVisitor.h"
#include "StmtException.h"

SCAM::Cast::Cast(SCAM::Expr *expr, const SCAM::DataType *toDatatype, StmtLocationInfo stmtLocationInfo) :
        Expr(toDatatype),
        expr(expr) {
    this->stmtLocationInfo = stmtLocationInfo;
    if (expr == nullptr) throw SCAM::StmtException("Cast: expr is null!",this->stmtLocationInfo);
    if (expr->getDataType() == toDatatype) throw SCAM::StmtException("No cast necessary -> same datatype. Remove static_cast",this->stmtLocationInfo);
    if (!expr->getDataType()->isUnsigned() && !expr->getDataType()->isInteger()) {
        throw SCAM::StmtException("Cast from " + expr->getDataType()->getName() + " to " + expr->getDataType()->getName() + " is not allowed",this->stmtLocationInfo);
    }
    if (!toDatatype->isUnsigned() && !toDatatype->isInteger()) {
        throw SCAM::StmtException("Cast only to unsigned or int",this->stmtLocationInfo);
    }
}

SCAM::Cast::~Cast() {

}

void SCAM::Cast::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

SCAM::Expr *SCAM::Cast::getSubExpr() const {
    return expr;
}

bool SCAM::Cast::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekCast(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Cast *) this;
    auto otherPtr = (const Cast *) &other;
    if (thisPtr->getDataType() != otherPtr->getDataType()) return false;
    if (thisPtr->expr == otherPtr->expr) return true;
    return *thisPtr->expr == *otherPtr->expr;
}


