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

        ArrayOperand(Variable *arrayVar, Expr *idx, LocationInfo stmtLocationInfo = LocationInfo());
        ArrayOperand(Operand * operand, Expr *idx, LocationInfo stmtLocationInfo = LocationInfo());


        virtual ~ArrayOperand() = default;

        Operand * getArrayOperand() const;


        Expr *getIdx() const;

        virtual bool operator==(const Stmt &other) const;

        virtual void accept(StmtAbstractVisitor &visitor);

    private:
        SCAM::Variable *arrayVar;
        Operand * operand;

        SCAM::Expr *idx;
    };
}

#endif //PROJECT_SELECT_H
