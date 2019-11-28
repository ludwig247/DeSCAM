//
// Created by ludwig on 27.10.16.
//

#ifndef SCAM_SYNTHESIZE_H
#define SCAM_SYNTHESIZE_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
//#include <PropertyFactory.h>

enum ITLOption {
    STANDARD,
    ADJUSTMACROS,
    PIPELINED,
    HLS
};

class PrintITL : public PluginFactory {

public:
    PrintITL();

    ~PrintITL() = default;

    std::map<std::string, std::string> printModel(Model *node);

    std::map<std::string, std::string> printModule(SCAM::Module *node);

    std::string print();

private:
    std::stringstream ss;

    ITLOption usedITLOption;

    std::string functions();

    std::string convertDataType(std::string dataTypeName);

    std::string convertDataTypeForHLS(std::string dataTypeName);

    std::string location(bool loc);

    std::string propertySuite();

    std::string adjustmacros();

    std::string pipelined();

    std::string hls();

    //        std::string hideConstants();
    SCAM::Module *module;

};


#endif //SCAM_SYNTHESIZE_H
