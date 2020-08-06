//
// Created by tobias on 16.08.17.
//


#include "DataSignalOperand.h"
#include "Operand.h"

#include <utility>
#include "NodePeekVisitor.h"

DESCAM::DataSignalOperand::DataSignalOperand(DataSignal *dataSignal, LocationInfo stmtLocationInfo) :
        dataSignal(dataSignal), Operand(dataSignal->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);

}

void DESCAM::DataSignalOperand::accept(StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

DESCAM::DataSignal *DESCAM::DataSignalOperand::getDataSignal() const {
    return dataSignal;
}

std::string DESCAM::DataSignalOperand::getOperandName() const {
    return dataSignal->getName();
}

bool DESCAM::DataSignalOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekDataSignalOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (DataSignalOperand *) this;
    auto otherPtr = (const DataSignalOperand *) &other;
    return (thisPtr->dataSignal == otherPtr->dataSignal);
}

DESCAM::Port *DESCAM::DataSignalOperand::getPort() const {
    return this->dataSignal->getPort();
}
