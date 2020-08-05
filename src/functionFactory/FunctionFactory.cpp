//
// Created by ludwig on 19.07.18.
//


#include "FunctionFactory.h"


/**
 * @brief Computes all possible return values dependent on the inputs
 * @param controlFlowMap
 */
DESCAM::FunctionFactory::FunctionFactory(const std::map<int, CfgBlock *> &controlFlowMap, Function *function, DESCAM::Module *module) {
    //Add a terminal node to the blockCFG
    auto cfgMapNew = DESCAM::CfgUtilities::addTerminalNodeForFunctions(controlFlowMap);
    //Find for each if the start end endnode
    auto startEndMap = DESCAM::CfgUtilities::getStartEndMap(cfgMapNew);
    //Find for each path start-end the visited nodes
    auto pathNodeMap = DESCAM::CfgUtilities::getPathNodes(startEndMap);

    //Flatten the graph back to linear code
    FlattenWhile flattenWhile(cfgMapNew.at(0), cfgMapNew.at(-1), startEndMap, pathNodeMap);

    //Save the resulting stmtList
    this->stmtList = flattenWhile.getStmtList();

    //Computes all paths that lead to a return
    FindPathsToReturn pathsToReturn(this->stmtList);

    //A path is described by the trigger conditions and the return value
    //The return value condition map stores the return value and the trigger conditions for this value, which rely on the parameters
    std::vector<std::pair<DESCAM::Return *, std::vector<DESCAM::Expr *> > > returnValueConditionList; //! Stores the return value for each possible sequence of inputs

    for (auto &&path : pathsToReturn.getPathList()) {
        auto returnValue = ReconstructOperations::getReturnValue(path->getStmtList(),module);
        auto conditions = ReconstructOperations::extractConditions(path->getStmtList(),module);
        if(returnValue == nullptr){
            for(auto stmt: path->getStmtList()){
                std::cout << PrintStmt::toString(stmt) << std::endl;
            }
        }
        assert(returnValue != nullptr && "Return value is null");
        returnValueConditionList.push_back((std::make_pair(returnValue, conditions)));
    }
    function->setReturnValueConditionList(returnValueConditionList);
}

const std::vector<DESCAM::Stmt *> &DESCAM::FunctionFactory::getStmtList() const {
    return stmtList;
}
