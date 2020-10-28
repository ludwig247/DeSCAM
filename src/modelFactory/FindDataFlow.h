//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_FINDDATAFLOW_H
#define SCAM_FINDDATAFLOW_H

#include "IFindDataFlow.h"
#include "IFindStateName.h"

namespace DESCAM {
class Module;
class Process;
class IFindDataFlowFactory;

/**
 * \brief processes a clang::stmt and extract all necessary information from it
 *
 * Different stages:
 * pass=0: Looking for operation(assignment, binary operator, member call, function call)
 * pass=1: Find LHS operator
 * pass=2: Find RHS operator
 */
class FindDataFlow : public IFindDataFlow, public clang::RecursiveASTVisitor<FindDataFlow> {
 public:
  /*static int count;*/

  FindDataFlow(DESCAM::IFindStateName *find_state_name, IFindDataFlowFactory *find_data_flow_factory);
  bool setup(clang::Stmt *stmt, Module *module,
             clang::CompilerInstance *ci,
             bool unsigned_flag) override;
  Expr *getExpr() const override;
  DESCAM::Stmt *getStmt() override;

  static std::string functionName;
  static bool isFunction;
  //Operator
  bool VisitBinaryOperator(clang::BinaryOperator *binaryOperator);
  bool VisitConditionalOperator(clang::ConditionalOperator *conditionalOperator);
  bool VisitUnaryOperator(clang::UnaryOperator *unaryOperator);
  bool VisitCXXMemberCallExpr(clang::CXXMemberCallExpr *memberCallExpr);
  bool VisitWhileStmt(clang::WhileStmt *whileStmt);
  bool VisitIfStmt(clang::IfStmt *ifStmt);
  bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *operatorCallExpr);

  bool VisitMemberExpr(clang::MemberExpr *memberExpr);
  bool VisitIntegerLiteral(clang::IntegerLiteral *integerLiteral);
  bool VisitCXXBoolLiteralExpr(clang::CXXBoolLiteralExpr *boolLiteralExpr);
  bool VisitDeclRefExpr(clang::DeclRefExpr *varDecl);
  bool VisitCXXStaticCastExpr(clang::CXXStaticCastExpr *staticCastExpr);
  bool VisitCompoundStmt(clang::CompoundStmt *compoundStmt);

  bool VisitCallExpr(clang::CallExpr *callExpr);
  bool VisitImplicitCastExpr(clang::ImplicitCastExpr *implicitCastExpr);
  bool VisitReturnStmt(clang::ReturnStmt *returnStmt);

  bool VisitArraySubscriptExpr(clang::ArraySubscriptExpr *arraySubscriptExpr);

 private:
  Module *module_; //! Module the dataflow is generated for
  DESCAM::Stmt *stmt_; //! Represents the stmt in case of operator, values are stored in lhs and rhs
  clang::CompilerInstance *ci_;
  IFindDataFlowFactory *find_data_flow_factory_;
  IFindStateName *find_state_name_;

  Expr *expr_;
  Expr *lhs_expr_; //! Assign Operation lValue = rValue
  Expr *rhs_expr_;//! Assign Operation lValue = rValue
  int pass_;
  bool unsigned_flag_;

  std::stringstream log_stream_; //! Contains every message that is generated during

  void switchPassExpr(Expr *stmt); //! Depending on the current value of pass assigns value to stmt(pass==0), lhs(1) or rhs(2)
  bool exitVisitor(const std::string &msg, const DESCAM::LocationInfo &stmtInfo);
  void clearExpressions();
};

}

#endif //SCAM_FINDDATAFLOW_H
