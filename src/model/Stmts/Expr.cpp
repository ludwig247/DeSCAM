//
// Created by ludwig on 02.11.16.
//

#include <PrintStmt.h>

#include <utility>
#include "Expr.h"
#include "DescamException.h"

DESCAM::Expr::Expr(const DESCAM::DataType *dataType, LocationInfo stmtLocationInfo) :
        dataType(dataType) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (dataType == nullptr) throw DESCAM::DescamException("DataType of EXPR is NULL",this->stmtLocationInfo);
}

const DESCAM::DataType *DESCAM::Expr::getDataType() const {
    return dataType;
}

bool DESCAM::Expr::isDataType(std::string n) const {
    return (dataType->getName() == n);
}

std::ostream &DESCAM::Expr::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}

