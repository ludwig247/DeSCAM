#include "FindNetlist.h"

namespace DESCAM {

bool FindNetlist::VisitCXXOperatorCallExpr(clang::CXXOperatorCallExpr *ce) {
  bool foundME = false;
  std::string moduleName;
  std::string instanceName;
  std::string portName;

  for (clang::Stmt::child_iterator it = ce->IgnoreImpCasts()->child_begin(), eit = ce->IgnoreImpCasts()->child_end();
       it != eit; it++) {
    if (auto *e = llvm::dyn_cast<clang::Expr>(*it)) {
      if (auto *me = llvm::dyn_cast<clang::MemberExpr>(e->IgnoreImpCasts())) {
        if (auto *de = llvm::dyn_cast<clang::DeclRefExpr>(me->getBase()->IgnoreImpCasts())) {
          moduleName = de->getDecl()->getType().getBaseTypeIdentifier()->getName().str();
          instanceName = de->getFoundDecl()->getNameAsString();
        }
        portName = me->getMemberDecl()->getNameAsString();
        foundME = true;
      }
      if (auto *channelDecl = llvm::dyn_cast<clang::DeclRefExpr>(e->IgnoreImpCasts())) {
        if (foundME) {
          //Instance Map: containing an entry for each instance of an module
          this->instance_map_.insert(std::make_pair(instanceName, moduleName));
          //Channel Map: containing an entry <<Instance, port>,channelDecl >
          auto innerEntry = std::pair<std::string, std::string>(instanceName, portName);
          auto outerEntry =
              std::pair<std::pair<std::string, std::string>, clang::DeclRefExpr *>(innerEntry, channelDecl);
          this->channel_map_.insert(outerEntry);
          foundME = false;
        }
      }
    }
  }

  return true;
}

std::map<std::string, std::string> FindNetlist::getInstanceMap() {
  return this->instance_map_;
}

std::map<std::pair<std::string, std::string>, clang::DeclRefExpr *> FindNetlist::getChannelMap() {
  return this->channel_map_;
}

bool FindNetlist::setup(clang::FunctionDecl *decl) {
  assert(decl);
  if (decl == this->decl_) { return true; }
  this->decl_ = decl;
  return TraverseDecl(decl);
}

}