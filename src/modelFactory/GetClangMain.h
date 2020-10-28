#ifndef _FIND_SCMAIN_H_
#define _FIND_SCMAIN_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include "IFindSCMain.h"

namespace DESCAM {
/*!
 * \brief Finds the sc_main within a TranslationUnit
 */
class GetClangMain : public IFindSCMain, public clang::RecursiveASTVisitor<GetClangMain> {
 public:
  ~GetClangMain() override = default;

  virtual bool VisitFunctionDecl(clang::FunctionDecl *functionDecl);

  bool setup(clang::TranslationUnitDecl *) override;
  bool isScMainFound() const override;

  clang::FunctionDecl *getSCMainFunctionDecl() override;

 private:
  clang::FunctionDecl *scmain_function_decl_;
  clang::TranslationUnitDecl * unit_decl_;
  int pass_;
  bool sc_main_found_;

};
}
#endif
