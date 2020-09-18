//
// Created by tobias on 19.07.18.
//

#include <NodePeekVisitor.h>
#include "ParamOperand.h"


DESCAM::ParamOperand::ParamOperand(DESCAM::Parameter *parameter, LocationInfo stmtLocationInfo) :
        parameter(parameter),
        Operand(parameter->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

void DESCAM::ParamOperand::accept(DESCAM::StmtAbstractVisitor &visitor) {
    visitor.visit(*this);


}

std::string DESCAM::ParamOperand::getOperandName() const {
    return this->parameter->getFullName();
}

DESCAM::Parameter *DESCAM::ParamOperand::getParameter() const {
    return parameter;
}

bool DESCAM::ParamOperand::operator==(const DESCAM::Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekParamOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (ParamOperand *) this;
    auto otherPtr = (const ParamOperand *) &other;
    return (thisPtr->parameter == otherPtr->parameter);
}
