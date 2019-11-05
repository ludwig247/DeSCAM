//
// Created by tobias on 20.07.18.
//

#ifndef PROJECT_CFGUTILITIES_H
#define PROJECT_CFGUTILITIES_H

#include <map>
#include <set>
#include "CfgBlock.h"

namespace SCAM {

    class CfgUtilities {
    public:
        CfgUtilities() = default;

        virtual ~CfgUtilities() = default;

        static std::map<SCAM::CfgBlock *, SCAM::CfgBlock *> getStartEndMap(const std::map<int, CfgBlock *> &cfgMap);

        static std::map<int, SCAM::CfgBlock *> addTerminalNodeForFunctions(const std::map<int, CfgBlock *> &cfgMap);

        static std::map<SCAM::CfgBlock *, std::set<int>> getPathNodes(const std::map<SCAM::CfgBlock *, SCAM::CfgBlock *> &startEndMap);

    private:

    };

}

#endif //PROJECT_CFGUTILITIES_H
