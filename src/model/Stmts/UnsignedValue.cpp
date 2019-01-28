//
// Created by ludwig on 19.01.18.
//

#include "UnsignedValue.h"
#include "NodePeekVisitor.h"

SCAM::UnsignedValue::UnsignedValue(unsigned int value) :
        value(value),
        ConstValue(DataTypes::getDataType("unsigned")) {
    assert(value >= 0 && "Unsigned value only allowed for value >= 0");
    assert(value <= (4294967295) && "Unsigned value only allowed for value <= 2^32-1");
}

unsigned int SCAM::UnsignedValue::getValue() {
    return value;
}

std::string SCAM::UnsignedValue::getValueAsString() const {
    return std::to_string(value);
}

void SCAM::UnsignedValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::UnsignedValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekUnsignedValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (UnsignedValue *) this;
    auto otherPtr = (const UnsignedValue *) &other;
    if (thisPtr->value == otherPtr->value) return true;
    return false;
}
