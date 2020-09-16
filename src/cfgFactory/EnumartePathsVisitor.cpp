//
// Created by tobias on 18.02.16.
//


#include <iostream>
#include "EnumartePathsVisitor.h"


DESCAM::EnumartePathsVisitor::EnumartePathsVisitor(DESCAM::CfgBlock *startNode, DESCAM::CfgBlock *endNode) :
        startNode(startNode),
        endNode(endNode) {
    this->core(startNode, {});
}

void DESCAM::EnumartePathsVisitor::core(DESCAM::CfgBlock *node, std::set<int> path) {
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
            this->core(succ, path);
        }
    }
}

const std::set<int> &DESCAM::EnumartePathsVisitor::getNodeList() const {
    return nodeList;
}
