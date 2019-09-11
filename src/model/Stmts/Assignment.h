//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_ASSIGNMENT_H
#define SCAM_ASSIGNMENT_H



#include "Stmt.h"

#include "StmtAbstractVisitor.h"
#include "Expr.h"


namespace SCAM{
/**
 * \brief Object, that represents an assignment
 *
 * Assignments can only be x = y with x either a member or a varDecl ...
 */
    class Assignment: public SCAM::Stmt {
    public:
        Assignment(Expr* lhs, Expr* rhs);
        Expr* getLhs();
        Expr* getRhs();

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual std::ostream &print(std::ostream &ostream) const;

        virtual bool operator==(const Stmt &other) const;

    private:
        Assignment() = default ;
        Expr* lhs;
        Expr* rhs;
    };
}


#endif //SCAM_ASSIGNMENT_H
