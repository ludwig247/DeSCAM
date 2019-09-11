//
// Created by ludwig on 03.11.16.
//


#include "NBWrite.h"
#include "PrintStmt.h"
#include "NodePeekVisitor.h"

SCAM::NBWrite::NBWrite(Port *portOperand, Expr *value) :
        value(value),
        Communication(portOperand,true),
        Expr(DataTypes::getDataType("bool")){
    if(portOperand->getDataType() != value->getDataType()){
        throw std::runtime_error("Port "+portOperand->getName() + " and Value '" + PrintStmt::toString(value) + "' are not of the same datatype");
    }
}

SCAM::Expr *SCAM::NBWrite::getValue() const {
    return value;
}

void SCAM::NBWrite::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}
    bool SCAM::NBWrite::operator==(const Stmt &other) const {
        if (this == &other) return true;
        if (NodePeekVisitor::nodePeekNBWrite(const_cast<Stmt*>(&other)) == nullptr) return false;
        auto thisPtr = (NBWrite *) this;
        auto otherPtr = (const NBWrite *) &other;
        if (thisPtr->getPort() != otherPtr->getPort()) return false;
        if (thisPtr->value == otherPtr->value) return true;
        if (*thisPtr->value == *otherPtr->value) return true;
        return false;
}
