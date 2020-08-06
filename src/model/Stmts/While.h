//
// Created by tobias on 06.11.15.
//

#ifndef SCAM_WHILE_H
#define SCAM_WHILE_H

#include "Branch.h"

namespace DESCAM {
    class While : public Branch {
    public:
        While(DESCAM::Expr *conditionStmt, LocationInfo stmtLocationInfo = LocationInfo());

        //GETTER
        DESCAM::Expr *getConditionStmt() const;

        //ACCEPT
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        DESCAM::Expr *conditionStmt;
    };

}


#endif //SCAM_WHILE_H
