//
// Created by tobias on 13.10.15.
//


#include <algorithm>
#include <PrintStmt.h>
#include "CfgNode.h"

namespace DESCAM {
    int CfgNode::node_cnt = 0;

    CfgNode::CfgNode(Stmt *stmt) :
            stmt(stmt),
            id(CfgNode::node_cnt++) {}

    CfgNode::CfgNode() :
            id(CfgNode::node_cnt++),
            stmt(nullptr) {}


    void CfgNode::addSuccessor(CfgNode *node) {
        node->addPredecessor(this);
        this->successorList.push_back(node);
    }

    void CfgNode::addPredecessor(CfgNode *node) const {
        bool inList = false;
        for (auto pred: this->predecessorList) {
            if (pred == node) inList = true;
        }
        if (!inList) this->predecessorList.push_back(node);
    }

    std::vector<CfgNode *> CfgNode::getSuccessorList() const {
        return this->successorList;
    }

    std::vector<CfgNode *> CfgNode::getPredecessorList() const {
        return this->predecessorList;
    }


    void CfgNode::setStmt(Stmt *stmt) {
//        CfgNode::stmt = stmt;

        this->stmt = stmt;
    }


    //! Replaces a successor with a new value
    void CfgNode::removeSuccessor(CfgNode *node) const {
        this->successorList.erase(std::remove(this->successorList.begin(), this->successorList.end(), node), this->successorList.end());
    }

    void CfgNode::replaceSuccessor(CfgNode *oldValue, CfgNode *newValue) const {
        std::replace(this->successorList.begin(), this->successorList.end(), oldValue, newValue);

    }

    void CfgNode::removePredecessor(CfgNode *node) const {
        this->predecessorList.erase(std::remove(this->predecessorList.begin(), this->predecessorList.end(), node));
    }

    void CfgNode::replacePredecessor(CfgNode *oldValue, CfgNode *newValue) const {
        std::replace(this->predecessorList.begin(), this->predecessorList.end(), oldValue, newValue);
    }

    Stmt *CfgNode::getStmt() const {
        return stmt;
    }

    const std::string CfgNode::print() {
        std::stringstream ss;
        ss << "[ID" << id << "]\t";// << std::endl;
        if (stmt == nullptr)
            ss << "nullptr" << std::endl;
        else
            ss << PrintStmt::toString(this->stmt) << std::endl;
        ss << "\t\t\tPred: ";
        for (auto pred: this->predecessorList) {
            ss << "[ID" << pred->getId() << "], ";
        }
        ss << std::endl << "\t\t\tSucc: ";
        for (auto succ: this->successorList) {
            ss << "[ID" << succ->getId() << "], ";
        }

        ss << std::endl;
        return ss.str();
    }

    const std::string CfgNode::printShort() {
        std::stringstream ss;
        ss << "[ID" << id << "]\t";// << std::endl;
        if (stmt == nullptr)
            ss << "nullptr" << std::endl;
        else
            ss << PrintStmt::toString(this->stmt) << std::endl;
        return ss.str();
    }

    int CfgNode::getId() const {
        return id;
    }

    void CfgNode::replaceId(int id_arg) {
        this->id = id_arg;
    }


    CfgNode::~CfgNode() {
        node_cnt--;
    }

    int CfgNode::getNode_cnt() {
        return node_cnt;
    }

    const std::string CfgNode::getName() {
        std::stringstream ss;
        ss << "state_" << id;
        return ss.str();
    }

    void CfgNode::setSuccessorList(std::vector<CfgNode *> succList) {
        this->successorList = succList;
    }

    void CfgNode::setPredecessorList(std::vector<CfgNode *> predList) {
        this->predecessorList = predList;
    }

}
