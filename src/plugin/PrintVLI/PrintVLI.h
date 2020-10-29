//
// Created by santana on 19.05.2020.
//

#ifndef SCAM_PRINTVLI_H
#define SCAM_PRINTVLI_H

#include <functional>
#include <sstream>

#include "Model.h"

#include "CommandLineParameter.h"
#include "ConditionVisitorVLI.h"
#include "DatapathVisitorVLI.h"
#include "PluginFactory.h"
#include "TimePointVisitorVLI.h"


class PrintVLI : public PluginFactory {

public:
    PrintVLI();
    ~PrintVLI() = default;

    std::map<std::string, std::string> printModel(Model *node);
    std::map<std::string, std::string> printModule(SCAM::Module *node);

    std::string print();

private:

    std::string functions();
    std::string globalFunctions();

    std::string convertDataType(std::string dataTypeName);
    std::string convertDataTypeForHLS(std::string dataTypeName);

    std::string location(bool loc);

    std::string printTemporalExpr(TemporalExpr* temporalExpr);

    std::string printProperty(Property* property);

    std::string macros();
    std::string macrosForHLS();
    std::string operations();

    SCAM::Module *module = nullptr;
    Model *model = nullptr;

    std::function<std::string()> macroFunction;
};


#endif //SCAM_PRINTVLI_H
