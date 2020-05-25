//
// Created by tobias on 24.10.16.
//

#include "EnumValue.h"
#include "NodePeekVisitor.h"
#include "DescamException.h"

DESCAM::EnumValue::EnumValue(std::string enumValue, const DataType *enumType, LocationInfo locationInfo) :
        enumValue(enumValue),
        ConstValue(enumType) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
    if(!enumType) throw DescamException("enumType is null",locationInfo);
}

const std::string &DESCAM::EnumValue::getEnumValue() const {
    return enumValue;
}

void DESCAM::EnumValue::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string DESCAM::EnumValue::getValueAsString() const {
    return this->enumValue;
}

bool DESCAM::EnumValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekEnumValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (EnumValue *) this;
    auto otherPtr = (const EnumValue *) &other;
    return ((thisPtr->getDataType() == otherPtr->getDataType()) && (thisPtr->enumValue == otherPtr->enumValue));
}


