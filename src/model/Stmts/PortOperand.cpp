//
// Created by ludwig on 03.11.15.
//

#include "PortOperand.h"

#include <utility>
#include "NodePeekVisitor.h"

DESCAM::PortOperand::PortOperand(DESCAM::Port *port, LocationInfo stmtLocationInfo) : port(port), Operand(port->getDataType()) {
this->stmtLocationInfo = std::move(stmtLocationInfo);
}

DESCAM::Port *DESCAM::PortOperand::getPort() {
    return this->port;
}


void DESCAM::PortOperand::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string DESCAM::PortOperand::getOperandName() const {
    return this->port->getName();
}

bool DESCAM::PortOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekPortOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (PortOperand *) this;
    auto otherPtr = (const PortOperand *) &other;
    return (thisPtr->port == otherPtr->port);
}
