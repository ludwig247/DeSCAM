//
// Created by johannes on 02.11.19.
//

#ifndef SCAM_VHDLWrapperMultiClkCycle_H
#define SCAM_VHDLWrapperMultiClkCycle_H

#include <memory>
#include <string>

#include "PluginFactory.h"
#include "SignalFactory.h"
#include "VHDLWrapper.h"

namespace DESCAM { namespace HLSPlugin { namespace VHDLWrapper {

        class VHDLWrapperMCO : public VHDLWrapper {

        public:
            VHDLWrapperMCO(
                    Module* module,
                    const std::string &moduleName,
                    std::shared_ptr<PropertySuiteHelper>& propertySuiteHelper,
                    std::shared_ptr<OptimizerHLS>& optimizer
            );
            ~VHDLWrapperMCO() = default;

            std::map<std::string, std::string> printModule() override ;

        private:
            std::string operationEnum() override ;

            void entity(std::stringstream& ss) override ;
            void signals(std::stringstream& ss) override ;
            void component(std::stringstream& ss) override ;
            void componentInst(std::stringstream& ss) override ;
            void monitor(std::stringstream& ss) override ;
            void moduleOutputHandling(std::stringstream& ss) override ;
            void controlProcess(std::stringstream& ss) override ;
        };

}}}

#endif //SCAM_VHDLWrapperMultiClkCycle_H
