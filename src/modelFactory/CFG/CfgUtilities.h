//
// Created by tobias on 20.07.18.
//

#ifndef PROJECT_CFGUTILITIES_H
#define PROJECT_CFGUTILITIES_H

#include <map>
#include <set>
#include "CFGNode.h"

namespace SCAM{

class CfgUtilities {
public:
    CfgUtilities() = default;
    virtual ~CfgUtilities() = default;

    static std::map<SCAM::CFGNode *, SCAM::CFGNode *> getStartEndMap(const std::map<int, CFGNode *> &cfgMap);
    static std::map<int, SCAM::CFGNode *> addTerminalNodeForFunctions(const std::map<int, CFGNode *> &cfgMap);
    static std::map<SCAM::CFGNode*,std::set<int>> getPathNodes(const std::map<SCAM::CFGNode *, SCAM::CFGNode *> & startEndMap);

private:

};

}

#endif //PROJECT_CFGUTILITIES_H
