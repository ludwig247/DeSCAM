//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_FINDCOMBINATIONALFUNCTION_H
#define PROJECT_FINDCOMBINATIONALFUNCTION_H

#include <map>
#include "IFindFunctions.h"
#include "clang/AST/RecursiveASTVisitor.h"

namespace DESCAM {
/***
 * \brief Finds all "combinational" functions of a module
 *
 * Functions are considered const if they are const with respect to the class and thereby don't change the state of the class.
 */
class FindFunctions : public IFindFunctions, public clang::RecursiveASTVisitor<FindFunctions> {
 public:
  FindFunctions();

  bool setup(clang::CXXRecordDecl *recordDecl) override;

  bool VisitCXXMethodDecl(clang::CXXMethodDecl *methodDecl);

  const std::map<std::string, clang::CXXMethodDecl *> &getFunctionMap() const override;

  const std::map<std::string, std::string> &getFunctionReturnTypeMap() const override;

  const std::map<std::string, std::vector<std::string>> &getFunctionParamNameMap() const override;

  const std::map<std::string, std::vector<std::string>> &getFunctionParamTypeMap() const override;

 private:

  /**
   * Resets the object back to its initial state
   */
  void clean();

  std::map<std::string, clang::CXXMethodDecl *> function_map_;
  std::map<std::string, std::string> function_return_type_map_;

  std::string clangToScamType(clang::QualType qualType) const;

  std::map<std::string, std::vector<std::string>> function_param_name_map_;
  std::map<std::string, std::vector<std::string>> function_param_type_map_;
};
}

#endif //PROJECT_FINDCOMBINATIONALFUNCTION_H
