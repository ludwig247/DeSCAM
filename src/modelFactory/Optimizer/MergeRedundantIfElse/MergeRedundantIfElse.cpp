//
// Created by M.I.Alkoudsi on 17.07.19.
//

#include "MergeRedundantIfElse.h"
#include "Optimizer/Debug.h"


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
            bool hasElseIf = false;
            bool ifthenif = false;
            if (node.second->getSuccessorList()[1]->hasIf()) {//else if
                if (node.second->getSuccessorList()[1]->getPredecessorList().size() > 1) {
                    for (auto pred : node.second->getSuccessorList()[1]->getPredecessorList()) {
                        if (pred->getBlockID() == node.second->getSuccessorList()[1]->getBlockID() - 1) {
                            ifthenif = true;
                        }
                    }
                }
                if (ifthenif) { continue; }
                hasElseIf = true;
                bool moreElseIf = true;
                while (moreElseIf) {
                    this->currentElseIfID = this->blockCFG.at(
                            this->currentElseIfID)->getSuccessorList()[1]->getBlockID();
                    int currentNodeID = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[0]->getBlockID();
                    if (this->blockCFG.at(this->currentElseIfID)->getSuccessorList().size() == 1) { break; }
                    this->checkedIfStmts.push_back(this->currentElseIfID);
                    int elsebranchID = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getBlockID();
                    std::vector<SCAM::Stmt *> ifStmtVector;
                    bool elseHasIf = false;
                    if (elsebranchID > currentNodeID) {
                        std::vector<int> blocksInsideIf;
                        for (int i = currentNodeID; i < elsebranchID; i++) { blocksInsideIf.push_back(i); }
                        this->trueBranchBlocksMap.insert(std::make_pair(this->currentElseIfID, blocksInsideIf));

                        while (currentNodeID != elsebranchID) {
                            if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                                for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                                    ifStmtVector.push_back(stmt);
                                }
                            }
                            currentNodeID++;
                        }
                        this->stmtsMap.insert(std::make_pair(-this->currentElseIfID, ifStmtVector));
                    } else { //else if without else
                        while (!(this->blockCFG.at(currentNodeID)->getSuccessorList().size() == 1 &&
                                 (this->blockCFG.at(currentNodeID)->getBlockID() >
                                  this->blockCFG.at(currentNodeID)->getSuccessorList()[0]->getBlockID()))) {
                            if (this->blockCFG.at(currentNodeID)->hasIf()) {
                                if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                                    for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                                        ifStmtVector.push_back(stmt);
                                    }
                                }
                                //call recursive function
                                AddNestedIfStatementsListsToStmtsMap(currentNodeID, ifStmtVector);
                                elseHasIf = true;
                                currentNodeID--;
                            } else if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                                for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                                    ifStmtVector.push_back(stmt);
                                }
                            }
                            currentNodeID++;
                        }
                        if (!elseHasIf) {
                            if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                                for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                                    ifStmtVector.push_back(stmt);
                                }
                            }
                        }
                        std::vector<int> blocksInsideIf;
                        for (int i = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[0]->getBlockID();
                             i <= currentNodeID; i++) { blocksInsideIf.push_back(i); }
                        this->trueBranchBlocksMap.insert(std::make_pair(this->currentElseIfID, blocksInsideIf));

                        this->stmtsMap.insert(std::make_pair(-this->currentElseIfID, ifStmtVector));
                        if (!this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->hasIf()) {
                            moreElseIf = false;
                        }
                    }
                }
            } else if (node.second->getSuccessorList()[1]->getStmtList().empty()) { break; }

            if (this->blockCFG.at(this->currentElseIfID)->getSuccessorList().size() == 1) {
                this->currentElseIfID = this->blockCFG.at(this->currentElseIfID)->getPredecessorList()[0]->getBlockID();
            }
            if (this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getPredecessorList().size() ==
                1) { //else statement
                this->ifAndItsElseMap.insert(std::make_pair(currentIfID, this->blockCFG.at(
                        this->currentElseIfID)->getSuccessorList()[1]->getBlockID()));
                hasElseIf = true;
                int currentNodeID = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getBlockID();
                std::vector<SCAM::Stmt *> ifStmtVector;
                bool elseHasIf = false;
                while (!(this->blockCFG.at(currentNodeID)->getSuccessorList().size() == 1 &&
                         (this->blockCFG.at(currentNodeID)->getBlockID() >
                          this->blockCFG.at(currentNodeID)->getSuccessorList()[0]->getBlockID()))) {
                    if (this->blockCFG.at(currentNodeID)->hasIf()) {
                        if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                            for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                                ifStmtVector.push_back(stmt);
                            }
                        }
                        //call recursive function
                        AddNestedIfStatementsListsToStmtsMap(currentNodeID, ifStmtVector);
                        elseHasIf = true;
                        currentNodeID--;
                    } else if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                        for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                            ifStmtVector.push_back(stmt);
                        }
                    }
                    currentNodeID++;
                }
                if (!elseHasIf) {
                    if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                        for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                            ifStmtVector.push_back(stmt);
                        }
                    }
                }

                std::vector<int> blocksInsideIf;
                for (int i = this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getBlockID();
                     i <= currentNodeID; i++) { blocksInsideIf.push_back(i); }
                this->trueBranchBlocksMap.insert(
                        std::make_pair(this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->getBlockID(),
                                       blocksInsideIf));


                this->stmtsMap.insert(std::make_pair(0, ifStmtVector));

            }
            if (!hasElseIf) {
                this->stmtsMap.clear();
                continue;
            }
            this->checkedIfStmts.push_back(this->currentIfID);
            int currentNodeID = this->blockCFG.at(this->currentIfID)->getSuccessorList()[0]->getBlockID();
            int elsebranchID = this->blockCFG.at(this->currentIfID)->getSuccessorList()[1]->getBlockID();
            std::vector<SCAM::Stmt *> ifStmtVector;
            std::vector<int> blocksInsideIf;
            for (int i = currentNodeID; i < elsebranchID; i++) { blocksInsideIf.push_back(i); }
            this->trueBranchBlocksMap.insert(std::make_pair(this->currentIfID, blocksInsideIf));
            while (currentNodeID != elsebranchID) {
                if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                    for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                        ifStmtVector.push_back(stmt);
                    }
                }
                currentNodeID++;
            }
            this->stmtsMap.insert(std::make_pair(this->currentIfID, ifStmtVector));
            int i = 0;
            for (auto ifstmt : this->stmtsMap) {
                auto elseifstmt = this->stmtsMap.begin();
                for (int j = 0; j <= i; j++) { elseifstmt++; }
                for (elseifstmt; elseifstmt != this->stmtsMap.end(); elseifstmt++) {
                    if (ifstmt.first == (*elseifstmt).first) { continue; }
                    if (ifstmt.second.size() != (*elseifstmt).second.size()) { continue; }
                    bool logicError = true;
                    auto ifStmtPtr = ifstmt.second.begin();
                    auto elseStmtPtr = (*elseifstmt).second.begin();
                    while (ifStmtPtr != ifstmt.second.end()) {
                        auto stmt1 = SCAM::PrintStmt::toString((*ifStmtPtr));
                        auto stmt2 = SCAM::PrintStmt::toString((*elseStmtPtr));
#ifdef DEBUG_MERGE_REDUNDANT_IF_ELSE
                        std::cout << "(*ifStmtPtr)= " << stmt1 << std::endl;
                        std::cout << "(*elseStmtPtr)= " << stmt2 << std::endl << std::endl;
#endif
                        //  if(!(**ifStmtPtr == **elseStmtPtr)){
                        if (stmt1 != stmt2) {
                            logicError = false;
                            break;
                        }
                        ifStmtPtr++;
                        elseStmtPtr++;
                    }

                    if (logicError) {
                        std::cout << std::endl;
                        if (ifstmt.first > 0 && (*elseifstmt).first < 0) {

                        } else if ((ifstmt.first > 0 && (*elseifstmt).first < 0) ||
                                   (ifstmt.first < 0 && (*elseifstmt).first > 0)) {

                            std::cout
                                    << "Warning!!, found the same code in the following 'if' and related 'else if' branch:"
                                    << std::endl;
                            if (ifstmt.first > 0) {
                                std::cout << SCAM::PrintStmt::toString(this->blockCFG.at(ifstmt.first)->getTerminator())
                                          << std::endl
                                          << "else "
                                          << SCAM::PrintStmt::toString(
                                                  this->blockCFG.at(-(*elseifstmt).first)->getTerminator())
                                          << std::endl;

                                auto ifCondition = dynamic_cast<SCAM::If *>(this->blockCFG.at(
                                        ifstmt.first)->getTerminator());
                                auto elseifcondition = dynamic_cast<SCAM::If *>(this->blockCFG.at(
                                        -(*elseifstmt).first)->getTerminator());
                                if (ifCondition != nullptr && elseifcondition != nullptr) {
                                    auto newCondition = new SCAM::If(
                                            new SCAM::Logical(ifCondition->getConditionStmt(), "or",
                                                              elseifcondition->getConditionStmt()));
                                    if (newCondition != nullptr &&
                                        this->blockCFG.find(ifstmt.first) != this->blockCFG.end()) {
                                        this->blockCFG.at(ifstmt.first)->setTerminator(newCondition);
                                        this->changedConditions.insert(ifstmt.first);
                                    }
                                    this->toBeDeletedMap.insert(std::make_pair(-(*elseifstmt).first, true));
                                }

                            } else {
                                std::cout
                                        << SCAM::PrintStmt::toString(
                                                this->blockCFG.at((*elseifstmt).first)->getTerminator())
                                        << std::endl << "else "
                                        << SCAM::PrintStmt::toString(this->blockCFG.at(-ifstmt.first)->getTerminator())
                                        << std::endl;
                                auto ifCondition = dynamic_cast<SCAM::If *>(this->blockCFG.at(
                                        (*elseifstmt).first)->getTerminator());
                                auto elseifcondition = dynamic_cast<SCAM::If *>(this->blockCFG.at(
                                        -ifstmt.first)->getTerminator());
                                if (ifCondition != nullptr && elseifcondition != nullptr) {
                                    auto newCondition = new SCAM::If(
                                            new SCAM::Logical(ifCondition->getConditionStmt(), "or",
                                                              elseifcondition->getConditionStmt()));
                                    if (newCondition != nullptr &&
                                        this->blockCFG.find(ifstmt.first) != this->blockCFG.end()) {
                                        this->blockCFG.at((*elseifstmt).first)->setTerminator(newCondition);
                                        this->changedConditions.insert((*elseifstmt).first);
                                    }
                                    this->toBeDeletedMap.insert(std::make_pair(-ifstmt.first, true));
                                }
                            }
                            std::cout
                                    << "This might indicate a copy and paste or logic error. Therefore, the else if branch is deleted!"
                                    << std::endl;
                        } else if ((ifstmt.first < 0 && (*elseifstmt).first == 0) ||
                                   (ifstmt.first == 0 && (*elseifstmt).first < 0)) {
                            std::cout
                                    << "Warning!!, found the same code in the following 'else if' and related 'else' branch:"
                                    << std::endl;
                            if (ifstmt.first == 0) {
                                std::cout
                                        << "else "
                                        << SCAM::PrintStmt::toString(
                                                this->blockCFG.at(-(*elseifstmt).first)->getTerminator())
                                        << std::endl;
                                this->toBeDeletedMap.insert(std::make_pair(-(*elseifstmt).first, true));
                            } else {
                                std::cout << "else "
                                          << SCAM::PrintStmt::toString(
                                                  this->blockCFG.at(-ifstmt.first)->getTerminator())
                                          << std::endl;
                                this->toBeDeletedMap.insert(std::make_pair(-ifstmt.first, true));
                            }
                            std::cout
                                    << "This might indicate a copy and paste or logic error. Therefore, the else if branch is deleted!"
                                    << std::endl;

                        } else if ((ifstmt.first > 0 && (*elseifstmt).first == 0) ||
                                   (ifstmt.first == 0 && (*elseifstmt).first > 0)) {
                            std::cout
                                    << "Warning!!, found the same code in the following 'if' and related 'else' branch:"
                                    << std::endl;
                            if (ifstmt.first == 0) {
                                std::cout
                                        << SCAM::PrintStmt::toString(
                                                this->blockCFG.at((*elseifstmt).first)->getTerminator())
                                        << std::endl;
                                this->toBeDeletedMap.insert(std::make_pair((*elseifstmt).first,
                                                                           true));
                            } else {
                                std::cout << SCAM::PrintStmt::toString(this->blockCFG.at(ifstmt.first)->getTerminator())
                                          << std::endl;
                                this->toBeDeletedMap.insert(std::make_pair(ifstmt.first,
                                                                           true));
                            }
                            std::cout
                                    << "This might indicate a copy and paste or logic error. Therefore, the if branch is deleted!"
                                    << std::endl;


                        } else if (ifstmt.first < 0 && (*elseifstmt).first < 0) {
                            std::cout
                                    << "Warning!!, found the same code in the following 'else if' and related 'else if' branch:"
                                    << std::endl << "else "
                                    << SCAM::PrintStmt::toString(this->blockCFG.at(-ifstmt.first)->getTerminator())
                                    << std::endl
                                    << "else "
                                    << SCAM::PrintStmt::toString(
                                            this->blockCFG.at(-(*elseifstmt).first)->getTerminator())
                                    << std::endl
                                    << "This might indicate a copy and paste or logic error. Therefore, one else if branch is deleted!"
                                    << std::endl;

                            if (this->changedConditions.find(-ifstmt.first) == this->changedConditions.end()) {
                                if (this->changedConditions.find(-(*elseifstmt).first) ==
                                    this->changedConditions.end()) {
                                    auto condition1 =  dynamic_cast<SCAM::If *>(
                                            this->blockCFG.at(-ifstmt.first)->getTerminator());
                                    auto condition2 =  dynamic_cast<SCAM::If *>(
                                            this->blockCFG.at(-(*elseifstmt).first)->getTerminator());
                                    if (condition1 != nullptr && condition2 != nullptr) {
                                        auto newCondition = new SCAM::If(
                                                new SCAM::Logical(condition1->getConditionStmt(), "or",
                                                                  condition2->getConditionStmt()));
                                        if (newCondition != nullptr &&
                                            this->blockCFG.find(-ifstmt.first) != this->blockCFG.end()) {
                                            this->blockCFG.at(-ifstmt.first)->setTerminator(newCondition);
                                            this->changedConditions.insert(-ifstmt.first);
                                            this->toBeDeletedMap.insert(std::make_pair(-(*elseifstmt).first, true));
                                        }
                                    }
                                } else {
                                    auto condition1 = dynamic_cast<SCAM::If *>(
                                            this->blockCFG.at(-ifstmt.first)->getTerminator());
                                    auto condition2 =  dynamic_cast<SCAM::If *>(
                                            this->blockCFG.at(-(*elseifstmt).first)->getTerminator());
                                    if (condition1 != nullptr && condition2 != nullptr) {
                                        auto newCondition = new SCAM::If(
                                                new SCAM::Logical(condition1->getConditionStmt(), "or",
                                                                  condition2->getConditionStmt()));
                                        if (newCondition != nullptr &&
                                            this->blockCFG.find(-(*elseifstmt).first) != this->blockCFG.end()) {
                                            this->blockCFG.at(-(*elseifstmt).first)->setTerminator(newCondition);
                                            this->changedConditions.insert(-(*elseifstmt).first);
                                            this->toBeDeletedMap.insert(std::make_pair(-ifstmt.first, true));
                                        }
                                    }
                                }
                            } else {
                                auto condition1 =  dynamic_cast<SCAM::If *>(
                                        this->blockCFG.at(-ifstmt.first)->getTerminator());
                                auto condition2 =  dynamic_cast<SCAM::If *>(
                                        this->blockCFG.at(-(*elseifstmt).first)->getTerminator());
                                if (condition1 != nullptr && condition2 != nullptr) {
                                    auto newCondition = new SCAM::If(
                                            new SCAM::Logical(condition1->getConditionStmt(), "or",
                                                              condition2->getConditionStmt()));
                                    if (newCondition != nullptr &&
                                        this->blockCFG.find(-ifstmt.first) != this->blockCFG.end()) {
                                        this->blockCFG.at(-ifstmt.first)->setTerminator(newCondition);
                                        this->changedConditions.insert(-ifstmt.first);
                                        this->toBeDeletedMap.insert(
                                                std::make_pair(-(*elseifstmt).first, true));
                                    }
                                }
                            }

                        }
                        std::cout << std::endl;
                    }

                }
                i++;
            }
#ifdef DEBUG_MERGE_REDUNDANT_IF_ELSE
            for (
                auto node
                    : this->stmtsMap) {
                std::cout << "if ID is " << node.first <<
                          std::endl;
                if (node.second.empty()) {
                    std::cout << "vector is empty";
                    continue;
                }
                for (
                    auto stmt
                        : node.second) {

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
        for(auto ifstmt : this->checkedIfStmts){
          std::cout << ifstmt << " " ;
        }

        std::cout << std::endl << "Blocks inside the following if stmts" << std::endl;
        for (auto blockid : this->trueBranchBlocksMap) {
            std::cout << "if Node" << blockid.first << std::endl;
            for (auto id : blockid.second) {
                std::cout << id << " ";
            }
            std::cout << std::endl;
        }
#endif
        for (auto fNode: this->toBeDeletedMap) {
            if (fNode.second) {//delete else if branch
                if (this->blockCFG.find(fNode.first) != this->blockCFG.end()) {
                    auto elseifnode = this->blockCFG.at(fNode.first);
                    for (auto pred : this->blockCFG.at(fNode.first)->getPredecessorList()) {
                        pred->replaceSuccessor(elseifnode, elseifnode->getSuccessorList()[1]);
                    }
                    this->blockCFG.erase(fNode.first);
                    for (auto insideNode : this->trueBranchBlocksMap.at(fNode.first)) {
                        if (this->blockCFG.find(insideNode) != this->blockCFG.end()) {
                            this->blockCFG.erase(insideNode);
                        }
                    }
                }
            }
        }

    }
}

void SCAM::MergeRedundantIfElse::AddNestedIfStatementsListsToStmtsMap(int &currentNodeID,
                                                                      std::vector<SCAM::Stmt *> &ifStmtList) {
    int elseIfID = currentNodeID;
    int elseifbranchID = this->blockCFG.at(currentNodeID)->getSuccessorList()[1]->getBlockID();
    currentNodeID = this->blockCFG.at(currentNodeID)->getSuccessorList()[0]->getBlockID();

    if (currentNodeID < elseifbranchID) { //there is else if or else

        while (currentNodeID != elseifbranchID) {
            if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                    ifStmtList.push_back(stmt);
                }
            }
            currentNodeID++;
        }

        if (this->blockCFG.at(elseifbranchID)->hasIf()) {//there is else if
            bool moreElseIf = true;
            while (moreElseIf) {
                elseIfID = this->blockCFG.at(elseIfID)->getSuccessorList()[1]->getBlockID();
                if (this->blockCFG.at(elseIfID)->getSuccessorList().size() == 1) { break; }
                currentNodeID = this->blockCFG.at(currentNodeID)->getSuccessorList()[0]->getBlockID();

                if (elseIfID > currentNodeID) {
                    while (currentNodeID != elseIfID) {
                        if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                            for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                                ifStmtList.push_back(stmt);
                            }
                        }
                        currentNodeID++;
                    }
                } else { //else if without else
                    while (!(this->blockCFG.at(currentNodeID)->getSuccessorList().size() == 1 &&
                             (this->blockCFG.at(currentNodeID)->getBlockID() >
                              this->blockCFG.at(currentNodeID)->getSuccessorList()[0]->getBlockID()))) {
                        if (this->blockCFG.at(currentNodeID)->hasIf()) {
                            //call recursive function
                            if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                                for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                                    ifStmtList.push_back(stmt);
                                }
                            }
                            AddNestedIfStatementsListsToStmtsMap(currentNodeID, ifStmtList);
                            currentNodeID--;
                        } else if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                            for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                                ifStmtList.push_back(stmt);
                            }
                        }
                        currentNodeID++;
                    }
                    if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                        for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                            ifStmtList.push_back(stmt);
                        }
                    }

                    if (!this->blockCFG.at(this->currentElseIfID)->getSuccessorList()[1]->hasIf()) {
                        moreElseIf = false;
                    }
                }

            }

        }
        if (this->blockCFG.at(elseIfID)->getSuccessorList().size() == 1) {
            elseIfID = this->blockCFG.at(elseIfID)->getPredecessorList()[0]->getBlockID();
        }
        if (this->blockCFG.at(elseIfID)->getSuccessorList()[1]->getPredecessorList().size() ==
            1) { //else statement
            currentNodeID = this->blockCFG.at(elseIfID)->getSuccessorList()[1]->getBlockID();
            while (!(this->blockCFG.at(currentNodeID)->getSuccessorList().size() == 1 &&
                     (this->blockCFG.at(currentNodeID)->getBlockID() >
                      this->blockCFG.at(currentNodeID)->getSuccessorList()[0]->getBlockID()))) {
                if (this->blockCFG.at(currentNodeID)->hasIf()) {
                    if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                        for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                            ifStmtList.push_back(stmt);
                        }
                    }
                    //call recursive function
                    AddNestedIfStatementsListsToStmtsMap(currentNodeID, ifStmtList);
                    currentNodeID--;
                } else if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                    for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                        ifStmtList.push_back(stmt);
                    }
                }
                currentNodeID++;
            }
            if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                    ifStmtList.push_back(stmt);
                }
            }


        }


    } else {
        if (this->blockCFG.at(elseIfID)->getSuccessorList()[1]->getPredecessorList().size() ==
            1) { //else statement

            while (!(this->blockCFG.at(currentNodeID)->getSuccessorList().size() == 1 &&
                     (this->blockCFG.at(currentNodeID)->getBlockID() >
                      this->blockCFG.at(currentNodeID)->getSuccessorList()[0]->getBlockID()))) {
                if (this->blockCFG.at(currentNodeID)->hasIf()) {
                    if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                        for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                            ifStmtList.push_back(stmt);
                        }
                    }
                    //call recursive function
                    AddNestedIfStatementsListsToStmtsMap(currentNodeID, ifStmtList);
                } else if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                    for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                        ifStmtList.push_back(stmt);
                    }
                }
                currentNodeID++;
            }
            if (!this->blockCFG.at(currentNodeID)->getStmtList().empty()) {
                for (auto stmt : this->blockCFG.at(currentNodeID)->getStmtList()) {
                    ifStmtList.push_back(stmt);
                }
            }
        }
    }
}

const std::map<int, SCAM::CfgBlock *> &SCAM::MergeRedundantIfElse::getNewBlockCFG() const {
    return this->blockCFG;
}


