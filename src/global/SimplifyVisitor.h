//
// Created by pmorku on 19.06.18.
//

#ifndef SCAM_SIMPLIFYVISITOR_H
#define SCAM_SIMPLIFYVISITOR_H

#include <Stmts/StmtAbstractVisitor.h>
#include "Stmts_all.h"

namespace SCAM {

    class SimplifyVisitor : public StmtAbstractVisitor {
    public:
        SimplifyVisitor(Stmt *node);

        Stmt *getSimplifiedNode() const;

        bool isNodeSimplified() const;
        
        static Stmt *simplifyNode(Stmt &node);

        static Expr *simplifyNode(Expr &node);

        static Branch *simplifyNode(Branch &node);

        static ConstValue *simplifyNode(ConstValue &node);

        static Operand *simplifyNode(Operand &node);

        static VariableOperand *simplifyNode(VariableOperand &node);

        static IntegerValue *simplifyNode(IntegerValue &node);

        static UnsignedValue *simplifyNode(UnsignedValue &node);

        static BoolValue *simplifyNode(BoolValue &node);

        static EnumValue *simplifyNode(EnumValue &node);

        static CompoundValue *simplifyNode(CompoundValue &node);

        static PortOperand *simplifyNode(PortOperand &node);

        static Expr *simplifyNode(UnaryExpr &node);

        static SectionOperand *simplifyNode(SectionOperand &node);

        static SectionValue *simplifyNode(SectionValue &node);

        static Expr *simplifyNode(Arithmetic &node);

        static Logical *simplifyNode(Logical &node);

        static Relational *simplifyNode(Relational &node);

        static Expr *simplifyNode(Bitwise &node);

        static NBRead *simplifyNode(NBRead &node);

        static NBWrite *simplifyNode(NBWrite &node);

        static SyncSignal *simplifyNode(SyncSignal &node);

        static DataSignalOperand *simplifyNode(DataSignalOperand &node);

        static Expr *simplifyNode(Cast &node);

        static Read *simplifyNode(Read &node);

        static Write *simplifyNode(Write &node);

        static ITE *simplifyNode(ITE &node);

        static Assignment *simplifyNode(Assignment &node);

        static While *simplifyNode(While &node);

        static If *simplifyNode(If &node);

        static FunctionOperand *simplifyNode(FunctionOperand &node);
        
    private:
        Stmt *nodePointer;
        bool nodeSimplified = false;

    protected:
        void visit(class VariableOperand &node) override;

        void visit(class IntegerValue &node) override;

        void visit(class UnsignedValue &node) override;

        void visit(class BoolValue &node) override;

        void visit(class EnumValue &node) override;

        void visit(class CompoundValue &node) override;

        void visit(class PortOperand &node) override;

        void visit(class Assignment &node) override;

        void visit(class UnaryExpr &node) override;

        void visit(class While &node) override;

        void visit(class If &node) override;

        void visit(class SectionOperand &node) override;

        void visit(class SectionValue &node) override;

        void visit(class ITE &node) override;

        void visit(class Arithmetic &node) override;

        void visit(class Logical &node) override;

        void visit(class Relational &node) override;

        void visit(class Bitwise &node) override;

        void visit(class Read &node) override;

        void visit(class Write &node) override;

        void visit(class NBRead &node) override;

        void visit(class NBWrite &node) override;

        void visit(class SyncSignal &node) override;

        void visit(class DataSignalOperand &node) override;

        void visit(class Cast &node) override;

        void visit(class FunctionOperand &node) override;

        void visit(class SubSelect &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ParamOperand &node) override;

        void visit(class Return &node) override;
    };
}


#endif //SCAM_SIMPLIFYVISITOR_H
