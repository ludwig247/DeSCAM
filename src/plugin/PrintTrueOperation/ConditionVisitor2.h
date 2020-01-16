//
// Created by ludwig on 31.08.16.
//

#ifndef SCAM_CONDITIONVISITOR2_H
#define SCAM_CONDITIONVISITOR2_H

#include <PrintStmt.h>

namespace SCAM {

    class ConditionVisitor2 : public PrintStmt {
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:
        virtual void visit(class Relational &node);

        virtual void visit(class SyncSignal &node);

        virtual void visit(class Arithmetic &node);

        virtual void visit(class Bitwise &node);

        virtual void visit(class DataSignalOperand &node);

        virtual void visit(class VariableOperand &node);

        virtual void visit(class IntegerValue &node);

        virtual void visit(class UnsignedValue &node);

        virtual void visit(class Cast &node);

        virtual void visit(class Return &node);

        virtual void visit(class ITE &node);

        virtual void visit(class Assignment &node);

        virtual void visit(class ArrayOperand &node);

        virtual void visit(class CompoundExpr &node);

        virtual void visit(class ParamOperand &node);

        virtual void visit(class Notify &node);

        virtual void visit(class TimeExprOperand &node);


        bool resize_flag = false;
    };

}

#endif //SCAM_CONDITIONVISITOR_H
