//
// Created by johannes on 26.10.19.
//

#ifndef SCAM_PRINTVISIBLEREGISTERS_H
#define SCAM_PRINTVISIBLEREGISTERS_H

#include "PrintStmt.h"
#include "Utilities.h"

namespace SCAM {

    class PrintVisibleRegisters : public PrintStmt {

    public:
        explicit PrintVisibleRegisters(SCAM::Stmt *stmt, Utilities *utils, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        static std::string toString(Stmt *stmt, Utilities *utils, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        std::string getString();

    protected:
        void visit(Assignment &node) override ;
        void visit(VariableOperand &node) override ;
        void visit(ParamOperand &node) override ;
        void visit(Notify &node) override {};

    private:
        void printIndent();

        Utilities *utilities;
        bool isRegister;
    };

}

#endif //SCAM_PRINTVISIBLEREGISTERS_H
