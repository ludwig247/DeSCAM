//
// Created by johannes on 31.01.20.
//

#ifndef DESCAM_PRINTRESETVALUES_H
#define DESCAM_PRINTRESETVALUES_H

#include <PrintStmt.h>

#include "PrintFunctionStatements.h"

namespace SCAM {

    class PrintResetValues : PrintStmt {

    public:
        PrintResetValues(SCAM::Stmt *stmt, const std::string& signalName, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        bool toString();

        std::string getString();

    protected:
        void visit(Assignment &node) override ;
        void visit(DataSignalOperand &node) override ;
        void visit(Notify &node) override ;
        void visit(VariableOperand &node) override ;

    private:
        Stmt* stmt;
        unsigned int indentSize;
        unsigned int indentOffset;
        std::string resetSignal;
        bool signalFound;
    };
}

#endif //DESCAM_PRINTRESETVALUES_H
