//
// Created by tobias on 07.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDMODULES_H_
#define SCAM_SRC_MODELFACTORY_IFINDMODULES_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include "Module.h"
#include "LocationInfo.h"
#include "clang/Frontend/CompilerInstance.h"

class IFindModules {
 public:
  virtual void setup(clang::TranslationUnitDecl *, clang::CompilerInstance *ci) = 0;
  virtual const std::map<std::string, clang::CXXRecordDecl *> &getModuleMap() = 0;
  virtual DESCAM::Module *createModule(clang::CXXRecordDecl *record_decl,
                                       std::string name,
                                       DESCAM::LocationInfo locationInfo) = 0;
};

#endif //SCAM_SRC_MODELFACTORY_IFINDMODULES_H_
