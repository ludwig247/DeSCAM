//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 9/16/18.
//

#ifndef PROJECT_COMMANDLINEPARAMETER_CPP
#define PROJECT_COMMANDLINEPARAMETER_CPP

#include <vector>
#include <sstream>
#include "FatalError.h"
#include "Logger/Logger.h"
#include "CommandLineParameter.h"

CommandLineParameter::CommandLineParameter() {
    std::vector<std::string> parameters;
    std::vector<std::string> parametersDescriptions;

    parameters = split(PLUGIN_NAMES, ';');
    for (auto &parameter : parameters) {
        plugin_Map.insert(std::make_pair(parameter, false));
    }

    parameters = split(OPTION_NAMES, ';');
    for (int i = 0; i < parameters.size(); i = i + 2)
        pluginOptions_Map[parameters[i]].insert(std::make_pair(parameters[i + 1], false));
}

//GETTERS
CommandLineParameter &CommandLineParameter::getInstance() {
    static CommandLineParameter instance;
    return instance;
}

std::map<std::string, bool> &CommandLineParameter::getPluginMap() {
    return CommandLineParameter::getInstance().plugin_Map;
}

std::map<std::string, bool> &CommandLineParameter::getOptionMap(std::string pluginName) {
    return CommandLineParameter::getInstance().pluginOptions_Map[pluginName];
}


//SETTERS
void CommandLineParameter::setPluginParameter(std::string parameter, bool value) {
    if (CommandLineParameter::getInstance().plugin_Map.find(parameter) != CommandLineParameter::getInstance().plugin_Map.end()) {
        CommandLineParameter::getInstance().plugin_Map[parameter] = value;
    } else TERMINATE("Unknown PlugIn: " + parameter);
}

void CommandLineParameter::setPluginOptionParameter(std::string pluginName, std::string parameter, bool value) {
    if (CommandLineParameter::getInstance().pluginOptions_Map.find(pluginName) != CommandLineParameter::getInstance().pluginOptions_Map.end()) {
        std::map<std::string, bool> t = CommandLineParameter::getInstance().pluginOptions_Map[pluginName];
        if (t.find(parameter) != t.end())
            CommandLineParameter::getInstance().pluginOptions_Map[pluginName][parameter] = value;
    } else TERMINATE("Unknown Plugin: " + pluginName + " or Option: " + parameter);
}

void CommandLineParameter::setOptimizeOptionsSet(const std::set<std::string> &optimizeOptionsSet) {
    CommandLineParameter::getInstance().optimizeOptionsSet = optimizeOptionsSet;
}

std::set<std::string> &CommandLineParameter::getOptimizeOptionsSet() {
    return  CommandLineParameter::getInstance().optimizeOptionsSet;
}

#endif //PROJECT_COMMANDLINEPARAMETER_CPP