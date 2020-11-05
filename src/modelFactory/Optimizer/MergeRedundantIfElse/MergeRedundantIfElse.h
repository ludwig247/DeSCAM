//
// Created by M.I.Alkoudsi on 17.07.19.
//

#ifndef SCAM_MERGEREDUNDANTIFELSE_H
#define SCAM_MERGEREDUNDANTIFELSE_H

#include <CfgBlock.h>
#include <vector>
#include <map>
#include <Stmts/Expr.h>
#include <set>
#include <algorithm>
#include <utility>
#include <PrintStmt.h>

namespace DESCAM {

/***
* \brief: Detects redundant if, elseif , else statements and merges them together
*
* \author: mi-alkoudsi
*
* \input:
*      - std::map<int, DESCAM::CfgBlock *> cfg;
* \output:
*      - std::map<int, CfgNode *> optimizedCFG;
*
* \details  If two conditional statements have exactly the same logic one of them is deleted and the condition of the other is updated e.g.,
*    1:if(x < y){
*    2: x+=y;
*    3: }else if(x == y){
*    4: x+=y;
*    5: }else{
*    6: y+=x;
*    7: }
*  becomes =>
*    1:if(x < y || x == y){
*    2: x+=y;
*    3: }else{
*    4: y+=x;
*    5: }
*/

class MergeRedundantIfElse {

 public:
  MergeRedundantIfElse() = delete;

  explicit MergeRedundantIfElse(std::map<int, CfgBlock *> CFG);

  ~MergeRedundantIfElse() = default;

  const std::map<int, CfgBlock *> &getNewBlockCFG() const;

 private:
  int current_if_id_;
  int current_else_if_id_;
  std::vector<int> checked_if_stmts_;
  std::map<int, CfgBlock *> block_cfg_;
  std::map<int, std::vector<Stmt *>> stmts_map_;
  std::map<int, std::vector<int>> true_branch_blocks_map_;
  std::set<int>
      to_be_deleted_map_;              //when true the bool indicates the else if, otherwise else and the int reflects the redundant if or else if
  std::map<int, int> if_and_its_else_map_;

  bool notFromTheSameGroupIfStatement(int if_id);

  void addStatementsInTrueBranch(int &first_block_in_true_branch_id, int &else_if_block_id, bool is_if_branch);

  void addStatementsInElseBranch(int &current_block_id, bool is_else_branch);

  void addNestedIfStatementsToStmtsMap(int &current_block_id, std::vector<Stmt *> &if_stmt_list);

  static void
  printWarning(const std::string &first_cond_type, Stmt *firstCond, const std::string &second_cond_type,
               const std::string &second_cond);
};

}

#endif //SCAM_MERGEREDUNDANTIFELSE_H
