//
// Created by burr on 09.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IMODELFACTORY_H_
#define SCAM_SRC_MODELFACTORY_IMODELFACTORY_H_

#include "clang/Frontend/CompilerInstance.h"

namespace DESCAM {
class IModelFactory : public clang::ASTConsumer {
 public:

  ~IModelFactory() override = default;

  virtual void setup(clang::CompilerInstance *ci) = 0;
 private:
  void HandleTranslationUnit(clang::ASTContext &context) override = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IMODELFACTORY_H_
