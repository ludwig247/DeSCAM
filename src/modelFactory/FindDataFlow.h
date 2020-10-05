//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_FINDDATAFLOW_H
#define SCAM_FINDDATAFLOW_H

#include <map>
#include <iostream>
#include <clang/AST/Stmt.h>
#include <clang/Analysis/CFG.h>
#include <clang/Basic/SourceManager.h>
#include <clang/Frontend/CompilerInstance.h>
#include "clang/AST/RecursiveASTVisitor.h"

#include <Logger/Logger.h>
#include <Model.h>
#include "PrintStmt.h"
#include "IFindDataFLow.h"

namespace DESCAM {
class Module;
class Process;
/**
 * \brief processes a clang::stmt and extract all necessary information from it
 *
 * Different stages:
 * pass=0: Looking for operation(assignment,binary operator,membercall, functioncall)
 * pass=1: Find LHS operator
 * pass=2: Find RHS operator
 */
class FindDataFlow : public IFindDataFlow {
 public:
  FindDataFlow(clang::Stmt *stmt, Module *module, clang::CompilerInstance &ci, bool unsigned_flag = false);
  //Operator
  bool VisitBinaryOperator(clang::BinaryOperator *binaryOperator) override;
  bool VisitConditionalOperator(clang::ConditionalOperator *conditionalOperator) override;
  bool VisitUnaryOperator(clang::UnaryOperator *unaryOperator) override;
  bool VisitCXXMemberCallExpr(clang::CXXMemberCallExpr *memberCallExpr) override;
  bool VisitWhileStmt(clang::WhileStmt *whileStmt) override;
  bool VisitIfStmt(clang::IfStmt *ifStmt) override;
  bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *operatorCallExpr) override;

  bool VisitMemberExpr(clang::MemberExpr *memberExpr) override;
  bool VisitIntegerLiteral(clang::IntegerLiteral *integerLiteral) override;
  bool VisitCXXBoolLiteralExpr(clang::CXXBoolLiteralExpr *boolLiteralExpr) override;
  bool VisitDeclRefExpr(clang::DeclRefExpr *varDecl) override;
  bool VisitCXXStaticCastExpr(clang::CXXStaticCastExpr *staticCastExpr) override;
  bool VisitCompoundStmt(clang::CompoundStmt *compoundStmt) override;

  bool VisitCallExpr(clang::CallExpr *callExpr) override;
  bool VisitImplicitCastExpr(clang::ImplicitCastExpr *implicitCastExpr) override;
  bool VisitReturnStmt(clang::ReturnStmt *returnStmt) override;

  bool VisitArraySubscriptExpr(clang::ArraySubscriptExpr *arraySubscriptExpr) override;
  Expr *getExpr() const override;
  DESCAM::Stmt *getStmt() override;

  static std::string functionName;
  static bool isFunction;

 private:
  Module *module; //! Module the dataflow is generated for
  DESCAM::Stmt *stmt; //! Represents the stmt in case of operator, values are stored in lhs and rhs
  clang::CompilerInstance &ci;

  Expr *expr;
  Expr *lhsExpr; //! Assign Operation lValue = rValue
  Expr *rhsExpr;//! Assign Operation lValue = rValue
  int pass;

  std::stringstream logStream; //! Contains every message that is generated during

  void switchPassExpr(Expr *stmt); //! Depending on the current value of pass assigns value to stmt(pass==0), lhs(1) or rhs(2)
  bool exitVisitor(const std::string &msg, const DESCAM::LocationInfo &stmtInfo);
  void clearExpressions();

  bool unsigned_flag;
};

}

#endif //SCAM_FINDDATAFLOW_H
