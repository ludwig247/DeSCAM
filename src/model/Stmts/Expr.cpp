//
// Created by ludwig on 02.11.16.
//

#include <PrintStmt.h>
#include "Expr.h"

SCAM::Expr::Expr(const SCAM ::DataType *dataType):
    dataType(dataType){
    if(dataType == nullptr) throw std::runtime_error("DataType of EXPR is NULL");
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
