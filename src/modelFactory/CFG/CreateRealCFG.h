//
// Created by tobias on 12.12.18.
//

#ifndef PROJECT_CREATEREALCFG_H
#define PROJECT_CREATEREALCFG_H

#include <map>
#include "CFGNode.h"

namespace SCAM{


class CreateRealCFG {
public:
    CreateRealCFG(const std::map<int, CFGNode *> &controlFlowMap);

    CreateRealCFG() = delete;

    virtual ~CreateRealCFG() = default;

private:

};


}
#endif //PROJECT_CREATEREALCFG_H
