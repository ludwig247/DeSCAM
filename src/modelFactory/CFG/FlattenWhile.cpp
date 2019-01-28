//
// Created by tobias on 19.04.16.
//

#include "FlattenWhile.h"
#include "FlattenIf.h"

SCAM::FlattenWhile::FlattenWhile(SCAM::CFGNode *startNode, SCAM::CFGNode *endNode,
                                 std::map<SCAM::CFGNode *, SCAM::CFGNode *> &startEndMap, std::map<SCAM::CFGNode*,std::set<int>>& pathNodeMap) :
        startNode(startNode),
        endNode(endNode),
        startEndMap(startEndMap),
        pathNodeMap(pathNodeMap){

     this->core(this->startNode->getSuccessorList()[0]);
}



void SCAM::FlattenWhile::core(SCAM::CFGNode *node) {
    //Add all stmts of block to the stmtList
    if (node != endNode) {
        //std::cout << node->getBlockID() << std::endl;
        for (auto stmt: node->getStmtList()) {
            this->stmtList.push_back(stmt);
        }
        //Check for a branching
        if (node->hasIf()) {
            //Build SCAM:ite for this if-block
            FlattenIf cascadeITE = FlattenIf(node, startEndMap[node], this->startEndMap, this->pathNodeMap);
            this->stmtList.push_back(cascadeITE.getITE());
            //Conntinue with endNode of the ite
            if (startEndMap[node] != endNode) {
                this->core(startEndMap[node]);
                return;
            }
        }
        else{
            //Not a branching and not a the end of true(false) path
            if(node->getSuccessorList().empty() && node->getBlockID() == -1) return;
            this->core(node->getSuccessorList()[0]);

        }
    }
    else {
        //std::cout << node->getBlockID() <<" STOP" << std::endl;
    }

}

std::vector<SCAM::Stmt *> SCAM::FlattenWhile::getStmtList() {
    return this->stmtList;

}
