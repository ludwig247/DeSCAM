//
// Created by lucas on 16.01.20.
//

#ifndef DESCAM_TEMPORALEXPR_H
#define DESCAM_TEMPORALEXPR_H

#include <vector>
#include <Stmt.h>
#include <TimeExpr.h>

namespace SCAM {

    enum TemporalExprType{AT, DURING};

    class TemporalExpr {

    public:

        TemporalExpr(Expr * timeExpr, Stmt *statement);

        TemporalExpr(Expr * timeExpr1, Expr * timeExpr2, Stmt *statement);

        TemporalExprType getType() const;

        void setType(TemporalExprType type);

        Stmt *getStatement() const;

        void setStatement(Stmt *statement);

        const std::vector<Expr *> &getTiming() const;

        void setTiming(Expr *timeExpr);

        void setTiming(Expr *timeExpr1, Expr *timeExpr2);

        bool isAt();

        bool isDuring();

    private:

        TemporalExprType type;

        std::vector<Expr*> timeExprs;

        Stmt * statement;

    };

}

#endif //DESCAM_TEMPORALEXPR_H
