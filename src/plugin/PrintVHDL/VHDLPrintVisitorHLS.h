//
// Created by johannes on 10.09.19.
//

#ifndef SCAM_VHDLPRINTVISITORHLS_H
#define SCAM_VHDLPRINTVISITORHLS_H

#include "VHDLPrintVisitor.h"
#include <PrintStmt.h>

namespace SCAM {

    class VHDLPrintVisitorHLS : VHDLPrintVisitor {
    public:
        explicit VHDLPrintVisitorHLS(SCAM::Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:
        void visit(SyncSignal &node) override ;
        void visit(Bitwise &node) override;
        void visit(ArrayOperand &node) override ;
        void visit(VariableOperand &node) override ;
        void visit(BoolValue &node) override ;
        void visit(DataSignalOperand &node) override ;

        std::string getString() override ;
    };

}


#endif //SCAM_VHDLPRINTVISITORHLS_H
