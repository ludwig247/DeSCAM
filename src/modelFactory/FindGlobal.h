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
#include "FindDataFlowFactory.h"

namespace DESCAM {
class FindGlobal : public IFindGlobal, public clang::RecursiveASTVisitor<FindGlobal> {
 public:

  FindGlobal() = default;

  ~FindGlobal() override = default;

  bool setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance *ci, IFindDataFlowFactory * find_data_flow_factory) override;

  const std::map<std::string, Variable *> &getVariableMap() const override;

  const std::map<std::string, Function *> &getFunctionMap() const override;

  const std::map<std::string, const clang::FunctionDecl *> &getFunctionDeclMap() const override;

  bool VisitVarDecl(const clang::VarDecl *var_decl);

  bool VisitFunctionDecl(const clang::FunctionDecl *function_decl);

 private:
  IFindDataFlowFactory * find_data_flow_factory_;
  clang::CompilerInstance *ci_;
  static DESCAM::DataType *getDataType(const clang::QualType &type) ;

  clang::TranslationUnitDecl *decl_;
  DESCAM::Module module_ = Module("placeholder");

  std::map<std::string, Variable *> variable_map_;
  std::map<std::string, Function *> function_map_;
  std::map<std::string, const clang::FunctionDecl *> function_decl_map_;

};
}

#endif //DESCAM_FINDGLOBAL_H
