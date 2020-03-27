//
// Created by Dino Mehmedagić on 18.03.20.
//

#include <PluginFactory.h>
#include <AbstractVisitor.h>
#include "../model/FSM.h"
#include "../model/Behavior/State.h"
#include <regex>

#ifndef DESCAM_ESTIMATEPOWER_H
#define DESCAM_ESTIMATEPOWER_H

#endif //DESCAM_ESTIMATEPOWER_H


class EstimatePower : public PluginFactory {
public:
    EstimatePower() = default;

    ~EstimatePower() = default;

    std::map<std::string, std::string> printModel(Model *node);

private:

    void registerOperations(FSM &node);

    void traverseProcessBody(FSM &node);

    std::string writeFile(std::pair <std::string, Module* > module);

    std::map <std::string, Port *> portMap;

    std::map <Operation *, bool> operationsCounted;

    std::map <unsigned int, Operation *> operationsMap;

    unsigned int operationsCounter;

    std::vector <std::string> processBody;

    void insertOperationLines(State *currentState, State *nextState);

    void debug(Module &node);

};
