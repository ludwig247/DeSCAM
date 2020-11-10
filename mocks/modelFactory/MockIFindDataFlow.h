//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDDATAFLOW_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDDATAFLOW_H_
//Clang

#include "IFindDataFlow.h"
#include <gmock/gmock.h>

namespace DESCAM {

/**
 * @brief processes a clang::stmt and extract all necessary information from it
 */
class MockIFindDataFlow: public IFindDataFlow {
 public:

  MOCK_METHOD(bool, VisitBinaryOperator, (clang::BinaryOperator *binaryOperator), (override));
  MOCK_METHOD(bool, VisitConditionalOperator, (clang::ConditionalOperator *conditionalOperator), (override));
  MOCK_METHOD(bool, VisitUnaryOperator, (clang::UnaryOperator *unaryOperator), (override));
  MOCK_METHOD(bool, VisitCXXMemberCallExpr, (clang::CXXMemberCallExpr *memberCallExpr), (override));
  MOCK_METHOD(bool, VisitWhileStmt, (clang::WhileStmt *whileStmt), (override));
  MOCK_METHOD(bool,  VisitIfStmt, (clang::IfStmt *ifStmt), (override));
  MOCK_METHOD(bool,  VisitCXXOperatorCallExpr, (clang::CXXOperatorCallExpr *operatorCallExpr), (override));

  MOCK_METHOD(bool,  VisitMemberExpr, (clang::MemberExpr *memberExpr), (override));
  MOCK_METHOD(bool,  VisitIntegerLiteral, (clang::IntegerLiteral *integerLiteral), (override));
  MOCK_METHOD(bool,  VisitCXXBoolLiteralExpr, (clang::CXXBoolLiteralExpr *boolLiteralExpr), (override));
  MOCK_METHOD(bool,  VisitDeclRefExpr, (clang::DeclRefExpr *varDecl), (override));
  MOCK_METHOD(bool,  VisitCXXStaticCastExpr, (clang::CXXStaticCastExpr *staticCastExpr), (override));
  MOCK_METHOD(bool,  VisitCompoundStmt, (clang::CompoundStmt *compoundStmt), (override));

  MOCK_METHOD(bool,  VisitCallExpr, (clang::CallExpr *callExpr), (override));
  MOCK_METHOD(bool,  VisitImplicitCastExpr, (clang::ImplicitCastExpr *implicitCastExpr), (override));
  MOCK_METHOD(bool,  VisitReturnStmt, (clang::ReturnStmt *returnStmt), (override));

  MOCK_METHOD(bool,  VisitArraySubscriptExpr, (clang::ArraySubscriptExpr *arraySubscriptExpr), (override));
  MOCK_METHOD((Expr *), getExpr, (), (const, override));
  MOCK_METHOD((DESCAM::Stmt *), getStmt, (), (override));
  
};
}
#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDDATAFLOW_H_
