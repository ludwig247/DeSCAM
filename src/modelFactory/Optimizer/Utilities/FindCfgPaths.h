//
// Created by M.I.Alkoudsi on 5/20/19.
//
#ifndef SCAM_FINDCFGPATHS_H
#define SCAM_FINDCFGPATHS_H

#include <map>
#include <stack>
#include "CfgPath.h"
#include <Stmts/Stmts_all.h>
#include <memory>
#include <algorithm>
#include <utility>


namespace DESCAM {
    /***
        * \brief: Finds all possible paths in the node CFG from one given node to the other
        * \author:mi-alkoudsi
        * \inputs:
        *       - int entryNode;
        *       - std::map<int, CfgNode *> CFG;
        * \outputs:
        *       - std::map<int, CfgPath> pathsMap;
        *       - std::map<int, std::vector<int>> NodeAndAllPathsReachingItPairMap;
        * \details: implements a variant of the DFS algorithm.
        * It traverses the CFG and stores the found paths(archs) in a map data structure
        * A path here is a sequence of nodes from the source node to the sink
        * Note: paths are not unrolled.
        * In other words, the last node in a path is that, which has the while(true) node as a direct successor
        */

    class FindCfgPaths {
    public:
        FindCfgPaths();

        FindCfgPaths(std::map<int, CfgNode *> CFG, int entryNode);

        FindCfgPaths(const FindCfgPaths &FCP);

        ~FindCfgPaths() = default;


        const std::map<int, CfgPath> &getPathsMap() const;

        void setPathsMap(const std::map<int, CfgPath> &pathsMap);

        const std::map<int, std::vector<int>> &getNodeAndAllPathsReachingItMap() const;

        void setNodeAndAllPathsReachingItMap(const std::map<int, std::vector<int>> &nodeAndPathsReachingItMap);

        void addPathToPathsMap(const int &pathID, CfgPath &path);

        std::map<int, std::vector<CfgNode *>> makeResetPathsToNode(int nodeId);

        std::map<int, std::vector<CfgNode *>> makeAllPathsToNode(int nodeId);

    private:
        int whileNodeID;
        std::vector<bool> isVisted;
        std::vector<int> nodeInSuccVec;
        std::map<int, CfgNode *> Cfg;
        std::map<int, CfgPath> pathsmap_;
        std::map<int, std::vector<int>> nodeAndAllPathsReachingItMap;
        bool pathEmpty;

        void removeBackwardsUntilIf(CfgPath *Path);

    };
}


#endif //SCAM_FINDCFGPATHS_H