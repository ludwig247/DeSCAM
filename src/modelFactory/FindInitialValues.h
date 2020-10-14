//
// Created by ludwig on 09.11.15.
//

#ifndef SCAM_FINDCONSTRUCTOR_H
#define SCAM_FINDCONSTRUCTOR_H

#include <Variable.h>
#include <Model.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include <clang/AST/Stmt.h>
#include <clang/Analysis/CFG.h>
#include <clang/Basic/SourceManager.h>
#include <clang/Frontend/CompilerInstance.h>
#include "IFindInitialValues.h"
#include "IFindDataFlow.h"

namespace DESCAM {
/**
 * \brief Visits the constructors of a sc_module in order to find inital values for members
 *
 * FindInitialValues has to be called after FindMember, otherwise no intitalvalues can be found.
 *
 */
class FindInitialValues : public IFindInitialValues, public clang::RecursiveASTVisitor<FindInitialValues> {
 public:
  virtual ~FindInitialValues() = default;
  FindInitialValues();

  void setup(clang::CXXRecordDecl *recordDecl,
             clang::FieldDecl *fieldDecl,
             DESCAM::Module *module,
             clang::CompilerInstance *ci);

  ConstValue *getInitValue() override;
  //Visitor
  bool VisitCXXConstructorDecl(clang::CXXConstructorDecl *constructorDecl);
 private:
  void clean();

  clang::FieldDecl *field_decl_;
  ConstValue *init_value_;
  int pass_;
  DESCAM::Module *module_;
  clang::CompilerInstance *ci_;
};

}

#endif //SCAM_FINDCONSTRUCTOR_H
