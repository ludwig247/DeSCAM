//
// Created by ludwig on 28.09.15.
//

#include "FindProcess.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "CFGFactory.h"
#include "CommandLineParameter.h"
#include "Optimizer/Optimizer.h"
#include "OperationFactory.h"
#include "PropertyFactory.h"

DESCAM::FindProcess::FindProcess(DESCAM::IFindDataFlowFactory *find_data_flow_factory) :
    find_data_flow_factory_(find_data_flow_factory) {

}

bool DESCAM::FindProcess::setup(clang::CXXRecordDecl *record_decl,
                                clang::CompilerInstance *ci,
                                Module *module,
                                Model *model) {
  std::cout << "TEST::setup\n";
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

    if (cfgFactory.getControlFlowMap().empty()) TERMINATE("CFG is empty!");
    DESCAM::CfgNode::node_cnt = 0;
    DESCAM::State::state_cnt = 0;
    DESCAM::Operation::operations_cnt = 0;
    auto optOptionsSet = CommandLineParameter::getOptimizeOptionsSet();

    if (!optOptionsSet.empty()) {
      DESCAM::Optimizer opt(cfgFactory.getControlFlowMap(), module, model, optOptionsSet);
      this->cfg_arg_ = opt.getCFG();
      DESCAM::OperationFactory operationFactory(this->cfg_arg_, module);
      PropertyFactory propertyFactory(module);

      this->property_suite_ = propertyFactory.getPropertySuite();
    } else {
      DESCAM::CreateRealCFG test(cfgFactory.getControlFlowMap());
      this->cfg_arg_ = test.getCFG();
      DESCAM::OperationFactory operationFactory(this->cfg_arg_, module);
      PropertyFactory propertyFactory(module);

      this->property_suite_ = propertyFactory.getPropertySuite();
    }

    return success;
  }
}
std::map<int, DESCAM::CfgNode *> DESCAM::FindProcess::getCfgArg() const {
  std::cout << "TEST::getCfgArg\n";
  std::cout << " | Size:" << cfg_arg_.size() << "\n";
  for (auto node:cfg_arg_) {
    std::cout << " | | Int:" << node.first << " NodeName:" << node.second->getName() << " Stmt:"
              << node.second->print();
  }
  return this->cfg_arg_;
}
std::shared_ptr<DESCAM::PropertySuite> DESCAM::FindProcess::getPropertySuite() const {
  std::cout << "TEST::getPropertySuite Name:" << property_suite_->getName() << "\n";
  return this->property_suite_;
}
