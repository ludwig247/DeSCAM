//
// Created by ludwig on 20.11.15.
//

#include "SectionOperand.h"

#include <utility>
#include "NodePeekVisitor.h"

DESCAM::SectionOperand::SectionOperand(DESCAM::Variable *sectionVariable, LocationInfo stmtLocationInfo) :
        sectionVariable(sectionVariable),
        Expr(sectionVariable->getDataType()) {
    this->stmtLocationInfo = std::move(stmtLocationInfo);
}

std::string DESCAM::SectionOperand::getName() {
    return this->sectionVariable->getName();
}

void DESCAM::SectionOperand::accept(StmtAbstractVisitor &visitor) {
    visitor.visit(*this);
}

bool DESCAM::SectionOperand::operator==(const Stmt &other) const {
    if (this == &other) return true;
    if (NodePeekVisitor::nodePeekSectionOperand(const_cast<Stmt *>(&other)) == nullptr) return false;
    auto thisPtr = (SectionOperand *) this;
    auto otherPtr = (const SectionOperand *) &other;
    return (thisPtr->sectionVariable == otherPtr->sectionVariable);
}

DESCAM::Variable *DESCAM::SectionOperand::getSectionVariable() const {
    return sectionVariable;
}
