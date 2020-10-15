//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDINITIALVALUES_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDINITIALVALUES_H_

#include "IFindInitialValues.h"
#include <gmock/gmock.h>

namespace DESCAM {
namespace MOCK {

/**
 * @brief Visits the constructors of a sc_module in order to find inital values for members
 */
class MockIFindInitialValues : public IFindInitialValues {
 public:


  MOCK_METHOD(void,
              setup,
              (clang::CXXRecordDecl * recordDecl, clang::FieldDecl * fieldDecl, DESCAM::Module * module,
                  clang::CompilerInstance * ci),
              (override));

  MOCK_METHOD((ConstValue * ), getInitValue, (), (override));
};
}
}
#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDINITIALVALUES_H_
