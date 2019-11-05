//
// Created by M.I.Alkoudsi on 27.07.19.
//
#include "RenumberCFG.h"
#include "Optimizer/Debug.h"


SCAM::RenumberCFG::RenumberCFG(std::map<int, SCAM::CfgBlock *> CFG) : blockCFG(std::move(CFG)) {

    std::vector<bool> visitedNodesVector((*this->blockCFG.rbegin()).first + 1, false);
    std::stack<SCAM::CfgBlock *> ifNodes;
    SCAM::CfgBlock *currentNode = (*this->blockCFG.begin()).second;
    int newId = 0;
    while (!areAllCFGNodesVisited(visitedNodesVector, this->blockCFG.size())) {
#ifdef DEBUG_RENUMBER_CFG
        std::cout << "current node is " << currentNode->getBlockID() << std::endl;
#endif
        if (visitedNodesVector[currentNode->getBlockID()] == false) {
            visitedNodesVector[currentNode->getBlockID()] = true;
            if (this->blockCFG.find(currentNode->getBlockID()) != this->blockCFG.end()) {
                this->newBlockCFG.insert(std::make_pair(newId, currentNode));
                newId++;
                if (currentNode->getSuccessorList().size() == 1) {
                    currentNode = currentNode->getSuccessorList()[0];
                } else if (currentNode->getSuccessorList().size() > 1) {
                    ifNodes.push(currentNode);
                    currentNode = currentNode->getSuccessorList()[0];
                }
            }
        } else if (!ifNodes.empty()) {
            auto ifNode = ifNodes.top();
            currentNode = ifNode->getSuccessorList()[1];
            ifNodes.pop();
        } else if (areAllCFGNodesVisited(visitedNodesVector, this->blockCFG.size())) { break; }
        else {
            throw std::runtime_error("unexpected behavior while renumbering blockCFG nodes!");
        }
    }
    for (auto node : this->newBlockCFG) {
        node.second->setBlockID(node.first);
    }
}

SCAM::RenumberCFG::RenumberCFG(std::map<int, SCAM::CfgNode *> CFG) : nodeCFG(std::move(CFG)) {
    std::vector<bool> visitedNodesVector((*this->nodeCFG.rbegin()).first + 10, false);
    std::stack<SCAM::CfgNode *> ifNodes;
    SCAM::CfgNode *currentNode = (*this->nodeCFG.begin()).second;
    int newId = 0;
    while (!areAllCFGNodesVisited(visitedNodesVector, this->nodeCFG.size())) {
#ifdef DEBUG_RENUMBER_CFG
       // std::cout << "current node is " << currentNode->getId() << std::endl;
#endif
        if (visitedNodesVector[currentNode->getId()] == false) {
            visitedNodesVector[currentNode->getId()] = true;
            if (this->nodeCFG.find(currentNode->getId()) != this->nodeCFG.end()) {
                this->newNodeCFG.insert(std::make_pair(newId, currentNode));
                newId++;
                if (currentNode->getSuccessorList().size() > 1) {
                    ifNodes.push(currentNode);
                }
                currentNode = currentNode->getSuccessorList()[0];
            }
        } else if (!ifNodes.empty()) {
            auto ifNode = ifNodes.top();
            currentNode = ifNode->getSuccessorList()[1];
            ifNodes.pop();
        } else if (areAllCFGNodesVisited(visitedNodesVector, this->nodeCFG.size())) { break; }
        else {
            for(auto node : this->nodeCFG){if (visitedNodesVector[node.first] == false){std::cout << "node" << node.first << " is not visited" << std::endl;  }}
            throw std::runtime_error("unexpected behavior while renumbering blockCFG nodes!");
        }
    }
    for (auto node : this->newNodeCFG) {
        node.second->replaceId(node.first);
    }

}

bool SCAM::RenumberCFG::areAllCFGNodesVisited(const std::vector<bool> &VistedNodesVector, int numCFGNodes) {
    int cnt = 0;
    for (auto node : VistedNodesVector) {
        if (node) { cnt++; }
    }
    return cnt == numCFGNodes;
}


const std::map<int, SCAM::CfgBlock *> &SCAM::RenumberCFG::getNewBlockCFG() const {
    return this->newBlockCFG;
}

const std::map<int, SCAM::CfgNode *> &SCAM::RenumberCFG::getNewNodeCFG() const {
    return this->newNodeCFG;
}


