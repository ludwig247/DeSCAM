//
// Created by schwarz on 08.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDNETLIST_H_
#define SCAM_SRC_MODELFACTORY_IFINDNETLIST_H_


#include <map>
#include <clang/AST/Expr.h>

namespace DESCAM {

class IFindNetlist {
 public:

  virtual ~IFindNetlist() = default;

  virtual bool setup(clang::FunctionDecl *) = 0;
  //GETTER
  virtual std::map<std::string, std::string> getInstanceMap() = 0;
  virtual std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *> getChannelMap() = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDNETLIST_H_
