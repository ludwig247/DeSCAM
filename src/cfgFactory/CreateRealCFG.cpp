//#include <utility>

//
// Created by tobias on 12.12.18.
//

#include <set>
#include <assert.h>
#include <PrintStmt.h>
#include "CreateRealCFG.h"
#include "Behavior/CfgNode.h"
#include "Model.h"

DESCAM::CreateRealCFG::CreateRealCFG(const std::map<int, DESCAM::CfgBlock *> &controlFlowMap) {

    auto entry = controlFlowMap.at(0);
    assert(entry->getPredecessorList().empty() && "Not an entry node");

    //Step1: Create a starting and ending node for each block
    //Storing a pair: blockID to cfgNode
    std::map<int, int> startNodeMap;
    std::map<int, int> endNodeMap;
    for (auto block: controlFlowMap) {
//        std::cout << block.second->print() << std::endl;
        auto stmtList = block.second->getStmtList();
        CfgNode *start = nullptr;
        CfgNode *end = nullptr;
        if (block.second->getStmtList().empty()) {
            //Create an empty node

            if (block.second->getTerminator() != nullptr) {
                auto newNode = new CfgNode(block.second->getTerminator());
                //end->addSuccessor(newNode);
                cfg.insert(std::make_pair(newNode->getId(), newNode));
                start = newNode;
                end = newNode;
            } else {
                auto *emptyNode = new CfgNode();
                start = emptyNode;
                end = emptyNode;
                cfg.insert(std::make_pair(emptyNode->getId(), emptyNode));
            }

        } else {
            auto startStmt = *stmtList.begin();
            start = new CfgNode(startStmt);
            cfg.insert(std::make_pair(start->getId(), start));
            end = start;

            for (int i = 1; i < stmtList.size(); i++) {
                auto newNode = new CfgNode(stmtList.at(i));
                end->addSuccessor(newNode);
                cfg.insert(std::make_pair(newNode->getId(), newNode));
                end = newNode;
            }

            if (block.second->getTerminator() != nullptr) {
                auto newNode = new CfgNode(block.second->getTerminator());
                end->addSuccessor(newNode);
                cfg.insert(std::make_pair(newNode->getId(), newNode));
                end = newNode;

            }
        }

        assert(start != nullptr && end != nullptr);

        startNodeMap.insert(std::make_pair(block.first, start->getId()));
        endNodeMap.insert(std::make_pair(block.first, end->getId()));

    }


    for (auto block: controlFlowMap) {
        for (auto succ: block.second->getSuccessorList()) {
            auto endNode = endNodeMap.at(block.first);
            auto succNode = startNodeMap.at(succ->getBlockID());
            cfg.at(endNode)->addSuccessor(cfg.at(succNode));
        }

    }

//    for(auto node : blockCFG) {
//        std::cout<< node.second->print();
//    }
//    for(auto node: startNodeMap){
//        std::cout << "BLOCK ID" << node.first << ": " << "ID:" << node.second << std::endl;
//    }
//    std::cout << "--" << std::endl;
//    for(auto node: endNodeMap){
//        std::cout << "BLOCK ID" << node.first << ": " << "ID:" << node.second << std::endl;
//    }
//
//    TERMINATE("STOP");


}

const std::map<int, DESCAM::CfgNode *> &DESCAM::CreateRealCFG::getCFG() const {
    return cfg;
}