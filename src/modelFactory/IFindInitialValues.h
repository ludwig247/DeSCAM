//
// Created by burr on 06.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDINITIALVALUES_H_
#define SCAM_SRC_MODELFACTORY_IFINDINITIALVALUES_H_

#include "clang/AST/Decl.h"
#include "clang/AST/DeclCXX.h"
#include "clang/Frontend/CompilerInstance.h"
#include "Model.h"

namespace DESCAM {

/**
 * @brief Visits the constructors of a sc_module in order to find inital values for members
 */
class IFindInitialValues {
 public:
  virtual ~IFindInitialValues() = default;

  virtual void setup(clang::CXXRecordDecl *recordDecl,
                     clang::FieldDecl *fieldDecl,
                     DESCAM::Module *module,
                     clang::CompilerInstance *ci) = 0;

  virtual ConstValue *getInitValue() = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDINITIALVALUES_H_
