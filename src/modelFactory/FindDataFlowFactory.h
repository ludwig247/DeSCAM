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
  IFindDataFlow *create_new(clang::Stmt *stmt,
                            Module *module,
                            clang::CompilerInstance *ci,
                            IFindDataFlowFactory *find_data_flow_factory,
                            bool unsigned_flag = false) override {
    auto find_state_name = new FindStateName();
    auto find_data_flow = new FindDataFlow(find_state_name);
    find_data_flow->setup(stmt, module, ci, find_data_flow_factory, unsigned_flag);
    return find_data_flow;
  }
};
}

#endif //SCAM_SRC_MODELFACTORY_FINDDATAFLOWFACTORY_H_
