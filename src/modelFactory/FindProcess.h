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
#include "GetClangProcess.h"
#include "IFindDataFlowFactory.h"

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
class FindProcess : public IFindProcess {
 public:
  explicit FindProcess(IFindDataFlowFactory *find_data_flow_factory);
  ~FindProcess() override = default;

  bool setup(clang::CXXRecordDecl *record_decl, clang::CompilerInstance *ci, Module *module, Model *model) override;
  //Getter
  std::map<int, DESCAM::CfgNode *> getCfgArg() const override;
  std::shared_ptr<PropertySuite> getPropertySuite() const override;

 private:
  clang::CXXRecordDecl *record_decl_;
  IFindDataFlowFactory *find_data_flow_factory_;
  std::map<int, DESCAM::CfgNode *> cfg_arg_;
  std::shared_ptr<PropertySuite> property_suite_;
};
}

#endif //SCAM_FINDPROCESS_H
