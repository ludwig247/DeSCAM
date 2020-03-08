//
// Created by johannes on 13.02.20.
//

#ifndef DESCAM_VHDLWRAPPER_H
#define DESCAM_VHDLWRAPPER_H

#include <memory>
#include <string>

#include "OperationModuleInterface.h"
#include "../Common/PropertySuiteHelper.h"
#include "PluginFactory.h"
#include "SignalFactory.h"

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

            class VHDLWrapper {
            public:
                VHDLWrapper();
                ~VHDLWrapper() = default;

                virtual std::map<std::string, std::string> printModule(
                        Module* module,
                        const std::string &moduleName,
                        PropertySuiteHelper* property_suite_helper
                ) = 0 ;

            protected:
                PropertySuiteHelper* propertySuiteHelper;
                Module* currentModule;
                std::string moduleName;
                std::unique_ptr<OperationModuleInterface> hlsModule;
                std::unique_ptr<SignalFactory> signalFactory;
                std::map<std::string, std::string> pluginOutput;

                virtual std::string printTypes();
                virtual std::string operationEnum() = 0;
                virtual std::string printArchitecture();

                virtual void entity(std::stringstream& ss) = 0;
                virtual void signals(std::stringstream& ss) = 0;
                virtual void functions(std::stringstream& ss);
                virtual void component(std::stringstream& ss) = 0;
                virtual void componentInst(std::stringstream& ss) = 0;
                virtual void monitor(std::stringstream& ss) = 0;
                virtual void moduleOutputHandling(std::stringstream& ss) = 0;
                virtual void controlProcess(std::stringstream& ss) = 0;

                virtual std::string getResetValue(Variable* variable);
                virtual std::string getResetValue(DataSignal* dataSignal);
                virtual std::string printDataTypes(const DataType* dataType);
                virtual std::string sensitivityList();
            };

}}}

#endif //DESCAM_VHDLWRAPPER_H
