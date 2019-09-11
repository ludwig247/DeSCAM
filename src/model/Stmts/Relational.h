//
// Created by ludwig on 03.11.16.
//

#ifndef SCAM_RELATIONAL_H
#define SCAM_RELATIONAL_H

#include "Expr.h"

namespace SCAM{
class Relational: public Expr {
public:
    Relational(Expr *lhs, std::string operation, Expr *rhs);

    //GETTER
    Expr * getRhs();
    Expr * getLhs();
    std::string getOperation();

    //ACCEPT
    virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const ;

private:
    Expr * lhs;
    Expr* rhs;
    std::string operation;
};
}


#endif //SCAM_RELATIONAL_H
