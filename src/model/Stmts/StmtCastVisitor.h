//
// Created by schwarz on 04.11.20.
//

#ifndef SCAM_SRC_MODEL_STMTS_STMTCASTVISITOR_H_
#define SCAM_SRC_MODEL_STMTS_STMTCASTVISITOR_H_
#include "StmtAbstractVisitor.h"
#include "Stmts_all.h"

namespace DESCAM {

/**
 * @brief Catches all calls to classes to StmtCastVisitor that are not the targeted DERIVED class. Will forward calls
 *        until DESCAM::Expr or until the targeted call to DERIVED
 */
class StmtCastVisitorBase : public StmtAbstractVisitor {
 protected:
  // Derived directly from Stmt
  void visit(struct Assignment &node) override {}
  void visit(struct While &node) override {}
  void visit(struct If &node) override {}
  void visit(struct ITE &node) override {}
  void visit(struct Read &node) override {}
  void visit(struct Write &node) override {}
  void visit(struct Return &node) override {}
  void visit(struct Wait &node) override {}

  // Derived directly from Expr
  void visit(struct Logical &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct Relational &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct Bitwise &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct SyncSignal &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct UnaryExpr &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct SectionOperand &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct Arithmetic &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct Cast &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct ArrayOperand &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct CompoundExpr &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct Notify &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct Peek &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct ArrayExpr &node) override { visit(*(static_cast<Expr*>(&node))); }
  void visit(struct Ternary &node) override { visit(*(static_cast<Expr*>(&node))); }

  // Derived directly from Operand
  void visit(struct VariableOperand &node) override { visit(*(static_cast<Operand*>(&node))); }
  void visit(struct PortOperand &node) override { visit(*(static_cast<Operand*>(&node))); }
  void visit(struct DataSignalOperand &node) override { visit(*(static_cast<Operand*>(&node))); }
  void visit(struct FunctionOperand &node) override { visit(*(static_cast<Operand*>(&node))); }
  void visit(struct ParamOperand &node) override { visit(*(static_cast<Operand*>(&node))); }
  void visit(struct TimePointOperand &node) override { visit(*(static_cast<Operand*>(&node))); }

  // ConstValue
  void visit(struct IntegerValue &node) override { visit(*(static_cast<ConstValue*>(&node))); }
  void visit(struct UnsignedValue &node) override { visit(*(static_cast<ConstValue*>(&node))); }
  void visit(struct BoolValue &node) override { visit(*(static_cast<ConstValue *>(&node))); }
  void visit(struct EnumValue &node) override { visit(*(static_cast<ConstValue*>(&node))); }
  void visit(struct CompoundValue &node) override { visit(*(static_cast<ConstValue*>(&node))); }
  void visit(struct SectionValue &node) override { visit(*(static_cast<ConstValue*>(&node))); }

  // Fixme This is really hacky. visit(Expr)
  virtual void visit(struct ConstValue &node) {visit(*(static_cast<Expr *>(&node)));}
  virtual void visit(struct Operand &node) {visit(*(static_cast<Expr *>(&node)));}
  virtual void visit(struct Expr &node) {}

};

/**
 * @brief StmtCastVisitor<Derived>(BASE).Get() behaves like dynamic_cast<DERIVED>(BASE). Returns DERIVED* or nullptr.
 * @tparam DERIVED
 */
template<class DERIVED>
class StmtCastVisitor : public StmtCastVisitorBase {
 private:
  DERIVED *ptr_;

 protected:
  void visit(DERIVED &node) override {
    ptr_ = &node;
  }

 public:
  explicit StmtCastVisitor(Stmt *node) : ptr_(nullptr) {
    node->accept(*this);
  }

  DERIVED *Get() const {
    return ptr_;
  }
};
}
#endif //SCAM_SRC_MODEL_STMTS_STMTCASTVISITOR_H_
