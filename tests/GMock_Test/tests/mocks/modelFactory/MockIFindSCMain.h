//
// Created by schwarz on 09.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_MOCKS_MODELFACTORY_MOCKIFINDSCMAIN_H_
#define SCAM_TESTS_GMOCK_TEST_MOCKS_MODELFACTORY_MOCKIFINDSCMAIN_H_

#include <gmock/gmock.h>
#include <IFindSCMain.h>

namespace DESCAM {
namespace MOCK {

class MockIFindSCMain : public IFindSCMain {
 public:
  MOCK_METHOD(bool, setup, (clang::TranslationUnitDecl * ), (override));
  MOCK_METHOD(bool, isScMainFound, (), (const, override));
  MOCK_METHOD((clang::FunctionDecl * ), getSCMainFunctionDecl, (), (override));
};
}
}
#endif //SCAM_TESTS_GMOCK_TEST_MOCKS_MODELFACTORY_MOCKIFINDSCMAIN_H_
