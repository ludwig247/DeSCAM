//
// Created by schauss on 10.02.20.
//

#include "PrintHLS.h"

using namespace SCAM::HLSPlugin;

std::map<std::string, std::string> PrintHLS::printModel(Model *model) {
    auto vhdlWrapper = std::make_unique<VHDLWrapper::VHDLWrapper>();
    auto vhdlWrapperModel = vhdlWrapper->printModel(model);
    pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());

    auto hls = std::make_unique<HLS::HLS>();
    auto hlsModel = hls->printModel(model);
    pluginOutput.insert(hlsModel.begin(), hlsModel.end());

    auto synthesisScript = std::make_unique<Script::SynthesisScripts>(hls->getOptimizer());
    auto script = synthesisScript->printModel(model);
    pluginOutput.insert(script.begin(), script.end());

    return pluginOutput;
}
