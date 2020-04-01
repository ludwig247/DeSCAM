//
// Created by tobias on 16.08.17.
//


#include "DataSignalOperand.h"
#include "Operand.h"

#include <utility>
#include "NodePeekVisitor.h"

SCAM::DataSignalOperand::DataSignalOperand(DataSignal *dataSignal, StmtLocationInfo stmtLocationInfo) :
        dataSignal(dataSignal), Operand(dataSignal->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);

}

void SCAM::DataSignalOperand::accept(StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

SCAM::DataSignal *SCAM::DataSignalOperand::getDataSignal() const {
    return dataSignal;
}

std::string SCAM::DataSignalOperand::getOperandName() const {
    return dataSignal->getName();
}

bool SCAM::DataSignalOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekDataSignalOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (DataSignalOperand *) this;
    auto otherPtr = (const DataSignalOperand *) &other;
    return (thisPtr->dataSignal == otherPtr->dataSignal);
}

SCAM::Port *SCAM::DataSignalOperand::getPort() const {
    return this->dataSignal->getPort();
}
