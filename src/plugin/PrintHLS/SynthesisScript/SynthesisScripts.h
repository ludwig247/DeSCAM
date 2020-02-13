//
// Created by johannes on 13.08.19.
//

#ifndef SCAM_PRINTSYNTHESISSCRIPTS_H
#define SCAM_PRINTSYNTHESISSCRIPTS_H

#include <memory>
#include <sstream>

#include "../HLS/Optimizer.h"
#include "PluginFactory.h"

namespace SCAM { namespace HLSPlugin { namespace Script {

            class SynthesisScripts : public PluginFactory {

            public:
                explicit SynthesisScripts(std::shared_ptr<HLS::Optimizer> opt);

                ~SynthesisScripts() = default;

                std::map<std::string, std::string> printModel(Model *node) override;

            private:
                PropertySuite *propertySuite;
                SCAM::Module *currentModule;
                std::shared_ptr<HLS::Optimizer> optimizer;

                std::string synthesisScript();
                std::string directivesScript();
                std::string setDirectivesReset();
                std::string setDirectiveInterface();
                std::string setDirectiveAllocation();
                std::string setDirectivePipeline();
            };

}}}

#endif //SCAM_PRINTSYNTHESISSCRIPTS_H
