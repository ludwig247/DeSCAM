//
// Created by tobias on 17.07.18.
//

#ifndef PROJECT_FINDCOMBINATIONALFUNCTION_H
#define PROJECT_FINDCOMBINATIONALFUNCTION_H

#include <map>
#include "IFindFunctions.h"
#include "clang/AST/RecursiveASTVisitor.h"
#include "IFindNewDatatype.h"
#include "IFindDataFlowFactory.h"
#include "GetClangFunctions.h"

namespace DESCAM {
/***
 * \brief Finds all "combinational" functions of a module
 *
 * Functions are considered const if they are const with respect to the class and thereby don't change the state of the class.
 */
class FindFunctions : public IFindFunctions {
 public:
  FindFunctions(IFindNewDatatype *find_new_datatype, IFindDataFlowFactory *find_data_flow_factory);

  bool setup(clang::CXXRecordDecl *record_decl,
             clang::CompilerInstance *ci,
             Module *module) override;

  std::map<std::string, Function *> getFunctionDecls() const override;
  std::map<int, CfgBlock *> getFunctionBody(std::string name) const override;

 private:
  IFindNewDatatype *find_new_datatype_;
  IFindDataFlowFactory *find_data_flow_factory_;

  GetClangFunctions *get_clang_functions_;
  Module *module_;
  clang::CompilerInstance *ci_;

  clang::CXXRecordDecl *record_decl_{};

  std::map<std::string, Function *> function_map_;
};
}

#endif //PROJECT_FINDCOMBINATIONALFUNCTION_H
