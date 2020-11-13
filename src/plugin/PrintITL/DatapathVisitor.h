//
// Created by ludwig on 29.08.16.
//

#ifndef SCAM_DATAPATHVISITOR_H
#define SCAM_DATAPATHVISITOR_H

#include <PrintStmt.h>

namespace DESCAM {

/**
 * \brief: Visitor that translates rhs of assignment in datapath
 *
 * There just some methods from the stmt visitor replaced
 *
 * \attention: only use during creation of prove part for operations
 *
 * \example:
 * cnt = 1 + cnt
 * lcd_value = lcd_value + sensor->read()
 *
 * is translated into
 *
 * cnt = 1 + cnt_at_t
 * lcd_value = lcd_value_at_t + sensor_sig_at_t
 */
class DatapathVisitor : public PrintStmt {
 public:
  DatapathVisitor() = default;
  explicit DatapathVisitor(std::string tp);
  static std::string toString(Stmt *stmt,
                              unsigned int indentSize = 2,
                              unsigned int indentOffset = 0,
                              std::string tp = "_at_t");

 protected:
  void visit(class VariableOperand &node) override;

  void visit(class SyncSignal &node) override;

  void visit(class Arithmetic &node) override;

  void visit(class Bitwise &node) override;

  void visit(class Relational &node) override;

  void visit(class DataSignalOperand &node) override;

  void visit(class IntegerValue &node) override;

  void visit(class UnsignedValue &node) override;

  void visit(class Cast &node) override;

  void visit(class CompoundExpr &node) override;

  void visit(class ArrayOperand &node) override;

  void visit(class UnaryExpr &node) override;

  void visit(class Ternary &node) override;

  bool resize_flag = false;
  std::string tp = "_at_t";
};

}

#endif //SCAM_DATAPATHVISITOR_H
