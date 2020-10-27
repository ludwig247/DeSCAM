//
// Created by tobias on 07.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDMODULES_H_
#define SCAM_SRC_MODELFACTORY_IFINDMODULES_H_

#include "clang/AST/RecursiveASTVisitor.h"

class IFindModules {
 public:
  virtual void setup(clang::TranslationUnitDecl *) = 0;
  virtual const std::map<std::string, clang::CXXRecordDecl *> &getModuleMap() = 0;
};

#endif //SCAM_SRC_MODELFACTORY_IFINDMODULES_H_
