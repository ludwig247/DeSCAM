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
                    std::shared_ptr<PropertySuite> propertySuite,
                    std::shared_ptr<OptimizerHLS>& optimizer
            );
            ~VHDLWrapperMCO() = default;

        private:

            void signals(std::stringstream& ss) override ;
            void component(std::stringstream& ss) override ;
            void componentInst(std::stringstream& ss) override ;
            std::string printMonitorOperation(const Operation &op) override;
            void moduleOutputHandling(std::stringstream& ss) override ;
            void controlProcess(std::stringstream& ss) override ;
        };

}}}

#endif //SCAM_VHDLWrapperMultiClkCycle_H
