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
        VHDLPrintVisitor() = default;

        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    private:

    protected:
        bool useHexFlag = true;

        virtual std::string getString();

        void visit(DataSignalOperand &node) override;
        void visit(VariableOperand &node) override;
        void visit(Relational &node) override;
        void visit(SyncSignal &node) override;
        void visit(Arithmetic &node) override;
        void visit(Bitwise &node) override;
        void visit(IntegerValue &node) override;
        void visit(UnsignedValue &node) override;
        void visit(Cast &node) override;
        void visit(Assignment &node) override;
        void visit(UnaryExpr &node) override;
        void visit(CompoundExpr &node) override;
        void visit(FunctionOperand &node) override;
        void visit(Return &node) override;
        void visit(ArrayOperand &node) override ;
    };

}

#endif //SCAM_VHDLPRINTVISITOR_H
