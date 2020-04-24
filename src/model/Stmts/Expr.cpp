//
// Created by ludwig on 02.11.16.
//

#include <PrintStmt.h>

#include <utility>
#include "Expr.h"
#include "StmtException.h"

SCAM::Expr::Expr(const SCAM::DataType *dataType, StmtLocationInfo stmtLocationInfo) :
        dataType(dataType) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if (dataType == nullptr) throw SCAM::StmtException("DataType of EXPR is NULL",this->stmtLocationInfo);
}

const SCAM::DataType *SCAM::Expr::getDataType() const {
    return dataType;
}

bool SCAM::Expr::isDataType(std::string n) const {
    return (dataType->getName() == n);
}

std::ostream &SCAM::Expr::print(std::ostream &ostream) const {
    ostream << PrintStmt::toString(this);
    return ostream;
}

