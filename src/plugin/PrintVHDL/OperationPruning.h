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
    OperationPruning(const std::map<int, State2 *> &stateMap, Module *module);

    const std::map<int, State2 *> &getNewStateMap() const;
    const std::vector<State2 *> &getUnreachableStates() const;

private:
    std::vector<State2 *> unreachableStates;
    std::map<int, State2 *> newStateMap;
//    std::map<Operation *, Path *> operationPathMap;
    Module * module;

};


#endif //PROJECT_OPERATIONPRUNING_H
