//
// Created by tobias on 28.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_FINDINSTANCES_H_
#define SCAM_SRC_MODELFACTORY_FINDINSTANCES_H_

#include "IFindInstances.h"
#include "GetClangMain.h"
#include "GetClangNetlist.h"
#include <Logger/Logger.h>
#include "FatalError.h"

namespace DESCAM{
class FindInstances: public IFindInstances {
 public:
  virtual ~FindInstances() = default;
  bool setup(clang::TranslationUnitDecl *tu, Model * const model) override;
  ModuleInstance *getModuleInstance() override;
 private:
  ModuleInstance * top_instance_ = nullptr;

};
}

#endif //SCAM_SRC_MODELFACTORY_FINDINSTANCES_H_
