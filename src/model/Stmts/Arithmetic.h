//
// Created by tobias on 20.05.16.
//

#ifndef SCAM_ARITHMETIC_H
#define SCAM_ARITHMETIC_H

#include "Stmt.h"
#include "Expr.h"
#include <string>

namespace SCAM{

class Arithmetic: public Expr {
public:
    Arithmetic(Expr * lhs, std::string operation, Expr* rhs);

    //GETTER
    Expr * getRhs() const;
    Expr * getLhs() const;
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

#endif //SCAM_ARITHMETIC_H
