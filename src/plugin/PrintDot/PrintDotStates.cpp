//
// Created by ludwig on 9/6/18.
//

#include "PrintDotStates.h"

std::map<std::string, std::string> PrintDotStates::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        this->ss.str("");
        this->ss << printDotStates(module.second);
        pluginOutput.insert(std::make_pair(module.first + ".dot", ss.str()));
    }
    return pluginOutput;
}

////////////////
    std::string PrintDotStates::printDotStates(Module *module) {
    std::stringstream ss;
    ss << "digraph " << module->getName() << " {  graph [rankdir=TD];  " << std::endl;
    for (auto state: module->getFSM()->getStateMap()) {
        for (auto outgoing: state.second->getOutgoingOperationList()) {
            // State -> Assumptions -> NextState
            ss << state.first << "->";
            ss << outgoing->getNextState()->getStateId() << ";" << std::endl;
        }
        if (state.second->isInit()) {
            ss << state.first << "[ label =\" init \"];" << std::endl;
        } else
            ss << state.first << "[ label =\"" << state.second->getSection() << "_" << state.second->getStateId()
               << "\"];" << std::endl;
    }


    ss << "}" << std::endl;

    return ss.str();

}