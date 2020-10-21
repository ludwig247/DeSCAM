//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDVARIABLES_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDVARIABLES_H_

#include "IFindVariables.h"
#include <gmock/gmock.h>

namespace DESCAM {
/**
  ** \brief Interface finding fieldDecl of a recordDecl, i.e., Member Variables
  **
  ** Ports are covered by find Ports. Hence, here we're looking for everything else.
  ** For now, we are considering built-in types only. Here we are also able to track down
  ** Types that are not supported!
 */

class MockIFindVariables: public IFindVariables {
 public:
  //GETTER
  MOCK_METHOD(bool, setup, (clang::CXXRecordDecl *record_decl, clang::CompilerInstance *ci, DESCAM::Module *module), (override));
  MOCK_METHOD((std::map<std::string, DESCAM::Variable *>), getVariableMap, (), (override));

};
}
#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDVARIABLES_H_
