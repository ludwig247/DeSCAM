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

  explicit FindGlobal(IFindDataFlowFactory *find_data_flow_factory);

  ~FindGlobal() override = default;

  bool setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance *ci) override;

  const std::map<std::string, Variable *> &getVariableMap() const override;

  const std::map<std::string, Function *> &getFunctionMap() const override;

  std::vector<DESCAM::Stmt *> getFunctionBody(std::string function_name,
                                              DESCAM::Function *function) const override;

  bool VisitVarDecl(const clang::VarDecl *varDecl);

  bool VisitFunctionDecl(const clang::FunctionDecl *funDecl);

 private:
  IFindDataFlowFactory *find_data_flow_factory_;
  clang::CompilerInstance *ci_;
  DESCAM::DataType *getDataType(const clang::QualType &type) const;

  clang::TranslationUnitDecl *decl_;
  DESCAM::Module module_ = Module("placeholder");

  std::map<std::string, Variable *> variable_map_;
  std::map<std::string, Function *> function_map_;
  std::map<std::string, const clang::FunctionDecl *> function_decl_map_;

};
}

#endif //DESCAM_FINDGLOBAL_H
