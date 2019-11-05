//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 5/22/19.
//

#ifndef SCAM_CREATEEXPLICITCFG_H
#define SCAM_CREATEEXPLICITCFG_H

#include <map>
#include <PropertyMacro.h>
#include "Behavior/CfgNode.h"

namespace SCAM {

    class CreateExplicitCFG {
    public:
        explicit CreateExplicitCFG(const std::map<int, SCAM::CfgNode *> &controlFlowMap, const std::vector<PropertyMacro *> &states);

        ~CreateExplicitCFG() = default;

        const std::map<int, CfgNode *> &getCfg() const;

        const std::multimap<std::string, std::vector<SCAM::CfgNode *>> &getCommGroups() const;

    private:
        std::map<int, SCAM::CfgNode *> cfg;
        std::multimap<std::string, std::vector<SCAM::CfgNode *>> commGroups;
    };

}
#endif //SCAM_CREATEEXPLICITCFG_H
