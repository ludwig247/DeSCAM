//
// Created by johannes on 13.08.19.
//

#ifndef SCAM_PRINTSYNTHESISSCRIPTS_H
#define SCAM_PRINTSYNTHESISSCRIPTS_H

#include <memory>
#include <sstream>

#include "OptimizerHLS.h"
#include "Constants.h"
#include "PluginFactory.h"

namespace SCAM { namespace HLSPlugin { namespace Script {

            class SynthesisScripts {

            public:
                SynthesisScripts(std::shared_ptr<OptimizerHLS> opt, HLSOption hlsOption);

                ~SynthesisScripts() = default;

                std::map<std::string, std::string> printModule(Module* module, const std::string &moduleName);

            private:
                std::shared_ptr<PropertySuite> propertySuite;
                SCAM::Module *currentModule;
                std::string moduleName;
                std::shared_ptr<OptimizerHLS> optimizer;
                HLSOption hlsOption;

                std::string synthesisScript();
                std::string directivesScript();
                std::string setDirectiveInterfaceNone();
                std::string setDirectiveInterfaceHS();
                std::string setDirectiveAllocation();
            };

}}}

#endif //SCAM_PRINTSYNTHESISSCRIPTS_H
