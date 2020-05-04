//
// Created by ludwig on 23.11.15.
//

#include "SectionValue.h"
#include "NodePeekVisitor.h"

SCAM::SectionValue::SectionValue(std::string value, const DataType *type, LocationInfo stmtLocationInfo) :
        value(value),
        ConstValue(type) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

std::string SCAM::SectionValue::getValue() {
    return this->value;
}

void SCAM::SectionValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string SCAM::SectionValue::getValueAsString() const {
    return this->value;
}

SCAM::SectionValue::SectionValue(const SCAM::ConstValue *constValue, LocationInfo stmtLocationInfo) :
        value(constValue->getValueAsString()),
        ConstValue(constValue->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

bool SCAM::SectionValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekSectionValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (SectionValue *) this;
    auto otherPtr = (const SectionValue *) &other;
    return ((thisPtr->getDataType() == otherPtr->getDataType()) && (thisPtr->value == otherPtr->value));
}
