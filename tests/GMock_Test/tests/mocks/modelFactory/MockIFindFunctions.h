//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_MOCKS_MODELFACTORY_MOCKIFINDFUNCTIONS_H_
#define SCAM_TESTS_GMOCK_TEST_MOCKS_MODELFACTORY_MOCKIFINDFUNCTIONS_H_

#include <gmock/gmock.h>
#include <IFindFunctions.h>

namespace DESCAM {
namespace MOCK {

class MockIFindFunctions : public IFindFunctions {
 public:
  typedef std::map<std::string, std::string> string_map;
  typedef std::map<std::string, std::vector<std::string>> vector_string_map;

  MOCK_METHOD(bool, setup, (clang::CXXRecordDecl * , clang::CompilerInstance *, Module *), (override));
  MOCK_METHOD((std::map<std::string, Function *>), getFunctionDecls, (), (const, override));
  MOCK_METHOD((std::map<int, CfgBlock *>), getFunctionBody, (std::string), (const, override));
};
}
}
#endif //SCAM_TESTS_GMOCK_TEST_MOCKS_MODELFACTORY_MOCKIFINDFUNCTIONS_H_
