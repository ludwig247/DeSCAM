//
// Created by johannes on 08.08.19.
//

#ifndef SCAM_PRINTFUNCTIONPARAMETERS_H
#define SCAM_PRINTFUNCTIONPARAMETERS_H

#include "PrintStmt.h"

namespace SCAM {

    class PrintFunctionParameters : public PrintStmt {

    public:
        explicit PrintFunctionParameters(SCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        std::string getString();

    protected:
        void visit(VariableOperand &node) override ;
        void visit(Notify &node) override {};
        void visit(Assignment &node) override ;
        void visit(DataSignalOperand &node) override {};
    };

}

#endif //SCAM_PRINTFUNCTIONPARAMETERS_H
