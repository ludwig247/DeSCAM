//
// Created by ludwig on 23.11.15.
//

#include "SectionValue.h"
#include "NodePeekVisitor.h"

DESCAM::SectionValue::SectionValue(std::string value, const DataType *type, LocationInfo stmtLocationInfo) :
        value(value),
        ConstValue(type) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

std::string DESCAM::SectionValue::getValue() {
    return this->value;
}

void DESCAM::SectionValue::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string DESCAM::SectionValue::getValueAsString() const {
    return this->value;
}

DESCAM::SectionValue::SectionValue(const DESCAM::ConstValue *constValue, LocationInfo stmtLocationInfo) :
        value(constValue->getValueAsString()),
        ConstValue(constValue->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

bool DESCAM::SectionValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekSectionValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (SectionValue *) this;
    auto otherPtr = (const SectionValue *) &other;
    return ((thisPtr->getDataType() == otherPtr->getDataType()) && (thisPtr->value == otherPtr->value));
}
