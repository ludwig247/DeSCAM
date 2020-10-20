//
// Created by burr on 05.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDFUNCTIONS_H_
#define SCAM_SRC_MODELFACTORY_IFINDFUNCTIONS_H_

#include "clang/AST/DeclCXX.h"
#include "CfgBlock.h"
#include <map>

namespace DESCAM {
/**
 * @brief Finds all "combinational" functions of a module
 */
class IFindFunctions {
 public:
  virtual ~IFindFunctions() = default;

  /**
   * @brief Setup for the FindFunction class. Result can be retrieved by calling getFunctionDecl
   * @param record_decl
   * @param ci
   * @param module_name
   * @param module
   * @return
   */
  virtual bool setup(clang::CXXRecordDecl *record_decl,
                     clang::CompilerInstance *ci,
                     std::string module_name,
                     Module *module) = 0;

  /**
  * @brief Returns all Function-declarations for the provided record_Decl
  * @return map with function name and function object without body
  */
  virtual std::map<std::string, Function *> getFunctionDecls() const = 0;
  /**
   * @brief returns the Body of a function
   * @param name name of the function
   * @return body of the function
   */
  virtual std::map<int, CfgBlock *> getFunctionBody(std::string name) const = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDFUNCTIONS_H_
