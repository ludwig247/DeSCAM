#ifndef DESCAM_CHECKERRORS_H
#define DESCAM_CHECKERRORS_H


//Clang
#include "clang/Frontend/FrontendPluginRegistry.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/AST/AST.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Parse/Parser.h"
#include "clang/Tooling/CommonOptionsParser.h"
#include "clang/Tooling/Tooling.h"


// PArse SystemC
#include "FindPorts.h"
#include "FindSCMain.h"
#include "FindModules.h"
#include "FindNetlist.h"
#include "FindVariables.h"
#include "IFindProcess.h"
#include "IFindGlobal.h"
#include "IFindFunctions.h"
#include "IFindInitialValues.h"
#include "Model.h"
#include <iostream>

using namespace clang::driver;
using namespace clang::tooling;
using namespace clang;

namespace DESCAM {

bool containsSubstring(std::string, std::string);

class CheckErrors : public ASTConsumer, public RecursiveASTVisitor<CheckErrors> {
 public:
  explicit CheckErrors(CompilerInstance &ci);

  ~CheckErrors() override = default;

  virtual bool preFire();

  virtual bool fire();

  virtual bool postFire();

 private:
  Model *model_;
  CompilerInstance &ci_;
  ASTContext &context_;
  llvm::raw_ostream &ostream_;
  std::vector<std::string> unimportant_modules_; //! List containing unimportant modules
  /** Pointer to FindFunctions Class (DIP) */
  std::unique_ptr<IFindFunctions> find_functions_;
  /** Pointer to FindInitialValues Class (DIP) */
  std::unique_ptr<IFindInitialValues> find_initial_values_;
  std::unique_ptr<IFindProcess> find_process_;
  std::unique_ptr<IFindGlobal> find_global_;
  std::unique_ptr<IFindVariables> find_variables_;

  //Methods
  void HandleTranslationUnit(ASTContext &context) override;

  void addModules(clang::TranslationUnitDecl *decl);

  void addGlobalConstants(TranslationUnitDecl *pDecl);

  void addPorts(Module *module, clang::CXXRecordDecl *decl);

  void addFunctions(Module *module, CXXRecordDecl *decl);

  void addBehavior(Module *module, clang::CXXRecordDecl *decl);

  void addVariables(Module *module, clang::CXXRecordDecl *decl);

};

}
#endif //DESCAM_CHECKERRORS_H
