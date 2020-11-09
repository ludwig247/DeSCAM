//
// Created by tobias on 01.04.20.
//

#ifndef DESCAM_TERNARYOPTIMIZER_H
#define DESCAM_TERNARYOPTIMIZER_H

#include <map>
#include <Module.h>
#include "RecursiveVisitor.h"
#include "Behavior/CfgNode.h"
#include "Behavior/State.h"
#include "Behavior/Operation.h"

namespace DESCAM {
class TernaryOptimizer : public RecursiveVisitor {
 public:
  TernaryOptimizer() = delete;
  TernaryOptimizer(Stmt *stmt, std::vector<Expr *> assumptionList, Module *module);
  TernaryOptimizer(Stmt *stmt, Module *module);

  Stmt *getStmt() const;

  Expr *getExpr() const;

  static bool isTrivialTrue(const std::vector<Expr *> &assumptionList, Expr *expr);

  static bool isTrivialFalse(const std::vector<Expr *> &assumptionList, Expr *expr);

 private:
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

  void visit(struct Branch &node) override;

  void visit(struct Arithmetic &node) override;

  void visit(struct Logical &node) override;

  void visit(struct Relational &node) override;

  void visit(struct Bitwise &node) override;

  void visit(struct Read &node) override;

  void visit(struct Write &node) override;

  void visit(struct ArrayExpr &node) override;

  void visit(struct SyncSignal &node) override;

  void visit(struct DataSignalOperand &node) override;

  void visit(struct Cast &node) override;

  void visit(struct DESCAM::FunctionOperand &node) override;

  void visit(struct ArrayOperand &node) override;

  void visit(struct CompoundExpr &node) override;

  void visit(struct Return &node) override;

  void visit(struct ParamOperand &node) override;

  void visit(struct Notify &node) override;

  void visit(struct Wait &node) override;

  void visit(struct Peek &node) override;

  void visit(struct TimePointOperand &node) override;

  void visit(struct Ternary &node) override;

  Expr *expr = nullptr;
  Stmt *stmt = nullptr;

  bool isTrue(DESCAM::Expr *expr) const;
  bool isFalse(DESCAM::Expr *expr) const;

  std::vector<Expr *> assumptionList;

  Module *module;
};
}

#endif //DESCAM_TERNARYOPTIMIZER_H
