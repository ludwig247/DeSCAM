//
// Created by schwarz on 09.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDSCMAIN_H_
#define SCAM_SRC_MODELFACTORY_IFINDSCMAIN_H_

#include "clang/AST/Decl.h"

namespace DESCAM {
/*!
 * \brief Finds the sc_main within a TranslationUnit
 */
class IFindSCMain {
 public:

  virtual ~IFindSCMain() = default;

  virtual bool setup(clang::TranslationUnitDecl *) = 0;

  virtual bool isScMainFound() const = 0;

  virtual clang::FunctionDecl *getSCMainFunctionDecl() = 0;

};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDSCMAIN_H_
