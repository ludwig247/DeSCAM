//
// Created by burr on 05.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_FINDDATAFLOWFACTORY_H_
#define SCAM_SRC_MODELFACTORY_FINDDATAFLOWFACTORY_H_

#include "IFindDataFlowFactory.h"
#include "FindDataFlow.h"

namespace DESCAM {
/**
 * @brief Factory-Class for FindDataFlow
 */
class FindDataFlowFactory : public IFindDataFlowFactory {
 public:
  explicit FindDataFlowFactory(IFindStateName *find_state_name) :
      find_state_name_(find_state_name) {};
  /**
   * @brief Creates a new instance of FindDataFlow
   * @param stmt ?
   * @param module ?
   * @param ci ?
   * @param unsigned_flag ?
   * @return Smart pointer to FindDataFlow object
   */
//  static IFindDataFlow *create(clang::Stmt *stmt,
//                               Module *module,
//                               clang::CompilerInstance *ci,
//                               IFindDataFlowFactory *find_data_flow_factory,
//                               bool unsigned_flag = false) {
//    auto find_data_flow = new FindDataFlow();
//    find_data_flow->setup(stmt, module, ci, find_data_flow_factory, unsigned_flag);
//    return find_data_flow;
//  }
  //FIXME: No default values on virtual methods
  IFindDataFlow *create_new(clang::Stmt *stmt,
                            Module *module,
                            clang::CompilerInstance *ci,
                            bool unsigned_flag) override {
    auto find_data_flow = new FindDataFlow(find_state_name_, this);
    find_data_flow->setup(stmt, module, ci, unsigned_flag);
    return find_data_flow;
  }
 private:
  IFindStateName *find_state_name_;
};
}

#endif //SCAM_SRC_MODELFACTORY_FINDDATAFLOWFACTORY_H_
