//
// Created by schauss on 10.02.20.
//

#ifndef DESCAM_PRINTHLS_H
#define DESCAM_PRINTHLS_H

#include <map>

#include "HLS/Utilities.h"
#include "PluginFactory.h"

class PrintHLS : public PluginFactory {
public:
    PrintHLS() = default;
    ~PrintHLS() = default;

    std::map<std::string, std::string> printModel(Model* model) override;

private:
    using hlsOptionEnum = SCAM::HLSPlugin::HLS::HLSOption;

    SCAM::HLSPlugin::HLS::HLSOption hlsOption = hlsOptionEnum::MCCO;;
};


#endif //DESCAM_PRINTHLS_H
