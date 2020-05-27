//
// Created by tobias on 23.10.15.
//

#include "IntegerValue.h"
#include <utility>
#include <DescamException.h>
#include "NodePeekVisitor.h"

DESCAM::IntegerValue::IntegerValue(int value, LocationInfo locationInfo) :
        value(value),
        ConstValue(DataTypes::getDataType("int")) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if(!(value >= -2147483648) || !(value <= 2147483647)) throw DescamException("Integer value is only allowed to be 32bit",locationInfo);

}

int DESCAM::IntegerValue::getValue() {
    return this->value;
}

void DESCAM::IntegerValue::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string DESCAM::IntegerValue::getValueAsString() const {
    return std::to_string(value);
}

bool DESCAM::IntegerValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekIntegerValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (IntegerValue *) this;
    auto otherPtr = (const IntegerValue *) &other;
    if (thisPtr->value == otherPtr->value) return true;
    return false;
}
