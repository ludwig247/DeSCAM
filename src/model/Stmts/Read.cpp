//
// Created by ludwig on 02.11.16.
//

#include <assert.h>
#include <PrintStmt.h>
#include "Read.h"
#include "NodePeekVisitor.h"

SCAM::Read::Read(Port *port, SCAM::VariableOperand *variable) :
        variable(variable),
        Communication(port, false) {
    //Variable == null -> port.DataType is "void"
    assert(variable != nullptr || port->getDataType()->isVoid());
}


SCAM::VariableOperand *SCAM::Read::getVariableOperand() const {
    assert(variable != nullptr);
    return variable;
}

void SCAM::Read::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::Read::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekRead(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Read *) this;
    auto otherPtr = (const Read *) &other;
    if (thisPtr->getPort() != otherPtr->getPort()) return false;
    if (thisPtr->variable == otherPtr->variable) return true;
    return false;
}

std::ostream &SCAM::Read::print(std::ostream &ostream) const {
    ostream <<PrintStmt::toString(this);
    return ostream;
}

