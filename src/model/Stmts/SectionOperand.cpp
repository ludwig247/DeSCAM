//
// Created by ludwig on 20.11.15.
//

#include "SectionOperand.h"
#include "NodePeekVisitor.h"

SCAM::SectionOperand::SectionOperand(SCAM::Variable *sectionVariable) :
        sectionVariable(sectionVariable),
        Expr(sectionVariable->getDataType()) {

}

std::string SCAM::SectionOperand::getName() {
    return this->sectionVariable->getName();
}

void SCAM::SectionOperand::accept(StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool SCAM::SectionOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekSectionOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (SectionOperand *) this;
    auto otherPtr = (const SectionOperand *) &other;
    return (thisPtr->sectionVariable == otherPtr->sectionVariable);
}

SCAM::Variable *SCAM::SectionOperand::getSectionVariable() const {
    return sectionVariable;
}
