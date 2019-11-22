//
// Created by pmorku on 10.07.18.
//

#ifndef PROJECT_SIMPLIFYOPERATIONS_H
#define PROJECT_SIMPLIFYOPERATIONS_H

#include <Behavior/State2.h>
#include <Behavior/Operation2.h>

namespace SCAM {
    class RelocateOpStmts {
    public:
        RelocateOpStmts(const std::map<int, SCAM::State2 *> &stateMap, Module *module);
    };
}


#endif //PROJECT_SIMPLIFYOPERATIONS_H
