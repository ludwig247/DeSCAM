//
// Created by tobias on 11.04.17.
//

#ifndef PROJECT_ISEXPRCONSTVISITOR_H
#define PROJECT_ISEXPRCONSTVISITOR_H


#include <set>

#include "StmtAbstractVisitor.h"
#include "PrintStmt.h"
#include "Stmts_all.h"

namespace DESCAM {

    class ExprVisitor : public StmtAbstractVisitor {
    public:

        static bool isConstVal(DESCAM::Expr *expr);

        static bool isBitwise(DESCAM::Expr *expr);

        static bool isVar(DESCAM::Expr *expr);

        static bool isParameter(DESCAM::Expr *expr);

        static std::set<Operand *> getUsedOperands(DESCAM::Expr *expr);

        static std::set<Variable *> getUsedVariables(DESCAM::Expr *expr);

        static std::set<Port *> getUsedPorts(DESCAM::Expr *expr);

        static std::set<SyncSignal *> getUsedSynchSignals(DESCAM::Expr *expr);

        static std::set<Ternary*> getUsedTernaryOperators(DESCAM::Expr * expr);

        static std::set<DataSignal *> getUsedDataSignals(DESCAM::Expr *expr);

        static std::set<ArrayOperand *> getUsedArrayOperands(DESCAM::Expr *expr);

        static std::set<DESCAM::Function *> getUsedFunction(DESCAM::Expr *expr);

        static Operand *getOperand(DESCAM::Expr *expr);

        void visit(class ArrayExpr &node) override;

        static bool isTernary(Expr *expr);

    private:
        ExprVisitor(DESCAM::Expr *expr);

        bool bitwise;
        bool constVal;
        bool var;
        bool parameter;
        bool compare = false;
        DESCAM::Expr *expr;

        std::set<Operand *> usedOperands;
        std::set<SyncSignal *> usedSynchSignal;
        std::set<DataSignal *> usedDataSignal;
        std::set<Variable *> usedVar;
        std::set<Port *> usedPorts;
        std::set<ArrayOperand *> usedArrayOperands;
        std::set<Function *> usedFunction;
        CompoundValue *compoundValue;
        std::set<Ternary*> usedTernary;

        virtual void visit(struct VariableOperand &node);

        virtual void visit(struct IntegerValue &node);

        virtual void visit(struct UnsignedValue &node);

        virtual void visit(struct BoolValue &node);

        virtual void visit(struct EnumValue &node);

        virtual void visit(struct CompoundValue &node);

        virtual void visit(struct PortOperand &node);

        virtual void visit(struct Assignment &node);

        virtual void visit(struct UnaryExpr &node);

        virtual void visit(struct While &node);

        virtual void visit(struct If &node);

        virtual void visit(struct SectionOperand &node);

        virtual void visit(struct SectionValue &node);

        virtual void visit(struct ITE &node);

        virtual void visit(struct Branch &node);

        virtual void visit(struct Arithmetic &node);

        virtual void visit(struct Logical &node);

        virtual void visit(struct Relational &node);

        virtual void visit(struct Bitwise &node);

        virtual void visit(struct Read &node);

        virtual void visit(struct Write &node);

        virtual void visit(struct SyncSignal &node);

        virtual void visit(struct DataSignalOperand &node);

        virtual void visit(struct Cast &node);

        virtual void visit(DESCAM::FunctionOperand &node);

        virtual void visit(class ArrayOperand &node);

        virtual void visit(class CompoundExpr &node);

        virtual void visit(Return &node);

        virtual void visit(ParamOperand &node);

        virtual void visit(Notify &node);

        virtual void visit(Wait &node);

        virtual void visit(Peek &node);

        virtual void visit(struct TimePointOperand &node);

        virtual void visit(struct Ternary &node);

    };
}


#endif //PROJECT_ISEXPRCONSTVISITOR_H
