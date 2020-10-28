#ifndef _FIND_SCMAIN_H_
#define _FIND_SCMAIN_H_

#include "clang/AST/RecursiveASTVisitor.h"

namespace DESCAM {
/*!
 * \brief Finds the sc_main within a TranslationUnit
 */
class GetClangMain : public clang::RecursiveASTVisitor<GetClangMain> {
 public:
  ~GetClangMain()  = default;

  virtual bool VisitFunctionDecl(clang::FunctionDecl *functionDecl);

  bool setup(clang::TranslationUnitDecl *) ;
  bool isScMainFound() const;

  clang::FunctionDecl *getSCMainFunctionDecl() ;

 private:
  clang::FunctionDecl *scmain_function_decl_;
  clang::TranslationUnitDecl * unit_decl_;
  int pass_;
  bool sc_main_found_;

};
}
#endif
