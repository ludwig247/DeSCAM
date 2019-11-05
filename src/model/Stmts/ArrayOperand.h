//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_SELECT_H
#define PROJECT_SELECT_H

#include <string>
#include "StmtAbstractVisitor.h"
#include "Operand.h"

namespace SCAM {
    class ArrayOperand : public Expr {
    public:
        ArrayOperand() = delete;

        ArrayOperand(Variable *arrayVar, Expr *idx);

        virtual ~ArrayOperand() = default;

        Variable *getArrayVar() const;

        Expr *getIdx() const;

        virtual bool operator==(const Stmt &other) const;

        virtual void accept(StmtAbstractVisitor &visitor);

    private:
        SCAM::Variable *arrayVar;
        SCAM::Expr *idx;
    };
}

#endif //PROJECT_SELECT_H
