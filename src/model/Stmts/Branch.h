//
// Created by tobias on 19.04.16.
//

#ifndef SCAM_BRANCH_H
#define SCAM_BRANCH_H

#include "Stmt.h"
#include "Expr.h"

namespace DESCAM {

    class Branch : public DESCAM::Stmt {
    public:
        virtual DESCAM::Expr *getConditionStmt() const = 0;
        virtual std::ostream &print(std::ostream &ostream) const;
    };

}


#endif //SCAM_BRANCH_H
