//
// Created by tobias on 18.02.16.
//

#ifndef SCAM_ENUMARTEPATHSVISITOR_H
#define SCAM_ENUMARTEPATHSVISITOR_H

#include <set>
#include <map>
#include "CFGNode.h"

namespace SCAM {
    /*!
     * \brief Class that enumarates all paths between start and endnode
     */
    class EnumartePathsVisitor {
    public:
        EnumartePathsVisitor(SCAM::CFGNode* startNode, SCAM::CFGNode* endNode);

        const std::set<int> &getNodeList() const;

        void core(SCAM::CFGNode   * node,std::set<int> path);

    private:
        SCAM::CFGNode* startNode;
        SCAM::CFGNode* endNode;
        int pathCnt;

        std::set<int> visitedNodes;
        std::set<int> nodeList;
    };
}
#endif //SCAM_ENUMARTEPATHSVISITOR_H
