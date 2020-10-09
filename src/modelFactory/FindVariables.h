//
// Created by tobias on 22.10.15.
//

#ifndef SCAM_FINDMEMBERS_H
#define SCAM_FINDMEMBERS_H

#include <map>
#include "clang/AST/RecursiveASTVisitor.h"
#include "IFindVariables.h"

namespace DESCAM {
/**
  ** \brief Visit fieldDecl of a recordDecl: Member Variables
  **
  ** Ports are covered by find Ports. Hence, here we're looking for everything else.
  ** For now, we are considering built-in types only. Here we are also able to track down
  ** Types that are not supported!
 */

class FindVariables : public IFindVariables, public clang::RecursiveASTVisitor<FindVariables> {
 public:
  FindVariables() = default;
  ~FindVariables() override = default;
  //Visitor
  bool VisitFieldDecl(clang::FieldDecl *fieldDecl);

  //GETTER
  bool setup(clang::CXXRecordDecl *record_decl) override;
  std::map<std::string, clang::QualType> getVariableTypeMap() const override;
  const std::map<std::string, clang::FieldDecl *> &getVariableMap() const override;
 private:
  clang::CXXRecordDecl *record_decl_;
  std::map<std::string, clang::FieldDecl *> member_map_; //! <NameOfField,Declaration>
  std::map<std::string, std::string> member_type_map_; //! <NameOfField,Declaration>

};

}

#endif //SCAM_FINDMEMBERS_H
