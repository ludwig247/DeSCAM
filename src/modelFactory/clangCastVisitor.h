//
// Created by schwarz on 02.11.20.
//

#ifndef SCAM_SRC_MODELFACTORY_CLANGCASTVISITOR_H_
#define SCAM_SRC_MODELFACTORY_CLANGCASTVISITOR_H_
#include "clang/AST/RecursiveASTVisitor.h"

/**
 * @brief Emulate a dyn_cast of a clang AST object without needing RTTI
 *
 * Use this class when you want upcast a clang AST object without using RTTI.
 * The class tries to emulate the behavior of std::dynamic_cast<T>, i.e., if successful it returns a ptr of type <T> and
 * a nullptr otherwise.
 *
 * @tparam T Cast target type
 *
 * @note This class is currently a 'living' thing as it does not exhaustively cover all visit*() functions of the
 *       underlying clang::RecursiveASTVisitor. Missing functions should be extended on a per-need basis.
 *       Probably this can be solved way more elegantly with clever use of template and/or macros.
 */
//template<class T>
class clangCastVisitor : public clang::RecursiveASTVisitor<clangCastVisitor> {
 private:
  clang::MemberExpr *member_expr_ = nullptr;
  clang::EnumConstantDecl *enum_constant_decl_ = nullptr;
  clang::ParmVarDecl *parm_var_decl_ = nullptr;
  clang::CXXConstructorDecl *cxx_constructor_decl_ = nullptr;
  clang::Expr *expr_ = nullptr;
  clang::DeclRefExpr *decl_ref_expr_ = nullptr;
  clang::TemplateSpecializationType *template_specialization_type_ = nullptr;
  clang::IntegerLiteral *integer_literal_ = nullptr;

 public:
  //====================================================================================================================
  // CTOR for used base type
  //====================================================================================================================

  /**
   * @param stmt
   */
  explicit clangCastVisitor(clang::Stmt *stmt) {
    clangCastVisitor::TraverseStmt(stmt);
  }

  /**
   * @param decl
   */
  explicit clangCastVisitor(clang::Decl *decl) {
    clangCastVisitor::TraverseDecl(decl);
  }

  /**
   * @param qual_type
   */
  explicit clangCastVisitor(clang::QualType qual_type) {
    clangCastVisitor::TraverseType(qual_type);
  }

  //====================================================================================================================
  // Get*()
  //====================================================================================================================

  /**
   * @brief Returns a valid pointer if the CTOR argument can be upcast to <T> and a nullptr otherwise.
   * @return <T> or nullptr
   */
  clang::MemberExpr *GetMemberExpr() const {
    return member_expr_;
  }
  clang::EnumConstantDecl *GetEnumConstantDecl() const {
    return enum_constant_decl_;
  }
  clang::ParmVarDecl *GetParmVarDecl() const {
    return parm_var_decl_;
  }
  clang::CXXConstructorDecl *GetCxxConstructorDecl() const {
    return cxx_constructor_decl_;
  }
  clang::Expr *GetExpr() const {
    return expr_;
  }
  clang::DeclRefExpr *GetDeclRefExpr() const {
    return decl_ref_expr_;
  }
  clang::TemplateSpecializationType *GetTemplateSpecializationType() const {
    return template_specialization_type_;
  }
  clang::IntegerLiteral *GetIntegerLiteral() const {
    return integer_literal_;
  }
  //====================================================================================================================
  // Visit*()
  //====================================================================================================================
  /**
   * @brief Shadows implementation of the respective clang::RecursiveASTVisitor. Sets the respective field:
   * @param type
   * @return
   */
  bool VisitMemberExpr(clang::MemberExpr *type) {
    member_expr_ = type;
    return false;
  }

  /**
   * @brief Shadows implementation of the respective clang::RecursiveASTVisitor. Sets the respective field:
   * @param type
   * @return
   */
  bool VisitEnumConstantDecl(clang::EnumConstantDecl *type) {
    enum_constant_decl_ = type;
    return false;
  }

  /**
   * @brief Shadows implementation of the respective clang::RecursiveASTVisitor. Sets the respective field:
   * @param type
   * @return
   */
  bool VisitParmVarDecl(clang::ParmVarDecl *type) {
    parm_var_decl_ = type;
    return false;
  }

  /**
   * @brief Shadows implementation of the respective clang::RecursiveASTVisitor. Sets the respective field:
   * @param type
   * @return
   */
  bool VisitCXXConstructorDecl(clang::CXXConstructorDecl *type) {
    cxx_constructor_decl_ = type;
    return false;
  }

  /**
   * @brief Shadows implementation of the respective clang::RecursiveASTVisitor. Sets the respective field:
   * @param type
   * @return
   */
  bool VisitDeclRefExpr(clang::DeclRefExpr *type) {
    decl_ref_expr_ = type;
    return false;
  }

  /**
   * @brief Shadows implementation of the respective clang::RecursiveASTVisitor. Sets the respective field:
   * @param type
   * @return
   */
  bool VisitTemplateSpecializationType(clang::TemplateSpecializationType *type) {
    template_specialization_type_ = type;
    return false;
  }

  /**
   * @brief Shadows implementation of the respective clang::RecursiveASTVisitor. Sets the respective field:
   * @param type
   * @return
   */
  bool VisitIntegerLiteral(clang::IntegerLiteral *type) {
    integer_literal_ = type;
    return false;
  }
};

#endif //SCAM_SRC_MODELFACTORY_CLANGCASTVISITOR_H_

