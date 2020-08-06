//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/5/19.
//

#ifndef SCAM_FINDSTATEOPERATIONS_H
#define SCAM_FINDSTATEOPERATIONS_H

#include "Behavior/CfgNode.h"
#include <ValidOperations.h>

#include <map>
#include <Module.h>

namespace DESCAM {

    /**
     * \brief: Extract all possible forward paths from important state to other important states.
     *          Return a boolean indicating if reaching a fixed loop (i.e. spurious path).
     *
     * \input:
     *      - std::map<int, DESCAM::CfgNode *> cfg;
     *      - std::vector<DESCAM::CfgNode *> importantStates;
     *      - DESCAM::Module * module;
     *      - DESCAM::CfgNode * whileNode;
     *
     * \output:
     *      - std::vector<std::vector<DESCAM::CfgNode *>> stateOperations;
     *      - std::vector<DESCAM::CfgNode *> spuriousPath;
     *
     * \details: Traverse CFG (iterative depth first search through reachable node's successors) and extract all possible paths starting from the important state.
     *      - If reaching a fixed loop (i.e. passing a list of nodes twice), return a boolean indicating a spurious path
     *
     */

    class FindStateOperations {
    public:
        FindStateOperations(std::map<int, DESCAM::CfgNode *> cfg_arg, std::vector<DESCAM::CfgNode *> importantStates_arg, DESCAM::Module * module_arg, DESCAM::CfgNode * whileNode_arg);
        ~FindStateOperations() = default;
        bool findOperations(DESCAM::CfgNode * state);
        const std::vector<DESCAM::CfgNode *> &getSpurious();
        const std::vector<std::vector<DESCAM::CfgNode *>> &getStateOperations();

    private:
        std::map<int, DESCAM::CfgNode *> cfg;
        DESCAM::CfgNode * whileNode;
        std::vector<DESCAM::CfgNode *> importantStates;
        DESCAM::Module * module;

        std::vector<std::vector<DESCAM::CfgNode *>> stateOperations;
        std::vector<DESCAM::CfgNode *> spuriousPath;
    };

}

#endif //SCAM_FINDSTATEOPERATIONS_H
