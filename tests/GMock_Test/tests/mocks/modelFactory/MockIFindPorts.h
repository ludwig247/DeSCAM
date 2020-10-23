//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPORTS_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPORTS_H_

#include "clang/Frontend/CompilerInstance.h"
#include "IFindPorts.h"
#include <gmock/gmock.h>

class MockIFindPorts : public IFindPorts {
 public:
  MOCK_METHOD(bool, setup, (clang::CXXRecordDecl * recordDecl, clang::CompilerInstance * ci), (override))
  bool setup(clang::CXXRecordDecl *gmock_a0, clang::CompilerInstance *gmock_a1, DESCAM::Module *module)
  ;
  //GETTER
  MOCK_METHOD((const std::map<std::string, std::string> &), getInPortMap, (), (const, override));
  MOCK_METHOD((const std::map<std::string, std::string> &), getOutPortMap, (), (const, override));

  MOCK_METHOD((const std::map<std::string, std::string> &), getInSharedPortMap, (), (const, override));
  MOCK_METHOD((const std::map<std::string, std::string> &), getOutSharedPortMap, (), (const, override));

  MOCK_METHOD((const std::map<std::string, std::string> &), getMasterInPortMap, (), (const, override));
  MOCK_METHOD((const std::map<std::string, std::string> &), getMasterOutPortMap, (), (const, override));

  MOCK_METHOD((const std::map<std::string, std::string> &), getSlaveInPortMap, (), (const, override));
  MOCK_METHOD((const std::map<std::string, std::string> &), getSlaveOutPortMap, (), (const, override));

  MOCK_METHOD((const std::map<std::string, DESCAM::LocationInfo> &), getLocationInfoMap, (), (const, override));
};
#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPORTS_H_
