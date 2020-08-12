//
// Created by johannes on 13.02.20.
//

#ifndef DESCAM_VHDLWRAPPER_H
#define DESCAM_VHDLWRAPPER_H

#include <memory>
#include <string>

#include "PropertySuiteHelper.h"
#include "OptimizerHLS.h"
#include "PluginFactory.h"
#include "SignalFactory.h"

namespace DESCAM { namespace HLSPlugin { namespace VHDLWrapper {

            class VHDLWrapper {
            public:
                VHDLWrapper() = default;
                ~VHDLWrapper() = default;

                virtual std::map<std::string, std::string> printModule() = 0 ;

            protected:
                std::shared_ptr<PropertySuiteHelper> propertySuiteHelper;
                Module* currentModule;
                std::string moduleName;
                std::shared_ptr<OptimizerHLS> optimizer;
                std::unique_ptr<SignalFactory> signalFactory;
                std::string operationEnum();

                virtual std::string printTypes();
                virtual std::string printArchitecture();

                virtual void entity(std::stringstream &ss) = 0;
                virtual void signals(std::stringstream &ss) = 0;
                virtual void functions(std::stringstream &ss);
                virtual void component(std::stringstream &ss) = 0;
                virtual void componentInst(std::stringstream &ss) = 0;
                virtual void monitor(std::stringstream &ss) = 0;
                virtual void moduleOutputHandling(std::stringstream &ss) = 0;
                virtual void controlProcess(std::stringstream &ss) = 0;
                virtual void printConstantOutputs(std::stringstream &ss);

                virtual std::string getResetValue(Variable *variable);
                virtual std::string getResetValue(DataSignal *dataSignal);
                virtual std::string printDataTypes(const DataType *dataType);
                virtual std::string sensitivityList();
            };

}}}

#endif //DESCAM_VHDLWRAPPER_H
