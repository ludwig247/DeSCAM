//
// Created by pmorku on 10.07.18.
//

#ifndef PROJECT_SIMPLIFYOPERATIONS_H
#define PROJECT_SIMPLIFYOPERATIONS_H

#include <operationGraph/State.h>
#include <operationGraph/Operation.h>

namespace SCAM {
    class RelocateOpStmts {
    public:
        RelocateOpStmts(const std::map<int, SCAM::State *> &stateMap, Module *module);
    };
}


#endif //PROJECT_SIMPLIFYOPERATIONS_H
