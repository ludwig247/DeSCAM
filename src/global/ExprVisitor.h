//
// Created by tobias on 11.04.17.
//

#ifndef PROJECT_ISEXPRCONSTVISITOR_H
#define PROJECT_ISEXPRCONSTVISITOR_H

#include <set>

#include "StmtAbstractVisitor.h"
#include "PrintStmt.h"
#include "Stmts_all.h"

namespace DESCAM {

class ExprVisitor : public StmtAbstractVisitor {
 public:

  static bool isConstVal(DESCAM::Expr *expr);

  static bool isBitwise(DESCAM::Expr *expr);

  static bool isVar(DESCAM::Expr *expr);

  static bool isParameter(DESCAM::Expr *expr);

  static bool isTernary(DESCAM::Expr *expr);

  static std::set<Operand *> getUsedOperands(DESCAM::Expr *expr);

  static std::set<Variable *> getUsedVariables(DESCAM::Expr *expr);

  static std::set<Port *> getUsedPorts(DESCAM::Expr *expr);

  static std::set<SyncSignal *> getUsedSynchSignals(DESCAM::Expr *expr);

  static std::set<Ternary *> getUsedTernaryOperators(DESCAM::Expr *expr);

  static std::set<DataSignal *> getUsedDataSignals(DESCAM::Expr *expr);

  static std::set<ArrayOperand *> getUsedArrayOperands(DESCAM::Expr *expr);

  static std::set<DESCAM::Function *> getUsedFunction(DESCAM::Expr *expr);

  static Operand *getOperand(DESCAM::Expr *expr);

  void visit(class ArrayExpr &node) override;

 private:
  ExprVisitor(DESCAM::Expr *expr);

  bool bitwise;
  bool constVal;
  bool var;
  bool parameter;
  bool compare = false;
  DESCAM::Expr *expr;

  std::set<Operand *> usedOperands;
  std::set<SyncSignal *> usedSynchSignal;
  std::set<DataSignal *> usedDataSignal;
  std::set<Variable *> usedVar;
  std::set<Port *> usedPorts;
  std::set<ArrayOperand *> usedArrayOperands;
  std::set<Function *> usedFunction;
  CompoundValue *compoundValue;
  std::set<Ternary *> usedTernary;

  void visit(struct VariableOperand &node) override;

  void visit(struct IntegerValue &node) override;

  void visit(struct UnsignedValue &node) override;

  void visit(struct BoolValue &node) override;

  void visit(struct EnumValue &node) override;

  void visit(struct CompoundValue &node) override;

  void visit(struct PortOperand &node) override;

  void visit(struct Assignment &node) override;

  void visit(struct UnaryExpr &node) override;

  void visit(struct While &node) override;

  void visit(struct If &node) override;

  void visit(struct SectionOperand &node) override;

  void visit(struct SectionValue &node) override;

  void visit(struct ITE &node) override;

  virtual void visit(struct Branch &node);

  void visit(struct Arithmetic &node) override;

  void visit(struct Logical &node) override;

  void visit(struct Relational &node) override;

  void visit(struct Bitwise &node) override;

  void visit(struct Read &node) override;

  void visit(struct Write &node) override;

  void visit(struct SyncSignal &node) override;

  void visit(struct DataSignalOperand &node) override;

  void visit(struct Cast &node) override;

  void visit(DESCAM::FunctionOperand &node) override;

  void visit(class ArrayOperand &node) override;

  void visit(class CompoundExpr &node) override;

  void visit(Return &node) override;

  void visit(ParamOperand &node) override;

  void visit(Notify &node) override;

  void visit(Wait &node) override;

  void visit(Peek &node) override;

  void visit(struct TimePointOperand &node) override;

  void visit(struct Ternary &node) override;
};
}

#endif //PROJECT_ISEXPRCONSTVISITOR_H
