//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPORTS_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPORTS_H_

#include "clang/Frontend/CompilerInstance.h"
#include "IFindPorts.h"
#include <gmock/gmock.h>

namespace DESCAM {
namespace MOCK {

class MockIFindPorts : public IFindPorts {
 public:
  MOCK_METHOD(bool,
              setup,
              (clang::CXXRecordDecl * recordDecl, clang::CompilerInstance * ci, DESCAM::Module * module),
              (override));
  MOCK_METHOD((std::map<std::string, DESCAM::Port *>), getPortMap, (), (const, override));
};
}
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPORTS_H_
