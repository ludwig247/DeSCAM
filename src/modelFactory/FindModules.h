#ifndef _SC_MODULES_H_
#define _SC_MODULES_H_

#include <map>
#include <string>

#include "IFindModules.h"
#include "IFindVariables.h"
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
  explicit FindModules(IFindVariables *find_variables);

  void setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance *ci) override;
  bool VisitCXXRecordDecl(clang::CXXRecordDecl *);
  const std::map<std::string, clang::CXXRecordDecl *> &getModuleMap() override;
  DESCAM::Module *createModule(clang::CXXRecordDecl *record_decl,
                               std::string name,
                               LocationInfo locationInfo) override;

 private:
  IFindVariables *find_variables_;

  clang::CompilerInstance *ci_;
  std::map<std::string, clang::CXXRecordDecl *> module_map_;

  void addVariables(Module *module, clang::CXXRecordDecl *decl); //!Adds variable to module

};
}
#endif
