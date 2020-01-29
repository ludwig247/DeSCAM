//
// Created by ludwig on 27.10.16.
//

#ifndef SCAM_SYNTHESIZE_H
#define SCAM_SYNTHESIZE_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
//#include <PropertyFactory.h>

class PrintITL : public PluginFactory {

public:
    PrintITL() = default;

    ~PrintITL() = default;

    std::map<std::string, std::string> printModel(Model *node);

    std::map<std::string, std::string> printModule(SCAM::Module *node);

    std::string print();

private:
    //std::stringstream ss;

    std::string functions();

    std::string convertDataType(std::string dataTypeName);

    std::string location(bool loc);

    std::string printTemporalExpr(TemporalExpr* temporalExpr);

    std::string printProperty(Property* property);

    std::string propertySuite();

    //std::string adjustmacros();

    //std::string pipelined();

//        std::string hideConstants();
    SCAM::Module *module;

};


#endif //SCAM_SYNTHESIZE_H
