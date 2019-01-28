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
    for (auto state: module->getFSM()->getStateMap()) {
        for (auto outgoing: state.second->getOutgoingOperationList()) {
            // State -> Assumptions -> NextState
            ss << state.first << "->";
            ss << "op_" << outgoing->getOp_id() << "[dir=none];\n";
            ss << "op_" << outgoing->getOp_id() << " ->";
            ss << outgoing->getNextState()->getStateId() << ";" << std::endl;
            //Assumptions
            if (!outgoing->getAssumptionList().empty()) {
                ss << "op_" << outgoing->getOp_id() << "[shape=record label =\"{ ";
                for (auto iterator = outgoing->getAssumptionList().begin();
                     iterator != outgoing->getAssumptionList().end(); ++iterator) {
                    ss << PrintStmtForDot::toString((*iterator));
                    if (iterator + 1 != outgoing->getAssumptionList().end()) {
                        ss << "|";
                    }
                }
                ss << "}\"];" << std::endl;
            } else {
                ss << "op_" << outgoing->getOp_id() << "[shape=record label =\"{ ";
                ss << "true";
                ss << "}\"];" << std::endl;
            }
        }
        if (state.second->isInit()) {
            ss << state.first << "[ label =\" init \"];" << std::endl;
        } else
            ss << state.first << "[ label =\"" << state.second->getSection() << "_" << state.second->getStateId()
               << "\"];" << std::endl;
    }
    ss << "}";

    return ss.str();
}