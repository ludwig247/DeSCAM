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


namespace SCAM {

    class PrintStmt : public StmtAbstractVisitor {
    public:

        static std::string toString(Stmt *stmt, unsigned int indentSize=2, unsigned int indentOffset=0);
        static std::string toString(const Stmt *stmt, unsigned int indentSize=2, unsigned int indentOffset=0);

    protected:

        virtual void visit(VariableOperand &node);
        virtual void visit(IntegerValue &node);
        virtual void visit(UnsignedValue &node);
        virtual void visit(BoolValue &node);
        virtual void visit(CompoundValue &node);
        virtual void visit(Assignment &node);
        virtual void visit(EnumValue &node);
        virtual void visit(PortOperand &node);
        virtual void visit(UnaryExpr &node);
        virtual void visit(While &node);
        virtual void visit(If &node);
        virtual void visit(SectionOperand &node);
        virtual void visit(SectionValue &node);
        virtual void visit(ITE &node);
        virtual void visit(Arithmetic &node);
        virtual void visit(Logical &node);
        virtual void visit(Relational &node);
        virtual void visit(Bitwise &node);
        virtual void visit(Read &node);
        virtual void visit(Write &node);
        virtual void visit(NBRead &node);
        virtual void visit(NBWrite &node);
        virtual void visit(SyncSignal &node);
        virtual void visit(DataSignalOperand &node);
        virtual void visit(Cast &node) override;
        virtual void visit(FunctionOperand &node);
        virtual void visit(SubSelect &node);
        virtual void visit(CompoundExpr &node);
        virtual void visit(ParamOperand &node);
        virtual void visit(Return &node);

    protected:

        std::string createString(Stmt *stmt, unsigned int indentSize, unsigned int indentOffset);
        std::stringstream ss;
        unsigned int indent;
        unsigned int indentSize;
        bool useParenthesesFlag = true;
    };

}

#endif //SCAM_PRINTSTMT_H
