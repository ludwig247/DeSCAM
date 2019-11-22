//
// Created by schauss on 02.10.19.
//

#ifndef SCAM_VISITFUNCTIONS_H
#define SCAM_VISITFUNCTIONS_H

#include <set>

#include <PrintStmt.h>

namespace SCAM {

    class VisitFunctions : PrintStmt {
    public:

        static std::set<std::string> printFunctionNames(Expr *expr);

    private:

        explicit VisitFunctions(Expr *expr);

        std::set<std::string> functionNames;

        void visit(Arithmetic &node) override ;
        void visit(VariableOperand &node) override {};
        void visit(DataSignalOperand &node) override {};
        void visit(SyncSignal &node) override {};
        void visit(EnumValue &node) override {};
        void visit(Relational &node) override ;
        void visit(UnaryExpr &node) override {};
        void visit(IntegerValue &node) override {};
        void visit(UnsignedValue &node) override {};
        void visit(Logical &node) override {};
        void visit(FunctionOperand &node) override ;
        void visit(CompoundExpr &node) override {};
        void visit(BoolValue &node) override {};
        void visit(CompoundValue& node) override {};
        void visit(PortOperand &node) override {};
        void visit(Assignment &node) override {};
        void visit(While &node) override {};
        void visit(If &node) override {};
        void visit(SectionOperand &node) override {};
        void visit(SectionValue &node) override {};
        void visit(ITE &node) override {};
        void visit(Bitwise &node) override{} ;
        void visit(Read &node) override {};
        void visit(Write &node) override {};
        void visit(Cast &node) override {};
        void visit(ArrayOperand &node) override {};
        void visit(ParamOperand &node) override {};
        void visit(Return &node) override {};
        void visit(Notify &node) override {};
    };

}
#endif //SCAM_VISITFUNCTIONS_H
