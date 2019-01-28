//
// Created by tobias on 19.07.18.
//

#include <NodePeekVisitor.h>
#include "ParamOperand.h"


SCAM::ParamOperand::ParamOperand(SCAM::Parameter *parameter):
    parameter(parameter),
    Operand(parameter->getDataType()){


}

void SCAM::ParamOperand::accept(SCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);


}

std::string SCAM::ParamOperand::getOperandName() const {
    return this->parameter->getName();
}

SCAM::Parameter *SCAM::ParamOperand::getParameter() const {
    return parameter;
}

bool SCAM::ParamOperand::operator==(const SCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekParamOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (ParamOperand *) this;
    auto otherPtr = (const ParamOperand *) &other;
    return (thisPtr->parameter == otherPtr->parameter);
}
