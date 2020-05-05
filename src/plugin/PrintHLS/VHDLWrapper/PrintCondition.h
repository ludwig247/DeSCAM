//
// Created by johannes on 10.09.19.
//

#ifndef SCAM_VHDLPRINTVISITORHLS_H
#define SCAM_VHDLPRINTVISITORHLS_H

#include <PrintStmt.h>

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

    class PrintCondition : public PrintStmt {
    public:
        PrintCondition() = default;

        explicit PrintCondition(SCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:
        bool useHexFlag = true;

        void visit(ArrayOperand &node) override ;
        void visit(Arithmetic &node) override ;
        void visit(Bitwise &node) override;
        void visit(BoolValue &node) override ;
        void visit(Cast &node) override;
        void visit(CompoundExpr &node) override;
        void visit(DataSignalOperand &node) override ;
        void visit(FunctionOperand &node) override ;
        void visit(IntegerValue &node) override ;
        void visit(Relational &node) override ;
        void visit(SyncSignal &node) override ;
        void visit(UnaryExpr &node) override;
        void visit(UnsignedValue &node) override ;
        void visit(VariableOperand &node) override ;

        virtual std::string getString();

    private:
        bool arithmeticOp = false;
        bool slice = false;
        unsigned int firstBit = 0;
        unsigned int lastBit = 0;

        void printBinaryVector(const unsigned int &value);
    };

}}}

#endif //SCAM_VHDLPRINTVISITORHLS_H
