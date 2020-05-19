//
// Created by tobias on 23.10.15.
//

#include "VariableOperand.h"

#include <utility>
#include "NodePeekVisitor.h"

DESCAM::VariableOperand::VariableOperand(Variable *variable, LocationInfo stmtLocationInfo) :
        variable(variable), Operand(variable->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

DESCAM::Variable *DESCAM::VariableOperand::getVariable() {
    return this->variable;
}

void DESCAM::VariableOperand::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

std::string DESCAM::VariableOperand::getOperandName() const {
    return this->variable->getFullName();
}

bool DESCAM::VariableOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekVariableOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (VariableOperand *) this;
    auto otherPtr = (const VariableOperand *) &other;
    return (thisPtr->variable == otherPtr->variable);
}

