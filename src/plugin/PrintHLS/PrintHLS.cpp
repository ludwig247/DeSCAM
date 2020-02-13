//
// Created by schauss on 10.02.20.
//

#include "PrintHLS.h"

PrintHLS::PrintHLS() :
    hls(nullptr)
{
}

std::map<std::string, std::string> PrintHLS::printModel(Model *model) {
    hls = std::make_unique<HLSPlugin::HLSModel::HLS>();
    auto hlsModel = hls->printModel(model);
    pluginOutput.insert(hlsModel.begin(), hlsModel.end());

    vhdlWrapper = std::make_unique<VHDLWrapper>();
    auto vhdlWrapperModel = vhdlWrapper->printModel(model);
    pluginOutput.insert(vhdlWrapperModel.begin(), vhdlWrapperModel.end());

    return pluginOutput;
}
