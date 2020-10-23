//
// Created by schwarz on 08.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDPROCESS_H_
#define SCAM_SRC_MODELFACTORY_IFINDPROCESS_H_

#include <string>
#include <map>
#include "clang/AST/DeclCXX.h"
#include "Module.h"
#include "clang/Frontend/CompilerInstance.h"
#include "enums.h"

namespace DESCAM {

/**
 * TODO Comment
 */
class IFindProcess {
 public:

  virtual ~IFindProcess() = default;

  virtual bool setup(clang::CXXRecordDecl *recordDecl, clang::CompilerInstance *ci, Module *module, Model *model) = 0;
  virtual std::map<int, DESCAM::CfgNode *> getCfgArg() const = 0;
  virtual std::shared_ptr<PropertySuite> getPropertySuite() const = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDPROCESS_H_
