//
// Created by tobias on 13.10.15.
//

#include <iostream>
#include <If.h>
#include <stdexcept>
#include <llvm/Support/raw_ostream.h>
#include <PrintStmt.h>
#include "CFGNode.h"

namespace SCAM {
//Constructor
    CFGNode::CFGNode() :
            blockID(-1),
            cfgBlockID(-1),
            terminator(nullptr) {
    }

    CFGNode::CFGNode(int blockID, int cfgBlockID) :
            blockID(blockID),
            cfgBlockID(cfgBlockID),
            terminator(nullptr) {

    }


//GETTER SETTER
    void CFGNode::addSuccessor(CFGNode *node) {
        node->addPredecessor(this);
        this->successorList.push_back(node);

    }

    void CFGNode::addPredecessor(CFGNode *node) {
        bool inList = false;
        for(auto pred: this->predecessorList){
            if(pred == node) inList = true;
        }
        if(!inList) this->predecessorList.push_back(node);

    }

    std::vector<CFGNode *> CFGNode::getSuccessorList() {
        return this->successorList;
    }

    std::vector<CFGNode *> CFGNode::getPredecessorList() {
        return this->predecessorList;
    }

    int CFGNode::getBlockID() const {
        return this->blockID;
    }


    void CFGNode::setBlockID(int id) {
        this->blockID = id;

    }

    int CFGNode::getClangBlockID() {
        return this->cfgBlockID;
    }

    bool CFGNode::hasTerminator() {
        if (this->terminator == nullptr) {
            return false;
        }
        return true;
    }

    void CFGNode::addStmt(SCAM::Stmt *stmt) {
        this->stmtList.push_back(stmt);

    }

    std::vector<SCAM::Stmt *> CFGNode::getStmtList() {
        return this->stmtList;
    }

    void CFGNode::setTerminator(SCAM::Stmt *terminator) {
        this->terminator = terminator;

    }

    SCAM::Stmt *CFGNode::getTerminator(){
        return this->terminator;
    }


    bool CFGNode::hasIf() {
        if (this->hasTerminator()) {
            if (SCAM::If *stmt = dynamic_cast<SCAM::If *>(this->terminator)) {
                return true;
            }

        }
        return false;

    }
    //! Replaces a successor with a new value
    void CFGNode::replaceSuccessor(CFGNode *oldValue, CFGNode *newValue) {
        std::replace(this->successorList.begin(), this->successorList.end(), oldValue, newValue);

    }

    void CFGNode::removePredecessor(CFGNode *node) {
        this->predecessorList.erase(std::remove(this->predecessorList.begin(),this->predecessorList.end(),node));
    }

    const std::string CFGNode::print() {
        std::stringstream ss;
        ss << "[ID" << this->blockID << "] [B" << this->cfgBlockID << "]" << std::endl;
        ss << "Stmtlist: " << stmtList.size() << std::endl;
        for(auto stmt: this->stmtList){
            ss << PrintStmt::toString(stmt) << std::endl;
        }
        ss  << "Pred: ";
        for(auto pred: this->predecessorList){
            ss << "[ID" << pred->getBlockID() << "], ";
        }
        ss << std::endl << "Succ: ";
        for(auto succ: this->successorList){
            ss << "[ID" << succ->getBlockID() << "], ";
        }

        ss << std::endl;
        return ss.str();

    }



}
