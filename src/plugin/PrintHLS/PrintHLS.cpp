//
// Created by schauss on 10.02.20.
//

#include "PrintHLS.h"
#include "OptimizerHLS.h"
#include "HLS.h"
#include "SynthesisScripts.h"
#include "VHDLWrapperSCO.h"
#include "VHDLWrapperMCO.h"

using namespace DESCAM::HLSPlugin;

std::map<std::string, std::string> PrintHLS::printModel(Model *model) {
    std::stringstream moduleNames;

    if (getOptionMap().at("sco")) {
        hlsOption = HLSOption::SCO;
    } else if (getOptionMap().at("mco")) {
        hlsOption = HLSOption::MCO;
    } else {
        std::cout << "\x1B[31mNo HLS Option selected. Default Option is \"Multi Cycle Operation!\"\033[0m\t\t" << std::endl;
        hlsOption = HLSOption::MCO;
    }

    for (auto& module: model->getModules()) {
        std::string moduleName = module.first;
        auto currentModule = module.second;

        moduleNames << moduleName << "\n";

        auto propertySuiteHelper = std::make_shared<PropertySuiteHelper>(*module.second->getPropertySuite());
        auto optimizer = std::make_shared<OptimizerHLS>(propertySuiteHelper, module.second);

        if (hlsOption == HLSOption::SCO) {
            auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperSCO>(currentModule, moduleName, propertySuiteHelper, optimizer);
            auto vhdlWrapperModel = vhdlWrapper->printModule();
            pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());
        } else {
            auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperMCO>(currentModule, moduleName, propertySuiteHelper, optimizer);
            auto vhdlWrapperModel = vhdlWrapper->printModule();
            pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());
        }

        auto hls = std::make_unique<HLS::HLS>(hlsOption, currentModule, moduleName, propertySuiteHelper, optimizer);
        auto hlsModel = hls->printModule();
        pluginOutput.insert(hlsModel.begin(), hlsModel.end());

        auto synthesisScript = std::make_unique<Script::SynthesisScripts>(optimizer, hlsOption);
        auto script = synthesisScript->printModule(currentModule, moduleName);
        pluginOutput.insert(script.begin(), script.end());
    }

    pluginOutput.insert(std::make_pair(".module_names.txt", moduleNames.str()));

    return pluginOutput;
}