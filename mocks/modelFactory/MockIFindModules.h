//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDMODULES_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDMODULES_H_

#include "IFindModules.h"
#include "gmock/gmock.h"

namespace DESCAM {
namespace MOCK {
class MockIFindModules : public IFindModules {
 public:
  MOCK_METHOD(void,
              setup,
              (clang::TranslationUnitDecl * , clang::CompilerInstance * ci, DESCAM::Model * model),
              (override));
  MOCK_METHOD((std::vector<DESCAM::Module *>), getModules, (), (override));
};
}
}
#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDMODULES_H_
