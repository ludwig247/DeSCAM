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
        std::map<int, bool> toBeDeletedMap;              //when true the bool indicates the else if, otherwise else and the int reflects the equal (redundant) if or else if
        std::set<int> changedConditions;
        std::map<int, int> ifAndItsElseMap;
        void AddNestedIfStatementsListsToStmtsMap(int &currentNodeID, std::vector<SCAM::Stmt *> &ifStmtList);
    };


}

#endif //SCAM_MERGEREDUNDANTIFELSE_H
