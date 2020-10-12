//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPROCESS_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPROCESS_H_

#include "IFindProcess.h"
#include <gmock/gmock.h>

namespace DESCAM {

/**
 * TODO Comment
 */
class MockIFindProcess : public IFindProcess {
 public:

  MOCK_METHOD(bool, setup, (clang::CXXRecordDecl * recordDecl), (override));
  //Getter
  MOCK_METHOD((const std::map<std::string, std::pair<clang::CXXMethodDecl *, PROCESS_TYPE>> &),
              getProcessMap,
              (),
              (override));
  MOCK_METHOD(bool, isValidProcess, (), (const, override));
  MOCK_METHOD((clang::CXXMethodDecl * ), getProcess, (), (const, override));

};
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDPROCESS_H_
