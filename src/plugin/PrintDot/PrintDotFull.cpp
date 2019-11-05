//
// Created by ludwig on 9/6/18.
//

#include "PrintDotFull.h"

std::map<std::string, std::string> PrintDotFull::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        this->ss.str("");
        this->ss << printDotFull(module.second);
        pluginOutput.insert(std::make_pair(module.first + ".dot", ss.str()));
    }
    return pluginOutput;
}

////////////////
std::string PrintDotFull::printDotFull(Module *module) {
    std::stringstream ss;
    ss << "digraph " << module->getName() << " {  graph [rankdir=TD];  " << std::endl;
    PropertySuite *ps = module->getPropertySuite();

    // Reset property
    {
        auto op = ps->getResetProperty();
        // State -> Assumptions -> Commitments -> NextState
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
        //Commitments
        if (!op->getCommitmentList().empty()) {
            ss << " | { Commitments | ";
            for (auto iterator = op->getCommitmentList().begin();
                 iterator != op->getCommitmentList().end(); ++iterator) {
                ss << PrintStmtForDot::toString((*iterator));
                if (iterator + 1 != op->getCommitmentList().end()) {
                    ss << "|";
                }
            }
            ss << "}";
        }
        ss << "}\"];" << std::endl;
    }


    for (auto op: ps->getOperationProperties()) {
        // State -> Assumptions -> Commitments -> NextState
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
        //Commitments
        if (!op->getCommitmentList().empty()) {
            ss << " | { Commitments | ";
            for (auto iterator = op->getCommitmentList().begin();
                 iterator != op->getCommitmentList().end(); ++iterator) {
                ss << PrintStmtForDot::toString((*iterator));
                if (iterator + 1 != op->getCommitmentList().end()) {
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

    ss << "}" << std::endl;

    return ss.str();

}