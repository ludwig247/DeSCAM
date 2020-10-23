//
// Created by tobias on 14.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDDATAFLOWFACTORY_H_
#define SCAM_SRC_MODELFACTORY_IFINDDATAFLOWFACTORY_H_

//#include "IFindDataFlow.h"
//#include "FindDataFlow.h"

namespace DESCAM {
class FindDataFlow;
class IFindDataFlow;
class IFindDataFlowFactory {
 public:
  virtual ~IFindDataFlowFactory() = default;
  virtual IFindDataFlow *create_new(clang::Stmt *stmt,
                                    Module *module,
                                    clang::CompilerInstance *ci,
                                    IFindDataFlowFactory *find_data_flow_factory,
                                    bool unsigned_flag = false) = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDDATAFLOWFACTORY_H_
