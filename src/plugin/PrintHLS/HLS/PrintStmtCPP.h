//
// Created by Deutschmann on 18.09.20.
//

#ifndef DESCAM_PRINTSTMTCPP_H
#define DESCAM_PRINTSTMTCPP_H

#include "PrintStmt.h"

namespace DESCAM { namespace HLSPlugin { namespace HLS {

            class PrintStmtCPP : public PrintStmt {

            public:

                PrintStmtCPP() = default;

                explicit PrintStmtCPP(DESCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

                static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

            protected:

                void visit(Arithmetic &node) override;
                void visit(ArrayOperand &node) override;
                void visit(Assignment &node) override;
                void visit(Bitwise &node) override;
                void visit(Cast &node) override;
                //void visit(CompoundExpr &node) override;
                //void visit(DataSignalOperand &node) override;
                //void visit(FunctionOperand &node) override;
                void visit(IntegerValue &node) override;
                //void visit(ITE &node) override;
                void visit(Logical &node) override;
                void visit(Notify &node) override;
                void visit(ParamOperand &node) override;
                void visit(Return &node) override;
                void visit(SyncSignal &node) override;
                void visit(Ternary &node) override;
                void visit(UnaryExpr &node) override;
                void visit(UnsignedValue &node) override;
                void visit(VariableOperand &node) override;

                std::string getString();

            private:
                //std::shared_ptr<OptimizerHLS> optimizer;
                //Side side;
                //HLSOption hlsOption;

                //void printIndent();
            };

        }}}

#endif //DESCAM_PRINTSTMTCPP_H
