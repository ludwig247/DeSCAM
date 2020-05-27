//
// Created by tobias on 09.08.17.
//

#include <assert.h>
#include <sstream>
#include "CompoundValue.h"
#include "PrintStmt.h"
#include "NodePeekVisitor.h"
#include "DescamException.h"

DESCAM::CompoundValue::CompoundValue(const std::vector<ConstValue *> &values, const DESCAM::DataType *dataType, LocationInfo stmtLocationInfo) : ConstValue(dataType) {
    this->stmtLocationInfo = stmtLocationInfo;
    assert(dataType != nullptr);
    if (!dataType->isCompoundType() && !dataType->isArrayType())throw DESCAM::DescamException("Type " + dataType->getName() + "is not a compound type",this->stmtLocationInfo);
    auto subTypes = dataType->getSubVarMap();
    if (subTypes.size() != values.size()) throw DESCAM::DescamException("Wrong number of values specified for compound value",this->stmtLocationInfo);
    int i = 0;
    for (auto subType : subTypes) {
        if (subType.second != values[i]->getDataType()) throw DESCAM::DescamException("Wrong datatype for compound value",this->stmtLocationInfo);
        this->values.insert(std::make_pair(subType.first, values[i]));
        i++;
    }
}


std::string DESCAM::CompoundValue::getValueAsString() const {
    return PrintStmt::toString(this);
}

void DESCAM::CompoundValue::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

const std::map<std::string, DESCAM::ConstValue *> &DESCAM::CompoundValue::getValues() const {
    return values;
}

bool DESCAM::CompoundValue::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekCompoundValue(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (CompoundValue *) this;
    auto otherPtr = (const CompoundValue *) &other;
    return ((thisPtr->getDataType() == otherPtr->getDataType()) && (thisPtr->values == otherPtr->values));
}
