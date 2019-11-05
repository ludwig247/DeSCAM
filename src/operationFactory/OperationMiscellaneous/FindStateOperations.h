//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 7/5/19.
//

#ifndef SCAM_FINDSTATEOPERATIONS_H
#define SCAM_FINDSTATEOPERATIONS_H

#include "Behavior/CfgNode.h"
#include <ValidOperations.h>

#include <map>
#include <Module.h>

namespace SCAM {

    /**
     * \brief: Extract all possible forward paths from important state to other important states.
     *          Return a boolean indicating if reaching a fixed loop (i.e. spurious path).
     *
     * \input:
     *      - std::map<int, SCAM::CfgNode *> cfg;
     *      - std::vector<SCAM::CfgNode *> importantStates;
     *      - SCAM::Module * module;
     *      - SCAM::CfgNode * whileNode;
     *
     * \output:
     *      - std::vector<std::vector<SCAM::CfgNode *>> stateOperations;
     *      - std::vector<SCAM::CfgNode *> spuriousPath;
     *
     * \details: Traverse CFG (iterative depth first search through reachable node's successors) and extract all possible paths starting from the important state.
     *      - If reaching a fixed loop (i.e. passing a list of nodes twice), return a boolean indicating a spurious path
     *
     */

    class FindStateOperations {
    public:
        FindStateOperations(std::map<int, SCAM::CfgNode *> cfg_arg, std::vector<SCAM::CfgNode *> importantStates_arg, SCAM::Module * module_arg, SCAM::CfgNode * whileNode_arg);
        ~FindStateOperations() = default;
        bool findOperations(SCAM::CfgNode * state);
        const std::vector<SCAM::CfgNode *> &getSpurious();
        const std::vector<std::vector<SCAM::CfgNode *>> &getStateOperations();

    private:
        std::map<int, SCAM::CfgNode *> cfg;
        SCAM::CfgNode * whileNode;
        std::vector<SCAM::CfgNode *> importantStates;
        SCAM::Module * module;

        std::vector<std::vector<SCAM::CfgNode *>> stateOperations;
        std::vector<SCAM::CfgNode *> spuriousPath;
    };

}

#endif //SCAM_FINDSTATEOPERATIONS_H
