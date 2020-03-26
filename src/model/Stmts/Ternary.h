//
// Created by tobias on 19.02.20.
//

#ifndef DESCAM_TERNARY_H
#define DESCAM_TERNARY_H


#include "Expr.h"

namespace SCAM {
    class Ternary : public Expr {
    public:
        Ternary() = delete;

        Ternary(Expr * condition, Expr *trueExpr, Expr *falseExpr);

        ~Ternary() = default;

        Expr *getCondition() const;

        Expr *getTrueExpr() const;

        Expr *getFalseExpr() const;

        void setTrivialTrue();
        void setTrivialFalse();


        void accept(StmtAbstractVisitor &visitor) override;

        bool operator==(const Stmt &other) const override;

    private:
        Expr *condition;
        Expr *trueExpr;
        Expr *falseExpr;

    };

}


#endif //DESCAM_TERNARY_H
