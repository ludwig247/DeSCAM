//
// Created by M.I.Alkoudsi on 7.7.19.
//

#ifndef SCAM_VALUESUBSTITUTION_H
#define SCAM_VALUESUBSTITUTION_H


#include "Expr.h"
#include "Stmt.h"
#include "Behavior/CfgNode.h"
#include <StmtAbstractVisitor.h>
#include <set>
#include <map>

namespace SCAM {

    class ValueSubstitution : public StmtAbstractVisitor {

    public:
        ValueSubstitution();

        /***
        * \brief: Substitutes a variable inside an expression with another expression
        *
        * \author: mi-alkoudsi
        *
        * \input:
        *      - SCAM::Expr *oldExpr;
        *      - std::string *varName;
        *      - SCAM::Expr *varVal;
        * \output:
        *      - SCAM::Expr *newExpr;
        */
        SCAM::Expr *substituteExpr(SCAM::Expr *oldExpr, std::string varName, SCAM::Expr *varVal);

        /***
        * \brief: Substitutes a variable inside a statement with another expression
        *
        * \author: mi-alkoudsi
        *
        * \input:
        *      - SCAM::Stmt *oldStmt;
        *      - std::string *varName;
        *      - SCAM::Expr *varVal;
        * \output:
        *      - SCAM::Stmt *newStmt;
        */
        SCAM::Stmt *substituteStmt(SCAM::Stmt *oldStmt, std::string varName, SCAM::Expr *varVal);


    private:
        std::string varName;
        SCAM::Expr *oldExpr;
        SCAM::Expr *varVal;
        SCAM::Expr *newExpr;
        SCAM::Stmt *oldStmt;
        SCAM::Stmt *newStmt;

        //visitors
        void visit(struct VariableOperand &node) override;

        void visit(struct IntegerValue &node) override {};

        void visit(struct UnsignedValue &node) override {};

        void visit(struct BoolValue &node) override {};

        void visit(struct EnumValue &node) override {};

        void visit(struct CompoundValue &node) override {};

        void visit(class PortOperand &node) override {};

        void visit(class Assignment &node) override;

        void visit(struct UnaryExpr &node) override;

        void visit(struct While &node) override;

        void visit(struct If &node) override;

        void visit(struct Read &node) override {};

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

        void visit(class TimePointOperand &node) override {};
    };
}
#endif //SCAM_VALUESUBSTITUTION_H
