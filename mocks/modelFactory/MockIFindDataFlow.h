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

  MOCK_METHOD((Expr *), getExpr, (), (const, override));
  MOCK_METHOD((DESCAM::Stmt *), getStmt, (), (override));
  
};
}
#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDDATAFLOW_H_
