//
// Created by johannes on 02.11.19.
//

#ifndef SCAM_PRINTVHDLFORHLS_H
#define SCAM_PRINTVHDLFORHLS_H

#include <memory>
#include <string>

#include "OperationModuleInterface.h"
#include "PluginFactory.h"
#include "SignalFactory.h"

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

        class VHDLWrapperOneClkCycle : public PluginFactory {

        public:
            VHDLWrapperOneClkCycle();
            ~VHDLWrapperOneClkCycle() = default;

            std::map<std::string, std::string> printModel(Model* model) override;

        private:
            PropertySuite* propertySuite;
            Module* currentModule;
            std::unique_ptr<OperationModuleInterface> hlsModule;
            std::unique_ptr<SignalFactory> signalFactory;

            std::string printTypes(Model* model);
            std::string printModule(Model* model);

            void entity(std::stringstream& ss);
            void signals(std::stringstream& ss);
            void functions(std::stringstream& ss);
            void component(std::stringstream& ss);
            void componentInst(std::stringstream& ss);
            void monitor(std::stringstream& ss);
            void moduleOutputHandling(std::stringstream& ss);
            void controlProcess(std::stringstream& ss);

            std::string getResetValue(Variable* variable);
            std::string getResetValue(DataSignal* dataSignal);
            std::string printDataTypes(const DataType* dataType);
            std::string sensitivityList();
        };

}}}

#endif //SCAM_PRINTVHDLFORHLS_H
