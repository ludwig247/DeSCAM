//
// Created by tobias on 23.10.15.
//

#include "VariableOperand.h"
#include "NodePeekVisitor.h"

SCAM::VariableOperand::VariableOperand(Variable *variable) :
        variable(variable), Operand(variable->getDataType()) {

}

SCAM::Variable *SCAM::VariableOperand::getVariable() {
    return this->variable;
}

void SCAM::VariableOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string SCAM::VariableOperand::getOperandName() const {
    return this->variable->getFullName();
}

bool SCAM::VariableOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekVariableOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (VariableOperand *) this;
    auto otherPtr = (const VariableOperand *) &other;
    return (thisPtr->variable == otherPtr->variable);
}

