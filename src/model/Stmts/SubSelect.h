//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_SELECT_H
#define PROJECT_SELECT_H

#include <string>
#include "StmtAbstractVisitor.h"
#include "Operand.h"

namespace SCAM{
class SubSelect: public Expr {
public:
    SubSelect(Operand *operand, std::string sub);

    SCAM::Operand * getOperand() const;
    std::string getSub() const;

    virtual void accept(StmtAbstractVisitor &visitor);

    virtual bool operator==(const Stmt &other) const;

private:
    SCAM::Operand * operand;
    std::string sub;
};
}

#endif //PROJECT_SELECT_H
