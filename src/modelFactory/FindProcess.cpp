//
// Created by ludwig on 28.09.15.
//

#include "FindProcess.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "CommandLineParameter.h"
#include "Optimizer/Optimizer.h"
#include "OperationFactory.h"
#include "PropertyFactory.h"
#include "CFGFactory.h"

DESCAM::FindProcess::FindProcess(DESCAM::IFindDataFlowFactory *find_data_flow_factory) :
    find_data_flow_factory_(find_data_flow_factory),
    record_decl_(nullptr) {}

bool DESCAM::FindProcess::setup(clang::CXXRecordDecl *record_decl,
                                clang::CompilerInstance *ci,
                                Module *module,
                                Model *model) {
  /*std::cout << "TEST::setup\n";
  std::cout << " | ModuleName:" << module->getName() << "\n";*/
  assert(record_decl);
  if (record_decl_ == record_decl) {
    return true;
  } else {
    record_decl_ = record_decl;
    bool success = true;
    GetClangProcess get_clang_process(success, record_decl_);

    if (!success) return success;

    clang::CXXMethodDecl *methodDecl;
    if (get_clang_process.isValidProcess()) {
      methodDecl = get_clang_process.getProcess();
    }
    /*
     * TODO What happens when methodDecl is not initialized? Does it violate the contract of cfgFactory? maybe else part?
     */
    DESCAM::CFGFactory cfgFactory(methodDecl, ci, module, find_data_flow_factory_, true);
    this->cfg_ = cfgFactory.getControlFlowMap();

    return success;
  }
}
const std::map<int, DESCAM::CfgBlock *> &DESCAM::FindProcess::getCFG() const {
  /*std::cout << "TEST::getCFG" << "\n";
  std::cout << " | Size:" << this->cfg_.size() << "\n";aw
  for (auto &block:this->cfg_) {
    std::cout << " | | Int:" << block.first << ", Block:" << "\n" << block.second->print() << "\n";
  }*/
  return this->cfg_;
}
