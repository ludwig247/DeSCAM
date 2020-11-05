//
// Created by joakim on 11/9/16.
//

// Modification is only done to enable indentation of the printout


#ifndef SCAM_PRINTSTMT_H
#define SCAM_PRINTSTMT_H

#include <sstream>
#include <string>

#include "StmtAbstractVisitor.h"
#include "Stmts_all.h"


namespace DESCAM {

    class PrintStmt : public StmtAbstractVisitor {
    public:

        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        static std::string toString(const Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:

        void visit(VariableOperand &node) override;

        void visit(IntegerValue &node) override;

        void visit(UnsignedValue &node) override;

        void visit(BoolValue &node) override;

        void visit(CompoundValue &node) override;

        void visit(Assignment &node) override;

        void visit(EnumValue &node) override;

        void visit(PortOperand &node) override;

        void visit(UnaryExpr &node) override;

        void visit(While &node) override;

        void visit(If &node) override;

        void visit(SectionOperand &node) override;

        void visit(SectionValue &node) override;

        void visit(ITE &node) override;

        void visit(Arithmetic &node) override;

        void visit(Logical &node) override;

        void visit(Relational &node) override;

        void visit(Bitwise &node) override;

        void visit(Read &node) override;

        void visit(Write &node) override;

        void visit(SyncSignal &node) override;

        void visit(DataSignalOperand &node) override;

        void visit(Cast &node) override;

        void visit(FunctionOperand &node) override;

        void visit(ArrayOperand &node) override;

        void visit(CompoundExpr &node) override;

        void visit(ParamOperand &node) override;

        void visit(Return &node) override;

        void visit(Notify &node) override;

        void visit(Wait &node) override;

        void visit(Peek &node) override;

        void visit(ArrayExpr &node) override;

        void visit(TimePointOperand &node) override;

        void visit(Ternary &node) override;

    protected:

        std::string createString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset);

        std::stringstream ss;
        unsigned int indent;
        unsigned int indentSize;
        bool useParenthesesFlag = true;
    };

}

#endif //SCAM_PRINTSTMT_H
