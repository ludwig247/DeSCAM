//
// Created by tobias on 06.11.15.
//

#ifndef SCAM_IF_H
#define SCAM_IF_H

#include "Branch.h"
#include "Expr.h"

namespace DESCAM {
    class If : public Branch {
    public:
        If(DESCAM::Expr *conditionStmt, LocationInfo stmtLocationInfo = LocationInfo());

        //GETTER
        bool hasElseStmt();

        DESCAM::Expr *getConditionStmt() const;

        //ACCEPT
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;


    protected:
        Expr *conditionStmt;
    };
}

#endif //SCAM_IF_H
