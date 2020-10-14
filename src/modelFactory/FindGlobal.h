//
// Created by tobias on 13.11.19.
//

#ifndef DESCAM_FINDGLOBAL_H
#define DESCAM_FINDGLOBAL_H

#include <map>
#include <string>
#include <Module.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include <IFindGlobal.h>
#include "FindDataFlow.h"

namespace DESCAM {
class FindGlobal : public IFindGlobal, public clang::RecursiveASTVisitor<FindGlobal> {
 public:

  FindGlobal() = default;

  ~FindGlobal() override = default;

  bool setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance *ci,IFindDataFlow * find_data_flow_) override;

  const std::map<std::string, Variable *> &getVariableMap() const override;

  const std::map<std::string, Function *> &getFunctionMap() const override;

  const std::map<std::string, const clang::FunctionDecl *> &getFunctionDeclMap() const override;

  bool VisitVarDecl(const clang::VarDecl *varDecl);

  bool VisitFunctionDecl(const clang::FunctionDecl *funDecl);

 private:

  clang::CompilerInstance *ci_;
  DESCAM::DataType *getDataType(const clang::QualType &type) const;

  clang::TranslationUnitDecl *decl_;
  IFindDataFlow * find_data_flow_;
  DESCAM::Module module_ = Module("placeholder");

  std::map<std::string, Variable *> variable_map_;
  std::map<std::string, Function *> function_map_;
  std::map<std::string, const clang::FunctionDecl *> functionDeclMap;

};
}

#endif //DESCAM_FINDGLOBAL_H
