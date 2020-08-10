//
// Created by lucas on 16.01.20.
//

#include "TimePointOperand.h"

DESCAM::TimePointOperand::TimePointOperand(Timepoint *timepoint, LocationInfo stmtLocationInfo) :
        timepoint(timepoint), Operand(timepoint->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);

}

void DESCAM::TimePointOperand::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string DESCAM::TimePointOperand::getOperandName() const {
    return this->timepoint->getName();
}

bool DESCAM::TimePointOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekTimePointOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (TimePointOperand *) this;
    auto otherPtr = (const TimePointOperand *) &other;
    return (thisPtr->timepoint == otherPtr->timepoint);
}

DESCAM::Timepoint *DESCAM::TimePointOperand::getTimepoint() const {
    return timepoint;
}
