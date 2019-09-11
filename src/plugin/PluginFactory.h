//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef PROJECT_STYLEFACTORY_H
#define PROJECT_STYLEFACTORY_H

#include "../parser/CommandLineParameter.h"
#include <Model.h>
#include <cxxabi.h>

using namespace SCAM;

class PluginFactory {
public:
    PluginFactory() = default;
    ~PluginFactory() = default;

    virtual std::map<std::string, std::string> printModel(Model *node) = 0;

    static PluginFactory *create(std::string type);

    std::map<std::string, bool> getOptionMap(){
        int status;
        char *pluginName = abi::__cxa_demangle(typeid(*this).name(), nullptr, nullptr, &status);
        return CommandLineParameter::getOptionMap(pluginName);
    }

    std::map<std::string, std::string> pluginOutput;
};

#endif //PROJECT_STYLEFACTORY_H
