//
// Created by johannes on 13.02.20.
//

#ifndef DESCAM_VHDLWRAPPER_H
#define DESCAM_VHDLWRAPPER_H

#include <memory>
#include <string>

#include "OperationModuleInterface.h"
#include "PluginFactory.h"
#include "SignalFactory.h"

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

            class VHDLWrapper : PluginFactory {
            public:
                VHDLWrapper();
                ~VHDLWrapper() = default;

                virtual std::map<std::string, std::string> printModel(Model* model) override;

            protected:
                PropertySuite* propertySuite;
                Module* currentModule;
                std::unique_ptr<OperationModuleInterface> hlsModule;
                std::unique_ptr<SignalFactory> signalFactory;

                virtual std::string printTypes(Model* model);
                virtual std::string printModule(Model* model);

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
