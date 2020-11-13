//
// Created by pmorku on 7/17/18.
//

#ifndef PROJECT_STMTNODEALLOC_H
#define PROJECT_STMTNODEALLOC_H

#include <Stmts/StmtAbstractVisitor.h>
#include <Stmts/Stmts_all.h>

namespace DESCAM {

class StmtNodeAlloc : public StmtAbstractVisitor {

 public:
  explicit StmtNodeAlloc(Stmt &node, bool simplifyNode = false);

  Stmt *getAllocNode() const;

  static Stmt *allocNode(Stmt &node, bool simplifyNode = false);

  static Expr *allocNode(Expr &node, bool simplifyNode = false);

  static Branch *allocNode(Branch &node, bool simplifyNode = false);

  static ConstValue *allocNode(ConstValue &node, bool simplifyNode = false);

  static Operand *allocNode(Operand &node, bool simplifyNode = false);

  static VariableOperand *allocNode(VariableOperand &node, bool simplifyNode = false);

  static TimePointOperand *allocNode(TimePointOperand &node, bool simplifyNode = false);

  static IntegerValue *allocNode(IntegerValue &node, bool simplifyNode = false);

  static UnsignedValue *allocNode(UnsignedValue &node, bool simplifyNode = false);

  static BoolValue *allocNode(BoolValue &node, bool simplifyNode = false);

  static EnumValue *allocNode(EnumValue &node, bool simplifyNode = false);

  static CompoundValue *allocNode(CompoundValue &node, bool simplifyNode = false);

  static PortOperand *allocNode(PortOperand &node, bool simplifyNode = false);

  static UnaryExpr *allocNode(UnaryExpr &node);

  static SectionOperand *allocNode(SectionOperand &node, bool simplifyNode = false);

  static SectionValue *allocNode(SectionValue &node, bool simplifyNode = false);

  static Arithmetic *allocNode(Arithmetic &node);

  static Logical *allocNode(Logical &node);

  static Relational *allocNode(Relational &node, bool simplifyNode = false);

  static Bitwise *allocNode(Bitwise &node);

  static SyncSignal *allocNode(SyncSignal &node, bool simplifyNode = false);

  static DataSignalOperand *allocNode(DataSignalOperand &node, bool simplifyNode = false);

  static Cast *allocNode(Cast &node);

  static Read *allocNode(Read &node, bool simplifyNode = false);

  static Wait *allocNode(Wait &node, bool simplifyNode = false);

  static Peek *allocNode(Peek &node, bool simplifyNode = false);

  static Write *allocNode(Write &node, bool simplifyNode = false);

  static ITE *allocNode(ITE &node, bool simplifyNode = false);

  static Assignment *allocNode(Assignment &node, bool simplifyNode = false);

  static While *allocNode(While &node, bool simplifyNode = false);

  static If *allocNode(If &node, bool simplifyNode = false);

  static FunctionOperand *allocNode(FunctionOperand &node, bool simplifyNode = false);

  static ArrayOperand *allocNode(ArrayOperand &node, bool simplifyNode = false);

  static CompoundExpr *allocNode(CompoundExpr &node, bool simplifyNode = false);

  static ArrayExpr *allocNode(ArrayExpr &node, bool simplifyNode = false);

  static ParamOperand *allocNode(ParamOperand &node, bool simplifyNode = false);

  static Return *allocNode(Return &node, bool simplifyNode = false);

  static Ternary *allocNode(Ternary &node, bool simplifyNode = false);

  static std::vector<VariableOperand *> &getAllocTableVariableOperand() {
    return allocTableVariableOperand;
  }

  static std::vector<TimePointOperand *> &getAllocTableTimeExprOperand() {
    return allocTableTimeExprOperand;
  }

  static std::vector<IntegerValue *> &getAllocTableIntegerValue() {
    return allocTableIntegerValue;
  }

  static std::vector<UnsignedValue *> &getAllocTableUnsignedValue() {
    return allocTableUnsignedValue;
  }

  static std::vector<BoolValue *> &getAllocTableBoolValue() {
    return allocTableBoolValue;
  }

  static std::vector<EnumValue *> &getAllocTableEnumValue() {
    return allocTableEnumValue;
  }

  static std::vector<CompoundValue *> &getAllocTableCompoundValue() {
    return allocTableCompoundValue;
  }

  static std::vector<PortOperand *> &getAllocTablePortOperand() {
    return allocTablePortOperand;
  }

  static std::vector<UnaryExpr *> &getAllocTableUnaryExpr() {
    return allocTableUnaryExpr;
  }

  static std::vector<SectionOperand *> &getAllocTableSectionOperand() {
    return allocTableSectionOperand;
  }

  static std::vector<SectionValue *> &getAllocTableSectionValue() {
    return allocTableSectionValue;
  }

  static std::vector<Arithmetic *> &getAllocTableArithmetic() {
    return allocTableArithmetic;
  }

  static std::vector<Logical *> &getAllocTableLogical() {
    return allocTableLogical;
  }

  static std::vector<Relational *> &getAllocTableRelational() {
    return allocTableRelational;
  }

  static std::vector<Bitwise *> &getAllocTableBitwise() {
    return allocTableBitwise;
  }

  static std::vector<SyncSignal *> &getAllocTableSyncSignal() {
    return allocTableSyncSignal;
  }

  static std::vector<DataSignalOperand *> &getAllocTableDataSignalOperand() {
    return allocTableDataSignalOperand;
  }

  static std::vector<Cast *> &getAllocTableCast() {
    return allocTableCast;
  }

  static std::vector<Read *> &getAllocTableRead() {
    return allocTableRead;
  }

  static std::vector<Write *> &getAllocTableWrite() {
    return allocTableWrite;
  }

  static std::vector<ITE *> &getAllocTableITE() {
    return allocTableITE;
  }

  static std::vector<Assignment *> &getAllocTableAssignment() {
    return allocTableAssignment;
  }

  static std::vector<While *> &getAllocTableWhile() {
    return allocTableWhile;
  }

  static std::vector<If *> &getAllocTableIf() {
    return allocTableIf;
  }

  static std::vector<FunctionOperand *> &getAllocTableFunctionOperand() {
    return allocTableFunctionOperand;
  }

  static std::vector<ArrayOperand *> &getAllocTableSubSelect() {
    return allocTableSubSelect;
  }

  static std::vector<CompoundExpr *> &getAllocTableCompoundExpr() {
    return allocTableCompoundExpr;
  }

  static std::vector<ParamOperand *> &getAllocTableParamOperand() {
    return allocTableParamOperand;
  }

  static std::vector<Return *> &getAllocTableReturn() {
    return allocTableReturn;
  }

 private:
  Stmt *allocNodeAddress = nullptr;

  // Expr node tables
  static std::vector<VariableOperand *> allocTableVariableOperand;
  static std::vector<TimePointOperand *> allocTableTimeExprOperand;
  static std::vector<IntegerValue *> allocTableIntegerValue;
  static std::vector<UnsignedValue *> allocTableUnsignedValue;
  static std::vector<BoolValue *> allocTableBoolValue;
  static std::vector<EnumValue *> allocTableEnumValue;
  static std::vector<CompoundValue *> allocTableCompoundValue;
  static std::vector<PortOperand *> allocTablePortOperand;
  static std::vector<UnaryExpr *> allocTableUnaryExpr;
  static std::vector<SectionOperand *> allocTableSectionOperand;
  static std::vector<SectionValue *> allocTableSectionValue;
  static std::vector<Arithmetic *> allocTableArithmetic;
  static std::vector<Logical *> allocTableLogical;
  static std::vector<Relational *> allocTableRelational;
  static std::vector<Bitwise *> allocTableBitwise;
  static std::vector<SyncSignal *> allocTableSyncSignal;
  static std::vector<DataSignalOperand *> allocTableDataSignalOperand;
  static std::vector<Cast *> allocTableCast;

  // Stmt node tables
  static std::vector<Read *> allocTableRead;
  static std::vector<Write *> allocTableWrite;
  static std::vector<ITE *> allocTableITE;
  static std::vector<Assignment *> allocTableAssignment;
  static std::vector<While *> allocTableWhile;
  static std::vector<If *> allocTableIf;
  static std::vector<FunctionOperand *> allocTableFunctionOperand;
  static std::vector<ArrayOperand *> allocTableSubSelect;
  static std::vector<CompoundExpr *> allocTableCompoundExpr;
  static std::vector<ParamOperand *> allocTableParamOperand;
  static std::vector<Return *> allocTableReturn;

  static std::vector<ArrayExpr *> allocTableArrayExpr;

 protected:
  void visit(class VariableOperand &node) override;

  void visit(class TimePointOperand &node) override;

  void visit(class IntegerValue &node) override;

  void visit(class UnsignedValue &node) override;

  void visit(class BoolValue &node) override;

  void visit(class EnumValue &node) override;

  void visit(class CompoundValue &node) override;

  void visit(class PortOperand &node) override;

  void visit(class Assignment &node) override;

  void visit(class UnaryExpr &node) override;

  void visit(class While &node) override;

  void visit(class If &node) override;

  void visit(class SectionOperand &node) override;

  void visit(class SectionValue &node) override;

  void visit(class ITE &node) override;

  void visit(class Arithmetic &node) override;

  void visit(class Logical &node) override;

  void visit(class Relational &node) override;

  void visit(class Bitwise &node) override;

  void visit(class Read &node) override;

  void visit(class Write &node) override;

  void visit(class SyncSignal &node) override;

  void visit(class DataSignalOperand &node) override;

  void visit(class Cast &node) override;

  void visit(class FunctionOperand &node) override;

  void visit(class ArrayOperand &node) override;

  void visit(class CompoundExpr &node) override;

  void visit(class ParamOperand &node) override;

  void visit(class Return &node) override;

  void visit(class Notify &node) override;

  void visit(class Wait &node) override;

  void visit(class Peek &node) override;

  void visit(class ArrayExpr &node) override;
  void visit(class Ternary &node) override;

};
}

#endif //PROJECT_STMTNODEALLOC_H
