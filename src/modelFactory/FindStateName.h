//
// Created by tobias on 25.11.19.
//

#ifndef DESCAM_FINDSTATENAME_H
#define DESCAM_FINDSTATENAME_H

#include <clang/AST/RecursiveASTVisitor.h>
#include "IFindStateName.h"
namespace DESCAM{
class FindStateName : public DESCAM::IFindStateName, public clang::RecursiveASTVisitor<FindStateName> {
 public:
  ~FindStateName() = default;
  FindStateName() = default;
  bool setup(clang::Stmt *stmt) override;

  bool hasStateName() const;
  const std::string &getStateName() const;

  bool VisitStringLiteral(clang::StringLiteral *stringLiteral);
 private:
  std::string state_name_ = "";
  bool is_set_ = false;
};
}


#endif //DESCAM_FINDSTATENAME_H
