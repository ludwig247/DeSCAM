//
// Created by tobias on 06.11.15.
//

#ifndef SCAM_WHILE_H
#define SCAM_WHILE_H

#include "Branch.h"

namespace SCAM{
    class While: public Branch {
    public:
        While(SCAM::Expr * conditionStmt);
        //GETTER
        SCAM::Expr* getConditionStmt() const;
        //ACCEPT
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        SCAM::Expr * conditionStmt;
    };

}


#endif //SCAM_WHILE_H
