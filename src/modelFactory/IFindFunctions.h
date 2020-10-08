//
// Created by burr on 05.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDFUNCTIONS_H_
#define SCAM_SRC_MODELFACTORY_IFINDFUNCTIONS_H_

#include "clang/AST/DeclCXX.h"
#include <map>

namespace DESCAM {
/**
 * @brief Finds all "combinational" functions of a module
 */
class IFindFunctions {
 public:
  virtual ~IFindFunctions() = default;

  /**
   * @brief setup for the IFindFunctions class
   * @param recordDecl ?
   */
  virtual void setup(clang::CXXRecordDecl *recordDecl) = 0;

  virtual const std::map<std::string, clang::CXXMethodDecl *> &getFunctionMap() const = 0;
  virtual const std::map<std::string, std::string> &getFunctionReturnTypeMap() const = 0;
  virtual const std::map<std::string, std::vector<std::string>> &getFunctionParamNameMap() const = 0;
  virtual const std::map<std::string, std::vector<std::string>> &getFunctionParamTypeMap() const = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDFUNCTIONS_H_
