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
  void visit(DESCAM::IntegerValue &node) override;

  void visit(DESCAM::BoolValue &node) override;

  void visit(DESCAM::UnsignedValue &node) override;

  void visit(DESCAM::CompoundValue &node) override;

  void visit(DESCAM::EnumValue &node) override;

  void visit(DESCAM::SectionValue &node) override;

  //terminal expressions, variables
  void visit(DESCAM::VariableOperand &node) override;

  void visit(DESCAM::SectionOperand &node) override;

  //non-terminal expressions
  void visit(DESCAM::UnaryExpr &node) override;

  //relational expr
  void visit(DESCAM::Arithmetic &node) override;

  void visit(DESCAM::Logical &node) override;

  void visit(DESCAM::Relational &node) override;

  void visit(DESCAM::Bitwise &node) override;

  void visit(DESCAM::SyncSignal &node) override;

  void visit(DESCAM::DataSignalOperand &node) override;

  void visit(DESCAM::Cast &node) override;

  void visit(DESCAM::FunctionOperand &node) override;

  void visit(DESCAM::ArrayOperand &node) override;

  void visit(class Ternary &node) override;

  //unsupported expressions all communication stuff, these are functions
  // can be treated as functions (which in z3 is not an expression)
  //fun fact: in z3 "1 + function" is an expression, but the function itself is not
  void visit(class PortOperand &node) override {TERMINATE("ExprSCAMtoZ3 did not expect PortOperand")}

  void visit(class Read &node) override {TERMINATE("ExprSCAMtoZ3 did not expect Read")}

  void visit(class Write &node) override {TERMINATE("ExprSCAMtoZ3 did not expect Write")} //returns nothing... so just ignore...

  void visit(class Assignment &node) override {TERMINATE("ExprSCAMtoZ3 did not expect Assignment")} //add to solver (as operand == expr)

  void visit(class ITE &node) override {TERMINATE("ExprSCAMtoZ3 did not expect ITE")} //ITE operator exists in z3, figure out its use

  static void visit(class CompoundPortOperand &node) override{TERMINATE("ExprSCAMtoZ3 did not expect CompoundPortOperand")}

  void visit(class While &node) override {TERMINATE("ExprSCAMtoZ3 did not expect While")}

  void visit(class If &node) override {TERMINATE("ExprSCAMtoZ3 did not expect If")}

  static void visit(class Branch &node) override{TERMINATE("ExprSCAMtoZ3 did not expect Branch")}

  void visit(class CompoundExpr &node) override {TERMINATE("ExprSCAMtoZ3 did not expect CompoundExpr")};

  void visit(class ArrayExpr &node) override {TERMINATE("ExprSCAMtoZ3 did not expect ArrayExpr")};

  void visit(class ParamOperand &node) override {TERMINATE("ExprSCAMtoZ3 did not Paramoperand")};

  void visit(class Return &node) override {TERMINATE("ExprSCAMtoZ3 did not expect Return")};

  void visit(class Notify &node) override {TERMINATE("ExprSCAMtoZ3 did not expect Notify")};

  void visit(class Wait &node) override {TERMINATE("ExprSCAMtoZ3 did not expect Wait")};

  void visit(class Peek &node) override {TERMINATE("ExprSCAMtoZ3 did not expect Peek")};

  void visit(class TimePointOperand &node) override {TERMINATE("ExprSCAMtoZ3 did not expect TimeExprOperand")};

 private:

  z3::expr z3_expr_; //used as "return value" for visit
  z3::context *context_;

  //set by top-level translate to DESCAM
  const std::map<std::string, DataType *> &datatype_map_;
  std::map<const DESCAM::DataType *, z3::sort> enum_type_sort_map_;
  std::map<const DESCAM::DataType *, z3::func_decl_vector> enum_type_value_map_;
  std::map<std::string, FunctionOperand *> function_operand_map_;
  std::map<std::string, ArrayOperand *> array_map_;

  const DESCAM::Module *module_;

  //recursive version of translate to DESCAM
  DESCAM::Expr *translate_intern(const z3::expr &z3_expr_intern);

  z3::sort find_or_add_sort(const DataType *pType);

  bool abort_ = false;
  bool unsigned_flag_;
  bool bitvector_flag_;

  std::map<std::string, std::string> relational_operator_map_;
  std::map<std::string, std::string> logical_operator_map_;
  std::map<std::string, std::string> unary_operator_map_;
  std::map<std::string, std::string> arith_operator_map_;
  std::map<std::string, std::string> bv_arith_operator_map_;
  std::map<std::string, std::string> bv_bitwise_operator_map_;

  std::map<std::string, std::string> bv_relational_operator_map_;

};

/** A macro that terminates DeSCAM in case a DescamException occurs */
#define CHECK_EXCEPTION_AND_RETURN(RETURN_VALUE)                        \
    if(DESCAM::DescamException::isExceptionHappened()) throw DESCAM::FatalError(); \
    else return RETURN_VALUE;
}

#endif //SCAM_EXPRSCAMTOZ3_H
