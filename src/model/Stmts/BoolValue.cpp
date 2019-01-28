//
// Created by tobias on 06.11.15.
//

#include "BoolValue.h"
#include "NodePeekVisitor.h"

SCAM::BoolValue::BoolValue(bool value) :
        value(value),
        ConstValue(DataTypes::getDataType("bool")) {
}


bool SCAM::BoolValue::getValue() {
    return this->value;
}

void SCAM::BoolValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string SCAM::BoolValue::getValueAsString() const {
    if (value) return "true";
    return "false";
}

bool SCAM::BoolValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekBoolValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (BoolValue *) this;
    auto otherPtr = (const BoolValue *) &other;
    return (thisPtr->value == otherPtr->value);
}
