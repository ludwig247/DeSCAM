//
// Created by schauss on 10.02.20.
//

#include "PrintHLS.h"

using namespace SCAM::HLSPlugin;

PrintHLS::PrintHLS()
{
    if (getOptionMap().at("one_clk_cycle_op")) {
        hlsOption = HLS::HLSOption::OCCO;
    } else if (getOptionMap().at("multi_clk_cycle_op")) {
        hlsOption = HLS::HLSOption::MCCO;
    } else {
        std::cout << "\x1B[31mNo HLS Option selected. Default Option is \"Multi Clock Cycle Operation!\"\033[0m\t\t" << std::endl;
        hlsOption = HLS::HLSOption::MCCO;
    }
}

std::map<std::string, std::string> PrintHLS::printModel(Model *model) {
    auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapperOneClkCycle>();
    auto vhdlWrapperModel = vhdlWrapper->printModel(model);
    pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());

    auto hls = std::make_unique<HLS::HLS>(hlsOption);
    auto hlsModel = hls->printModel(model);
    pluginOutput.insert(hlsModel.begin(), hlsModel.end());

    auto synthesisScript = std::make_unique<Script::SynthesisScripts>(hls->getOptimizer());
    auto script = synthesisScript->printModel(model);
    pluginOutput.insert(script.begin(), script.end());

    return pluginOutput;
}