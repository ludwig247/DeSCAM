//
// Created by johannes on 13.02.20.
//

#ifndef DESCAM_VHDLWRAPPER_H
#define DESCAM_VHDLWRAPPER_H

#include <memory>
#include <string>

#include "PropertySuite.h"
#include "OptimizerHLS.h"
#include "PluginFactory.h"
#include "SignalFactory.h"

namespace DESCAM { namespace HLSPlugin { namespace VHDLWrapper {

            class VHDLWrapper {
            public:
                VHDLWrapper() = default;
                ~VHDLWrapper() = default;

                std::map<std::string, std::string> printModule();

            protected:

                std::shared_ptr<PropertySuite> propertySuite;
                Module* currentModule;
                std::string moduleName;
                std::shared_ptr<OptimizerHLS> optimizer;
                std::unique_ptr<SignalFactory> signalFactory;

                // Print functions for VHDL type package
                std::string printTypes();
                void operationEnum(std::stringstream &ss);
                std::string printDataTypes(const DataType *dataType);

                // Print functions for VHDL wrapper
                std::string printArchitecture();
                void entity(std::stringstream &ss);
                void functions(std::stringstream &ss);
                void printConstantOutputs(std::stringstream &ss);

                std::string sensitivityList();
                std::string getResetValue(Variable *variable);
                std::string getResetValue(DataSignal *dataSignal);

                virtual void signals(std::stringstream &ss) = 0;
                virtual void component(std::stringstream &ss) = 0;
                virtual void componentInst(std::stringstream &ss) = 0;
                virtual void monitor(std::stringstream &ss) = 0;
                virtual void moduleOutputHandling(std::stringstream &ss) = 0;
                virtual void controlProcess(std::stringstream &ss) = 0;
            };

}}}

#endif //DESCAM_VHDLWRAPPER_H
