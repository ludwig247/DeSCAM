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

namespace SCAM {

    /***
   * \brief: Detects redundant if, elseif , else statements and merges them together
   *
   * \author: mi-alkoudsi
   *
   * \input:
   *      - std::map<int, SCAM::CfgBlock *> cfg;
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
        int currentIfID;
        int currentElseIfID;
        std::vector<int> checkedIfStmts;
        std::map<int, CfgBlock *> blockCFG;
        std::map<int, std::vector<Stmt *>> stmtsMap;
        std::map<int, std::vector<int>> trueBranchBlocksMap;
        std::set<int> toBeDeletedMap;              //when true the bool indicates the else if, otherwise else and the int reflects the redundant if or else if
        std::map<int, int> ifAndItsElseMap;

        bool notFromTheSameGroupIfStatement(int ifId);

        void addStatementsInTrueBranch(int &firstBlockInTrueBranchId, int &elseIfblockId, bool isIfBranch);

        void addStatementsInElseBranch(int &currentBlockId, bool isElseBranch);

        void addNestedIfStatementsToStmtsMap(int &currentBlockID, std::vector<Stmt *> &ifStmtList);

        static void
        printWarning(const std::string &firstCondType, Stmt* firstCond, const std::string &secondCondType,
                     const std::string &secondCond);
    };


}

#endif //SCAM_MERGEREDUNDANTIFELSE_H
