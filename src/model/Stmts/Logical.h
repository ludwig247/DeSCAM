//
// Created by ludwig on 03.11.16.
//

#ifndef SCAM_LOGICAL_H
#define SCAM_LOGICAL_H

#include "Expr.h"

namespace SCAM {

    class Logical : public Expr {
    public:
        Logical(Expr *lhs, std::string operation, Expr *rhs);

        //GETTER
        Expr *getRhs();

        Expr *getLhs();

        std::string getOperation() const;

        //ACCEPT
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        Expr *lhs;
        Expr *rhs;
        std::string operation;

    };
}
#endif //SCAM_LOGICAL_H
