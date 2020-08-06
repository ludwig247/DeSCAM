//
// Created by tobias on 18.02.16.
//

#ifndef SCAM_ENUMARTEPATHSVISITOR_H
#define SCAM_ENUMARTEPATHSVISITOR_H

#include <set>
#include <map>
#include "CfgBlock.h"

namespace DESCAM {
    /*!
     * \brief Class that enumarates all paths between start and endnode
     */
    class EnumartePathsVisitor {
    public:
        EnumartePathsVisitor(DESCAM::CfgBlock *startNode, DESCAM::CfgBlock *endNode);

        const std::set<int> &getNodeList() const;

        void core(DESCAM::CfgBlock *node, std::set<int> path);

    private:
        DESCAM::CfgBlock *startNode;
        DESCAM::CfgBlock *endNode;
        int pathCnt;

        std::set<int> visitedNodes;
        std::set<int> nodeList;
    };
}
#endif //SCAM_ENUMARTEPATHSVISITOR_H
