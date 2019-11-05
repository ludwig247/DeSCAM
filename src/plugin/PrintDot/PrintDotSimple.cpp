//
// Created by ludwig on 9/6/18.
//

#include "PrintDotSimple.h"

std::map<std::string, std::string> PrintDotSimple::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        this->ss.str("");
        this->ss << printDotSimple(module.second);
        pluginOutput.insert(std::make_pair(module.first + ".dot", ss.str()));
    }
    return pluginOutput;
}

////////////////
std::string PrintDotSimple::printDotSimple(Module *module) {
    std::stringstream ss;

    ss << "digraph " << module->getName() << " {  graph [rankdir=TD];  " << std::endl;
    PropertySuite *ps = module->getPropertySuite();

    // Reset property
    {
        auto op = ps->getResetProperty();
        // State -> Assumptions -> NextState
        ss << "init" << "->";
        ss << "op_" << op->getName() << "[dir=none];\n";
        ss << "op_" << op->getName() << " ->";
        ss << op->getNextState()->getName() << ";" << std::endl;
        ss << "op_" << op->getName() << "[shape=record label =\"{" << op->getName() << "}";
        //Assumptions
        if (!op->getAssumptionList().empty()) { //should be empty
            ss << " | { Assumptions |";
            for (auto iterator = op->getAssumptionList().begin();
                 iterator != op->getAssumptionList().end(); ++iterator) {
                ss << PrintStmtForDot::toString((*iterator));
                if (iterator + 1 != op->getAssumptionList().end()) {
                    ss << "|";
                }
            }
            ss << "}";
        }
        ss << "}\"];" << std::endl;
    }


    for (auto op: ps->getOperationProperties()) {
        // State -> Assumptions -> NextState
        ss << op->getState()->getName() << "->";
        ss << "op_" << op->getName() << "[dir=none];\n";
        ss << "op_" << op->getName() << " ->";
        ss << op->getNextState()->getName() << ";" << std::endl;
        ss << "op_" << op->getName() << "[shape=record label =\"{" << op->getName() << "}";
        //Assumptions
        if (!op->getAssumptionList().empty()) {
            ss << " | { Assumptions |";
            for (auto iterator = op->getAssumptionList().begin();
                 iterator != op->getAssumptionList().end(); ++iterator) {
                ss << PrintStmtForDot::toString((*iterator));
                if (iterator + 1 != op->getAssumptionList().end()) {
                    ss << "|";
                }
            }
            ss << "}";
        }
        ss << "}\"];" << std::endl;
    }

    ss << "init [ label =\"init\"];" << std::endl;
    for (auto state:ps->getStates())
        ss << state->getName() << "[ label =\"" << state->getName() << "\"];" << std::endl;

    ss << "}";

    return ss.str();
}