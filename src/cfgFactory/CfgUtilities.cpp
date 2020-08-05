//
// Created by tobias on 20.07.18.
//

#include "CfgUtilities.h"
#include "FindEndNode.h"
#include "FatalError.h"
#include "Logger/Logger.h"


/**
 *
 * @param cfgMap
 * @return Return value represetns a map that stores for each if the node where all paths merge again
 */
std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> DESCAM::CfgUtilities::getStartEndMap(const std::map<int, DESCAM::CfgBlock *> &cfgMap) {
    std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> startEndMap;
    for (auto block: cfgMap) {
        auto startNode = block.second;
        if (startNode->hasTerminator() && startNode->getSuccessorList().size() >= 1) {
            FindEndNode visitor = FindEndNode(startNode);
            startEndMap.insert(std::make_pair(startNode, visitor.getEndNode()));
            //Start - End point of path
            if (visitor.getEndNode() == nullptr) {
                TERMINATE("No end-node found for ID[" + block.first);
            }
        }
    }

    return startEndMap;
}

/**
 *
 * @param startEndMap
 * @return computes all visited nodes among each path between start/end node
 */
std::map<DESCAM::CfgBlock *, std::set<int>> DESCAM::CfgUtilities::getPathNodes(const std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> &startEndMap) {
    std::map<DESCAM::CfgBlock *, std::set<int>> pathNodeMap;
    for (auto nodePair: startEndMap) {
        EnumartePathsVisitor enumartePathsVisitor(nodePair.first, nodePair.second);
        pathNodeMap.insert(std::make_pair(nodePair.first, enumartePathsVisitor.getNodeList()));
    }
    return pathNodeMap;
}

/**
 *
 * @param cfgMap
 * @return Adds a terminal node(ID=-1) for functions that is reached after the return is called
 */
std::map<int, DESCAM::CfgBlock *> DESCAM::CfgUtilities::addTerminalNodeForFunctions(const std::map<int, DESCAM::CfgBlock *> &cfgMap) {

    std::map<int, DESCAM::CfgBlock *> newCfgMap;
    newCfgMap.insert(cfgMap.begin(), cfgMap.end());
    CfgBlock *terminalNode = new CfgBlock(-1, -1);
    for (auto node: cfgMap) {
        if (node.second->getSuccessorList().size() == 0) {
            node.second->addSuccessor(terminalNode);
        }
    }
    newCfgMap.insert(std::make_pair(terminalNode->getBlockID(), terminalNode));

    return newCfgMap;
}
