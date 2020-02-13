//
// Created by johannes on 10.09.19.
//

#ifndef SCAM_VHDLPRINTVISITORHLS_H
#define SCAM_VHDLPRINTVISITORHLS_H

#include <PrintStmt.h>

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

    class PrintStatement : public PrintStmt {
    public:
        PrintStatement() = default;

        explicit PrintStatement(SCAM::Stmt *stmt, bool printAssumption, unsigned int indentSize = 2, unsigned int indentOffset = 0);
        static std::string toString(Stmt *stmt, bool printAssumption, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:
        bool useHexFlag = true;
        bool printAssumption = false;

        void visit(Arithmetic &node) override ;
        void visit(ArrayOperand &node) override ;
        void visit(Assignment &node) override;
        void visit(Bitwise &node) override;
        void visit(BoolValue &node) override ;
        void visit(Cast &node) override;
        void visit(CompoundExpr &node) override;
        void visit(DataSignalOperand &node) override ;
        void visit(FunctionOperand &node) override ;
        void visit(IntegerValue &node) override ;
        void visit(Relational &node) override ;
        void visit(Return &node) override;
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
