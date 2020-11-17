//
// Created by burr on 15.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_GETCLANGVARIABLES_H_
#define SCAM_SRC_MODELFACTORY_GETCLANGVARIABLES_H_

#include "clang/AST/RecursiveASTVisitor.h"
#include "map"
#include "FatalError.h"
#include "Logger/Logger.h"

namespace DESCAM {
class GetClangVariables : public clang::RecursiveASTVisitor<GetClangVariables> {
 public:
  /**
   * Traverses the Clang AST to find all variables
   * @param success true if traversed successfully
   * @param record_decl clang RecordDecl, that should be traversed;
   */
  explicit GetClangVariables(bool &success, clang::CXXRecordDecl *record_decl);

  bool VisitFieldDecl(clang::FieldDecl *fieldDecl);

  std::map<std::string, clang::QualType> getVariableTypeMap() const;

  const std::map<std::string, clang::FieldDecl *> &getVariableMap() const;

 private:
  std::map<std::string, clang::FieldDecl *> member_map_; //! <NameOfField,Declaration>

  clang::CXXRecordDecl *record_decl_;
};
}

#endif //SCAM_SRC_MODELFACTORY_GETCLANGVARIABLES_H_
