//
// Created by tobias on 20.07.18.
//

#ifndef PROJECT_CFGUTILITIES_H
#define PROJECT_CFGUTILITIES_H

#include <map>
#include <set>
#include "CfgBlock.h"

namespace DESCAM {

    class CfgUtilities {
    public:
        CfgUtilities() = default;

        virtual ~CfgUtilities() = default;

        static std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> getStartEndMap(const std::map<int, CfgBlock *> &cfgMap);

        static std::map<int, DESCAM::CfgBlock *> addTerminalNodeForFunctions(const std::map<int, CfgBlock *> &cfgMap);

        static std::map<DESCAM::CfgBlock *, std::set<int>> getPathNodes(const std::map<DESCAM::CfgBlock *, DESCAM::CfgBlock *> &startEndMap);

    private:

    };

}

#endif //PROJECT_CFGUTILITIES_H
