//
// Created by burr on 16.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_GETCLANGFUNCTIONS_H_
#define SCAM_SRC_MODELFACTORY_GETCLANGFUNCTIONS_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include "map"

namespace DESCAM {
class GetClangFunctions: public clang::RecursiveASTVisitor<GetClangFunctions>  {
 public:
  explicit GetClangFunctions(clang::CXXRecordDecl* record_decl);

  virtual bool VisitCXXMethodDecl(clang::CXXMethodDecl *methodDecl);

  const std::map<std::string, clang::CXXMethodDecl *> &getFunctionMap() const;

  const std::map<std::string, std::string> &getFunctionReturnTypeMap() const;

  const std::map<std::string, std::vector<std::string>> &getFunctionParamNameMap() const;

  const std::map<std::string, std::vector<std::string>> &getFunctionParamTypeMap() const;

 private:
  std::map<std::string, clang::CXXMethodDecl *> function_map_;
  std::map<std::string, std::string> function_return_type_map_;

  std::string clangToScamType(clang::QualType qualType) const;

  std::map<std::string, std::vector<std::string>> function_param_name_map_;
  std::map<std::string, std::vector<std::string>> function_param_type_map_;
};
}
#endif //SCAM_SRC_MODELFACTORY_GETCLANGFUNCTIONS_H_
