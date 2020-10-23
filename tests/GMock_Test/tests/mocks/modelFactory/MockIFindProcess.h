//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPROCESS_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPROCESS_H_

#include "IFindProcess.h"
#include <gmock/gmock.h>

namespace DESCAM {
namespace MOCK {

/**
 * TODO Comment
 */
class MockIFindProcess : public IFindProcess {
 public:

  MOCK_METHOD(bool,
              setup,
              (clang::CXXRecordDecl * recordDecl, clang::CompilerInstance * ci, Module * module, Model * model),
              (override));
  //Getter
  MOCK_METHOD((std::map<int, DESCAM::CfgNode *>), getCfgArg, (), (const, override));
  MOCK_METHOD((std::shared_ptr<PropertySuite>), getPropertySuite, (), (const, override));

};
}
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPROCESS_H_
