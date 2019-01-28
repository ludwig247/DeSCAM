//
// Created by tobias on 24.10.16.
//

#include <assert.h>
#include "EnumValue.h"
#include "NodePeekVisitor.h"

SCAM::EnumValue::EnumValue(std::string enumValue,const DataType * enumType):
        enumValue(enumValue),
        ConstValue(enumType){
        assert(enumType != nullptr);
}

const std::string &SCAM::EnumValue::getEnumValue() const {
    return enumValue;
}

void SCAM::EnumValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string SCAM::EnumValue::getValueAsString() const {
    return this->enumValue;
}

    bool SCAM::EnumValue::operator==(const Stmt &other) const {
        if (this == &other) return true;
        if (NodePeekVisitor::nodePeekEnumValue(const_cast<Stmt*>(&other)) == nullptr) return false;
        auto thisPtr = (EnumValue *) this;
        auto otherPtr = (const EnumValue *) &other;
        return ((thisPtr->getDataType() == otherPtr->getDataType()) && (thisPtr->enumValue == otherPtr->enumValue));
    }


