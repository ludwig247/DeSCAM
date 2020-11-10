//
// Created by tobias on 28.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDINSTANCES_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDINSTANCES_H_

#include "IFindInstances.h"
#include <gmock/gmock.h>

namespace DESCAM {
namespace MOCK {

/**
 * @brief Visits the constructors of a sc_module in order to find inital values for members
 */
class MockIFindInstances : public IFindInstances {
 public:
  MOCK_METHOD(bool,setup,(clang::TranslationUnitDecl *tu, Model * const model),(override));
  MOCK_METHOD((ModuleInstance*),getModuleInstance,(),(override));
};
}
}
#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDINSTANCES_H_
