//
// Created by ludwig on 02.11.16.
//
#include "Operand.h"

#include <utility>

SCAM::Operand::Operand(const DataType *type, StmtLocationInfo stmtLocationInfo) : Expr(type) {
this->stmtLocationInfo = std::move(stmtLocationInfo);
}
