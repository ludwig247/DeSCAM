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
    PropertySuite *ps = module->getPropertySuite();

    // Reset property
    {
        auto op = ps->getResetProperty();
        // State -> NextState
        ss << "init" << "->";
        ss << "op_" << op->getName() << "[dir=none];\n";
        ss << "op_" << op->getName() << " ->" << op->getNextState()->getName() << ";" << std::endl;
        ss << "op_" << op->getName() << "[shape=record label =\"" << op->getName() << "\"];" << std::endl;
    }


    for (auto op: ps->getOperationProperties()) {
        // State -> NextState
        ss << op->getState()->getName() << "->";
        ss << "op_" << op->getName() << "[dir=none];\n";
        ss << "op_" << op->getName() << " ->" << op->getNextState()->getName() << ";" << std::endl;
        ss << "op_" << op->getName() << "[shape=record label =\"" << op->getName() << "\"];" << std::endl;
    }

    ss << "init [ label =\"init\"];" << std::endl;
    for (auto state:ps->getStates())
        ss << state->getName() << "[ label =\"" << state->getName() << "\"];" << std::endl;
    ss << "}" << std::endl;

    return ss.str();
}