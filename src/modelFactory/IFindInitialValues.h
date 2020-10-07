//
// Created by burr on 06.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDINITIALVALUES_H_
#define SCAM_SRC_MODELFACTORY_IFINDINITIALVALUES_H_

#include "clang/AST/RecursiveASTVisitor.h"

namespace DESCAM {

/**
 * @brief Visits the constructors of a sc_module in order to find inital values for members
 */
class IFindInitialValues : public clang::RecursiveASTVisitor<IFindInitialValues> {
 public:
  virtual ~IFindInitialValues() = default;

  virtual ConstValue *getInitValue() = 0;

  virtual bool VisitCXXConstructorDecl(clang::CXXConstructorDecl *constructorDecl) = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDINITIALVALUES_H_