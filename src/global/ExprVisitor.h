//
// Created by tobias on 11.04.17.
//

#ifndef PROJECT_ISEXPRCONSTVISITOR_H
#define PROJECT_ISEXPRCONSTVISITOR_H


#include <set>

#include "StmtAbstractVisitor.h"
#include "PrintStmt.h"
#include "Stmts_all.h"

namespace  SCAM{

    class ExprVisitor: public  StmtAbstractVisitor {
    public:

        static bool isConstVal(SCAM::Expr * expr );
        static bool isBitwise(SCAM::Expr * expr );
        static bool isVar(SCAM::Expr * expr );
        static bool isParameter(SCAM::Expr * expr );

        static std::set<Operand *> getUsedOperands(SCAM::Expr * expr );
        static std::set<Variable *> getUsedVariables(SCAM::Expr * expr );
        static std::set<Port *> getUsedPorts(SCAM::Expr * expr );
        static std::set<SyncSignal *> getUsedSynchSignals(SCAM::Expr * expr );
        static std::set<DataSignal *> getUsedDataSignals(SCAM::Expr * expr );
        static Operand * getOperand(SCAM::Expr * expr );



    private:
        ExprVisitor(SCAM::Expr* expr);

        bool bitwise;
        bool constVal;
        bool var;
        bool parameter;
        SCAM::Expr * expr;
        std::set<Operand*> usedOperands;
        std::set<SyncSignal*> usedSynchSignal;
        std::set<DataSignal*> usedDataSignal;
        std::set<Variable*> usedVar;

        std::set<Port*> usedPorts;

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

        virtual void visit(struct NBRead &node);

        virtual void visit(struct NBWrite &node);

        virtual void visit(struct SyncSignal &node);

        virtual void visit(struct DataSignalOperand &node);

        virtual void visit(struct Cast &node);

        virtual void visit(SCAM::FunctionOperand &node);

        virtual void visit(class SubSelect &node);

        virtual void visit(class CompoundExpr &node);

        virtual void visit(Return &node);

        virtual void visit(ParamOperand &node);
    };
}




#endif //PROJECT_ISEXPRCONSTVISITOR_H
