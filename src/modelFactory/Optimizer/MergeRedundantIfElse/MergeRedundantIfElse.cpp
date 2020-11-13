//
// Created by M.I.Alkoudsi on 17.07.19.
//

#include <Logger/LoggerMsg.h>
#include <Logger/Logger.h>
#include <Stmts/StmtCastVisitor.h>
#include "MergeRedundantIfElse.h"

/* In each iteration, the algorithm first finds the true branches in a level of conditional statements,
 * then it checks if all statements in a true branch of a conditional statement are equal to these
 * in another conditional statement in same level.
 */

DESCAM::MergeRedundantIfElse::MergeRedundantIfElse(std::map<int, DESCAM::CfgBlock *> CFG)
    : block_cfg_(std::move(CFG)), current_else_if_id_(0),
      current_if_id_(0) {
  for (auto node : this->block_cfg_) {
    if (node.second->hasIf()) {
      if (std::find(this->checked_if_stmts_.begin(), this->checked_if_stmts_.end(), node.first) !=
          this->checked_if_stmts_.end()) {
        continue;
      }
      this->current_if_id_ = node.first;
      this->current_else_if_id_ = node.first;
      bool hasElseIfOrElse = false;
      if (node.second->getSuccessorList().size() < 2) continue;
      auto secondSucc = node.second->getSuccessorList()[1];
      if (!secondSucc) { continue; }
      if (secondSucc->hasIf()) {
        if (notFromTheSameGroupIfStatement(secondSucc->getBlockID())) { continue; }
        //adding else if statements and their true branches to the stmtsMap
        hasElseIfOrElse = true;
        while (bool moreElseIf = true) {
          this->current_else_if_id_ = this->block_cfg_.at(
              this->current_else_if_id_)->getSuccessorList()[1]->getBlockID();
          int currentBlockId = this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList()[0]->getBlockID();
          if (this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList().size() == 1) {
            this->current_else_if_id_ =
                this->block_cfg_.at(this->current_else_if_id_)->getPredecessorList()[0]->getBlockID();
            break;
          }
          int elsebranchID = this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList()[1]->getBlockID();
          if (notFromTheSameGroupIfStatement(elsebranchID)) { // e.g., else { if(...){...} }
            break;
          }
          this->checked_if_stmts_.push_back(this->current_else_if_id_);

          if (elsebranchID > currentBlockId) {
            addStatementsInTrueBranch(currentBlockId, elsebranchID, false);
          } else { //else if without else
            addStatementsInElseBranch(currentBlockId, false);
            break;
          }
        }
      } else if (node.second->getSuccessorList()[1]->getStmtList().empty()) { break; }

      if (this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList()[1]->getPredecessorList().size() ==
          1) {
        //adding statements in the else branch of the If statement to stmtsMap
        this->if_and_its_else_map_.insert(std::make_pair(current_if_id_, this->block_cfg_.at(
            this->current_else_if_id_)->getSuccessorList()[1]->getBlockID()));
        hasElseIfOrElse = true;
        int currentBlockId = this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList()[1]->getBlockID();
        addStatementsInElseBranch(currentBlockId, true);
      }
      if (!hasElseIfOrElse) {
        this->stmts_map_.clear();
        continue;
      }
      //Adding statements in the true branch of the If statement to stmtsMap
      this->checked_if_stmts_.push_back(this->current_if_id_);
      int currentBlockId = this->block_cfg_.at(this->current_if_id_)->getSuccessorList()[0]->getBlockID();
      int elseBranchId = this->block_cfg_.at(this->current_if_id_)->getSuccessorList()[1]->getBlockID();
      addStatementsInTrueBranch(currentBlockId, elseBranchId, true);

      //Checking statements inside true branches of conditional statements
      int i = 0;
      for (auto conditionTrueBranchPair : this->stmts_map_) {
        auto pair = this->stmts_map_.begin();
        for (int j = 0; j <= i; j++) { pair++; }
        for (pair; pair != this->stmts_map_.end(); pair++) {
          if (conditionTrueBranchPair.first == (*pair).first) { continue; }
          if (conditionTrueBranchPair.second.size() != (*pair).second.size()) { continue; }
          bool redundantLogic = true;
          auto cond1TrueBranchPtr = conditionTrueBranchPair.second.begin();
          auto cond2TrueBranchPtr = (*pair).second.begin();
          while (cond1TrueBranchPtr != conditionTrueBranchPair.second.end()) {
#ifdef DEBUG_MERGE_REDUNDANT_IF_ELSE
            auto stmt1 = DESCAM::PrintStmt::toString((*cond1TrueBranchPtr));
            auto stmt2 = DESCAM::PrintStmt::toString((*cond2TrueBranchPtr));
            std::cout << "(*cond1TrueBranchPtr)= " << stmt1 << std::endl;
            std::cout << "(*cond2TrueBranchPtr)= " << stmt2 << std::endl << std::endl;
#endif
            if (!(**cond1TrueBranchPtr == **cond2TrueBranchPtr)) {
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
                ifBlock = this->block_cfg_.at(conditionTrueBranchPair.first);
                elseIfBlock = this->block_cfg_.at(-(*pair).first);
              } else {
                ifBlock = this->block_cfg_.at((*pair).first);
                elseIfBlock = this->block_cfg_.at(-conditionTrueBranchPair.first);
              }
              if (to_be_deleted_map_.find(elseIfBlock->getBlockID()) != to_be_deleted_map_.end()) { continue; }
              printWarning("if", ifBlock->getTerminator(), "else if",
                           PrintStmt::toString(elseIfBlock->getTerminator()));

              auto ifCondition = StmtCastVisitor<DESCAM::If>(ifBlock->getTerminator()).Get();
              auto elseifcondition = StmtCastVisitor<DESCAM::If>(elseIfBlock->getTerminator()).Get();
              if (ifCondition && elseifcondition) {
                auto newCondition = new DESCAM::If(new DESCAM::Logical(
                    ifCondition->getConditionStmt(),
                    "or",
                    elseifcondition->getConditionStmt(),
                    ifCondition->getStmtInfo()),
                                                   ifCondition->getStmtInfo());
                if (newCondition &&
                    this->block_cfg_.find(ifBlock->getBlockID()) != this->block_cfg_.end()) {
                  this->block_cfg_.at(ifBlock->getBlockID())->setTerminator(newCondition);
                }
                this->to_be_deleted_map_.insert(elseIfBlock->getBlockID());
              }
            } else if ((conditionTrueBranchPair.first < 0 && (*pair).first == 0) ||
                (conditionTrueBranchPair.first == 0 && (*pair).first < 0)) {
              CfgBlock *elseIfBlock;
              if (conditionTrueBranchPair.first == 0) {
                elseIfBlock = this->block_cfg_.at(-(*pair).first);
              } else {
                elseIfBlock = this->block_cfg_.at(-conditionTrueBranchPair.first);
              }
              if (to_be_deleted_map_.find(elseIfBlock->getBlockID()) != to_be_deleted_map_.end()) { continue; }
              printWarning("else if", elseIfBlock->getTerminator(), "else",
                           "");
              this->to_be_deleted_map_.insert(elseIfBlock->getBlockID());

            } else if ((conditionTrueBranchPair.first > 0 && (*pair).first == 0) ||
                (conditionTrueBranchPair.first == 0 && (*pair).first > 0)) {
              CfgBlock *ifBlock;
              if (conditionTrueBranchPair.first == 0) {
                ifBlock = this->block_cfg_.at((*pair).first);
              } else {
                ifBlock = this->block_cfg_.at(conditionTrueBranchPair.first);
              }
              printWarning("if", ifBlock->getTerminator(), "else",
                           "");
              this->to_be_deleted_map_.insert(ifBlock->getBlockID());
            } else if (conditionTrueBranchPair.first < 0 && (*pair).first < 0) {
              CfgBlock *elseifBlock1, *elseIfBlock2;
              elseifBlock1 = this->block_cfg_.at(-conditionTrueBranchPair.first);
              elseIfBlock2 = this->block_cfg_.at(-(*pair).first);
              if (to_be_deleted_map_.find(elseifBlock1->getBlockID()) != to_be_deleted_map_.end() ||
                  to_be_deleted_map_.find(elseIfBlock2->getBlockID()) != to_be_deleted_map_.end()) { continue; }
              printWarning("else if", elseifBlock1->getTerminator(), "else if",
                           PrintStmt::toString(elseIfBlock2->getTerminator()));
              auto elseIf1Condition = StmtCastVisitor<DESCAM::If>(elseifBlock1->getTerminator()).Get();
              auto elseIf2condition = StmtCastVisitor<DESCAM::If>(elseIfBlock2->getTerminator()).Get();
              if (elseIf1Condition && elseIf2condition) {
                auto newCondition = new DESCAM::If(
                    new DESCAM::Logical(elseIf1Condition->getConditionStmt(), "or",
                                        elseIf2condition->getConditionStmt(), elseIf1Condition->getStmtInfo()),
                    elseIf1Condition->getStmtInfo());
                if (newCondition &&
                    this->block_cfg_.find(elseifBlock1->getBlockID()) != this->block_cfg_.end()) {
                  this->block_cfg_.at(elseifBlock1->getBlockID())->setTerminator(newCondition);
                }
                this->to_be_deleted_map_.insert(elseIfBlock2->getBlockID());
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
                            DESCAM::PrintStmt::toString(stmt)
                            <<
                            std::endl;
              }
          }
      }
#endif

      this->stmts_map_.clear();
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
  for (auto ifStatement: this->to_be_deleted_map_) {
    if (this->block_cfg_.find(ifStatement) != this->block_cfg_.end()) {
      auto elseifnode = this->block_cfg_.at(ifStatement);
      for (auto pred : this->block_cfg_.at(ifStatement)->getPredecessorList()) {
        pred->replaceSuccessor(elseifnode, elseifnode->getSuccessorList()[1]);
        elseifnode->getSuccessorList()[1]->replacePredecessor(elseifnode, pred);
      }
      this->block_cfg_.erase(ifStatement);

      for (auto insideNode : this->true_branch_blocks_map_.at(ifStatement)) {
        if (this->block_cfg_.find(insideNode) != this->block_cfg_.end()) {
          this->block_cfg_.erase(insideNode);
        }
      }
    }
  }
}

void DESCAM::MergeRedundantIfElse::addNestedIfStatementsToStmtsMap(int &current_block_id,
                                                                   std::vector<DESCAM::Stmt *> &if_stmt_list) {
  ///add if statements
  auto elseIfID = current_block_id;
  auto elseifbranchID = this->block_cfg_.at(current_block_id)->getSuccessorList()[1]->getBlockID();
  current_block_id = this->block_cfg_.at(current_block_id)->getSuccessorList()[0]->getBlockID();
  if (current_block_id < elseifbranchID) { //there is else if or else
    while (current_block_id != elseifbranchID) {
      if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
        for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
          if_stmt_list.push_back(stmt);
        }
      }
      if (this->block_cfg_.at(current_block_id)->hasIf()) {
        if_stmt_list.push_back(this->block_cfg_.at(current_block_id)->getTerminator());
      }
      current_block_id++;
    }
    if (this->block_cfg_.at(elseifbranchID)->hasIf()) {//there is else if
      bool moreElseIf = true;
      while (moreElseIf) {
        elseIfID = this->block_cfg_.at(elseIfID)->getSuccessorList()[1]->getBlockID();
        if (this->block_cfg_.at(elseIfID)->getSuccessorList().size() == 1) {
          elseIfID = this->block_cfg_.at(elseIfID)->getPredecessorList()[0]->getBlockID();
          break;
        } else if (notFromTheSameGroupIfStatement(elseIfID)) { break; }
        current_block_id = this->block_cfg_.at(current_block_id)->getSuccessorList()[0]->getBlockID();
        if (elseIfID > current_block_id) {
          while (current_block_id != elseIfID) {
            if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
              for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
                if_stmt_list.push_back(stmt);
              }
            }
            if (this->block_cfg_.at(current_block_id)->hasIf()) {
              if_stmt_list.push_back(this->block_cfg_.at(current_block_id)->getTerminator());
            }
            current_block_id++;
          }
        } else { //else if without else
          while (!(this->block_cfg_.at(current_block_id)->getSuccessorList().size() == 1 &&
              (this->block_cfg_.at(current_block_id)->getBlockID() >
                  this->block_cfg_.at(current_block_id)->getSuccessorList()[0]->getBlockID()))) {
            if (this->block_cfg_.at(current_block_id)->hasIf()) {
              //call recursive function
              if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
                for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
                  if_stmt_list.push_back(stmt);
                }
              }
              if_stmt_list.push_back(this->block_cfg_.at(current_block_id)->getTerminator());
              addNestedIfStatementsToStmtsMap(current_block_id, if_stmt_list);
              current_block_id--;
            } else if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
              for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
                if_stmt_list.push_back(stmt);
              }
            }
            current_block_id++;
          }
          if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
            for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
              if_stmt_list.push_back(stmt);
            }
          }
          if (!this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList()[1]->hasIf()) {
            moreElseIf = false;
          }
        }
      }
    }
    if (this->block_cfg_.at(elseIfID)->getSuccessorList()[1]->getPredecessorList().size() ==
        1) { //else statement
      current_block_id = this->block_cfg_.at(elseIfID)->getSuccessorList()[1]->getBlockID();
      while (!(this->block_cfg_.at(current_block_id)->getSuccessorList().size() == 1 &&
          (this->block_cfg_.at(current_block_id)->getBlockID() >
              this->block_cfg_.at(current_block_id)->getSuccessorList()[0]->getBlockID()))) {
        if (this->block_cfg_.at(current_block_id)->hasIf()) {
          if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
            for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
              if_stmt_list.push_back(stmt);
            }
          }
          //call recursive function
          addNestedIfStatementsToStmtsMap(current_block_id, if_stmt_list);
          current_block_id--;
        } else if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
          for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
            if_stmt_list.push_back(stmt);
          }
        }
        current_block_id++;
      }
      if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
        for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
          if_stmt_list.push_back(stmt);
        }
      }
    }
  } else {
    if (this->block_cfg_.at(elseIfID)->getSuccessorList()[1]->getPredecessorList().size() ==
        1) { //else statement
      while (!(this->block_cfg_.at(current_block_id)->getSuccessorList().size() == 1 &&
          (this->block_cfg_.at(current_block_id)->getBlockID() >
              this->block_cfg_.at(current_block_id)->getSuccessorList()[0]->getBlockID()))) {
        if (this->block_cfg_.at(current_block_id)->hasIf()) {
          if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
            for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
              if_stmt_list.push_back(stmt);
            }
          }
          //call recursive function
          addNestedIfStatementsToStmtsMap(current_block_id, if_stmt_list);
        } else if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
          for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
            if_stmt_list.push_back(stmt);
          }
        }
        current_block_id++;
      }
      if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
        for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
          if_stmt_list.push_back(stmt);
        }
      }
    }
  }
}

const std::map<int, DESCAM::CfgBlock *> &DESCAM::MergeRedundantIfElse::getNewBlockCFG() const {
  return this->block_cfg_;
}

bool DESCAM::MergeRedundantIfElse::notFromTheSameGroupIfStatement(int if_id) {
  if (this->block_cfg_.at(if_id)->getPredecessorList().size() > 1) {
    for (auto pred : this->block_cfg_.at(if_id)->getPredecessorList()) {
      if (pred->getBlockID() == if_id - 1) {
        return true;
      }
    }
  }
  return false;
}

void DESCAM::MergeRedundantIfElse::addStatementsInTrueBranch(int &first_block_in_true_branch_id, int &else_if_block_id,
                                                             bool is_if_branch) {
  std::vector<int> blocksInsideIf;
  for (auto i = first_block_in_true_branch_id; i < else_if_block_id; i++) { blocksInsideIf.push_back(i); }

  std::vector<DESCAM::Stmt *> ifStmtVector;
  while (first_block_in_true_branch_id != else_if_block_id) {
    for (auto stmt : this->block_cfg_.at(first_block_in_true_branch_id)->getStmtList()) {
      ifStmtVector.push_back(stmt);
    }
    if (this->block_cfg_.at(first_block_in_true_branch_id)->hasIf()) {
      ifStmtVector.push_back(this->block_cfg_.at(first_block_in_true_branch_id)->getTerminator());
    }
    first_block_in_true_branch_id++;
  }
  if (is_if_branch) {
    this->true_branch_blocks_map_.insert(std::make_pair(this->current_if_id_, blocksInsideIf));
    this->stmts_map_.insert(std::make_pair(this->current_if_id_, ifStmtVector));
  } else {
    this->true_branch_blocks_map_.insert(std::make_pair(this->current_else_if_id_, blocksInsideIf));
    this->stmts_map_.insert(std::make_pair(-this->current_else_if_id_, ifStmtVector));
  }
}

void DESCAM::MergeRedundantIfElse::addStatementsInElseBranch(int &current_block_id, bool is_else_branch) {
  bool elseHasIf = false;
  std::vector<DESCAM::Stmt *> ifStmtVector;
  while (!(this->block_cfg_.at(current_block_id)->getSuccessorList().size() == 1 &&
      (this->block_cfg_.at(current_block_id)->getBlockID() >
          this->block_cfg_.at(current_block_id)->getSuccessorList()[0]->getBlockID()))) {
    if (this->block_cfg_.at(current_block_id)->hasIf()) {
      for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
        ifStmtVector.push_back(stmt);
      }
      if (this->block_cfg_.at(current_block_id)->hasIf()) {
        ifStmtVector.push_back(this->block_cfg_.at(current_block_id)->getTerminator());
      }
      //call recursive function
      addNestedIfStatementsToStmtsMap(current_block_id, ifStmtVector);
      elseHasIf = true;
      current_block_id--;
    } else if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
      for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
        ifStmtVector.push_back(stmt);
      }
    }
    current_block_id++;
  }
  if (!elseHasIf) {
    if (!this->block_cfg_.at(current_block_id)->getStmtList().empty()) {
      for (auto stmt : this->block_cfg_.at(current_block_id)->getStmtList()) {
        ifStmtVector.push_back(stmt);
      }
    }
  }
  if (is_else_branch) {
    this->stmts_map_.insert(std::make_pair(0, ifStmtVector));
    std::vector<int> blocksInsideIf;
    for (int i = this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList()[1]->getBlockID();
         i <= current_block_id; i++) { blocksInsideIf.push_back(i); }
    this->true_branch_blocks_map_.insert(
        std::make_pair(this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList()[1]->getBlockID(),
                       blocksInsideIf));
  } else {
    this->stmts_map_.insert(std::make_pair(-this->current_else_if_id_, ifStmtVector));
    std::vector<int> blocksInsideIf;
    for (int i = this->block_cfg_.at(this->current_else_if_id_)->getSuccessorList()[0]->getBlockID();
         i <= current_block_id; i++) { blocksInsideIf.push_back(i); }
    this->true_branch_blocks_map_.insert(std::make_pair(this->current_else_if_id_, blocksInsideIf));
  }
}

void
DESCAM::MergeRedundantIfElse::printWarning(const std::string &first_cond_type, DESCAM::Stmt *firstCond,
                                           const std::string &second_cond_type,
                                           const std::string &second_cond) {

  std::stringstream warning;
  warning << "Found the same code in the following '" << first_cond_type
          << "' and related '" << second_cond_type << "' branch:" << std::endl;
  if (first_cond_type == "if") {
    warning << PrintStmt::toString(firstCond) << std::endl;

  } else if (first_cond_type == "else if") {
    warning << "else " << PrintStmt::toString(firstCond) << std::endl;
  }
  if (second_cond_type == "else if") {
    warning << "else " << second_cond << std::endl;
  }
  warning << "This might indicate a copy and paste or logic error. Therefore, the conditions are merged!"
          << std::endl;
  auto msg = warning.str();
  LocationInfo locationInfo = firstCond->getStmtInfo();
  auto sl = DESCAM::LoggerMsg::SeverityLevel::Warning;
  auto vt = DESCAM::LoggerMsg::ViolationType::NA;
  auto pl = DESCAM::Logger::getCurrentProcessedLocation();
  DESCAM::LoggerMsg lmsg(msg, locationInfo, sl, vt, pl);
  DESCAM::Logger::addMsg(lmsg);
}



