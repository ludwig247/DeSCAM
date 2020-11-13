//
// Created by tobias on 28.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDINSTANCES_H_
#define SCAM_SRC_MODELFACTORY_IFINDINSTANCES_H_

#include "clang/AST/AST.h"
#include "Model.h"

namespace DESCAM{

class IFindInstances {
 public:
  virtual ~IFindInstances() = default;
  virtual bool setup(clang::TranslationUnitDecl *tu, Model * const model) = 0;
  virtual ModuleInstance * getModuleInstance() = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDINSTANCES_H_
