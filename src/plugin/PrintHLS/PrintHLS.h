//
// Created by schauss on 10.02.20.
//

/* TODO:
- ITL property checking std_logic_vector to unsigned and signed [Bug]
- reserved names in VHDL (ex. record for Function0) [Bug]
- array handling [Feature]
- global functions and global variables handling [Feature]
- reset to input [Bug]
- check Output Register (ex. Interconnect) [Bug]
*/

#ifndef DESCAM_PRINTHLS_H
#define DESCAM_PRINTHLS_H

#include <map>

#include "Common/Constants.h"
#include "PluginFactory.h"

class PrintHLS : public PluginFactory {
public:
    PrintHLS() = default;
    ~PrintHLS() = default;

    std::map<std::string, std::string> printModel(Model* model) override;

private:
    using hlsOptionEnum = DESCAM::HLSPlugin::HLSOption;

    hlsOptionEnum hlsOption = hlsOptionEnum::MCO;;
};


#endif //DESCAM_PRINTHLS_H
