#include <iostream>
#include "GetClangMain.h"

namespace DESCAM {

bool GetClangMain::VisitFunctionDecl(clang::FunctionDecl *functionDecl) {

  /// Find sc_main.
  /// There are three conditions to satisfy this:
  /// 1. Must have sc_main in its name.
  /// 2. Must have a body
  /// 3. Must *not* be a first declaration. (This is because systemc.h includes a null definition of sc_main.
  if ((functionDecl->getNameInfo().getAsString() == "sc_main") && (functionDecl->hasBody())) {
    //Pass the null definition of main
    if (pass_ == 0) {
      // This is the null definition - skip
      pass_++;
    }
    if (pass_ == 1) {
      // This finds the actual sc_main
      scmain_function_decl_ = functionDecl;
      sc_main_found_ = true;
      return false;
    } else {
      // If we get to here, something in the SC files went wrong. Multiple sc_main definitions.
      // TODO implement actual exception handling here. This is a user created error.
      assert(false && "Multiple sc_main definitions found");
    }
  }
  return true;
}

clang::FunctionDecl *GetClangMain::getSCMainFunctionDecl() {
  assert (scmain_function_decl_);
  return scmain_function_decl_;
}

bool GetClangMain::isScMainFound() const {
  return sc_main_found_;
}

bool GetClangMain::setup(clang::TranslationUnitDecl *unit_decl) {
  assert (unit_decl);
  if (unit_decl == unit_decl_) {
    return true;
  } else {
    pass_ = 0;
    sc_main_found_ = false;
    scmain_function_decl_ = nullptr;
    //Find sc_main
    return TraverseDecl(unit_decl);
  }
}

}