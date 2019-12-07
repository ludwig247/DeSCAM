//
// Created by johannes on 02.11.19.
//

#ifndef SCAM_PRINTVHDLFORHLS_H
#define SCAM_PRINTVHDLFORHLS_H

#include <string>
#include <memory>

#include "PluginFactory.h"
#include "SignalFactoryNew.h"
#include "HLSmodule.h"

class PrintVHDLForHLS : public PluginFactory{

public:
    PrintVHDLForHLS();
    ~PrintVHDLForHLS() = default;

    std::map<std::string, std::string> printModel(Model *model) override ;

private:
    PropertySuite *propertySuite;
    Module *currentModule;
    std::unique_ptr<HLSmodule> hlsModule;
    std::unique_ptr<SignalFactoryNew> signalFactoryNew;

    std::string printTypes(Model *model);
    std::string printModule(Model *model);
    void entity(std::stringstream &ss);
    void signals(std::stringstream &ss);
    void monitor(std::stringstream &ss);
    void functions(std::stringstream &ss);
    std::string printDataTypes(const DataType *dataType);
    std::string printSensitivityList();
};


#endif //SCAM_PRINTVHDLFORHLS_H
