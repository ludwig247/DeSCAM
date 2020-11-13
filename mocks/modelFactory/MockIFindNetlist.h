//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDNETLIST_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDNETLIST_H_

#include <map>
#include <IFindNetlist.h>
#include <gmock/gmock.h>

namespace DESCAM {

class MockIFindNetlist: public IFindNetlist {
 public:

  MOCK_METHOD(bool, setup, (clang::FunctionDecl *), (override));
  //GETTER
  MOCK_METHOD((std::map<std::string, std::string>), getInstanceMap, (), (override));
  MOCK_METHOD((std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *>), getChannelMap, (), (override));
};
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDNETLIST_H_
