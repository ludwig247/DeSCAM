//
// Created by ludwig on 29.08.16.
//

#ifndef SCAM_DATAPATHVISITORVLI_H
#define SCAM_DATAPATHVISITORVLI_H

#include <PrintStmt.h>

namespace SCAM {

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
    class DatapathVisitorVLI : public PrintStmt {
    public:
        DatapathVisitorVLI() = default;
        explicit DatapathVisitorVLI(std::string tp);
        static std::string toString(Stmt *stmt, unsigned int indentSize = 2, unsigned int indentOffset = 0, std::string tp = "_at_t");

    protected:
        virtual void visit(class VariableOperand &node);

        void visit(class SyncSignal &node);

        void visit(class Arithmetic &node);

        void visit(class Bitwise &node);

        void visit(class Relational &node);

        void visit(class DataSignalOperand &node);

        void visit(class IntegerValue &node);

        void visit(class UnsignedValue &node);

        void visit(class Cast &node);

        void visit(class CompoundExpr &node);

        void visit(class ArrayOperand &node) override;

        void visit(class UnaryExpr &node) override;

        void visit(class Logical &node) override;

        void visit(class EnumValue &node) override;

        bool resize_flag = false;
        std::string tp = "_at_t";

    private:

        std::string convertToLower(const std::string &inString);
    };


}


#endif //SCAM_DATAPATHVISITORVLI_H
