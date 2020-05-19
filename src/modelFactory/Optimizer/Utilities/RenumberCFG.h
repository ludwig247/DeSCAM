//
// Created by M.I.Alkoudsi on 27.07.19.
//

#ifndef SCAM_RENUMBERCFG_H
#define SCAM_RENUMBERCFG_H


#include "Behavior/CfgNode.h"
#include "PrintStmt.h"
#include <map>
#include <stack>
#include <utility>
#include <Stmts/Expr.h>
#include <CfgBlock.h>


namespace SCAM {

    /***
     * \brief: Give the nodes in the CFG sequential IDs.
     * \author: mi-alkoudsi
     * \details: Implements a DFS like algorithm to renumber the nodes in the CFG.
     * Especially helpful when a given algorithm implementation relies on sequential IDs
     * but removal of some nodes in the CFG happened due to optimizations, which affected the sequential numbering of the CFG
     */



    class RenumberCFG {

    public:
        RenumberCFG() = delete;

        explicit RenumberCFG(std::map<int, CfgBlock *> blockCFG);

        explicit RenumberCFG(std::map<int, CfgNode *> nodeCFG);

        ~RenumberCFG() = default;

        const std::map<int, CfgBlock *> &getNewBlockCFG() const;

        const std::map<int, CfgNode *> &getNewNodeCFG() const;

    private:
        std::map<int, CfgBlock *> blockCFG;
        std::map<int, CfgBlock *> newBlockCFG;
        std::map<int, CfgNode *> nodeCFG;
        std::map<int, CfgNode *> newNodeCFG;

        static bool areAllCFGNodesVisited(const std::vector<bool> &VistedNodesVector, int numCFGNodes);

    };
}


#endif //SCAM_RENUMBERCFG_H
