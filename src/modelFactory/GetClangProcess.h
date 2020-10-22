//
// Created by burr on 22.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_GETCLANGPROCESS_H_
#define SCAM_SRC_MODELFACTORY_GETCLANGPROCESS_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include "map"
#include "enums.h"

namespace DESCAM {

class GetClangProcess : public clang::RecursiveASTVisitor<GetClangProcess> {
 public:
  GetClangProcess(bool &success, clang::CXXRecordDecl *record_decl);

  //Getter
  bool isValidProcess() const;
  clang::CXXMethodDecl *getProcess() const;

  /// Virtual methods from RecursiveASTVisitor
  virtual bool VisitStringLiteral(clang::StringLiteral *s);
  virtual bool VisitCXXMethodDecl(clang::CXXMethodDecl *md);
  virtual bool VisitMemberExpr(clang::MemberExpr *e);

 private:
  clang::CXXRecordDecl *record_decl_;
  std::vector<clang::CXXMethodDecl *> other_functions_;
  int pass_;
  clang::Stmt *constructor_stmt_;
  std::map<std::string, std::pair<clang::CXXMethodDecl *, PROCESS_TYPE> > process_map_;
  PROCESS_TYPE process_type_; //! Method, Thread, Process
};
}
#endif //SCAM_SRC_MODELFACTORY_GETCLANGPROCESS_H_
