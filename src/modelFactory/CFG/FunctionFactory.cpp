//
// Created by ludwig on 19.07.18.
//

#include <PrintStmt.h>
#include <toPPA/SectionToPaths.h>
#include <toPPA/ValuePropagation.h>
#include "FunctionFactory.h"
#include "CfgUtilities.h"
/**
 * @brief Computes all possible return values dependent on the inputs
 * @param controlFlowMap
 */
SCAM::FunctionFactory::FunctionFactory(const std::map<int, CFGNode *> &controlFlowMap, Function  * function) {
    //Add a terminal node to the CFG
    auto cfgMapNew = SCAM::CfgUtilities::addTerminalNodeForFunctions(controlFlowMap);
    //Find for each if the start end endnode
    auto startEndMap = SCAM::CfgUtilities::getStartEndMap(cfgMapNew);
    //Find for each path start-end the visited nodes
    auto pathNodeMap = SCAM::CfgUtilities::getPathNodes(startEndMap);

    //Flatten the graph back to linear code
    FlattenWhile flattenWhile(cfgMapNew.at(0), cfgMapNew.at(-1), startEndMap, pathNodeMap);

    //Save the resulting stmtList
    this->stmtList = flattenWhile.getStmtList();

    //Computes all paths that lead to a return
    SectionToPaths sectionToPaths(std::map<std::string,std::vector<Stmt*> >({std::make_pair("run",this->stmtList)}));
    ValuePropagation valuePropagation(sectionToPaths.getNewSectionPathMap(), function);
    //A path is described by the trigger conditions and the return value
    //The return value condition map stores the return value and the trigger conditions for this value, which rely on the parameters
    std::map<SCAM::Return *,std::vector<SCAM::Expr*> > returnValueConditionMap; //! Stores the return value for each possible sequence of inputs
    std::vector<std::pair<SCAM::Return *,std::vector<SCAM::Expr*> > >returnValueConditionList; //! Stores the return value for each possible sequence of inputs
    for (auto &&section : valuePropagation.getNewSectionPathMap()) {
        for (auto &&path : section.second) {
            assert(path->getReturnValue()!= nullptr && "Return value is null");
            returnValueConditionList.push_back((std::make_pair(path->getReturnValue(),path->getConditionList())));
        }
    }

    //function->setReturnValueConditionMap(returnValueConditionMap);
    function->setReturnValueConditionList(returnValueConditionList);
}

const std::vector<SCAM::Stmt *> &SCAM::FunctionFactory::getStmtList() const {
    return stmtList;
}
