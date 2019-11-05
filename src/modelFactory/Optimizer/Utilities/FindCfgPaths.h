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


namespace SCAM {
    /***
        * @brief: Finds all possible paths in the node CFG from one given node to the other
        * @author:M.I.Alkoudsi
        *
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
        std::map<int, CfgPath> Pathsmap;
        std::map<int, std::vector<int>> nodeAndAllPathsReachingItMap;
        bool pathEmpty;

        void removeBackwardsUntilIf(SCAM::CfgPath *Path);

    };
}


#endif //SCAM_FINDCFGPATHS_H