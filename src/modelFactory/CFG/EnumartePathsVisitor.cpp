//
// Created by tobias on 18.02.16.
//


#include <iostream>
#include "EnumartePathsVisitor.h"


SCAM::EnumartePathsVisitor::EnumartePathsVisitor(SCAM::CFGNode *startNode, SCAM::CFGNode *endNode) :
        startNode(startNode),
        endNode(endNode){
    this->core(startNode,{});
}

void SCAM::EnumartePathsVisitor::core(SCAM::CFGNode *node, std::set<int> path) {
    if (node == endNode) {
        this->nodeList.insert(node->getBlockID());
        //Add all nodes among this path to the valid path list
        for (auto &&item : path) {
            this->nodeList.insert(item);
        }
        return;
    }
    //Path already visited?
    if (!this->visitedNodes.insert(node->getBlockID()).second) {
        return;
    }
    //Visit all successors
    else {
        path.insert(node->getBlockID());
        if (node->getSuccessorList().empty()) return;
        for (auto succ: node->getSuccessorList()) {
            this->core(succ,path);
        }
    }
}

const std::set<int> &SCAM::EnumartePathsVisitor::getNodeList() const {
    return nodeList;
}
