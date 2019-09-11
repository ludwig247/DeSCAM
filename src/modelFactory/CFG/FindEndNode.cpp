//
// Created by tobias on 18.02.16.
//

#include <iostream>
#include "FindEndNode.h"
#include <algorithm>
#include <assert.h>


/* !
 * \brief Method to compute the endNode of an If(same for wait and operation)
 *
 * (1) Decide wether node is a endNode(node where the branches of an if merge again)
 *      Switch(#pred):
 *      case(1): no merging point
 *               Decide whether node is a branch(if)
 *      case(2): trival merging point node is endNode
 *      case(3+): determine how many branches are coming from an outer if and how many from the current if
 *              - if only inner if-> node is endNode of startNode
 *              - outer if -> node is also endNode of an outer if
 * (2) Return
 */

SCAM::FindEndNode::FindEndNode(SCAM::CFGNode *startNode) :
        startNode(startNode),
        endNode(startNode){

    assert(startNode != nullptr);
    assert(startNode->hasTerminator());
    //Either starteNode is a while(true) with 1 successor or an if two successors ...
    assert((startNode->getSuccessorList().size() == 1 && dynamic_cast<SCAM::While *>(startNode->getTerminator()) != nullptr) ||
                   startNode->getSuccessorList().size() == 2) ;

    //CASE: While of thread
    if (startNode->getSuccessorList().size() == 1) {
        for (auto pred:  startNode->getPredecessorList()) {
            this->pathNodes.insert(pred->getBlockID());
        }
        this->recursion(startNode->getSuccessorList().at(0));
    }
    //CASE: If stmt
    else{
        //Idea: Visit true and false branch.
        //Visiting the true branch will add all nodes of the CFG to the set that are reachable from this node
        //Afterwards visit the false branch. The first node that is visited and contained in the set is the endnode
        this->recursion(startNode->getSuccessorList().at(0));
        this->recursion(startNode->getSuccessorList().at(1));
    }
}

void SCAM::FindEndNode::recursion(SCAM::CFGNode *node) {
    if (!pathNodes.insert(node->getBlockID()).second) {
        this->endNode = node;
        return;
    } else {
        if(!node->getSuccessorList().empty()) {
            this->recursion(node->getSuccessorList().at(0));
        }else{
            //HERE: two cases are possible
            //A function is analyzed then everything ends with the terminal node, which has an id == -1
            //Or the behavorial description uses for example a std::throw std::runtime_error("
            if(node->getBlockID()== -1) this->endNode = node;
            else throw std::runtime_error("Probably a std::exception, assert or unexpected return is used within the behavioral description!");
        }
    }
}

SCAM::CFGNode *SCAM::FindEndNode::getEndNode() {
    return this->endNode;
}


