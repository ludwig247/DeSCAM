//
// Created by burr on 27.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDDATAFLOWFACTORY_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDDATAFLOWFACTORY_H_

#include "IFindDataFlowFactory.h"
#include <gmock/gmock.h>

namespace DESCAM{
namespace MOCK{
 class MockIFindDataFlowFactory: public IFindDataFlowFactory{
  public:
   MOCK_METHOD((IFindDataFlow *),create_new,(clang::Stmt *,Module *,clang::CompilerInstance *,bool));
 };
}
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MOCKS_MODELFACTORY_MOCKIFINDDATAFLOWFACTORY_H_
