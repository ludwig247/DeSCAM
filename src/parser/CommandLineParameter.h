//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 9/16/18.
//

#ifndef PROJECT_COMMANDLINEPARAMETER_H
#define PROJECT_COMMANDLINEPARAMETER_H

#include <string>
#include <map>
#include <iostream>

class CommandLineParameter {
public:
    //GETTERS
    static CommandLineParameter &getInstance();
    static std::map<std::string, bool> &getPluginMap(); //FIXME: don't see how would this be useful anymore!!??
    static std::map<std::string, bool> &getOptionMap(std::string pluginName);

    //SETTERS
    static void setPluginParameter(std::string parameter, bool value);
    static void setPluginOptionParameter(std::string pluginName, std::string parameter, bool value);

    //DELETED
    CommandLineParameter(CommandLineParameter const &) = delete;             // copy constructor is private
    CommandLineParameter &operator=(CommandLineParameter const &) = delete; // assignment operator is private
private:
    //    CONSTRUCTOR
    CommandLineParameter();
    ~CommandLineParameter() = default;

    std::map<std::string, bool> plugin_Map;
    std::map<std::string, std::map<std::string, bool> > pluginOptions_Map;
};


#endif //PROJECT_COMMANDLINEPARAMETER_H
