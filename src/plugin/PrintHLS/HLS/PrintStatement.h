//
// Created by johannes on 28.07.19.
//

#ifndef SCAM_PRINTCOMMITMENTSHLS_H
#define SCAM_PRINTCOMMITMENTSHLS_H

#include <memory>

#include "OptimizerHLS.h"
#include "PrintBitOperations.h"
#include "PrintStmt.h"
#include "Utilities.h"

namespace SCAM { namespace HLSPlugin { namespace HLS {

    class PrintStatement : public PrintStmt {

    public:
        explicit PrintStatement(
                SCAM::Stmt *stmt,
                std::shared_ptr<OptimizerHLS>& optimizer,
                HLSOption hlsOption,
                unsigned int indentSize = 2,
                unsigned int indentOffset = 0
        );

        static std::string toString(
                Stmt *stmt,
                unsigned int indentSize = 2,
                unsigned int indentOffset = 0
        );

        static std::string toString(
                Stmt *stmt,
                std::shared_ptr<OptimizerHLS>& opt,
                HLSOption hlsOption,
                unsigned int indentSize = 2,
                unsigned int indentOffset = 0
        );

        std::string getString();

    protected:
        void visit(ArrayOperand &node) override;
        void visit(Assignment &node) override ;
        void visit(Bitwise &node) override ;
        void visit(Cast &node) override ;
        void visit(CompoundExpr &node) override ;
        void visit(DataSignalOperand &node) override ;
        void visit(FunctionOperand &node) override ;
        void visit(ITE &node) override ;
        void visit(Logical &node) override ;
        void visit(ParamOperand &node) override ;
        void visit(Return &node) override ;
        void visit(SyncSignal &node) override ;
        void visit(UnaryExpr &node) override ;
        void visit(VariableOperand &node) override ;

    private:
        std::shared_ptr<OptimizerHLS> optimizer;
        Side side;
        HLSOption hlsOption;

        void printIndent();
    };

}}}

#endif //SCAM_PRINTCOMMITMENTSHLS_H
