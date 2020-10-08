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
#include "IFindPorts.h"
#include "FindSCMain.h"
#include "FindModules.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "Model.h"
#include "IFindFunctions.h"
#include "IFindInitialValues.h"
#include <iostream>

#include "IFindGlobal.h"
#include "IFindNetlist.h"
#include "IFindProcess.h"

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
class ModelFactory : public ASTConsumer, public RecursiveASTVisitor<ModelFactory> {
 public:
  explicit ModelFactory(CompilerInstance &ci);
  ~ModelFactory() override = default;

  virtual bool preFire();
  virtual bool fire();
  virtual bool postFire();
 private:
  Model *model;
  CompilerInstance &_ci;
  ASTContext &_context;
  // unused?: SourceManager &_sm;
  llvm::raw_ostream &_os;
  std::vector<std::string> unimportant_modules_; //! List containing unimportant modules
  /** Pointer to FindFunctions Class (DIP) */
  std::unique_ptr<IFindFunctions> find_functions_;
  /** Pointer to FindInitialValues Class (DIP) */
  std::unique_ptr<IFindInitialValues> find_initial_values_;
  /** Pointer to FindInitialValues Class (DIP) */
  std::unique_ptr<IFindGlobal> find_global_;
  /** Pointer to IFindModules Class (DIP) */
  std::unique_ptr<IFindModules> find_modules_;
  /** Pointer to IFindPorts Class (DIP) */
  std::unique_ptr<IFindPorts> find_ports_;
  /** TODO Pointer to is X is not a descriptive/useful comment */
  std::unique_ptr<IFindNetlist> find_netlist_;
  std::unique_ptr<IFindProcess> find_process_;

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
