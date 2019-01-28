//
// Created by ludwig on 21.01.16.
//

#include "FlattenIf.h"


SCAM::FlattenIf::FlattenIf(SCAM::CFGNode *startNode, SCAM::CFGNode *endNode, std::map<SCAM::CFGNode *, SCAM::CFGNode *> &startEndMap, std::map<SCAM::CFGNode*,std::set<int>>& pathNodeMap ) :
        startNode(startNode),
        endNode(endNode),
        ite(nullptr),
        pass(0),
        startEndMap(startEndMap),
        pathNodeMap(pathNodeMap){

    SCAM::If *stmt = dynamic_cast<SCAM::If *>(startNode->getTerminator());
    this->ite = new ITE(stmt->getConditionStmt());

    //Find all elements on the true path
    //std::cout << "NODE[" << startNode->getBlockID() << "]" << std::endl;
    //std::cout << "TRUE" << std::endl;
    SCAM::CFGNode *truePath = startNode->getSuccessorList()[0];
    this->core((truePath));
    //Find all elements on the false path
    this->pass = 1;
    //std::cout << "FALSE" << std::endl;
    SCAM::CFGNode *falsePath = startNode->getSuccessorList()[1];
    this->core(falsePath);
}


void SCAM::FlattenIf::core(SCAM::CFGNode *node) {
    //Is node on path between
    if(pathNodeMap[startNode].find(node->getBlockID()) == pathNodeMap[startNode].end()){
        std::cout << startNode->getBlockID() << ": " << node->getBlockID() << std::endl;
        return;
    }
    //Add all stmts of block to the stmtLista
    if (node != endNode) {
        //std::cout << node->getBlockID() << std::endl;
        for (auto stmt: node->getStmtList()) {
            if (pass == 0) this->ite->addIfList(stmt);
            if (pass == 1) this->ite->addElseList(stmt);
        }
        //Check for a branching
        if (node->hasIf()) {
            //Build SCAM:ite for this if-block
            FlattenIf cascadeITE = FlattenIf(node, startEndMap[node], this->startEndMap, this->pathNodeMap);
            if (pass == 0) this->ite->addIfList(cascadeITE.getITE());
            if (pass == 1) this->ite->addElseList(cascadeITE.getITE());
            //Conntinue with endNode of the ite
            if (startEndMap[node] != endNode) {
                this->core(startEndMap[node]);
                return;
            }
        } else {
            //Not a branching and not a the end of true(false) path
            this->core(node->getSuccessorList()[0]);
            return;
        }
    } else {
        //std::cout << node->getBlockID() <<" STOP" << std::endl;
    }
}

SCAM::ITE *SCAM::FlattenIf::getITE() {
    return this->ite;
}
