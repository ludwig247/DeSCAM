//
// Created by schauss on 07.10.19.
//

#ifndef SCAM_VHDLPRINTRESETNOTIFY_H
#define SCAM_VHDLPRINTRESETNOTIFY_H

#include "PrintCondition.h"
#include <PrintStmt.h>

namespace DESCAM { namespace HLSPlugin { namespace VHDLWrapper {

    class PrintResetNotify : PrintCondition {

    public:
        explicit PrintResetNotify(DESCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:

        std::string getString() override;

        void visit(Assignment &node) override ;
        void visit(DataSignalOperand &node) override {};
        void visit(VariableOperand &node) override {};
        void visit(BoolValue &node) override ;
    };

    class PrintResetSignal : PrintCondition {

    public:
        PrintResetSignal(DESCAM::Stmt *stmt, const std::string& signalName, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        bool toString();

        std::string getString() override;

    protected:

        void visit(Assignment &node) override ;
        void visit(DataSignalOperand &node) override ;
        void visit(VariableOperand &node) override ;
        void visit(BoolValue &node) override ;

    private:
        Stmt* stmt;
        unsigned int indentSize;
        unsigned int indentOffset;
        std::string resetSignal;
        bool signalFound;
    };
}}}

#endif //SCAM_VHDLPRINTRESETNOTIFY_H
