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

namespace SCAM {


    class ExprTranslator:  public StmtAbstractVisitor {
    public:
        ExprTranslator(z3::context * context);
        virtual ~ExprTranslator();

        Expr * translate(z3::expr &z3_expr, const SCAM::Module *module = nullptr);
        bool isAbort() const;
        z3::expr& translate(SCAM::Expr* scam_expr);
        z3::context *  getContext();
        void reset();

    private:
        ExprTranslator();

        //terminal expression, values
        void visit(SCAM::IntegerValue &node);
        void visit(SCAM::BoolValue &node);
        void visit(SCAM::UnsignedValue &node);
        void visit(SCAM::CompoundValue &node);
        void visit(SCAM::EnumValue& node);
        void visit(SCAM::SectionValue &node);
        //terminal expressions, variables
        void visit(SCAM::VariableOperand &node);
        void visit(SCAM::SectionOperand &node);
        //non-terminal expressions
        void visit(SCAM::UnaryExpr &node);
        //relational expr
        void visit(SCAM::Arithmetic &node);
        void visit(SCAM::Logical &node);
        void visit(SCAM::Relational &node);
        void visit(SCAM::Bitwise &node);
        void visit(SCAM::SyncSignal &node);
        void visit(SCAM::DataSignalOperand &node);
        void visit(SCAM::Cast &node);
        void visit(SCAM::FunctionOperand &node);
        void visit(SCAM::SubSelect &node);


        //unsupported expressions all communication stuff, these are functions
        // can be treated as functions (which in z3 is not an expression)
        //fun fact: in z3 "1 + function" is an expression, but the function itself is not
        void visit(class PortOperand &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect PortOperand");}
        void visit(class Read &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect Read");}
        void visit(class NBRead &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect NBRead");}
        void visit(class NBWrite &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect NBWrite");}
        void visit(class Write &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect Write");} //returns nothing... so just ignore...
        void visit(class Assignment &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect Assignment");} //add to solver (as operand == expr)
        void visit(class ITE &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect ITE");} //ITE operator exists in z3, figure out its use
        void visit(class CompoundPortOperand &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect CompoundPortOperand");}
        void visit(class While &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect While");}
        void visit(class If &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect If");}
        void visit(class Branch &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect Branch");}
        void visit(class CompoundExpr &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect Branch");};
        void visit(class ParamOperand &node){throw std::runtime_error("ExprSCAMtoZ3 did not Paramoperand");};
        void visit(class Return &node){throw std::runtime_error("ExprSCAMtoZ3 did not expect Return");};

    private:


        z3::expr z3_expr; //used as "return value" for visit
        z3::context * context;

        //set by top-level transltate to SCAM
        const std::map<std::string,DataType*>& datatypeMap;
        std::map<const SCAM::DataType*,z3::sort> enumTypeSortMap;
        std::map<const SCAM::DataType*,z3::func_decl_vector> enumTypeValueMap;

        const SCAM::Module* module;

        std::map<std::string,FunctionOperand*> functionOperandMap;
        //recursive version of translate to SCAM
        SCAM::Expr* translate_intern(z3::expr& z3_expr);

        z3::sort find_or_add_sort(const DataType *pType);
        bool abort=false;
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

}


#endif //SCAM_EXPRSCAMTOZ3_H
