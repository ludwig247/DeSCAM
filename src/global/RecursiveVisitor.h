//
// Created by tobias on 31.03.20.
//

#ifndef DESCAM_RECURSIVEVISITOR_H
#define DESCAM_RECURSIVEVISITOR_H

#include "Stmts_all.h"

namespace DESCAM {
//! Visits a DESCAM::Stmt recursively until all leaf nodes are reached. This class should be used a base for all recursive visitors
class RecursiveVisitor : public StmtAbstractVisitor {
 public:
  RecursiveVisitor() = default;
  explicit RecursiveVisitor(Stmt *stmt);
  ~RecursiveVisitor() = default;

 public:
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
};
}

#endif //DESCAM_RECURSIVEVISITOR_H
