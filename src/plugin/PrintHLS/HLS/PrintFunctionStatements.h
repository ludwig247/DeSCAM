//
// Created by johannes on 28.07.19.
//

#ifndef SCAM_PRINTTESTVISITORS_H
#define SCAM_PRINTTESTVISITORS_H

#include "PrintStmt.h"
#include "Utilities.h"
#include "OptimizeForHLS.h"
#include "BitSlicingHLS.h"

namespace SCAM {

    class PrintFunctionStatements : public PrintStmt {

    public:
        explicit PrintFunctionStatements(SCAM::Stmt *stmt, OptimizeForHLS *opt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);
        static std::string toString(Stmt *stmt, OptimizeForHLS *opt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        std::string getString();

    protected:
        void visit(VariableOperand &node) override ;
        void visit(DataSignalOperand &node) override ;
        void visit(SyncSignal &node) override ;
        void visit(UnaryExpr &node) override ;
        void visit(CompoundExpr &node) override ;
        void visit(Cast &node) override ;
        void visit(ITE &node) override ;
        void visit(Return &node) override ;
        void visit(ParamOperand &node) override ;
        void visit(Logical &node) override ;
        void visit(FunctionOperand &node) override ;
        void visit(Assignment &node) override ;
        void visit(Bitwise &node) override ;
        void visit(ArrayOperand &node) override;

    private:
        OptimizeForHLS *opt;
        Side side;

        void printIndent();
    };

}

#endif //SCAM_PRINTTESTVISITORS_H
