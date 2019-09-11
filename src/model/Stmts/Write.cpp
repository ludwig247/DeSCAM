//
// Created by ludwig on 02.11.16.
//

#include <PrintStmt.h>
#include "Write.h"
#include "NodePeekVisitor.h"

SCAM::Write::Write(Port *portOperand, SCAM::Expr *value) :
        value(value),
        Communication(portOperand, false) {

}

SCAM::Expr *SCAM::Write::getValue() const {
    return value;
}

void SCAM::Write::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

bool SCAM::Write::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekWrite(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (Write *) this;
    auto otherPtr = (const Write *) &other;
    if (thisPtr->getPort() != otherPtr->getPort()) return false;
    if (thisPtr->value == otherPtr->value) return true;
    if (*thisPtr->value == *otherPtr->value) return true;
    return false;
}

std::ostream &SCAM::Write::print(std::ostream &ostream) const {
    ostream <<PrintStmt::toString(this);
    return ostream;
}
