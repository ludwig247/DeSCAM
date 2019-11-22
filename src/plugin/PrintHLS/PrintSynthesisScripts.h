//
// Created by johannes on 13.08.19.
//

#ifndef SCAM_PRINTSYNTHESISSCRIPTS_H
#define SCAM_PRINTSYNTHESISSCRIPTS_H


#include <sstream>

#include <PluginFactory.h>



    class PrintSynthesisScripts : public PluginFactory {

    public:
        PrintSynthesisScripts();
        ~PrintSynthesisScripts() = default;

        std::map<std::string, std::string> printModel(Model *node) override ;

    private:
        PropertySuite *propertySuite;
        SCAM::Module* currentModule;

        std::string synthesisScript();
        std::string directivesScript();

        std::string setDirectivesReset();
        std::string setDirectiveInterface();
        std::string setDirectiveAllocation();
        std::string setDirectivePipeline();
    };

#endif //SCAM_PRINTSYNTHESISSCRIPTS_H
