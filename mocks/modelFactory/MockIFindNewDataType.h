//
// Created by schwarz on 12.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDNEWDATATYPE_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDNEWDATATYPE_H_

#include "IFindNewDatatype.h"

namespace DESCAM {
namespace MOCK {

class MockIFindNewDatatype : public IFindNewDatatype {
 public:
  MOCK_METHOD(DESCAM::DataType
  *, getDataType, (const clang::QualType &), (override));
  MOCK_METHOD(std::string, getTypeName,
  (const clang::QualType &), (override));
  MOCK_METHOD(bool, isGlobal,(const clang::QualType &), (override)
  );
};
}
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDNEWDATATYPE_H_
