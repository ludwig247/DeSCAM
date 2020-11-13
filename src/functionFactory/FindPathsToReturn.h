//
// Created by tobias on 01.07.16.
//

#ifndef SCAM_SECTIONVISITOR_H
#define SCAM_SECTIONVISITOR_H

#include <StmtAbstractVisitor.h>
#include <vector>
#include "Path.h"
#include <PrintStmt.h>
#include <Stmts_all.h>

namespace DESCAM {
/*!
 * \brief Find all paths within in a section
 *
 *
 * Two things can happen:
 * a) Non-branch node: add current stmt to all exisiting paths
 * b) branch node: duplicate all existing paths, to one half all stmts of the true branch are added
 * to the other half all stmts of the false branch are added(see visit(struct ITE))
 *  Example:
 *  @collecting
 *  if (cnt < 5) {
 *               lcd_value = lcd_value + sensor->read();
 *               sensor->nb_read(lcd_value);
 *               ++cnt;
 *               if(cnt == 5){
 *                   nextstate = printing;
 *               }
 *           }
 *
 *  Resulting paths:
 *  Path #0
 *  Conditions:
 *   cnt == 5
 *   cnt < 5
 *  Stmts:
 *   lcd_value = lcd_value + sensor->read()
 *   sensor->nb_read(lcd_value)
 *   ++cnt
 *   nextstate = printing
 *
 *  Path #1
 *  Conditions:
 *   !cnt == 5
 *   cnt < 5
 *  Stmts:
 *   lcd_value = lcd_value + sensor->read()
 *   sensor->nb_read(lcd_value)
 *   ++cnt
 *
 *  Path #2
 *  Conditions:
 *   !cnt < 5
 *  Stmts:
 *
 */

class FindPathsToReturn : public StmtAbstractVisitor {
 public:
  FindPathsToReturn() = delete;
  virtual ~FindPathsToReturn();

  explicit FindPathsToReturn(const std::vector<Stmt *> &stmtList);
  std::vector<DESCAM::Path *> getPathList();

  void visit(class ArrayExpr &node) override;

 private:

  static std::map<DESCAM::Stmt *, DESCAM::Stmt *> trueMap; //! <condition, if-stmt> Contains an entry for each if
  static std::map<DESCAM::Stmt *, DESCAM::Stmt *> falseMap; //! <condition, if-stmt> Contains an entry for each if
  void appendStmtToPaths(DESCAM::Stmt *stmt); //! Appends the current stmt to each of the paths
  std::vector<DESCAM::Path *> pathList;

  DESCAM::Stmt *find_or_add_true(Expr *conditionStmt); //! Either looks up the if-stmt for the condition or creates a new one
  DESCAM::Stmt *find_or_add_false(Expr *conditionStmt); //! Either looks up the if-stmt for the condition or creates a new one

  void visit(struct VariableOperand &node) override;
  void visit(struct TimePointOperand &node) override;
  void visit(struct IntegerValue &node) override;
  void visit(struct UnsignedValue &node) override;
  void visit(struct BoolValue &node) override;
  void visit(struct EnumValue &node) override;
  void visit(struct CompoundValue &node) override;
  void visit(class PortOperand &node) override;
  void visit(class Assignment &node) override;
  void visit(struct UnaryExpr &node) override;
  void visit(struct While &node) override;
  void visit(struct If &node) override;
  void visit(struct Read &node) override;
  void visit(struct Wait &node) override;
  void visit(class DESCAM::Peek &node) override;
  void visit(struct Write &node) override;
  void visit(struct SectionOperand &node) override;
  void visit(class SectionValue &node) override;
  void visit(struct ITE &node) override;
  void visit(struct Arithmetic &node) override;
  void visit(struct Logical &node) override;
  void visit(struct Bitwise &node) override;
  void visit(struct Relational &node) override;
  void visit(struct SyncSignal &node) override;
  void visit(struct DataSignalOperand &node) override;
  void visit(struct Cast &node) override;
  void visit(class DESCAM::FunctionOperand &node) override;
  void visit(class CompoundExpr &node) override;
  void visit(class DESCAM::ArrayOperand &node) override;
  void visit(class DESCAM::ParamOperand &node) override;
  void visit(class DESCAM::Return &node) override;
  void visit(class DESCAM::Notify &node) override;
  void visit(class DESCAM::Ternary &node) override;

};

}

#endif //SCAM_SECTIONVISITOR_H
