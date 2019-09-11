//
// Created by ludwig on 05.11.15.
//

#ifndef SCAM_UNARYOPERATOR_H
#define SCAM_UNARYOPERATOR_H

#include "Stmt.h"
#include "Expr.h"
#include <string>

namespace SCAM{
    class UnaryExpr: public SCAM::Expr {
    public:
        UnaryExpr(std::string operation, Expr * stmt);
        //GETTER
        Expr* getExpr();
        std::string getOperation();

        //ACCEPT
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        Expr* expr; //! Contains the stmt the operation is performed on.
        std::string operation;


    };
}



#endif //SCAM_UNARYOPERATOR_H
