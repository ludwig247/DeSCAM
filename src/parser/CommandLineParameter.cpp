//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 9/16/18.
//

#ifndef PROJECT_COMMANDLINEPARAMETER_CPP
#define PROJECT_COMMANDLINEPARAMETER_CPP

#include <vector>
#include <sstream>
#include "CommandLineParameter.h"
#include "CommandLineParametersConfig.h"

CommandLineParameter::CommandLineParameter(){
    std::vector<std::string> parameters;
    std::vector<std::string> parametersDescriptions;

    parameters = split(PLUGIN_NAMES, ';');
    for (auto &parameter : parameters) {
        plugin_Map.insert(std::make_pair(parameter, false));
    }

    parameters = split(OPTION_NAMES, ';');
    for (int i = 0; i < parameters.size(); i=i+2) {
        std::map<std::string, bool> t;
        t.insert(std::make_pair(parameters[i+1],false));
        pluginOptions_Map.insert(std::make_pair(parameters[i], t));
    }
}

//GETTERS
CommandLineParameter &CommandLineParameter::getInstance() {
    static CommandLineParameter instance;
    return instance;
}

std::map<std::string, bool> &CommandLineParameter::getPluginMap(){
    return CommandLineParameter::getInstance().plugin_Map;
}
std::map<std::string, bool> &CommandLineParameter::getOptionMap(std::string pluginName){
    return CommandLineParameter::getInstance().pluginOptions_Map[pluginName];
}


//SETTERS
void CommandLineParameter::setPluginParameter(std::string parameter, bool value){
    if (CommandLineParameter::getInstance().plugin_Map.find(parameter) != CommandLineParameter::getInstance().plugin_Map.end()) {
        CommandLineParameter::getInstance().plugin_Map[parameter] = value;
    } else throw std::runtime_error("Unknown PlugIn: " + parameter);
}

void CommandLineParameter::setPluginOptionParameter(std::string pluginName, std::string parameter, bool value){
    if (CommandLineParameter::getInstance().pluginOptions_Map.find(pluginName) != CommandLineParameter::getInstance().pluginOptions_Map.end()) {
        std::map<std::string, bool> t = CommandLineParameter::getInstance().pluginOptions_Map[pluginName];
        if(t.find(parameter) != t.end())
            CommandLineParameter::getInstance().pluginOptions_Map[pluginName][parameter] = value;
    } else throw std::runtime_error("Unknown Plugin: " + pluginName + " or Option: " + parameter);
}

#endif //PROJECT_COMMANDLINEPARAMETER_CPP