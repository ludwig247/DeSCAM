//
// Created by M.I.Alkoudsi on 27.07.19.
//

#include "RemoveEmptyNodes.h"



DESCAM::RemoveEmptyNodes::RemoveEmptyNodes(std::map<int, DESCAM::CfgBlock *> CFG) : blockCFG(std::move(CFG)) {
    for (auto node : this->blockCFG) {
        if (!node.second->hasTerminator() && node.second->getStmtList().empty()) {
            if (node.first == 0 || node.second->getPredecessorList().size() > 2) {
                continue;
            }
            this->emptyNodesSet.insert(node.first);
        }
    }

    for (auto nodeId : this->emptyNodesSet) {
        if (this->blockCFG.find(nodeId) != this->blockCFG.end()) {
            removeNullStatementAndReplaceItInPredecessorsAndSuccessors(nodeId);
        }
    }

    if (!emptyNodesSet.empty()) {
        RenumberCFG rcn(this->blockCFG);
        this->blockCFG = rcn.getNewBlockCFG();
    }

}

const std::map<int, DESCAM::CfgBlock *> &DESCAM::RemoveEmptyNodes::getNewBlockCFG() const {
    return this->blockCFG;
}


void DESCAM::RemoveEmptyNodes::removeNullStatementAndReplaceItInPredecessorsAndSuccessors(int nodeId) {
    auto cfgBlock = this->blockCFG.at(nodeId);
    std::vector<bool> alreadyReplacedPredecessorInSuccessorIndicatorVector(
            this->blockCFG.at(nodeId)->getSuccessorList().size(), false);
    std::vector<bool> alreadyReplacedSuccessorInPredecessorIndicatorVector(
            this->blockCFG.at(nodeId)->getSuccessorList().size(), false);
    int succIdx = 0, predIdx = 0;
    for (auto predecessor : this->blockCFG.at(nodeId)->getPredecessorList()) {
        for (auto successor : this->blockCFG.at(nodeId)->getSuccessorList()) {
            if (!alreadyReplacedPredecessorInSuccessorIndicatorVector[succIdx]) {
                removeOrReplacePredecessorInSuccessor(cfgBlock, predecessor, successor);
                alreadyReplacedPredecessorInSuccessorIndicatorVector[succIdx] = true;
            } else { successor->addPredecessor(predecessor); }
            if (!alreadyReplacedSuccessorInPredecessorIndicatorVector[predIdx]) {
                removeOrReplaceSuccessorInPredecessor(cfgBlock, successor, predecessor);
                alreadyReplacedSuccessorInPredecessorIndicatorVector[predIdx] = true;
            } else { predecessor->addSuccessor(successor); }
            succIdx++;
        }
        succIdx = 0;
        predIdx++;
    }
    this->blockCFG.erase(nodeId);
}

void
DESCAM::RemoveEmptyNodes::removeOrReplacePredecessorInSuccessor(DESCAM::CfgBlock *cfgBlock, DESCAM::CfgBlock *Predecessor,
                                                              DESCAM::CfgBlock *successor) {
    bool predAlreadyInSuccPredList = false;
    for (auto predInSuc : successor->getPredecessorList()) {
        if (predInSuc == Predecessor) {
            predAlreadyInSuccPredList = true;
        }
    }
    if (predAlreadyInSuccPredList) {
        successor->removePredecessor(cfgBlock);
    } else {
        successor->replacePredecessor(cfgBlock, Predecessor);
    }
}

void
DESCAM::RemoveEmptyNodes::removeOrReplaceSuccessorInPredecessor(DESCAM::CfgBlock *cfgBlock, DESCAM::CfgBlock *successor,
                                                              DESCAM::CfgBlock *Predecessor) {
    bool succAlreadyInPredSuccList = false;
    for (auto succInPred : Predecessor->getSuccessorList()) {
        if (succInPred == successor) {
            succAlreadyInPredSuccList = true;
        }
    }
    if (succAlreadyInPredSuccList) {
        Predecessor->removeSuccessor(cfgBlock);
    } else {
        Predecessor->replaceSuccessor(cfgBlock, successor);
    }

}


