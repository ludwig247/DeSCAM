//
// Created by lukas on 19.02.19.
//

#ifndef PROJECT_CHISELDATAPATHVISITOR_H
#define PROJECT_CHISELDATAPATHVISITOR_H

#include <PrintStmt.h>
#include <algorithm>
#include <string>

namespace DESCAM {

    /**
     * \brief: Visitor that translates rhs of assignment in datapath
     *
     * There just some methods from the stmt visitor replaced
     *
     * \attention: only use during creation of prove part for operations
     *
     * \example:
     * cnt = 1 + cnt
	 * lcd_value = lcd_value + sensor->read()
     *
     * is translated into
     *
     * cnt = 1 + cnt_at_t
     * lcd_value = lcd_value_at_t + sensor_sig_at_t
     */
    class ChiselDatapathVisitor : public PrintStmt {
    public:
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0);

    protected:
        virtual void visit(class VariableOperand &node);

        void visit(class SyncSignal &node);

        void visit(class Arithmetic &node);

        void visit(class EnumValue &node);

        void visit(class Bitwise &node);

        void visit(class Relational &node);

        void visit(class DataSignalOperand &node);

        void visit(class IntegerValue &node);

        void visit(class UnsignedValue &node);

        void visit(class BoolValue &node);

        void visit(class Cast &node);

        void visit(class CompoundExpr &node);

        bool resize_flag = false;
    };


}

#endif //PROJECT_CHISELDATAPATHVISITOR_H
