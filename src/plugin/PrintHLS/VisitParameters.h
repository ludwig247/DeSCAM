//
// Created by johannes on 17.08.19.
//

#ifndef SCAM_VISITPARAMETERS_H
#define SCAM_VISITPARAMETERS_H

#include <set>
#include <Stmts_all.h>

#include "StmtAbstractVisitor.h"

namespace SCAM {

    class VisitParameters : public StmtAbstractVisitor {

    public:
        static std::set<std::pair<std::string, std::string> > getParameters(Expr *expr);
        static std::map<std::string, std::string> getParametersVHDL(Expr *expr);
        static std::vector<std::string> getOperators(Expr *expr);

    private:
        std::set<std::pair<std::string, std::string> > parameters;
        std::map<std::string, std::string> HDLToVHDLMap;
        std::vector<std::string> operators;

        explicit VisitParameters(SCAM::Expr *expr);

        std::string convertDataType(const std::string &typeName);

        void visit(Arithmetic &node) override ;
        void visit(VariableOperand &node) override ;
        void visit(DataSignalOperand &node) override ;
        void visit(SyncSignal &node) override ;
        void visit(EnumValue &node) override {};
        void visit(Relational &node) override ;
        void visit(UnaryExpr &node) override ;
        void visit(IntegerValue &node) override {};
        void visit(UnsignedValue &node) override {};
        void visit(Logical &node) override ;
        void visit(FunctionOperand &node) override ;
        void visit(CompoundExpr &node) override ;
        void visit(BoolValue &node) override {};
        void visit(CompoundValue& node) override {};
        void visit(PortOperand &node) override {};
        void visit(Assignment &node) override {};
        void visit(While &node) override {};
        void visit(If &node) override {};
        void visit(SectionOperand &node) override {};
        void visit(SectionValue &node) override {};
        void visit(ITE &node) override ;
        void visit(Bitwise &node) override ;
        void visit(Read &node) override {};
        void visit(Write &node) override {};
        void visit(Cast &node) override {};
        void visit(ArrayOperand &node) override {};
        void visit(ParamOperand &node) override {};
        void visit(Return &node) override ;
        void visit(Notify &node) override ;
        void visit(Wait &node) override {};
        void visit(Peek &node) override {};
        void visit(ArrayExpr &node) override {};
    };

}

#endif //SCAM_VISITPARAMETERS_H