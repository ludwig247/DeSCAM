//
// Created by tobias on 07.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDPORTS_H_
#define SCAM_SRC_MODELFACTORY_IFINDPORTS_H_

#include <map>
#include <clang/AST/ASTContext.h>
#include "clang/AST/RecursiveASTVisitor.h"
#include "enums.h"
#include "LocationInfo.h"
#include "Module.h"
#include "Port.h"

class IFindPorts {
 public:
  virtual bool setup(clang::CXXRecordDecl *recordDecl, clang::CompilerInstance *ci, DESCAM::Module *module) = 0;

  virtual std::map<std::string, DESCAM::Port *> getPortMap() const = 0;
};
#endif //SCAM_SRC_MODELFACTORY_IFINDPORTS_H_
