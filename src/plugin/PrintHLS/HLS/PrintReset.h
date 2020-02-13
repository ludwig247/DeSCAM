//
// Created by johannes on 31.01.20.
//

#ifndef DESCAM_PRINTRESET_H
#define DESCAM_PRINTRESET_H

#include "PrintStatement.h"
#include "PrintStmt.h"

namespace SCAM { namespace HLSPlugin { namespace HLS {

    class PrintReset : PrintStmt {

    public:
        PrintReset(SCAM::Stmt *stmt, const std::string& signalName, unsigned int indentSize = 2, unsigned int indentOffset = 0);

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

}}}

#endif //DESCAM_PRINTRESET_H
