#ifndef _SC_MODULES_H_
#define _SC_MODULES_H_

#include <map>
#include <string>

#include "IFindModules.h"
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
  FindModules() = default;

  void setup(clang::TranslationUnitDecl *decl) override;
  bool VisitCXXRecordDecl(clang::CXXRecordDecl *);
  const std::map<std::string, clang::CXXRecordDecl *> &getModuleMap() override;

 private:
  std::map<std::string, clang::CXXRecordDecl *> module_map_;

};
}
#endif
