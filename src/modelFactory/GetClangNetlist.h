#ifndef _NETLIST_GEN_H_
#define _NETLIST_GEN_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include <map>

namespace DESCAM {

class GetClangNetlist : public clang::RecursiveASTVisitor<GetClangNetlist> {
 public:

  ~GetClangNetlist()  = default;

  virtual bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce);

  bool setup(clang::FunctionDecl *decl) ;
  //GETTER
  std::map<std::string, std::string> getInstanceMap() ;
  std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *> getChannelMap() ;

 private:
  clang::FunctionDecl *decl_;
  std::map<std::string, std::string> instance_map_; //! <instance_name, sc_module>
  std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *> channel_map_; //! <<Instance,Port>,channelDecl >
};
}
#endif
