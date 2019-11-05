//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include "PrintCompleteness.h"

#include <algorithm>


std::map<std::string, std::string> PrintCompleteness::printModel(Model *node) {
    for (auto &module: node->getModules()) {

        std::stringstream result;

        auto suite = module.second->getPropertySuite();
        result << "completeness " << suite->getName() << ";\n\n";

        result << "disable iff: rst;\n\n";

        result << "inputs:\n";
        result << "\t" << "clk,\n";
        result << "\t" << "rst";
        std::set<std::string> coveredPorts;
        for (auto signal : suite->getDpSignals()) {
            if ((signal->getPort()->getInterface()->isInput())
                && (coveredPorts.find(signal->getPort()->getName()) == coveredPorts.end())) {
                result << ",\n\t" << signal->getPort()->getName() << "_sig";
                coveredPorts.insert(signal->getPort()->getName());
            }
        }
        for (auto sync : suite->getSyncSignals()) {
            result << ",\n\t" << sync->getName();
        }
        result << ";\n\n";

        result << "determination_requirements:\n";
        std::set<std::string> coveredSignals;
        for (auto signal : suite->getVisibleRegisters()) {
            if (coveredSignals.find(signal->getName()) == coveredSignals.end()) {
                result << "\t" << "determined(" << signal->getName() << ");\n";
                coveredSignals.insert(signal->getName());
            }
        }
        for (auto notify : suite->getNotifySignals()) {
            if (notify->getPort()->getInterface()->isOutput()) {
                result << "\tif (" << notify->getName() << ") determined(" << notify->getPort()->getName() << "_sig) endif;\n";
            }
            result << "\t" << "determined(" << notify->getName() << ");\n";
        }
        result << "\n";

        result << "reset_property: reset;\n\n";

        result << "property_graph:\n";
        for (auto succ : suite->getSuccessorProperties(suite->getResetProperty()->getNextState())) {
            std::string succName = succ->getName();
            std::transform(succName.begin(), succName.end(), succName.begin(), ::tolower);
            result << "\t" << "reset->" << succName << ";\n";
        }
        for (auto state : suite->getStates()) {
            for (auto pred : suite->getPredecessorProperties(state)) {
                for (auto succ : suite->getSuccessorProperties(state)) {
                    // Convert property names to lowercase, because Onespin only knows this spelling
                    std::string predName = pred->getName();
                    std::string succName = succ->getName();
                    std::transform(predName.begin(), predName.end(), predName.begin(), ::tolower);
                    std::transform(succName.begin(), succName.end(), succName.begin(), ::tolower);
                    result << "\t" << predName << "->" << succName << ";\n";
                }
            }
        }

        result << "end completeness;";

        pluginOutput.insert(std::make_pair(module.first + ".gfv", result.str()));


    }
    return pluginOutput;
}