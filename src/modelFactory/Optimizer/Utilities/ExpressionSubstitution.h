//
// Created by M.I.Alkoudsi on 11.09.19.
//

#ifndef SCAM_EXPRESSSIONSUBSTITUTION_H
#define SCAM_EXPRESSSIONSUBSTITUTION_H


#include <set>
#include <map>
#include <StmtAbstractVisitor.h>
#include "ExprVisitor.h"
#include "Behavior/CfgNode.h"

namespace SCAM {

    class ExpressionSubstitution : public StmtAbstractVisitor {

    public:
        /***
        * \brief: Substitutes an expression inside a statement with another expression
        *
        * \author: mi-alkoudsi
        *
        * \input:
        *      - SCAM::Stmt *stmt;
        *      - SCAM::Expr *oldExpr;
        *      - SCAM::Expr *newExpr;
        * \output:
        *      - SCAM::Stmt *newStmt;
        */
        ExpressionSubstitution(SCAM::Stmt *stmt, SCAM::Expr *oldExpr, SCAM::Expr *newExpr);

        /***
        * \brief: Substitutes an expression inside an expression with another expression
        *
        * \author: mi-alkoudsi
        *
        * \input:
        *      - SCAM::Expr *Expr;
        *      - SCAM::Expr *oldExpr;
        *      - SCAM::Expr *newExpr;
        * \output:
        *      - SCAM::Expr *modifiedExpr;
        */
        ExpressionSubstitution(SCAM::Expr *expr, SCAM::Expr *oldExpr, SCAM::Expr *newExpr);

        SCAM::Stmt *getNewStmt() const;

        SCAM::Stmt *getModifiedExpr() const;

        static SCAM::Stmt *substituteExpr(SCAM::Stmt *stmt, SCAM::Expr *oldExpr, SCAM::Expr *newExpr);

        static SCAM::Expr *substituteExpr(SCAM::Expr *expr, SCAM::Expr *oldExpr, SCAM::Expr *newExpr);


    private:
        SCAM::Expr *oldExpr;
        SCAM::Expr *newExpr;
        SCAM::Stmt *newStmt;
        SCAM::Stmt *oldStmt;
        SCAM::Expr *propagatedExpr;

        //visitors
        void visit(struct VariableOperand &node) override;

        void visit(struct IntegerValue &node) override;

        void visit(struct UnsignedValue &node) override;

        void visit(struct BoolValue &node) override;

        void visit(struct EnumValue &node) override;

        void visit(struct CompoundValue &node) override;

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override;

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override {};

        void visit(struct If &node) override;

        void visit(struct Read &node) override;

        void visit(struct Write &node) override;

        void visit(struct SectionOperand &node) override {};

        void visit(class SectionValue &node) override {};

        void visit(struct ITE &node) override {};

        void visit(struct Arithmetic &node) override;

        void visit(struct Logical &node) override;

        void visit(struct Relational &node) override;

        void visit(struct Bitwise &node) override;

        void visit(struct SyncSignal &node) override {};

        void visit(struct DataSignalOperand &node) override {};

        void visit(struct Cast &node) override;

        void visit(struct SCAM::FunctionOperand &node) override;

        void visit(struct ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ArrayExpr &node) override;

        void visit(class ParamOperand &node) override;

        void visit(class Return &node) override;

        void visit(class Notify &node) override {};

        void visit(class Wait &node) override {};

        void visit(class Peek &node) override {};

    };

}
#endif //SCAM_VALUESUBSTITUTION_H