//
// Created by schauss on 10.02.20.
//

#include "PrintHLS.h"

PrintHLS::PrintHLS() :
    hls(nullptr)
{
}

std::map<std::string, std::string> PrintHLS::printModel(Model *model) {
//    hls = std::make_unique<MainHLS>();
    auto scripts = hls->printModel(model);
    pluginOutput.insert(scripts.begin(), scripts.end());

    return pluginOutput;
}
