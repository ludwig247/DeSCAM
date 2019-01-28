//
// Created by ludwig on 12.10.16.
//

#ifndef SCAM_REPLACESTMT_H
#define SCAM_REPLACESTMT_H

#include <StmtAbstractVisitor.h>
#include <Stmt.h>
#include <Stmts/ParamOperand.h>
#include <Stmts/Return.h>

namespace SCAM {
    /*!
     * \brief: Replaces any Ast-Node with the given stmt
     *
     * \warning: NOT COMPLETELY IMPLEMENTED!
     */
    class ReplaceStmt: public StmtAbstractVisitor {



    public:
        ReplaceStmt(SCAM::Stmt *toReplace, SCAM::Stmt *replaceWith);

        Stmt *getNewStmt() const;

        virtual void visit(struct VariableOperand &node) override;
        virtual void visit(struct IntegerValue &node) override;
        virtual void visit(struct UnsignedValue &node) override;
        virtual void visit(struct BoolValue &node) override;
        virtual void visit(struct EnumValue &node) override;
        virtual void visit(struct CompoundValue &node) override;
        virtual void visit(class PortOperand &node) override;
        virtual void visit(class Assignment &node) override;
        virtual void visit(struct UnaryExpr &node) override;
        virtual void visit(struct While &node) override;
        virtual void visit(struct If &node) override;
        virtual void visit(struct SectionOperand &node) override;
        virtual void visit(class SectionValue &node) override;
        virtual void visit(struct ITE &node) override;
        virtual void visit(struct Arithmetic &node) override;
        virtual void visit(struct Logical &node) override;
        virtual void visit(struct Relational &node) override;
        virtual void visit(struct Bitwise &node) override;
        virtual void visit(struct Read &node) override;
        virtual void visit(struct Write &node) override;
        virtual void visit(struct NBRead &node) override;
        virtual void visit(struct NBWrite &node) override;
        virtual void visit(struct SyncSignal &node) override;
        virtual void visit(struct DataSignalOperand &node) override;
        virtual void visit(struct Cast &node) override;
        virtual void visit(struct FunctionOperand &node);
        virtual void visit(struct SubSelect &node);
        virtual void visit(struct CompoundExpr &node);
        virtual void visit(SCAM::ParamOperand &node);
        virtual void visit(SCAM::Return &node);


    private:
        SCAM::Stmt * toReplace;
        SCAM::Stmt * replaceWith;
        SCAM::Stmt * newStmt;

    };
}


#endif //SCAM_REPLACESTMT_H
