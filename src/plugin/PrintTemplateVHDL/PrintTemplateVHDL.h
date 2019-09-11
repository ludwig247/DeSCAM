//
// Created by tobias on 13.02.17.
//

#ifndef PROJECT_PRINTTEMPLATEVHDL_H
#define PROJECT_PRINTTEMPLATEVHDL_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"

/*
 * Translates a model into a VHDL template
 */
using namespace SCAM;

    class PrintTemplateVHDL : public PluginFactory {
    public:
        PrintTemplateVHDL() = default;

        ~PrintTemplateVHDL() = default;

        std::map<std::string, std::string> printModel(Model *node);
    private:
        std::stringstream ss;

        ////////////////
        std::string Text_types(std::string Name);

        std::string header(std::string Name);

        std::string entities(Module *node);

        std::string architecture_synch(Module *node);
    };

#endif //PROJECT_PRINTTEMPLATEVHDL_H
