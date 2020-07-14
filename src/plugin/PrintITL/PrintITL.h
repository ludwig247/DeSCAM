//
// Created by ludwig on 27.10.16.
//

#ifndef SCAM_SYNTHESIZE_H
#define SCAM_SYNTHESIZE_H

#include <functional>
#include <sstream>

#include "Model.h"
#include "CommandLineParameter.h"
#include "ConditionVisitor.h"
#include "DatapathVisitor.h"
#include "PluginFactory.h"
#include "TimePointVisitor.h"


class PrintITL : public PluginFactory {

public:
    PrintITL();
    ~PrintITL() = default;

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


#endif //SCAM_SYNTHESIZE_H
