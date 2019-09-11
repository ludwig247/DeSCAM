//
// Created by tobias on 20.07.18.
//

#include "CfgUtilities.h"
#include "FindEndNode.h"

/**
 *
 * @param cfgMap
 * @return Return value represetns a map that stores for each if the node where all paths merge again
 */
std::map<SCAM::CFGNode *, SCAM::CFGNode *> SCAM::CfgUtilities::getStartEndMap(const std::map<int, SCAM::CFGNode *> &cfgMap) {
    std::map<SCAM::CFGNode *, SCAM::CFGNode *> startEndMap;
    for (auto block: cfgMap) {
        auto startNode = block.second;
        if (startNode->hasTerminator() && startNode->getSuccessorList().size() >= 1) {
            FindEndNode visitor = FindEndNode(startNode);
            startEndMap.insert(std::make_pair(startNode, visitor.getEndNode()));
            //Start - End point of path
            if(visitor.getEndNode() == nullptr){
                throw std::runtime_error("No end-node found for ID[" + block.first);
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
std::map<SCAM::CFGNode*,std::set<int>> SCAM::CfgUtilities::getPathNodes(const std::map<SCAM::CFGNode *, SCAM::CFGNode *> & startEndMap) {
    std::map<SCAM::CFGNode*,std::set<int>> pathNodeMap;
    for(auto nodePair: startEndMap){
        EnumartePathsVisitor enumartePathsVisitor(nodePair.first,nodePair.second);
        pathNodeMap.insert(std::make_pair(nodePair.first,enumartePathsVisitor.getNodeList()));
    }
    return pathNodeMap;
}
/**
 *
 * @param cfgMap
 * @return Adds a terminal node(ID=-1) for functions that is reached after the return is called
 */
std::map<int, SCAM::CFGNode *> SCAM::CfgUtilities::addTerminalNodeForFunctions(const std::map<int, SCAM::CFGNode *> &cfgMap) {

    std::map<int, SCAM::CFGNode *> newCfgMap;
    newCfgMap.insert(cfgMap.begin(),cfgMap.end());
    CFGNode * terminalNode = new CFGNode(-1,-1);
    for(auto node: cfgMap){
        if(node.second->getSuccessorList().size() == 0){
            node.second->addSuccessor(terminalNode);
        }
    }
    newCfgMap.insert(std::make_pair(terminalNode->getBlockID(),terminalNode));

    return newCfgMap;
}
