//
// Created by ludwig on 31.08.16.
//

#ifndef SCAM_VHDLPRINTVISITOR_H
#define SCAM_VHDLPRINTVISITOR_H

#include <PrintStmt.h>

namespace SCAM {

    class VHDLPrintVisitor : public PrintStmt {
    public:
        VHDLPrintVisitor(SCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        std::string getString();

    private:
        bool useHexFlag = true;

    protected:
        virtual void visit(class DataSignalOperand &node);

        virtual void visit(class VariableOperand &node);

        virtual void visit(class Relational &node);

        virtual void visit(class SyncSignal &node);

        virtual void visit(class Arithmetic &node);

        virtual void visit(class Bitwise &node);

        virtual void visit(class IntegerValue &node);

        virtual void visit(class UnsignedValue &node);

        virtual void visit(class Cast &node);

        virtual void visit(class Assignment &node);

        virtual void visit(class UnaryExpr &node);

        virtual void visit(class CompoundExpr &node);

        virtual void visit(class FunctionOperand &node);

        virtual void visit(class Return &node);

    };

}

#endif //SCAM_VHDLPRINTVISITOR_H
