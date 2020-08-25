//
// Created by ludwig on 19.07.18.
//

#ifndef PROJECT_FUNCTIONFACTORY_H
#define PROJECT_FUNCTIONFACTORY_H



#include <CfgBlock.h>
#include <Function.h>
#include "FindPathsToReturn.h"
#include <CfgUtilities.h>
#include <FlattenWhile.h>
#include "ReconstructOperations.h"
#include <map>

namespace DESCAM{
    /***
     * \bref Builds a function from a CFG
     *
     */
class FunctionFactory {
public:
    FunctionFactory(const std::map<int, CfgBlock *> &controlFlowMap, Function *function, DESCAM::Module *module);

    virtual ~FunctionFactory() = default;

    const std::vector<Stmt *> &getStmtList() const;

private:
    std::vector<Stmt*> stmtList;
};


}


#endif //PROJECT_FUNCTIONFACTORY_H
