//
// Created by schwarz on 02.11.20.
//

#ifndef SCAM_SRC_MODELFACTORY_CLANGCASTVISITOR_H_
#define SCAM_SRC_MODELFACTORY_CLANGCASTVISITOR_H_
#include "clang/AST/RecursiveASTVisitor.h"

template <class T>
class clangCastVisitor : public clang::RecursiveASTVisitor<clangCastVisitor<T>> {
 private:
  T* ptr;

 public:
  T *GetPtr() const {
    return ptr;
  }

  bool VisitMemberExpr(clang::MemberExpr *E) {

  }
};

#endif //SCAM_SRC_MODELFACTORY_CLANGCASTVISITOR_H_

