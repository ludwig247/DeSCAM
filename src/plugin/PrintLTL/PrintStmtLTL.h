//
// Created by anna on 12.07.18.
//

#ifndef PROJECT_PRINTSTMTLTL_H
#define PROJECT_PRINTSTMTLTL_H

#include <PrintStmt.h>
#include <ModuleInstance.h>

namespace SCAM {

    class PrintStmtLTL : public PrintStmt {
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize=2, unsigned int indentOffset=0);
    protected:
        virtual void visit(EnumValue &node);
        virtual void visit(Logical &node);
        virtual void visit(UnaryExpr &node);
        virtual void visit(SyncSignal &node);
        virtual void visit(DataSignalOperand &node);
        virtual void visit(VariableOperand &node);
    };


}

#endif //PROJECT_PRINTSTMTLTL_H
