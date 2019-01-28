//
// Created by ludwig on 03.11.16.
//

#include "NBRead.h"
#include "VariableOperand.h"
#include "NodePeekVisitor.h"

SCAM::NBRead::NBRead(Port *port, VariableOperand *variable):
        variable(variable),
        Communication(port,true),
        Expr(DataTypes::getDataType("bool")){
    if(port->getDataType() != variable->getDataType()) throw std::runtime_error("Port and Variable are not of the same datatype");
}

SCAM::VariableOperand *SCAM::NBRead::getVariableOperand() const {
    return variable;
}

void SCAM::NBRead::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

    bool SCAM::NBRead::operator==(const Stmt &other) const {
        if (this == &other) return true;
        if (NodePeekVisitor::nodePeekNBRead(const_cast<Stmt*>(&other)) == nullptr) return false;
        auto thisPtr = (NBRead *) this;
        auto otherPtr = (const NBRead *) &other;
        return ((thisPtr->variable == otherPtr->variable) && (thisPtr->getPort() == otherPtr->getPort()));
    }
