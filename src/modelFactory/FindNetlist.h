#ifndef _NETLIST_GEN_H_
#define _NETLIST_GEN_H_

#include "IFindNetlist.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include <map>

namespace DESCAM {

class FindNetlist : public IFindNetlist, public clang::RecursiveASTVisitor<FindNetlist> {
 public:

  ~FindNetlist() override = default;

  virtual bool VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce);

  bool setup(clang::FunctionDecl *decl) override;
  //GETTER
  std::map<std::string, std::string> getInstanceMap() override;
  std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *> getChannelMap() override;

 private:
  clang::FunctionDecl *decl_;
  std::map<std::string, std::string> instance_map_; //! <instance_name, sc_module>
  std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *> channel_map_; //! <<Instance,Port>,channelDecl >
};
}
#endif
