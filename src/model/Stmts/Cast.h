//
// Created by ludwig on 22.03.18.
//

#ifndef PROJECT_CAST_H
#define PROJECT_CAST_H

#include "Expr.h"

namespace DESCAM {

    class Cast : public Expr {
    public:
        Cast(DESCAM::Expr *, const DataType *toDatatype, LocationInfo stmtLocationInfo = LocationInfo());

        virtual ~Cast();

        Expr *getSubExpr() const;

        virtual void accept(StmtAbstractVisitor &visitor) override;

        virtual bool operator==(const Stmt &other) const;

    private:
        Expr *expr;
    };
}

#endif //PROJECT_CAST_H
