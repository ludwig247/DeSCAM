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
    PrintHLS();
    ~PrintHLS() = default;

    std::map<std::string, std::string> printModel(Model* model) override;

private:
    SCAM::HLSPlugin::HLS::HLSOption hlsOption;
};


#endif //DESCAM_PRINTHLS_H
