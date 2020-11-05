//
// Created by tobias on 13.10.15.
//

#include <iostream>
#include <If.h>
#include <stdexcept>
#include <llvm/Support/raw_ostream.h>
#include <PrintStmt.h>
#include "CfgBlock.h"
#include "StmtCastVisitor.h"

namespace DESCAM {
//Constructor
    CfgBlock::CfgBlock() :
            blockID(-1),
            cfgBlockID(-1),
            terminator(nullptr) {
    }

    CfgBlock::CfgBlock(int blockID, int cfgBlockID) :
            blockID(blockID),
            cfgBlockID(cfgBlockID),
            terminator(nullptr) {

    }


//GETTER SETTER
    void CfgBlock::addSuccessor(CfgBlock *node) {
        node->addPredecessor(this);
        this->successorList.push_back(node);

    }

    void CfgBlock::addPredecessor(CfgBlock *node) {
        bool inList = false;
        for (auto pred: this->predecessorList) {
            if (pred == node) inList = true;
        }
        if (!inList) this->predecessorList.push_back(node);
    }

    std::vector<CfgBlock *> CfgBlock::getSuccessorList() {
        return this->successorList;
    }

    std::vector<CfgBlock *> CfgBlock::getPredecessorList() {
        return this->predecessorList;
    }

    int CfgBlock::getBlockID() const {
        return this->blockID;
    }


    void CfgBlock::setBlockID(int id) {
        this->blockID = id;

    }

    int CfgBlock::getClangBlockID() {
        return this->cfgBlockID;
    }

    bool CfgBlock::hasTerminator() {
        if (this->terminator == nullptr) {
            return false;
        }
        return true;
    }

    void CfgBlock::addStmt(DESCAM::Stmt *stmt) {
        this->stmtList.push_back(stmt);
    }

    std::vector<DESCAM::Stmt *> CfgBlock::getStmtList() {
        return this->stmtList;
    }

    void CfgBlock::setTerminator(DESCAM::Stmt *terminator) {
        this->terminator = terminator;

    }

    DESCAM::Stmt *CfgBlock::getTerminator() {
        return this->terminator;
    }


    bool CfgBlock::hasIf() {
        if (this->hasTerminator()) {
            if (DESCAM::If *stmt = StmtCastVisitor<DESCAM::If>(this->terminator).Get()) {
                return true;
            }
        }
        return false;
    }

    //! Replaces a successor with a new value
    void CfgBlock::replaceSuccessor(CfgBlock *oldValue, CfgBlock *newValue) {
        std::replace(this->successorList.begin(), this->successorList.end(), oldValue, newValue);
    }

    void CfgBlock::removeSuccessor(CfgBlock *succBlock) {
        this->successorList.erase(std::remove(this->successorList.begin(), this->successorList.end(), succBlock));
    }


    void CfgBlock::removePredecessor(CfgBlock *node) {
        this->predecessorList.erase(std::remove(this->predecessorList.begin(), this->predecessorList.end(), node));
    }

    void CfgBlock::replacePredecessor(CfgBlock *oldValue, CfgBlock *newValue) {
        std::replace(this->predecessorList.begin(), this->predecessorList.end(), oldValue, newValue);
    }

    const std::string CfgBlock::print() {
        std::stringstream ss;
        ss << "[ID" << this->blockID << "] [B" << this->cfgBlockID << "]" << std::endl;
        ss << "Stmtlist: " << stmtList.size() << std::endl;
        for (auto stmt: this->stmtList) {
            ss << PrintStmt::toString(stmt) << std::endl;
        }
        if (this->getTerminator() != nullptr)
            ss << PrintStmt::toString(this->getTerminator()) << std::endl;
        ss << "Pred: ";
        for (auto pred: this->predecessorList) {
            ss << "[ID" << pred->getBlockID() << "], ";
        }
        ss << std::endl << "Succ: ";
        for (auto succ: this->successorList) {
            ss << "[ID" << succ->getBlockID() << "], ";
        }

        ss << std::endl;
        return ss.str();

    }

    void CfgBlock::setStmtList(const std::vector<DESCAM::Stmt *> &newStmtList) {
        this->stmtList = newStmtList;
    }
}
