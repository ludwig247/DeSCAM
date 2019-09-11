//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include "PrintTemplate.h"


std::map<std::string, std::string> PrintTemplate::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        std::stringstream result;
        result << "Generate the output you want\n";
        pluginOutput.insert(std::make_pair(module.first + ".txt", result.str()));
    }
    return pluginOutput;
}