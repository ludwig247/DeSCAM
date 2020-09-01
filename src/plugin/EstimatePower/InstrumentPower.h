//
// Created by lanrez on 8/30/20.
//

#ifndef SCAM_INSTRUMENTPOWER_H
#define SCAM_INSTRUMENTPOWER_H


#include <PluginFactory.h>


class InstrumentPower : public PluginFactory {

public:
    InstrumentPower() = default;

    ~InstrumentPower() = default;

    std::map<std::string, std::string> printModel(Model *node);

private:

    void registerOperations(FSM &node);

    void traverseProcessBody(FSM &node, unsigned int processPosition);

    std::string writeFile(std::pair <std::string, DESCAM::Module* > module);

    std::map <std::string, Port *> portMap;

    std::map <Operation *, bool> operationsCounted;


    unsigned int operationsCounter;

    std::vector <std::string> processBody;

    void debug(DESCAM::Module &node);

    void mapStates(FSM &node);

    std::map <Port*, std::vector <State*>> ports2States;

    std::map <int, State *> stateLines;

    int whichLine(State &state);

    void mapStates2Lines(FSM &node);

    std::string lhs(std::string condition);

    std::string rhs(std::string condition);

    bool isPositive (std::string condition);

    std::map <int, DESCAM::Stmt *> stateStmt;

    void findStateStmt(FSM * node);

};

#endif //SCAM_INSTRUMENTPOWER_H
