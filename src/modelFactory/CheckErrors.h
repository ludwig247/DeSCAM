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
#include "IFindProcess.h"
#include "IFindGlobal.h"
#include "IFindFunctions.h"
#include "IFindInitialValues.h"
#include "IFindNewDatatype.h"
#include "IModelFactory.h"
#include "IFindModules.h"
#include "IFindPorts.h"
#include "IFindNetlist.h"
#include "IFindVariables.h"
#include "IFindSCMain.h"
#include "Model.h"
#include <iostream>
#include "FindDataFlow.h"
#include "IFindDataFlowFactory.h"

using namespace clang::driver;
using namespace clang::tooling;
using namespace clang;

namespace DESCAM {

bool containsSubstring(std::string, std::string);

class CheckErrors : public IModelFactory, public RecursiveASTVisitor<CheckErrors> {
 public:
  CheckErrors(IFindFunctions *find_functions,
              IFindInitialValues *find_initial_values,
              IFindModules *find_modules,
              IFindNewDatatype *find_new_datatype,
              IFindPorts *find_ports,
              IFindGlobal *find_global,
              IFindNetlist *find_netlist,
              IFindProcess *find_process,
              IFindVariables *find_variables,
              IFindSCMain *find_sc_main);
  ~CheckErrors() override = default;

  void setup(CompilerInstance *ci) override;

  bool preFire();
  bool fire();
  bool postFire();

 private:
  Model *model_;
  CompilerInstance *ci_;
  ASTContext *context_;
  llvm::raw_ostream &ostream_;
  std::vector<std::string> unimportant_modules_; //! List containing unimportant modules

  // DIP-Pointers
  IFindFunctions *find_functions_;
  IFindInitialValues *find_initial_values_;
  IFindGlobal *find_global_;
  IFindModules *find_modules_;
  IFindPorts *find_ports_;
  IFindNetlist *find_netlist_;
  IFindProcess *find_process_;
  IFindVariables *find_variables_;
  IFindNewDatatype *find_new_datatype_;
  IFindDataFlowFactory * find_data_flow_factory_;
  IFindSCMain *find_sc_main_;

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
