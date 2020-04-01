//
// Created by tobias on 31.03.20.
//

#ifndef DESCAM_RECURSIVEVISITOR_H
#define DESCAM_RECURSIVEVISITOR_H

#include "Stmts_all.h"

namespace SCAM{
    //! Visits a SCAM::Stmt recursively until all leaf nodes are reached. This class should be used a base for all recursive visitors
    class RecursiveVisitor: public StmtAbstractVisitor {
        RecursiveVisitor() = default;
        ~RecursiveVisitor() = default;

    public:
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

        virtual void visit(struct ArrayExpr &node) override;

        virtual void visit(struct SyncSignal &node);

        virtual void visit(struct DataSignalOperand &node);

        virtual void visit(struct Cast &node);

        virtual void visit(struct SCAM::FunctionOperand &node);

        virtual void visit(struct ArrayOperand &node);

        virtual void visit(struct CompoundExpr &node);

        virtual void visit(struct Return &node);

        virtual void visit(struct ParamOperand &node);

        virtual void visit(struct Notify &node);

        virtual void visit(struct Wait &node);

        virtual void visit(struct Peek &node);

        virtual void visit(struct TimePointOperand &node);

        virtual void visit(struct Ternary &node);
    };
}



#endif //DESCAM_RECURSIVEVISITOR_H
