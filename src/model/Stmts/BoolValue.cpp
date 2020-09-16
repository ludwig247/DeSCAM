//
// Created by tobias on 06.11.15.
//

#include "BoolValue.h"
#include "NodePeekVisitor.h"

DESCAM::BoolValue::BoolValue(bool value, LocationInfo stmtLocationInfo) :
        value(value),
        ConstValue(DataTypes::getDataType("bool")) {
    this->stmtLocationInfo = stmtLocationInfo;
}


bool DESCAM::BoolValue::getValue() {
    return this->value;
}

void DESCAM::BoolValue::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string DESCAM::BoolValue::getValueAsString() const {
    if (value) return "true";
    return "false";
}

bool DESCAM::BoolValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekBoolValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (BoolValue *) this;
    auto otherPtr = (const BoolValue *) &other;
    return (thisPtr->value == otherPtr->value);
}
