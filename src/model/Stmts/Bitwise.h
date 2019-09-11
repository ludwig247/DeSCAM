//
// Created by ludwig on 23.06.17.
//

#ifndef PROJECT_BITWISE_H
#define PROJECT_BITWISE_H


#include "Expr.h"

namespace SCAM{
    class Bitwise: public Expr {
    public:
        Bitwise(Expr *lhs, std::string operation, Expr *rhs);

        //GETTER
        Expr * getRhs();
        Expr * getLhs();
        std::string getOperation();

        //ACCEPT
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        Expr * lhs;
        Expr* rhs;
        std::string operation;
    };
}


#endif //PROJECT_BITWISE_H
