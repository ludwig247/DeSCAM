//
// Created by tobias on 19.02.20.
//

#ifndef DESCAM_COMPAREOPERATOR_H
#define DESCAM_COMPAREOPERATOR_H


#include "Expr.h"

namespace SCAM {
    class CompareOperator : public Expr {
    public:
        CompareOperator() = delete;

        CompareOperator(Expr *condition, Expr *trueExpr, Expr *falseExpr);

        ~CompareOperator() = default;

        Expr *getCondition() const;

        Expr *getTrueExpr() const;

        Expr *getFalseExpr() const;

        void accept(StmtAbstractVisitor &visitor) override;

        bool operator==(const Stmt &other) const override;

    private:
        Expr *condition;
        Expr *trueExpr;
        Expr *falseExpr;

    };

}


#endif //DESCAM_COMPAREOPERATOR_H
