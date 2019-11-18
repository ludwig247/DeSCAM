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
     * @brief: detects redundant if, elseif , else statements
     *  for e.g.: when an if statement and one of related else if statements have exactly the same statement lists
     *
     */

    class MergeRedundantIfElse {

    public:
        MergeRedundantIfElse() = delete;

        explicit MergeRedundantIfElse(std::map<int, SCAM::CfgBlock *> CFG);

        ~MergeRedundantIfElse() = default;

        const std::map<int, CfgBlock *> &getNewBlockCFG() const;

    private:
        int currentIfID;
        int currentElseIfID;
        std::vector<int> checkedIfStmts;
        std::map<int, SCAM::CfgBlock *> blockCFG;
        std::map<int, std::vector<SCAM::Stmt *>> stmtsMap;
        std::map<int, std::vector<int>> trueBranchBlocksMap;
        std::set<int> toBeDeletedMap;              //when true the bool indicates the else if, otherwise else and the int reflects the redundant if or else if
        std::map<int, int> ifAndItsElseMap;
        bool notFromTheSameGroupIfStatement(int ifId);
        void addStatementsInTrueBranch(int &firstBlockInTrueBranchId, int& elseIfblockId, bool isIfBranch);
        void addStatementsInElseBranch(int &currentBlockId, bool isElseBranch);
        void addNestedIfStatementsToStmtsMap(int &currentBlockID, std::vector<SCAM::Stmt *> &ifStmtList);
        static void printWarning(const std::string& firstCondType, const std::string& firstCond, const std::string& secondCondType, const std::string& secondCond);
    };


}

#endif //SCAM_MERGEREDUNDANTIFELSE_H
