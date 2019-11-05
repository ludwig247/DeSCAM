//
// Created by tobias on 12.12.18.
//

#ifndef PROJECT_CREATEREALCFG_H
#define PROJECT_CREATEREALCFG_H

#include <map>
#include "CfgBlock.h"
#include "Behavior/CfgNode.h"

namespace SCAM {


    class CreateRealCFG {
    public:
        explicit CreateRealCFG(const std::map<int, SCAM::CfgBlock *> &controlFlowMap);

        CreateRealCFG() = delete;

        const std::map<int, CfgNode *> &getCFG() const;

        virtual ~CreateRealCFG() = default;

    private:
        std::map<int, SCAM::CfgNode *> cfg;
    };


}
#endif //PROJECT_CREATEREALCFG_H
