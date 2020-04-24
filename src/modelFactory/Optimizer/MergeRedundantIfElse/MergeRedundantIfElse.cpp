//
// Created by M.I.Alkoudsi on 17.07.19.
//

#include "MergeRedundantIfElse.h"
#include "Optimizer/Debug.h"

/* In each iteration, the algorithm first finds the true branches in a level of conditional statements,
 * then it checks if all statements in a true branch of a conditional statement are equal to these
 * in another conditional statement in same level.
 */

SCAM::MergeRedundantIfElse::MergeRedundantIfElse(std::map<int, SCAM::CfgBlock *> CFG)
        : blockCFG(std::move(CFG)), currentElseIfID(0),
          currentIfID(0) {
    for (auto node : this->blockCFG) {
        if (node.second->hasIf()) {
            if (std::find(this->checkedIfStmts.begin(), this->checkedIfStmts.end(), node.first) !=
                this->checkedIfStmts.end()) {
                continue;
            }
            this->currentIfID = node.first;
            this->currentElseIfID = node.first;
            bool hasElseIfOrElse = false;
            if(node.second->getSuccessorList().size() < 2) continue;
            auto secondSucc = node.second->getSuccessorList()[1];
            if(!secondSucc){continue;}
            if (secondSucc->hasIf()) {
                if (notFromTheSameGroupIfStatement(secondSucc->getBlockID())) { continue; }
                //adding else if statements and their true branches to the stmtsMap
                hasElseIfOrElse = true;
                while (bool moreElseIf = true) {
                    this->currentElseIfID = this->blockCFG.at(
                            this->currentElseIfID)->getSuccessorList()[1]->getBlockID();
                    int currentBlockId = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[0]->getBlockID();
                    if (this->blockCFG.at(this->currentElseIfID)->getSuccessorList().size() == 1) {
                        this->currentElseIfID = this->blockCFG.at(this->currentElseIfID)->getPredecessorList()[0]->getBlockID();
                        break;
                    }
                    int elsebranchID = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getBlockID();
                    if (notFromTheSameGroupIfStatement(elsebranchID)) { // e.g., else { if(...){...} }
                        break;
                    }
                    this->checkedIfStmts.push_back(this->currentElseIfID);

                    if (elsebranchID > currentBlockId) {
                        addStatementsInTrueBranch(currentBlockId, elsebranchID, false);
                    } else { //else if without else
                        addStatementsInElseBranch(currentBlockId, false);
                        break;
                    }
                }
            } else if (node.second->getSuccessorList()[1]->getStmtList().empty()) { break; }

            if (this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getPredecessorList().size() ==
                1) {
                //adding statements in the else branch of the If statement to stmtsMap
                this->ifAndItsElseMap.insert(std::make_pair(currentIfID, this->blockCFG.at(
                        this->currentElseIfID)->getSuccessorList()[1]->getBlockID()));
                hasElseIfOrElse = true;
                int currentBlockId = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getBlockID();
                addStatementsInElseBranch(currentBlockId, true);
            }
            if (!hasElseIfOrElse) {
                this->stmtsMap.clear();
                continue;
            }
            //Adding statements in the true branch of the If statement to stmtsMap
            this->checkedIfStmts.push_back(this->currentIfID);
            int currentBlockId = this->blockCFG.at(this->currentIfID)->getSuccessorList()[0]->getBlockID();
            int elseBranchId = this->blockCFG.at(this->currentIfID)->getSuccessorList()[1]->getBlockID();
            addStatementsInTrueBranch(currentBlockId, elseBranchId, true);

            //Checking statements inside true branches of conditional statements
            int i = 0;
            for (auto conditionTrueBranchPair : this->stmtsMap) {
                auto pair = this->stmtsMap.begin();
                for (int j = 0; j <= i; j++) { pair++; }
                for (pair; pair != this->stmtsMap.end(); pair++) {
                    if (conditionTrueBranchPair.first == (*pair).first) { continue; }
                    if (conditionTrueBranchPair.second.size() != (*pair).second.size()) { continue; }
                    bool redundantLogic = true;
                    auto cond1TrueBranchPtr = conditionTrueBranchPair.second.begin();
                    auto cond2TrueBranchPtr = (*pair).second.begin();
                    while (cond1TrueBranchPtr != conditionTrueBranchPair.second.end()) {
#ifdef DEBUG_MERGE_REDUNDANT_IF_ELSE
                        auto stmt1 = SCAM::PrintStmt::toString((*cond1TrueBranchPtr));
                        auto stmt2 = SCAM::PrintStmt::toString((*cond2TrueBranchPtr));
                        std::cout << "(*cond1TrueBranchPtr)= " << stmt1 << std::endl;
                        std::cout << "(*cond2TrueBranchPtr)= " << stmt2 << std::endl << std::endl;
#endif
                          if(!(**cond1TrueBranchPtr == **cond2TrueBranchPtr)){
                            redundantLogic = false;
                            break;
                        }
                        cond1TrueBranchPtr++;
                        cond2TrueBranchPtr++;
                    }

                    if (redundantLogic) {
                        if ((conditionTrueBranchPair.first > 0 && (*pair).first < 0) ||
                            (conditionTrueBranchPair.first < 0 && (*pair).first > 0)) {
                            CfgBlock *ifBlock, *elseIfBlock;
                            if (conditionTrueBranchPair.first > 0) {
                                ifBlock = this->blockCFG.at(conditionTrueBranchPair.first);
                                elseIfBlock = this->blockCFG.at(-(*pair).first);
                            } else {
                                ifBlock = this->blockCFG.at((*pair).first);
                                elseIfBlock = this->blockCFG.at(-conditionTrueBranchPair.first);
                            }
                            if (toBeDeletedMap.find(elseIfBlock->getBlockID()) != toBeDeletedMap.end()) { continue; }
                            printWarning("if", PrintStmt::toString(ifBlock->getTerminator()), "else if",
                                         PrintStmt::toString(elseIfBlock->getTerminator()));

                            auto ifCondition = dynamic_cast<SCAM::If *>(ifBlock->getTerminator());
                            auto elseifcondition = dynamic_cast<SCAM::If *>(elseIfBlock->getTerminator());
                            if (ifCondition && elseifcondition) {
                                auto newCondition = new SCAM::If(
                                        new SCAM::Logical(ifCondition->getConditionStmt(), "or",
                                                          elseifcondition->getConditionStmt(),ifCondition->getStmtInfo()),ifCondition->getStmtInfo());
                                if (newCondition &&
                                    this->blockCFG.find(ifBlock->getBlockID()) != this->blockCFG.end()) {
                                    this->blockCFG.at(ifBlock->getBlockID())->setTerminator(newCondition);
                                }
                                this->toBeDeletedMap.insert(elseIfBlock->getBlockID());
                            }
                        } else if ((conditionTrueBranchPair.first < 0 && (*pair).first == 0) ||
                                   (conditionTrueBranchPair.first == 0 && (*pair).first < 0)) {
                            CfgBlock *elseIfBlock;
                            if (conditionTrueBranchPair.first == 0) {
                                elseIfBlock = this->blockCFG.at(-(*pair).first);
                            } else {
                                elseIfBlock = this->blockCFG.at(-conditionTrueBranchPair.first);
                            }
                            if (toBeDeletedMap.find(elseIfBlock->getBlockID()) != toBeDeletedMap.end()) { continue; }
                            printWarning("else if", PrintStmt::toString(elseIfBlock->getTerminator()), "else",
                                         "");
                            this->toBeDeletedMap.insert(elseIfBlock->getBlockID());

                        } else if ((conditionTrueBranchPair.first > 0 && (*pair).first == 0) ||
                                   (conditionTrueBranchPair.first == 0 && (*pair).first > 0)) {
                            CfgBlock *ifBlock;
                            if (conditionTrueBranchPair.first == 0) {
                                ifBlock = this->blockCFG.at((*pair).first);
                            } else {
                                ifBlock = this->blockCFG.at(conditionTrueBranchPair.first);
                            }
                            printWarning("if", PrintStmt::toString(ifBlock->getTerminator()), "else",
                                         "");
                            this->toBeDeletedMap.insert(ifBlock->getBlockID());
                        } else if (conditionTrueBranchPair.first < 0 && (*pair).first < 0) {
                            CfgBlock *elseifBlock1, *elseIfBlock2;
                            elseifBlock1 = this->blockCFG.at(-conditionTrueBranchPair.first);
                            elseIfBlock2 = this->blockCFG.at(-(*pair).first);
                            if (toBeDeletedMap.find(elseifBlock1->getBlockID()) != toBeDeletedMap.end() ||
                                toBeDeletedMap.find(elseIfBlock2->getBlockID()) != toBeDeletedMap.end()) { continue; }
                            printWarning("else if", PrintStmt::toString(elseifBlock1->getTerminator()), "else if",
                                         PrintStmt::toString(elseIfBlock2->getTerminator()));
                            auto elseIf1Condition = dynamic_cast<SCAM::If *>(elseifBlock1->getTerminator());
                            auto elseIf2condition = dynamic_cast<SCAM::If *>(elseIfBlock2->getTerminator());
                            if (elseIf1Condition && elseIf2condition) {
                                auto newCondition = new SCAM::If(
                                        new SCAM::Logical(elseIf1Condition->getConditionStmt(), "or",
                                                          elseIf2condition->getConditionStmt(),elseIf1Condition->getStmtInfo()),elseIf1Condition->getStmtInfo());
                                if (newCondition &&
                                    this->blockCFG.find(elseifBlock1->getBlockID()) != this->blockCFG.end()) {
                                    this->blockCFG.at(elseifBlock1->getBlockID())->setTerminator(newCondition);
                                }
                                this->toBeDeletedMap.insert(elseIfBlock2->getBlockID());
                            }

                        }
                    }
                }
                i++;
            }
#ifdef DEBUG_MERGE_REDUNDANT_IF_ELSE
            for (
                const auto &block
                    : this->stmtsMap) {
                std::cout << "if ID is " << block.first <<
                          std::endl;
                if (block.second.empty()) {
                    std::cout << "vector is empty";
                    continue;
                }
                for (
                    auto stmt
                        : block.second) {

                    if (stmt != nullptr) {
                        std::cout <<
                                  SCAM::PrintStmt::toString(stmt)
                                  <<
                                  std::endl;
                    }
                }
            }
#endif

            this->stmtsMap.clear();
        }
#ifdef DEBUG_MERGE_REDUNDANT_IF_ELSE
        std::cout << std::endl << "checked if stmts" << std::endl;
        for (auto ifstmt : this->checkedIfStmts) {
            std::cout << ifstmt << " ";
        }

        std::cout << std::endl << "Blocks inside the following if stmts" << std::endl;
        for (const auto &blockid : this->trueBranchBlocksMap) {
            std::cout << "if Node" << blockid.first << std::endl;
            for (auto id : blockid.second) {
                std::cout << id << " ";
            }
            std::cout << std::endl;
        }
#endif
    }
    for (auto ifStatement: this->toBeDeletedMap) {
        if (this->blockCFG.find(ifStatement) != this->blockCFG.end()) {
            auto elseifnode = this->blockCFG.at(ifStatement);
            for (auto pred : this->blockCFG.at(ifStatement)->getPredecessorList()) {
                pred->replaceSuccessor(elseifnode, elseifnode->getSuccessorList()[1]);
                elseifnode->getSuccessorList()[1]->replacePredecessor(elseifnode,pred);
            }
            this->blockCFG.erase(ifStatement);

            for (auto insideNode : this->trueBranchBlocksMap.at(ifStatement)) {
                if (this->blockCFG.find(insideNode) != this->blockCFG.end()) {
                    this->blockCFG.erase(insideNode);
                }
           }
        }
    }
}

void SCAM::MergeRedundantIfElse::addNestedIfStatementsToStmtsMap(int &currentBlockID,
                                                                 std::vector<SCAM::Stmt *> &ifStmtList) {
    ///add if statements
    auto elseIfID = currentBlockID;
    auto elseifbranchID = this->blockCFG.at(currentBlockID)->getSuccessorList()[1]->getBlockID();
    currentBlockID = this->blockCFG.at(currentBlockID)->getSuccessorList()[0]->getBlockID();
    if (currentBlockID < elseifbranchID) { //there is else if or else
        while (currentBlockID != elseifbranchID) {
            if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                    ifStmtList.push_back(stmt);
                }
            }
            if(this->blockCFG.at(currentBlockID)->hasIf()){
                ifStmtList.push_back(this->blockCFG.at(currentBlockID)->getTerminator());
            }
            currentBlockID++;
        }
        if (this->blockCFG.at(elseifbranchID)->hasIf()) {//there is else if
            bool moreElseIf = true;
            while (moreElseIf) {
                elseIfID = this->blockCFG.at(elseIfID)->getSuccessorList()[1]->getBlockID();
                if (this->blockCFG.at(elseIfID)->getSuccessorList().size() == 1){
                    elseIfID = this->blockCFG.at(elseIfID)->getPredecessorList()[0]->getBlockID();
                    break;
                }else if(notFromTheSameGroupIfStatement(elseIfID)){break;}
                currentBlockID = this->blockCFG.at(currentBlockID)->getSuccessorList()[0]->getBlockID();
                if (elseIfID > currentBlockID) {
                    while (currentBlockID != elseIfID) {
                        if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                            for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                                ifStmtList.push_back(stmt);
                            }
                        }
                        if(this->blockCFG.at(currentBlockID)->hasIf()){
                            ifStmtList.push_back(this->blockCFG.at(currentBlockID)->getTerminator());
                        }
                        currentBlockID++;
                    }
                } else { //else if without else
                    while (!(this->blockCFG.at(currentBlockID)->getSuccessorList().size() == 1 &&
                             (this->blockCFG.at(currentBlockID)->getBlockID() >
                              this->blockCFG.at(currentBlockID)->getSuccessorList()[0]->getBlockID()))) {
                        if (this->blockCFG.at(currentBlockID)->hasIf()) {
                            //call recursive function
                            if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                                for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                                    ifStmtList.push_back(stmt);
                                }
                            }
                            ifStmtList.push_back(this->blockCFG.at(currentBlockID)->getTerminator());
                            addNestedIfStatementsToStmtsMap(currentBlockID, ifStmtList);
                            currentBlockID--;
                        } else if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                            for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                                ifStmtList.push_back(stmt);
                            }
                        }
                        currentBlockID++;
                    }
                    if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                        for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                            ifStmtList.push_back(stmt);
                        }
                    }
                    if (!this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->hasIf()) {
                        moreElseIf = false;
                    }
                }
            }
        }
        if (this->blockCFG.at(elseIfID)->getSuccessorList()[1]->getPredecessorList().size() ==
            1) { //else statement
            currentBlockID = this->blockCFG.at(elseIfID)->getSuccessorList()[1]->getBlockID();
            while (!(this->blockCFG.at(currentBlockID)->getSuccessorList().size() == 1 &&
                     (this->blockCFG.at(currentBlockID)->getBlockID() >
                      this->blockCFG.at(currentBlockID)->getSuccessorList()[0]->getBlockID()))) {
                if (this->blockCFG.at(currentBlockID)->hasIf()) {
                    if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                        for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                            ifStmtList.push_back(stmt);
                        }
                    }
                    //call recursive function
                    addNestedIfStatementsToStmtsMap(currentBlockID, ifStmtList);
                    currentBlockID--;
                } else if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                    for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                        ifStmtList.push_back(stmt);
                    }
                }
                currentBlockID++;
            }
            if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                    ifStmtList.push_back(stmt);
                }
            }
        }
    } else {
        if (this->blockCFG.at(elseIfID)->getSuccessorList()[1]->getPredecessorList().size() ==
            1) { //else statement
            while (!(this->blockCFG.at(currentBlockID)->getSuccessorList().size() == 1 &&
                     (this->blockCFG.at(currentBlockID)->getBlockID() >
                      this->blockCFG.at(currentBlockID)->getSuccessorList()[0]->getBlockID()))) {
                if (this->blockCFG.at(currentBlockID)->hasIf()) {
                    if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                        for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                            ifStmtList.push_back(stmt);
                        }
                    }
                    //call recursive function
                    addNestedIfStatementsToStmtsMap(currentBlockID, ifStmtList);
                } else if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                    for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                        ifStmtList.push_back(stmt);
                    }
                }
                currentBlockID++;
            }
            if (!this->blockCFG.at(currentBlockID)->getStmtList().empty()) {
                for (auto stmt : this->blockCFG.at(currentBlockID)->getStmtList()) {
                    ifStmtList.push_back(stmt);
                }
            }
        }
    }
}

const std::map<int, SCAM::CfgBlock *> &SCAM::MergeRedundantIfElse::getNewBlockCFG() const {
    return this->blockCFG;
}

bool SCAM::MergeRedundantIfElse::notFromTheSameGroupIfStatement(int ifId) {
    if (this->blockCFG.at(ifId)->getPredecessorList().size() > 1) {
        for (auto pred : this->blockCFG.at(ifId)->getPredecessorList()) {
            if (pred->getBlockID() == ifId - 1) {
                return true;
            }
        }
    }
    return false;
}

void SCAM::MergeRedundantIfElse::addStatementsInTrueBranch(int &firstBlockInTrueBranchId, int &elseIfblockId,
                                                           bool isIfBranch) {
    std::vector<int> blocksInsideIf;
    for (auto i = firstBlockInTrueBranchId; i < elseIfblockId; i++) { blocksInsideIf.push_back(i); }

    std::vector<SCAM::Stmt *> ifStmtVector;
    while (firstBlockInTrueBranchId != elseIfblockId) {
        for (auto stmt : this->blockCFG.at(firstBlockInTrueBranchId)->getStmtList()) {
            ifStmtVector.push_back(stmt);
        }
        if(this->blockCFG.at(firstBlockInTrueBranchId)->hasIf()){
            ifStmtVector.push_back(this->blockCFG.at(firstBlockInTrueBranchId)->getTerminator());
        }
        firstBlockInTrueBranchId++;
    }
    if (isIfBranch) {
        this->trueBranchBlocksMap.insert(std::make_pair(this->currentIfID, blocksInsideIf));
        this->stmtsMap.insert(std::make_pair(this->currentIfID, ifStmtVector));
    } else {
        this->trueBranchBlocksMap.insert(std::make_pair(this->currentElseIfID, blocksInsideIf));
        this->stmtsMap.insert(std::make_pair(-this->currentElseIfID, ifStmtVector));
    }
}

void SCAM::MergeRedundantIfElse::addStatementsInElseBranch(int &currentBlockId, bool isElseBranch) {
    bool elseHasIf = false;
    std::vector<SCAM::Stmt *> ifStmtVector;
    while (!(this->blockCFG.at(currentBlockId)->getSuccessorList().size() == 1 &&
             (this->blockCFG.at(currentBlockId)->getBlockID() >
              this->blockCFG.at(currentBlockId)->getSuccessorList()[0]->getBlockID()))) {
        if (this->blockCFG.at(currentBlockId)->hasIf()) {
            for (auto stmt : this->blockCFG.at(currentBlockId)->getStmtList()) {
                ifStmtVector.push_back(stmt);
            }
            if(this->blockCFG.at(currentBlockId)->hasIf()){
                ifStmtVector.push_back(this->blockCFG.at(currentBlockId)->getTerminator());
            }
            //call recursive function
            addNestedIfStatementsToStmtsMap(currentBlockId, ifStmtVector);
            elseHasIf = true;
            currentBlockId--;
        } else if (!this->blockCFG.at(currentBlockId)->getStmtList().empty()) {
            for (auto stmt : this->blockCFG.at(currentBlockId)->getStmtList()) {
                ifStmtVector.push_back(stmt);
            }
        }
        currentBlockId++;
    }
    if (!elseHasIf) {
        if (!this->blockCFG.at(currentBlockId)->getStmtList().empty()) {
            for (auto stmt : this->blockCFG.at(currentBlockId)->getStmtList()) {
                ifStmtVector.push_back(stmt);
            }
        }
    }
    if (isElseBranch) {
        this->stmtsMap.insert(std::make_pair(0, ifStmtVector));
        std::vector<int> blocksInsideIf;
        for (int i = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getBlockID();
             i <= currentBlockId; i++) { blocksInsideIf.push_back(i); }
        this->trueBranchBlocksMap.insert(
                std::make_pair(this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getBlockID(),
                               blocksInsideIf));
    } else {
        this->stmtsMap.insert(std::make_pair(-this->currentElseIfID, ifStmtVector));
        std::vector<int> blocksInsideIf;
        for (int i = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[0]->getBlockID();
             i <= currentBlockId; i++) { blocksInsideIf.push_back(i); }
        this->trueBranchBlocksMap.insert(std::make_pair(this->currentElseIfID, blocksInsideIf));
    }
}

void
SCAM::MergeRedundantIfElse::printWarning(const std::string &firstCondType, const std::string &firstCond,
                                         const std::string &secondCondType,
                                         const std::string &secondCond) {
    std::stringstream warning;
    warning << "\t\033[1;33mWarning\033[0m: found the same code in the following '" << firstCondType
            << "' and related '" << secondCondType << "' branch:" << std::endl;
    if (firstCondType == "if") {
        warning << firstCond << std::endl;
    } else if (firstCondType == "else if") {
        warning << "else " << firstCond << std::endl;
    }
    if (secondCondType == "else if") {
        warning << "else " << secondCond << std::endl;
    }
    warning << "This might indicate a copy and paste or logic error. Therefore, the conditions are merged!"
            << std::endl;
    std::cout << warning.str();
}



