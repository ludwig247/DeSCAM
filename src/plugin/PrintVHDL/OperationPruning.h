//
// Created by pmorku on 7/29/18.
//

#ifndef PROJECT_OPERATIONPRUNING_H
#define PROJECT_OPERATIONPRUNING_H

#include <Module.h>
#include <Stmts/Stmts_all.h>

using namespace SCAM;

class OperationPruning {
public:
    OperationPruning(const std::map<int, State *> &stateMap, Module *module);

    const std::map<int, State *> &getNewStateMap() const;
    const std::vector<State *> &getUnreachableStates() const;

private:
    std::vector<State *> unreachableStates;
    std::map<int, State *> newStateMap;
//    std::map<Operation *, Path *> operationPathMap;
    Module * module;

};


#endif //PROJECT_OPERATIONPRUNING_H
