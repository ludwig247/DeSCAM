//
// Created by ludwig on 02.11.16.
//
#include "Operand.h"

#include <utility>

DESCAM::Operand::Operand(const DataType *type, LocationInfo stmtLocationInfo) : Expr(type) {
this->stmtLocationInfo = std::move(stmtLocationInfo);
}
