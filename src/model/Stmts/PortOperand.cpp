//
// Created by ludwig on 03.11.15.
//

#include "PortOperand.h"
#include "NodePeekVisitor.h"

SCAM::PortOperand::PortOperand(SCAM::Port *port) : port(port), Operand(port->getDataType()) {

}

SCAM::Port *SCAM::PortOperand::getPort() {
    return this->port;
}


void SCAM::PortOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string SCAM::PortOperand::getOperandName() const {
    return this->port->getName();
}

bool SCAM::PortOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekPortOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (PortOperand *) this;
    auto otherPtr = (const PortOperand *) &other;
    return (thisPtr->port == otherPtr->port);
}
