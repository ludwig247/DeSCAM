//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDGLOBAL_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDGLOBAL_H_

#include "IFindGlobal.h"
#include "gmock/gmock.h"

namespace DESCAM {
namespace MOCK {
/**
 * TODO Comment for DoD
 */
class MockIFindGlobal : public IFindGlobal {
 public:

  MOCK_METHOD(bool, setup, (clang::TranslationUnitDecl * decl, clang::CompilerInstance * ci), (override));

  MOCK_METHOD((const std::map<std::string, Variable *> &), getVariableMap, (), (const, override));

  MOCK_METHOD((const std::map<std::string, Function *> &), getFunctionMap, (), (const, override));

  MOCK_METHOD((std::vector<DESCAM::Stmt *>), getFunctionBody, (std::string, DESCAM::Function *), (const, override));
};
}
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDGLOBAL_H_
