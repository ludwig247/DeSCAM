//
// Created by schauss on 10.02.20.
//

#include "PrintHLS.h"
#include "HLS/HLS.h"
#include "SynthesisScript/SynthesisScripts.h"
#include "VHDLWrapper/VHDLWrapperOneClkCycle.h"
#include "VHDLWrapper/VHDLWrapperMultiClkCycle.h"

using namespace SCAM::HLSPlugin;

PrintHLS::PrintHLS()
{
    if (getOptionMap().at("occo")) {
        hlsOption = HLS::HLSOption::OCCO;
    } else if (getOptionMap().at("mcco")) {
        hlsOption = HLS::HLSOption::MCCO;
    } else {
        std::cout << "\x1B[31mNo HLS Option selected. Default Option is \"Multi Clock Cycle Operation!\"\033[0m\t\t" << std::endl;
        hlsOption = HLS::HLSOption::MCCO;
    }
}

std::map<std::string, std::string> PrintHLS::printModel(Model *model) {
    if (hlsOption == HLS::HLSOption::OCCO) {
        auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperOneClkCycle>();
        auto vhdlWrapperModel = vhdlWrapper->printModel(model);
        pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());
    } else {
        auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperMultiClkCycle>();
        auto vhdlWrapperModel = vhdlWrapper->printModel(model);
        pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());
    }

    auto hls = std::make_unique<HLS::HLS>(hlsOption);
    auto hlsModel = hls->printModel(model);
    pluginOutput.insert(hlsModel.begin(), hlsModel.end());

    auto synthesisScript = std::make_unique<Script::SynthesisScripts>(hls->getOptimizer(), hlsOption);
    auto script = synthesisScript->printModel(model);
    pluginOutput.insert(script.begin(), script.end());

    return pluginOutput;
}