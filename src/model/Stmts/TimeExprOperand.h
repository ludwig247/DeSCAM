//
// Created by lucas on 16.01.20.
//

#ifndef DESCAM_TIMEEXPROPERAND_H
#define DESCAM_TIMEEXPROPERAND_H

#include "NodePeekVisitor.h"
#include "Operand.h"
#include "TimeExpr.h"

namespace SCAM {
    /**
     * \brief Points to a TimeExpr
     *
     */
    class TimeExprOperand : public Operand {
    public:
        explicit TimeExprOperand(TimeExpr *timeExpr);

        TimeExpr *getTimeExpr();

        virtual void accept(StmtAbstractVisitor &visitor);

        std::string getOperandName() const;

        virtual bool operator==(const Stmt &other) const;

    private:
        TimeExpr *timeExpr;
    };


}
#endif //DESCAM_TIMEEXPROPERAND_H
