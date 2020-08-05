//
// Created by lukas on 01.04.19.
//

#ifndef PROJECT_CHISELSVADATAPATHVISITOR_H
#define PROJECT_CHISELSVADATAPATHVISITOR_H

#include <PrintStmt.h>

namespace DESCAM {

    class ChiselSVADatapathVisitor : public PrintStmt {
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:
        virtual void visit(class Relational &node);

        virtual void visit(class SyncSignal &node);

        virtual void visit(class Notify &node);

        virtual void visit(class Arithmetic &node);

        virtual void visit(class Bitwise &node);

        virtual void visit(class DataSignalOperand &node);

        virtual void visit(class VariableOperand &node);

        virtual void visit(class IntegerValue &node);

        virtual void visit(class UnsignedValue &node);

        virtual void visit(class BoolValue &node);

        virtual void visit(class UnaryExpr &node);

        virtual void visit(class Assignment &node);

        virtual void visit(class Logical &node);

        virtual void visit(class EnumValue &node);

        virtual void visit(class Cast &node);

        virtual void visit(class CompoundExpr &node);

        virtual void visit(class CompoundValue &node);

        bool resize_flag = false;
    };

}

#endif //PROJECT_CHISELSVADATAPATHVISITOR_H
