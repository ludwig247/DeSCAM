//
// Created by tobias on 14.10.20.
//

#ifndef SCAM_SRC_MODELFACTORY_IFINDDATAFLOWFACTORY_H_
#define SCAM_SRC_MODELFACTORY_IFINDDATAFLOWFACTORY_H_

#include "IFindDataFlow.h"
#include "FindDataFlow.h"
namespace DESCAM {
class IFindDataFlowFactory {
 public:
  virtual IFindDataFlow *create_new(clang::Stmt *stmt,
                               Module *module,
                               clang::CompilerInstance *ci,
                               bool unsigned_flag = false) = 0;
};
}

#endif //SCAM_SRC_MODELFACTORY_IFINDDATAFLOWFACTORY_H_
