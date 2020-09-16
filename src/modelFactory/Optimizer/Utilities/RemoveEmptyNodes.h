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


namespace DESCAM {

    /***
     * \brief: Removes nodes in the CfgBlock graph that have no statements and terminator
     * \author: mi-alkoudsi
     */

    class RemoveEmptyNodes {

    public:
        RemoveEmptyNodes() = delete;

        explicit RemoveEmptyNodes(std::map<int, CfgBlock *> CFG);

        ~RemoveEmptyNodes() = default;

        const std::map<int, CfgBlock *> &getNewBlockCFG() const;

    private:
        std::map<int, CfgBlock *> blockCFG;
        std::set<int> emptyNodesSet;
        static void removeOrReplacePredecessorInSuccessor(CfgBlock* cfgBlock, CfgBlock* Predecessor , CfgBlock* successor);
        static void removeOrReplaceSuccessorInPredecessor(CfgBlock* cfgBlock, CfgBlock* successor , CfgBlock* Predecessor);
        void removeNullStatementAndReplaceItInPredecessorsAndSuccessors(int nodeId);
    };


}

#endif //SCAM_REMOVEEMPTYNODES_H
