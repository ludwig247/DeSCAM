//
// Created by tobias on 12.12.18.
//

#ifndef PROJECT_CREATEREALCFG_H
#define PROJECT_CREATEREALCFG_H

#include <map>
#include "CfgBlock.h"
#include "Behavior/CfgNode.h"

namespace DESCAM {


    class CreateRealCFG {
    public:
        explicit CreateRealCFG(const std::map<int, DESCAM::CfgBlock *> &controlFlowMap);

        CreateRealCFG() = delete;

        const std::map<int, CfgNode *> &getCFG() const;

        virtual ~CreateRealCFG() = default;

    private:
        std::map<int, DESCAM::CfgNode *> cfg;
    };


}
#endif //PROJECT_CREATEREALCFG_H
