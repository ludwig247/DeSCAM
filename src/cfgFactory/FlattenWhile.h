//
// Created by tobias on 19.04.16.
//

#ifndef SCAM_FLATTENWHILE_H
#define SCAM_FLATTENWHILE_H

#include "CfgBlock.h"
#include <map>
#include <set>

namespace DESCAM {

    class FlattenWhile {
    public:
        FlattenWhile(DESCAM::CfgBlock *startNode, DESCAM::CfgBlock *endNode,
                     std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> &startEndMap, std::map<DESCAM::CfgBlock *, std::set<int>> &pathNodeMap);

        void core(DESCAM::CfgBlock *node);

        std::vector<DESCAM::Stmt *> getStmtList();

    private:
        DESCAM::CfgBlock *startNode;
        DESCAM::CfgBlock *endNode;
        std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> &startEndMap; //! Map containg the exit node for each ite block
        std::map<DESCAM::CfgBlock *, std::set<int>> &pathNodeMap; //! Map containg an entry for each node between start and end
        std::vector<DESCAM::Stmt *> stmtList;
    };


}


#endif //SCAM_FLATTENWHILE_H
