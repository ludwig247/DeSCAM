//
// Created by Deutschmann on 09.09.20.
//

#ifndef DESCAM_PRINTSTMTVHDL_H
#define DESCAM_PRINTSTMTVHDL_H

#include "PrintStmt.h"

namespace DESCAM {
    namespace HLSPlugin {
        namespace VHDLWrapper {

            class PrintStmtVHDL : public PrintStmt {

            public:

                PrintStmtVHDL() = default;

                explicit PrintStmtVHDL(DESCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

                static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

            protected:

                void visit(Arithmetic &node) override;

                void visit(ArrayOperand &node) override;

                void visit(Assignment &node) override;

                void visit(Bitwise &node) override;

                void visit(BoolValue &node) override;

                void visit(Cast &node) override;

                //void visit(CompoundExpr &node) override;
                void visit(DataSignalOperand &node) override;

                void visit(FunctionOperand &node) override;

                void visit(IntegerValue &node) override;

                void visit(Notify &node) override;

                void visit(ParamOperand &node) override;

                void visit(Relational &node) override;

                void visit(Return &node) override;

                void visit(SyncSignal &node) override;

                void visit(UnaryExpr &node) override;

                void visit(UnsignedValue &node) override;

                void visit(VariableOperand &node) override;

                std::string getString();

            private:

                // Flag used to convert operands to signed types in arithmetic operations
                bool arithmeticOperation = false;

                // Flag used to print Integer and Unsigned values as a number
                bool asNumber = false;

            };

        }
    }
}

#endif //DESCAM_PRINTSTMTVHDL_H
