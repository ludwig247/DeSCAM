//
// Created by ludwig on 15.09.15.
//

#ifndef SCAM_CREATEMODEL_H
#define SCAM_CREATEMODEL_H


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
#include "Model.h"
#include "IFindPorts.h"
#include "IFindFunctions.h"
#include "IFindInitialValues.h"
#include "IFindNewDatatype.h"
#include "IFindGlobal.h"
#include "IFindNetlist.h"
#include "IFindProcess.h"
#include "IFindSCMain.h"
#include "IModelFactory.h"
#include "IFindModules.h"
#include "IFindVariables.h"
#include "FindDataFlow.h"

using namespace clang::driver;
using namespace clang::tooling;
using namespace clang;

namespace DESCAM {

bool containsSubstring(std::string, std::string);

/*!
 * \brief Factory for creating a DESCAM::Model
 *
 * HandleTranslationUnit is called after instantiation of the model and calls three methods preFire, fire and postFire
 * The preFire face is unimportant for us and is automatically followed by the fire face.
 * During the fire face the clang ast is instantiated and can be accessed using visitors.
 * The clang::TranslationUnitDecl contains the hole AST and is passed to FindModules in order to extract the modules of the
 * systemc description. For each module the ports are extracted using FindPorts and so on.
 * Afterwards a netlist of all modules is extracted, starting with the sc_main().
 * Right now only two modules can be connected and  a nested modules are not supported
 *
 * The model is then accessed using the DESCAM::GraphVisitor. This visitors only prints the structural information of the system.
 * In order to access the behavioral information  for each module we refer DESCAM::SuspensionAutomata.
 *
 */
class ModelFactory : public IModelFactory, public RecursiveASTVisitor<ModelFactory> {
 public:
  explicit ModelFactory(IFindFunctions *find_functions,
                        IFindInitialValues *find_initial_values,
                        IFindModules *find_modules,
                        IFindNewDatatype *find_new_datatype,
                        IFindPorts *find_ports,
                        IFindGlobal *find_global,
                        IFindNetlist *find_netlist,
                        IFindProcess *find_process,
                        IFindVariables *find_variables,
                        IFindSCMain *find_sc_main);

  ~ModelFactory() override = default;


  void setup(CompilerInstance *ci) override;

  bool preFire() override;
  bool fire() override;
  bool postFire() override;

 private:
  Model *model_;
  CompilerInstance *ci_;
  ASTContext *context_;
  // unused?: SourceManager &_sm;
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
  IFindSCMain *find_sc_main_;

  //Methods
  void HandleTranslationUnit(ASTContext &context) override;

  void addModules(clang::TranslationUnitDecl *decl);
  void addGlobalConstants(TranslationUnitDecl *pDecl);
  void addPorts(Module *module, clang::CXXRecordDecl *decl);
  void addFunctions(Module *module, CXXRecordDecl *decl);
  void addBehavior(Module *module, clang::CXXRecordDecl *decl);
  void addVariables(Module *module, clang::CXXRecordDecl *decl); //!Adds variable to module
  void addInstances(TranslationUnitDecl *tu);
  void removeUnused();

};

}
#endif //SCAM_CREATEMODEL_H
