//
// Created by joakim on 06.11.16.
//

#ifndef SCAM_EXPRSCAMTOZ3_H
#define SCAM_EXPRSCAMTOZ3_H

#include "z3++.h"
#include <StmtAbstractVisitor.h>
#include <Model.h>
#include "Stmts_all.h"
#include <ExprVisitor.h>
#include "PrintStmt.h"
#include "FatalError.h"
#include "Logger/Logger.h"

namespace DESCAM {

    class ExprTranslator : public StmtAbstractVisitor {
    public:
        explicit ExprTranslator(z3::context *context);

        virtual ~ExprTranslator() = default;

        Expr *translate(z3::expr &z3_expr, const DESCAM::Module *module = nullptr);

        bool isAbort() const;

        z3::expr &translate(DESCAM::Expr *scam_expr);

        z3::context *getContext();

        void reset();



    private:
        ExprTranslator();
        //terminal expression, values
        void visit(DESCAM::IntegerValue &node);

        void visit(DESCAM::BoolValue &node);

        void visit(DESCAM::UnsignedValue &node);

        void visit(DESCAM::CompoundValue &node);

        void visit(DESCAM::EnumValue &node);

        void visit(DESCAM::SectionValue &node);

        //terminal expressions, variables
        void visit(DESCAM::VariableOperand &node);

        void visit(DESCAM::SectionOperand &node);

        //non-terminal expressions
        void visit(DESCAM::UnaryExpr &node);

        //relational expr
        void visit(DESCAM::Arithmetic &node);

        void visit(DESCAM::Logical &node);

        void visit(DESCAM::Relational &node);

        void visit(DESCAM::Bitwise &node);

        void visit(DESCAM::SyncSignal &node);

        void visit(DESCAM::DataSignalOperand &node);

        void visit(DESCAM::Cast &node);

        void visit(DESCAM::FunctionOperand &node);

        void visit(DESCAM::ArrayOperand &node);

        void visit(class Ternary &node) override;

        //unsupported expressions all communication stuff, these are functions
        // can be treated as functions (which in z3 is not an expression)
        //fun fact: in z3 "1 + function" is an expression, but the function itself is not
        void visit(class PortOperand &node) { TERMINATE("ExprSCAMtoZ3 did not expect PortOperand"); }

        void visit(class Read &node) { TERMINATE("ExprSCAMtoZ3 did not expect Read"); }

        void visit(class Write &node) { TERMINATE("ExprSCAMtoZ3 did not expect Write"); } //returns nothing... so just ignore...
        void visit(class Assignment &node) { TERMINATE("ExprSCAMtoZ3 did not expect Assignment"); } //add to solver (as operand == expr)
        void visit(class ITE &node) { TERMINATE("ExprSCAMtoZ3 did not expect ITE"); } //ITE operator exists in z3, figure out its use
        void visit(class CompoundPortOperand &node) { TERMINATE("ExprSCAMtoZ3 did not expect CompoundPortOperand"); }

        void visit(class While &node) { TERMINATE("ExprSCAMtoZ3 did not expect While"); }

        void visit(class If &node) { TERMINATE("ExprSCAMtoZ3 did not expect If"); }

        void visit(class Branch &node) { TERMINATE("ExprSCAMtoZ3 did not expect Branch"); }

        void visit(class CompoundExpr &node) { TERMINATE("ExprSCAMtoZ3 did not expect CompoundExpr"); };
        void visit(class ArrayExpr &node) { TERMINATE("ExprSCAMtoZ3 did not expect ArrayExpr"); };
        void visit(class ParamOperand &node) { TERMINATE("ExprSCAMtoZ3 did not Paramoperand"); };

        void visit(class Return &node) { TERMINATE("ExprSCAMtoZ3 did not expect Return"); };

        void visit(class Notify &node) { TERMINATE("ExprSCAMtoZ3 did not expect Notify"); };

        void visit(class Wait &node) { TERMINATE("ExprSCAMtoZ3 did not expect Wait"); };

        void visit(class Peek &node) override { TERMINATE("ExprSCAMtoZ3 did not expect Peek"); };

        void visit(class TimePointOperand &node) override { TERMINATE("ExprSCAMtoZ3 did not expect TimeExprOperand"); };

    private:


        z3::expr z3_expr; //used as "return value" for visit
        z3::context *context;

        //set by top-level transltate to DESCAM
        const std::map<std::string, DataType *> &datatypeMap;
        std::map<const DESCAM::DataType *, z3::sort> enumTypeSortMap;
        std::map<const DESCAM::DataType *, z3::func_decl_vector> enumTypeValueMap;
        std::map<std::string, FunctionOperand *> functionOperandMap;
        std::map<std::string, ArrayOperand *> arrayMap;


        const DESCAM::Module *module;

        //recursive version of translate to DESCAM
        DESCAM::Expr *translate_intern(const z3::expr &z3_expr_intern);

        z3::sort find_or_add_sort(const DataType *pType);

        bool abort = false;
        bool unsigned_flag;
        bool bitvector_flag;

        std::map<std::string, std::string> relationalOperatorMap;
        std::map<std::string, std::string> logicalOperatorMap;
        std::map<std::string, std::string> unaryOperatorMap;
        std::map<std::string, std::string> arithOperatorMap;
        std::map<std::string, std::string> bvArithOperatorMap;
        std::map<std::string, std::string> bvBitwiseOperatorMap;

        std::map<std::string, std::string> bvRelationalOperatorMap;

    };

/** A macro that terminates DeSCAM in case a DescamException occurs */
#define CHECK_EXCEPTION_AND_RETURN(RETURN_VALUE)                        \
    if(DESCAM::DescamException::isExceptionHappened()) throw DESCAM::FatalError(); \
    else return RETURN_VALUE;
}


#endif //SCAM_EXPRSCAMTOZ3_H
