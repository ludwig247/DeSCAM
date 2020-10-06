//
// Created by burr on 06.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_FINDFUNCTIONSFACTORY_H_
#define SCAM_SRC_MODELFACTORY_FINDFUNCTIONSFACTORY_H_

#include "IFindFunctions.h"
#include "FindFunctions.h"

namespace DESCAM {
/**
 * @brief Factory-Class for FindDataFlow
 */
class FindFunctionsFactory {
 public:
  /**
   * @brief Creates a new instance of FindFunctions
   * @param recordDecl ?
   * @return Smart pointer to FindFunctions object
   */
  static std::unique_ptr<IFindFunctions> create(clang::CXXRecordDecl *recordDecl) {
    std::unique_ptr<IFindFunctions> pointer(new FindFunctions(recordDecl));
    return pointer;
  }
};
}

#endif //SCAM_SRC_MODELFACTORY_FINDFUNCTIONSFACTORY_H_
