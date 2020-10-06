//
// Created by burr on 06.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_FINDFUNCTIONSFACTORY_H_
#define SCAM_SRC_MODELFACTORY_FINDFUNCTIONSFACTORY_H_

#include "IFindFunctions.h"
#include "FindFunctions.h"

namespace DESCAM {
class FindFunctionsFactory {
 public:
  static std::unique_ptr<IFindFunctions> create(clang::CXXRecordDecl *recordDecl) {
    std::unique_ptr<IFindFunctions> pointer(new FindFunctions(recordDecl));
    return pointer;
  }
};
}

#endif //SCAM_SRC_MODELFACTORY_FINDFUNCTIONSFACTORY_H_
