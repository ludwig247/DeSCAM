//
// Created by schauss on 10.02.20.
//

#ifndef DESCAM_PRINTHLS_H
#define DESCAM_PRINTHLS_H

#include <map>
#include <memory>

#include "PluginFactory.h"
#include "PrintHLS/HLS/MainHLS.h"

class PrintHLS : public PluginFactory {
public:
    PrintHLS();

    ~PrintHLS() = default;

    std::map<std::string, std::string> printModel(Model *model) override;

private:
    std::unique_ptr<MainHLS> hls;
};


#endif //DESCAM_PRINTHLS_H
