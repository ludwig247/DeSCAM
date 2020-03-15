//
// Created by schauss on 10.02.20.
//

/* TODO:
- check Output Register (ex. Interconnect)
- VHDL Wrapper change from std_logic_vector and std_logic to unsigned, signed and boolean
- reserved names in VHDL (ex. Function0)
- constant outputs (ex. requestQ)
- array handling
- global functions and global variables handling
- add ReadMe
- SCO: reset to input
- SCO: script warning if initiation intervall > 1
- MCO: operation vector size (one operation, ex. Basic00)
- MCO: script set t_min, t_max, do not delete module in Wrapper
- MCO: internal register handling
*/

#include "PrintHLS.h"
#include "OptimizerHLS.h"
#include "HLS/HLS.h"
#include "SynthesisScript/SynthesisScripts.h"
#include "VHDLWrapper/VHDLWrapperOneClkCycle.h"
#include "VHDLWrapper/VHDLWrapperMultiClkCycle.h"

using namespace SCAM::HLSPlugin;

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
            auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperOneClkCycle>(currentModule, moduleName, propertySuiteHelper, optimizer);
            auto vhdlWrapperModel = vhdlWrapper->printModule();
            pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());
        } else {
            auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperMultiClkCycle>(currentModule, moduleName, propertySuiteHelper, optimizer);
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