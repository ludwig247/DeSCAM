//
// Created by tobias on 09.08.17.
//

#include <assert.h>
#include <sstream>
#include "CompoundValue.h"
#include "PrintStmt.h"
#include "NodePeekVisitor.h"

SCAM::CompoundValue::CompoundValue(const std::vector<ConstValue *> &values, const SCAM::DataType *dataType) : ConstValue(dataType) {
    assert(dataType != nullptr);
    if (!dataType->isCompoundType())throw std::runtime_error("Type " + dataType->getName() + "is not a compound type");
    auto subTypes = dataType->getSubVarMap();
    if (subTypes.size() != values.size()) throw std::runtime_error("Wrong number of values specified for compound value");
    int i = 0;
    for (auto subType : subTypes) {
        if (subType.second != values[i]->getDataType()) throw std::runtime_error("Wrong datatype for compound value");
        this->values.insert(std::make_pair(subType.first, values[i]));
        i++;
    }
}


std::string SCAM::CompoundValue::getValueAsString() const {
    return PrintStmt::toString(this);
}

void SCAM::CompoundValue::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

const std::map<std::string, SCAM::ConstValue *> &SCAM::CompoundValue::getValues() const {
    return values;
}

    bool SCAM::CompoundValue::operator==(const Stmt &other) const {
        if (this == &other) return true;
        if (NodePeekVisitor::nodePeekCompoundValue(const_cast<Stmt*>(&other)) == nullptr) return false;
        auto thisPtr = (CompoundValue *) this;
        auto otherPtr = (const CompoundValue *) &other;
        return ((thisPtr->getDataType() == otherPtr->getDataType()) && (thisPtr->values == otherPtr->values));
    }
