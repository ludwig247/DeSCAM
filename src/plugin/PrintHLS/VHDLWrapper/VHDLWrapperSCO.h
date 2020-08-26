//
// Created by johannes on 02.11.19.
//

#ifndef SCAM_PRINTVHDLFORHLS_H
#define SCAM_PRINTVHDLFORHLS_H

#include <memory>
#include <string>

#include "PluginFactory.h"
#include "SignalFactory.h"
#include "VHDLWrapper.h"

namespace DESCAM { namespace HLSPlugin { namespace VHDLWrapper {

        class VHDLWrapperSCO : public VHDLWrapper {

        public:
            VHDLWrapperSCO(
                    Module* module,
                    const std::string &moduleName,
                    std::shared_ptr<PropertySuite> propertySuite,
                    std::shared_ptr<OptimizerHLS>& optimizer
            );
            ~VHDLWrapperSCO() = default;

            std::map<std::string, std::string> printModule() override ;

        private:

            void entity(std::stringstream& ss) override ;
            void signals(std::stringstream& ss) override ;
            void component(std::stringstream& ss) override ;
            void componentInst(std::stringstream& ss) override ;
            void monitor(std::stringstream& ss) override ;
            void moduleOutputHandling(std::stringstream& ss) override ;
            void controlProcess(std::stringstream& ss) override ;

            bool emptyModule();
        };

}}}

#endif //SCAM_PRINTVHDLFORHLS_H
