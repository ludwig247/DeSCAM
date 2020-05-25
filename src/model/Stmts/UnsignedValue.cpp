//
// Created by ludwig on 19.01.18.
//

#include "UnsignedValue.h"
#include "DescamException.h"
#include <utility>
#include "NodePeekVisitor.h"

DESCAM::UnsignedValue::UnsignedValue(unsigned int value, LocationInfo locationInfo) :
        value(value),
        ConstValue(DataTypes::getDataType("unsigned")) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if(!(value >= 0))  throw DescamException("Unsigned value only allowed for value >= 0",locationInfo);
    if(!(value <= (4294967295)))  throw DescamException("Unsigned value only allowed for value <= 2^32-1",locationInfo);
}

unsigned int DESCAM::UnsignedValue::getValue() {
    return value;
}

std::string DESCAM::UnsignedValue::getValueAsString() const {
    return std::to_string(value);
}

void DESCAM::UnsignedValue::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::UnsignedValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekUnsignedValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (UnsignedValue *) this;
    auto otherPtr = (const UnsignedValue *) &other;
    if (thisPtr->value == otherPtr->value) return true;
    return false;
}
