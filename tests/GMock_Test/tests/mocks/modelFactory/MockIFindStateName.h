//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDSTATENAME_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDSTATENAME_H_

#include "IFindStateName.h"
#include <gmock/gmock.h>

namespace DESCAM {
namespace MOCK {

class MockIFindStateName : public IFindStateName {
 public:
  MOCK_METHOD(bool, setup, (clang::Stmt * ), (override));
  MOCK_METHOD((const std::string &), getStateName, (), (const, override));
};
}
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDSTATENAME_H_
