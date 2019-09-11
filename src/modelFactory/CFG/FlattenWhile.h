//
// Created by tobias on 19.04.16.
//

#ifndef SCAM_FLATTENWHILE_H
#define SCAM_FLATTENWHILE_H

#include "CFGNode.h"
#include <map>
#include <set>

namespace SCAM {

    class FlattenWhile  {
    public:
        FlattenWhile(SCAM::CFGNode *startNode, SCAM::CFGNode *endNode,
                     std::map<SCAM::CFGNode *, SCAM::CFGNode *> &startEndMap, std::map<SCAM::CFGNode*,std::set<int>>& pathNodeMap);

        void core(SCAM::CFGNode *node);
        std::vector<SCAM::Stmt *> getStmtList();

    private:
        SCAM::CFGNode *startNode;
        SCAM::CFGNode *endNode;
        std::map<SCAM::CFGNode *, SCAM::CFGNode *> &startEndMap; //! Map containg the exit node for each ite block
        std::map<SCAM::CFGNode*,std::set<int>>& pathNodeMap; //! Map containg an entry for each node between start and end
        std::vector<SCAM::Stmt *> stmtList;
    };


}


#endif //SCAM_FLATTENWHILE_H
