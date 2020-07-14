//
// Created by johannes on 31.03.20.
//

#ifndef DESCAM_PRINTFUNCTION_H
#define DESCAM_PRINTFUNCTION_H

#include <PrintStmt.h>

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

    class PrintFunction : public PrintStmt {
    public:
        PrintFunction() = default;

        explicit PrintFunction(SCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:
        bool useHexFlag = true;

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
        void visit(ParamOperand &node) override ;
        void visit(Relational &node) override ;
        void visit(Return &node) override;
        void visit(SyncSignal &node) override ;
        void visit(UnaryExpr &node) override;
        void visit(UnsignedValue &node) override ;
        void visit(VariableOperand &node) override ;

        virtual std::string getString();

    private:
        bool slice = false;
        bool arithmeticOp = false;
        unsigned int firstBit = 0;
        unsigned int lastBit = 0;

        void printBinaryVector(const unsigned int &value);
    };

}}}

#endif //DESCAM_PRINTFUNCTION_H
