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
#include "VHDLWrapper.h"

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

        class VHDLWrapperOneClkCycle : public VHDLWrapper {

        public:
            VHDLWrapperOneClkCycle() = default;
            ~VHDLWrapperOneClkCycle() = default;

            std::map<std::string, std::string> printModule(Module* module, const std::string &moduleName) override ;

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

#endif //SCAM_PRINTVHDLFORHLS_H
