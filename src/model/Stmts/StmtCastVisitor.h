//
// Created by schwarz on 04.11.20.
//

#ifndef SCAM_SRC_MODEL_STMTS_STMTCASTVISITOR_H_
#define SCAM_SRC_MODEL_STMTS_STMTCASTVISITOR_H_
#include "StmtAbstractVisitor.h"
#include "Stmt.h"
#include "Expr.h"

namespace DESCAM {

class StmtCastVisitorBase : public StmtAbstractVisitor {
 public:
  void visit(struct VariableOperand &node) override {}
  void visit(struct IntegerValue &node) override {}
  void visit(struct UnsignedValue &node) override {}
  void visit(struct BoolValue &node) override {}
  void visit(struct EnumValue &node) override {}
  void visit(struct CompoundValue &node) override {}
  void visit(struct PortOperand &node) override {}
  void visit(struct Assignment &node) override {}
  void visit(struct UnaryExpr &node) override {}
  void visit(struct While &node) override {}
  void visit(struct If &node) override {}
  void visit(struct SectionOperand &node) override {}
  void visit(struct SectionValue &node) override {}
  void visit(struct ITE &node) override {}
  void visit(struct Arithmetic &node) override {}
  void visit(struct Logical &node) override {}
  void visit(struct Relational &node) override {}
  void visit(struct Bitwise &node) override {}
  void visit(struct Read &node) override {}
  void visit(struct Write &node) override {}
  void visit(struct SyncSignal &node) override {}
  void visit(struct DataSignalOperand &node) override {}
  void visit(struct Cast &node) override {}
  void visit(struct FunctionOperand &node) override {}
  void visit(struct ArrayOperand &node) override {}
  void visit(struct CompoundExpr &node) override {}
  void visit(struct ParamOperand &node) override {}
  void visit(struct Return &node) override {}
  void visit(struct Notify &node) override {}
  void visit(struct Wait &node) override {}
  void visit(struct Peek &node) override {}
  void visit(struct ArrayExpr &node) override {}
  void visit(struct TimePointOperand &node) override {}
  void visit(struct Ternary &node) override {}

  virtual void visit(struct Expr &expr) {}
  virtual void visit(struct ConstValue &expr) {}
};

template<class DERIVED>
class StmtCastVisitor : public StmtCastVisitorBase {
 private:
  DERIVED *ptr_;

 public:
  explicit StmtCastVisitor(Stmt *node) : ptr_(nullptr) {
    node->accept(*this);
  }

  void visit(DERIVED &node) override {
    ptr_ = &node;
  }

  DERIVED *Get() const {
    return ptr_;
  }
};
}
#endif //SCAM_SRC_MODEL_STMTS_STMTCASTVISITOR_H_
