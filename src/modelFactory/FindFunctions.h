//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_FINDCOMBINATIONALFUNCTION_H
#define PROJECT_FINDCOMBINATIONALFUNCTION_H

#include <clang/AST/RecursiveASTVisitor.h>
#include <map>
#include "IFindFunctions.h"

namespace DESCAM {
/***
 * \brief Finds all "combinational" functions of a module
 *
 * Functions are considered const if they are const with respect to the class and thereby don't change the state of the class.
 */
class FindFunctions : public IFindFunctions {
 public:
  FindFunctions(clang::CXXRecordDecl *recordDecl);
  virtual bool VisitCXXMethodDecl(clang::CXXMethodDecl *methodDecl) override;

  const std::map<std::string, clang::CXXMethodDecl *> &getFunctionMap() const override;

  const std::map<std::string, std::string> &getFunctionReturnTypeMap() const override;

  const std::map<std::string, std::vector<std::string>> &getFunctionParamNameMap() const override;

  const std::map<std::string, std::vector<std::string>> &getFunctionParamTypeMap() const override;

 private:

  std::map<std::string, clang::CXXMethodDecl *> functionMap;
  std::map<std::string, std::string> functionReturnTypeMap;

  std::string clangToScamType(clang::QualType qualType);

  std::map<std::string, std::vector<std::string>> functionParamNameMap;
  std::map<std::string, std::vector<std::string>> functionParamTypeMap;
};
}

#endif //PROJECT_FINDCOMBINATIONALFUNCTION_H
