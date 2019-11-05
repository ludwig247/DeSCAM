//
// Created by tobias on 19.04.16.
//

#ifndef SCAM_FLATTENWHILE_H
#define SCAM_FLATTENWHILE_H

#include "CfgBlock.h"
#include <map>
#include <set>

namespace SCAM {

    class FlattenWhile {
    public:
        FlattenWhile(SCAM::CfgBlock *startNode, SCAM::CfgBlock *endNode,
                     std::map<SCAM::CfgBlock *, SCAM::CfgBlock *> &startEndMap, std::map<SCAM::CfgBlock *, std::set<int>> &pathNodeMap);

        void core(SCAM::CfgBlock *node);

        std::vector<SCAM::Stmt *> getStmtList();

    private:
        SCAM::CfgBlock *startNode;
        SCAM::CfgBlock *endNode;
        std::map<SCAM::CfgBlock *, SCAM::CfgBlock *> &startEndMap; //! Map containg the exit node for each ite block
        std::map<SCAM::CfgBlock *, std::set<int>> &pathNodeMap; //! Map containg an entry for each node between start and end
        std::vector<SCAM::Stmt *> stmtList;
    };


}


#endif //SCAM_FLATTENWHILE_H
