//
// Created by johannes on 13.08.19.
//

#ifndef SCAM_PRINTSYNTHESISSCRIPTS_H
#define SCAM_PRINTSYNTHESISSCRIPTS_H

#include <memory>
#include <sstream>

#include "../HLS/Optimizer.h"
#include "../HLS/Utilities.h"
#include "PluginFactory.h"

namespace SCAM { namespace HLSPlugin { namespace Script {

            class SynthesisScripts : public PluginFactory {

            public:
                explicit SynthesisScripts(std::shared_ptr<HLS::Optimizer> opt, HLS::HLSOption hlsOption);

                ~SynthesisScripts() = default;

                std::map<std::string, std::string> printModel(Model *node) override;

            private:
                PropertySuite *propertySuite;
                SCAM::Module *currentModule;
                std::shared_ptr<HLS::Optimizer> optimizer;
                HLS::HLSOption hlsOption;

                std::string synthesisScript();
                std::string directivesScript();
                std::string setDirectiveInterfaceNone();
                std::string setDirectiveInterfaceHS();
                std::string setDirectiveAllocation();
            };

}}}

#endif //SCAM_PRINTSYNTHESISSCRIPTS_H
