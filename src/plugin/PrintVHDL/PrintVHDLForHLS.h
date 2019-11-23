//
// Created by johannes on 02.11.19.
//

#ifndef SCAM_PRINTVHDLFORHLS_H
#define SCAM_PRINTVHDLFORHLS_H

#include <string>
#include <memory>

#include "PrintHLS/Utilities.h"
#include "PluginFactory.h"
#include "SignalFactory.h"

class PrintVHDLForHLS : public PluginFactory{

public:
    PrintVHDLForHLS();
    ~PrintVHDLForHLS() = default;

    std::map<std::string, std::string> printModel(Model *model) override ;

private:
    PropertySuite *propertySuite;
    Module *currentModule;
    std::unique_ptr<Utilities> utils;
    std::unique_ptr<SignalFactory> signalFactory;

    std::string printTypes(Model *model);
    std::string printModule(Model *model);
    std::string functions();
    std::string printDataTypes(const DataType *dataType);
    std::string convertDataTypeConstrained(std::string dataTypeName);
    std::string convertDataType(std::string dataTypeName);
    std::string printSensitivityList();
};


#endif //SCAM_PRINTVHDLFORHLS_H
