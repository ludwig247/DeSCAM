//
// Created by burr on 05.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_
#define SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_

//Clang
#include "clang/AST/RecursiveASTVisitor.h"
#include <clang/AST/Stmt.h>

#include "PrintStmt.h"

namespace DESCAM {

/**
 * @brief processes a clang::stmt and extract all necessary information from it
 */
class IFindDataFlow : public clang::RecursiveASTVisitor<IFindDataFlow> {
 public:
  virtual ~IFindDataFlow() = default;

  virtual bool VisitBinaryOperator(clang::BinaryOperator *binaryOperator) = 0;
  virtual bool VisitConditionalOperator(clang::ConditionalOperator *conditionalOperator) = 0;
  virtual bool VisitUnaryOperator(clang::UnaryOperator *unaryOperator) = 0;
  virtual bool VisitCXXMemberCallExpr(clang::CXXMemberCallExpr *memberCallExpr) = 0;
  virtual bool VisitWhileStmt(clang::WhileStmt *whileStmt) = 0;
  virtual bool VisitIfStmt(clang::IfStmt *ifStmt) = 0;
  virtual bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *operatorCallExpr) = 0;

  virtual bool VisitMemberExpr(clang::MemberExpr *memberExpr) = 0;
  virtual bool VisitIntegerLiteral(clang::IntegerLiteral *integerLiteral) = 0;
  virtual bool VisitCXXBoolLiteralExpr(clang::CXXBoolLiteralExpr *boolLiteralExpr) = 0;
  virtual bool VisitDeclRefExpr(clang::DeclRefExpr *varDecl) = 0;
  virtual bool VisitCXXStaticCastExpr(clang::CXXStaticCastExpr *staticCastExpr) = 0;
  virtual bool VisitCompoundStmt(clang::CompoundStmt *compoundStmt) = 0;

  virtual bool VisitCallExpr(clang::CallExpr *callExpr) = 0;
  virtual bool VisitImplicitCastExpr(clang::ImplicitCastExpr *implicitCastExpr) = 0;
  virtual bool VisitReturnStmt(clang::ReturnStmt *returnStmt) = 0;

  virtual bool VisitArraySubscriptExpr(clang::ArraySubscriptExpr *arraySubscriptExpr) = 0;
  virtual Expr *getExpr() const = 0;
  virtual DESCAM::Stmt *getStmt() = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDDATAFLOW_H_
