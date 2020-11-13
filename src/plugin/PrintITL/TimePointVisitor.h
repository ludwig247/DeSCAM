//
// Created by lucas on 28.01.20.
//

#ifndef DESCAM_TIMEPOINTVISITOR_H
#define DESCAM_TIMEPOINTVISITOR_H

#include <PrintStmt.h>

namespace DESCAM {

    class TimePointVisitor : public PrintStmt {
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:
        void visit(class Relational &node) override;

        void visit(class SyncSignal &node) override;

        void visit(class Arithmetic &node) override;

        void visit(class Bitwise &node) override;

        void visit(class DataSignalOperand &node) override;

        void visit(class VariableOperand &node) override;

        void visit(class IntegerValue &node) override;

        void visit(class UnsignedValue &node) override;

        void visit(class UnaryExpr & node) override;

        void visit(class Cast &node) override;

        void visit(class Return &node) override;

        void visit(class ITE &node) override;

        void visit(class Assignment &node) override;

        void visit(class ArrayOperand &node) override;

        void visit(class CompoundExpr &node) override;

        void visit(class ParamOperand &node) override;

        void visit(class Notify &node) override;

        void visit(class ArrayExpr &node) override;

        virtual void visit(class Timepoint &node);

        bool resize_flag = false;
    };

}

#endif //DESCAM_TIMEPOINTVISITOR_H
