//
// Created by ludwig on 22.03.18.
//

#include <PrintStmt.h>
#include "Cast.h"
#include "NodePeekVisitor.h"
#include "DescamException.h"

DESCAM::Cast::Cast(DESCAM::Expr *expr, const DESCAM::DataType *toDatatype, LocationInfo stmtLocationInfo) :
        Expr(toDatatype),
        expr(expr) {
    this->stmtLocationInfo = stmtLocationInfo;
    if (expr == nullptr) throw DESCAM::DescamException("Cast: expr is null!",this->stmtLocationInfo);
    if (expr->getDataType() == toDatatype) throw DESCAM::DescamException("No cast necessary -> same datatype. Remove static_cast",this->stmtLocationInfo);
    if (!expr->getDataType()->isUnsigned() && !expr->getDataType()->isInteger()) {
        throw DESCAM::DescamException("Cast from " + expr->getDataType()->getName() + " to " + expr->getDataType()->getName() + " is not allowed",this->stmtLocationInfo);
    }
    if (!toDatatype->isUnsigned() && !toDatatype->isInteger()) {
        throw DESCAM::DescamException("Cast only to unsigned or int",this->stmtLocationInfo);
    }
}

DESCAM::Cast::~Cast() {

}

void DESCAM::Cast::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

DESCAM::Expr *DESCAM::Cast::getSubExpr() const {
    return expr;
}

bool DESCAM::Cast::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekCast(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Cast *) this;
    auto otherPtr = (const Cast *) &other;
    if (thisPtr->getDataType() != otherPtr->getDataType()) return false;
    if (thisPtr->expr == otherPtr->expr) return true;
    return *thisPtr->expr == *otherPtr->expr;
}


