//
// Created by lucas on 16.01.20.
//

#include "TimePointOperand.h"

SCAM::TimePointOperand::TimePointOperand(Timepoint *timepoint) :
        timepoint(timepoint), Operand(timepoint->getDataType()) {

}

void SCAM::TimePointOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string SCAM::TimePointOperand::getOperandName() const {
    return this->timepoint->getName();
}

bool SCAM::TimePointOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekTimePointOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (TimePointOperand *) this;
    auto otherPtr = (const TimePointOperand *) &other;
    return (thisPtr->timepoint == otherPtr->timepoint);
}

SCAM::Timepoint *SCAM::TimePointOperand::getTimepoint() const {
    return timepoint;
}
