//
// Created by tobias on 31.01.20.
//

#include <CreatePropertySuite.h>
#include "TrueOperation.h"


SCAM::TrueOperation::TrueOperation(SCAM::Module const *  module):
    //stateMap(module->getFSM()->getStateMap()),
    module(module) {
    //Step 1: find all cycles starting from the start state
    auto start = this->getStartState(module->getFSM()->getStateMap());
    findCylces(start, start, {});
    std::cout << printCycles() << std::endl;

    //Step 2: create "composed" PropertySuite
    //TODO: add "composed" operations to PropertySuite
    //TODO: problem right now is to print the composed properties. Idea: make printing of properties a static function in PrintITL ?
    createPropertySuite();




    //TODO: check output with hardware
}


void SCAM::TrueOperation::setRightHook() {

}

void SCAM::TrueOperation::findCylces(State2 *current, State2 *start, const std::vector<const Operation2 *> &opList) {
    this->loop_detection++;
    if(this->loop_detection == 0xFFFF-1) throw std::runtime_error(" loop "); //TODO: show trace of loop
    for (auto operation: current->getOutgoingOperationsList()) {
        if(operation->IsWait()) continue;
        auto newOpList = opList;
        newOpList.push_back(operation);
        if (operation->getNextState() == start) {
            this->cycleMap.push_back(newOpList);
        } else findCylces(operation->getNextState(), start, newOpList);
    }
    return;
}

SCAM::State2 *SCAM::TrueOperation::getStartState(const std::map<int, State2 *> &stateMap) const {
        //Init state should always be index 0
        State2 *initState = stateMap.at(0);
        assert(initState->getName() == "init_0" && "Wrong state");
        return  initState->getOutgoingOperationsList().back()->getNextState();
}

std::string SCAM::TrueOperation::printCycles() const {

    std::stringstream ss;
    int i=0;
    for (const auto &cycle : cycleMap) {
        ss << "Cycle #" << i++ << std::endl;
        int j = cycle.size()-1;
        for(auto op: cycle){
            ss  << "op_"<< op->getId() <<"[" << op->getState()->getName() << ":" << op->getNextState()->getName() << "]";
            if(j-- != 0){
                ss << "->";
            }else{
               ss  << std::endl;
            }

        }
    }
    return ss.str();
}

void SCAM::TrueOperation::createPropertySuite() {

    auto s2qed = new PropertySuite("TrueOperation");
    // Generate PropertySuite
    //Ports
    //SCAM::CreatePropertySuite::addNotifySignals(this->module, s2qed);
    //SCAM::CreatePropertySuite::addSyncSignals(this->module, s2qed);
    //SCAM::CreatePropertySuite::addDataSignals(this->module, s2qed);

    //Vars
    //SCAM::CreatePropertySuite::addVisibleRegisters(this->varMap, s2qed);

    //States
    //SCAM::CreatePropertySuite::addStates(this->module, s2qed);

    //Functions
    //SCAM::CreatePropertySuite::addFunctions(this->module, s2qed);

    SCAM::CreatePropertySuite::addTrueOperations(cycleMap,this->module, s2qed);

}

std::string SCAM::TrueOperation::printProperty(SCAM::Property *property) {
    return std::string();
}

