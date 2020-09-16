//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 6/24/19.
//

#ifndef PROJECT_EXPANDCOMMUNICATIONS_H
#define PROJECT_EXPANDCOMMUNICATIONS_H

#include <map>
#include <PropertyMacro.h>
#include "Behavior/CfgNode.h"

namespace DESCAM {

    class ExpandCommunications {
    public:
        explicit ExpandCommunications(const std::map<int, DESCAM::CFGNode2 *> &controlFlowMap, const std::map<std::string, Port *> &modulePorts);

        ~ExpandCommunications() = default;

        const std::map<int, CFGNode2 *> &getCFG() const;

        const std::multimap<std::string, std::vector<DESCAM::CFGNode2 *>> &getCommGroups() const;

    private:
        std::map<int, DESCAM::CFGNode2 *> cfg;
        std::multimap<std::string, std::vector<DESCAM::CFGNode2 *>> commGroups;
    };

}
#endif //PROJECT_EXPANDCOMMUNICATIONS_H
