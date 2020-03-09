//
// Created by schauss on 10.02.20.
//

#include "PrintHLS.h"
#include "OptimizerHLS.h"
#include "HLS/HLS.h"
#include "SynthesisScript/SynthesisScripts.h"
#include "VHDLWrapper/VHDLWrapperOneClkCycle.h"
#include "VHDLWrapper/VHDLWrapperMultiClkCycle.h"

using namespace SCAM::HLSPlugin;

std::map<std::string, std::string> PrintHLS::printModel(Model *model) {
    std::stringstream moduleNames;

    if (getOptionMap().at("occo")) {
        hlsOption = HLSOption::OCCO;
    } else if (getOptionMap().at("mcco")) {
        hlsOption = HLSOption::MCCO;
    } else {
        std::cout << "\x1B[31mNo HLS Option selected. Default Option is \"Multi Clock Cycle Operation!\"\033[0m\t\t" << std::endl;
        hlsOption = HLSOption::MCCO;
    }

    for (auto& module: model->getModules()) {
        std::string moduleName = module.first;
        auto currentModule = module.second;

        moduleNames << moduleName << "\n";

        auto propertySuiteHelper = std::make_shared<PropertySuiteHelper>(*module.second->getPropertySuite());
        auto optimizer = std::make_shared<OptimizerHLS>(propertySuiteHelper, module.second);

        if (hlsOption == HLSOption::OCCO) {
            auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperOneClkCycle>(currentModule, moduleName, propertySuiteHelper, optimizer);
            auto vhdlWrapperModel = vhdlWrapper->printModule();
            pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());
        } else {
            auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperMultiClkCycle>();
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