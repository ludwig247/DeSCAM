#ifndef _SC_MODULES_H_
#define _SC_MODULES_H_

#include <map>
#include <string>

#include "IFindModules.h"
#include "IFindVariables.h"
#include "IFindPorts.h"
#include "IFindFunctions.h"
#include "IFindProcess.h"
#include "clang/AST/RecursiveASTVisitor.h"

namespace DESCAM {

/*
 * \brief Finds all modules defined by the user
 *
 * Ignores modules that are defined by system_c
 *
 */

class FindModules : public IFindModules, public clang::RecursiveASTVisitor<FindModules> {
 public:
  explicit FindModules(IFindVariables *find_variables,
                       IFindPorts *find_ports,
                       IFindFunctions *find_functions,
                       IFindProcess *find_process);

  void setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance *ci, DESCAM::Model *model) override;
  bool VisitCXXRecordDecl(clang::CXXRecordDecl *);
  const std::map<std::string, clang::CXXRecordDecl *> &getModuleMap() override;
  std::vector<DESCAM::Module *> getModules() override;

 private:
  IFindVariables *find_variables_;
  IFindPorts *find_ports_;
  IFindFunctions *find_functions_;
  IFindProcess *find_process_;

  clang::CompilerInstance *ci_;
  DESCAM::Model *model_;
  std::map<std::string, clang::CXXRecordDecl *> module_map_;
  std::vector<DESCAM::Module *> modules;
  std::vector<std::string> unimportant_modules_; //! List containing unimportant modules

  void addVariables(Module *module, clang::CXXRecordDecl *decl); //!Adds variable to module
  void addPorts(DESCAM::Module *module, clang::CXXRecordDecl *decl);
  void addFunctions(Module *module, clang::CXXRecordDecl *decl);
  void addBehavior(Module *module, clang::CXXRecordDecl *decl);
};
}
#endif
