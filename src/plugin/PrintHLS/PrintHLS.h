//
// Created by schauss on 10.02.20.
//

#ifndef DESCAM_PRINTHLS_H
#define DESCAM_PRINTHLS_H

#include <map>
#include <memory>

#include "PluginFactory.h"

#include "HLS/HLS.h"
#include "VHDLWrapper/VHDLWrapper.h"
#include "SynthesisScript/SynthesisScripts.h"

class PrintHLS : public PluginFactory {
public:
    PrintHLS() = default;
    ~PrintHLS() = default;

    std::map<std::string, std::string> printModel(Model* model) override;
};


#endif //DESCAM_PRINTHLS_H
