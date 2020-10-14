//
// Created by burr on 05.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_FINDDATAFLOWFACTORY_H_
#define SCAM_SRC_MODELFACTORY_FINDDATAFLOWFACTORY_H_

#include "IFindDataFlow.h"
#include "FindDataFlow.h"

namespace DESCAM {
/**
 * @brief Factory-Class for FindDataFlow
 */
class FindDataFlowFactory {
 public:
  /**
   * @brief Creates a new instance of FindDataFlow
   * @param stmt ?
   * @param module ?
   * @param ci ?
   * @param unsigned_flag ?
   * @return Smart pointer to FindDataFlow object
   */
  static IFindDataFlow * create(clang::Stmt *stmt,
                                               Module *module,
                                               clang::CompilerInstance *ci,
                                               IFindDataFlow *find_data_flow,
                                               bool unsigned_flag = false) {
    find_data_flow->setup(stmt, module, ci, unsigned_flag);
    return find_data_flow;

  }


};
}

#endif //SCAM_SRC_MODELFACTORY_FINDDATAFLOWFACTORY_H_
