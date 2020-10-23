//
// Created by ludwig on 28.09.15.
//

#ifndef SCAM_FINDPROCESS_H
#define SCAM_FINDPROCESS_H

#include "IFindProcess.h"

#include <vector>
#include <string>
#include <map>
#include "clang/AST/RecursiveASTVisitor.h"

#include "enums.h"

namespace DESCAM {
/*!
 * \brief Class searches for process declartions within a sc_module
 *
 * For now, only modules with one thread are allowed. This should be changed in future!
 * BUT: a merge between the suspension automats of the differnt methods has to be done
 *
 * //TODO: rethink finding of proccesses? Too complicated
 * //TODO: only allow threads
 */
class FindProcess : public IFindProcess, public clang::RecursiveASTVisitor<FindProcess> {
 public:

  virtual ~FindProcess() override = default;

  /// Virtual methods from RecursiveASTVisitor
  virtual bool VisitStringLiteral(clang::StringLiteral *s);
  virtual bool VisitCXXMethodDecl(clang::CXXMethodDecl *md);
  virtual bool VisitMemberExpr(clang::MemberExpr *e);

  //Getter
  bool setup(clang::CXXRecordDecl *record_decl) override;
  const std::map<std::string, std::pair<clang::CXXMethodDecl *, PROCESS_TYPE>> &getProcessMap() override;
  bool isValidProcess() const override;
  clang::CXXMethodDecl *getProcess() const override;

 private:
  clang::CXXRecordDecl *record_decl_;
  PROCESS_TYPE process_type_; //! Method, Thread, Process
  clang::Stmt *constructor_stmt_;

  std::map<std::string, std::pair<clang::CXXMethodDecl *, PROCESS_TYPE> > process_map_;
  //! <processName, <MethodDecl, processType> >
  std::vector<clang::CXXMethodDecl *> other_functions_;

  int pass_;

};
}

#endif //SCAM_FINDPROCESS_H
