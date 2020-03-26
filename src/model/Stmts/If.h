//
// Created by tobias on 06.11.15.
//

#ifndef SCAM_IF_H
#define SCAM_IF_H

#include "Branch.h"
#include "Expr.h"

namespace SCAM {
    class If : public Branch {
    public:
        explicit If(SCAM::Expr * conditionStmt);

        //GETTER
        bool hasElseStmt();

        SCAM::Expr * getConditionStmt() const override;

        //ACCEPT
        void accept(StmtAbstractVisitor &visitor) override;
        virtual bool operator==(const Stmt &other) const override ;

    protected:
        Expr *conditionStmt;
    };
}

#endif //SCAM_IF_H
