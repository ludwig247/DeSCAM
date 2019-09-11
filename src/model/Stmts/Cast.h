//
// Created by ludwig on 22.03.18.
//

#ifndef PROJECT_CAST_H
#define PROJECT_CAST_H

#include "Expr.h"

namespace SCAM{

class Cast: public Expr{
public:
    Cast(SCAM::Expr *, const DataType * toDatatype);
    virtual ~Cast();
    Expr *getSubExpr() const;

        virtual void accept(StmtAbstractVisitor &visitor) override;

        virtual bool operator==(const Stmt &other) const;

private:
    Expr * expr;
};
}

#endif //PROJECT_CAST_H
