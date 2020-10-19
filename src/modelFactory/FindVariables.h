//
// Created by tobias on 22.10.15.
//

#ifndef SCAM_FINDMEMBERS_H
#define SCAM_FINDMEMBERS_H

#include <map>
#include "clang/AST/RecursiveASTVisitor.h"
#include "IFindVariables.h"
#include "GetClangVariables.h"
#include "Logger/Logger.h"
#include "GlobalUtilities.h"
#include "clang/AST/Decl.h"
#include "GetClangVariables.h"
#include "IFindNewDatatype.h"
#include "IFindInitialValues.h"
#include "IFindDataFlowFactory.h"

namespace DESCAM {
/**
  ** \brief Visit fieldDecl of a recordDecl: Member Variables
  **
  ** Ports are covered by find Ports. Hence, here we're looking for everything else.
  ** For now, we are considering built-in types only. Here we are also able to track down
  ** Types that are not supported!
 */

class FindVariables : public IFindVariables {
 public:
  explicit FindVariables(IFindNewDatatype *find_new_datatype,
                         IFindInitialValues *find_initial_values,
                         IFindDataFlowFactory *find_data_flow_factory);
  ~FindVariables() override = default;

  std::map<std::string, DESCAM::Variable *> getVariableMap() override;
  bool setup(clang::CXXRecordDecl *record_decl, clang::CompilerInstance *ci, DESCAM::Module *module) override;
 private:
  IFindNewDatatype *find_new_datatype_;
  IFindInitialValues *find_initial_values_;
  IFindDataFlowFactory *find_data_flow_factory_;

  clang::CXXRecordDecl *record_decl_;
  std::map<std::string, Variable *> variable_map_;
};

}

#endif //SCAM_FINDMEMBERS_H
