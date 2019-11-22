//
// Created by schauss on 07.10.19.
//

#ifndef SCAM_VHDLPRINTRESETNOTIFY_H
#define SCAM_VHDLPRINTRESETNOTIFY_H

#include "VHDLPrintVisitor.h"
#include <PrintStmt.h>

namespace SCAM {

    class VHDLPrintResetNotify : VHDLPrintVisitor {

    public:
        explicit VHDLPrintResetNotify(SCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:

        std::string getString() override;

        void visit(Assignment &node) override ;
        void visit(DataSignalOperand &node) override {};
        void visit(VariableOperand &node) override {};
        void visit(BoolValue &node) override ;
    };
}

#endif //SCAM_VHDLPRINTRESETNOTIFY_H
