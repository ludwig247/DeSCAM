//
// Created by schwarz on 08.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDVARIABLE_H_
#define SCAM_SRC_MODELFACTORY_IFINDVARIABLE_H_

#include <map>
#include "clang/AST/Type.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclCXX.h"
#include "IFindVariables.h"

namespace DESCAM {
/**
  ** \brief Interface finding fieldDecl of a recordDecl, i.e., Member Variables
  **
  ** Ports are covered by find Ports. Hence, here we're looking for everything else.
  ** For now, we are considering built-in types only. Here we are also able to track down
  ** Types that are not supported!
 */

class IFindVariables {
 public:
  virtual ~IFindVariables() = default;
  //GETTER
  virtual bool setup(clang::CXXRecordDecl *record_decl) = 0;
  virtual std::map<std::string, clang::QualType> getVariableTypeMap() const = 0;
  virtual const std::map<std::string, clang::FieldDecl *> &getVariableMap() const = 0;

};
}
#endif //SCAM_SRC_MODELFACTORY_IFINDVARIABLES_H_
