//
// Created by M.I.Alkoudsi on 27.07.19.
//

#ifndef SCAM_REMOVEEMPTYNODES_H
#define SCAM_REMOVEEMPTYNODES_H


#include <set>
#include <map>
#include <utility>
#include <CfgBlock.h>
#include <Stmts/Expr.h>
#include "PrintStmt.h"
#include "RenumberCFG.h"


namespace SCAM {

    /***
     * @brief: Removes nodes in the CfgBlock graph that have no statements and terminator
     *
     *
     */

    class RemoveEmptyNodes {

    public:
        RemoveEmptyNodes() = delete;

        explicit RemoveEmptyNodes(std::map<int, SCAM::CfgBlock *> CFG);

        ~RemoveEmptyNodes() = default;

        const std::map<int, CfgBlock *> &getNewBlockCFG() const;

    private:
        std::map<int, SCAM::CfgBlock *> blockCFG;
        std::set<int> emptyNodesSet;
        static void removeOrReplacePredecessorInSuccessor(SCAM::CfgBlock* cfgBlock, SCAM::CfgBlock* Predecessor , SCAM::CfgBlock* successor);
        static void removeOrReplaceSuccessorInPredecessor(SCAM::CfgBlock* cfgBlock, SCAM::CfgBlock* successor , SCAM::CfgBlock* Predecessor);
        void removeNullStatementAndReplaceItInPredecessorsAndSuccessors(int nodeId);
    };


}

#endif //SCAM_REMOVEEMPTYNODES_H
