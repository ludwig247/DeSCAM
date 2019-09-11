//
// Created by aashildl on 03.04.19.
//

#ifndef PROJECT_PRINTSKELETONSV_H
#define PROJECT_PRINTSKELETONSV_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"

/*
 * Translates a model into a SystemVerilog template
 */
    class PrintSkeletonSV : public PluginFactory {
    public:
        PrintSkeletonSV() = default;

        ~PrintSkeletonSV() = default;

        std::map<std::string, std::string> printModel(Model *node);
    private:
        std::stringstream ss;

        ////////////////
        std::string Text_types(std::string Name);

        std::string header(std::string Name);

        std::string entities(Module *node);

        std::string architecture_synch(Module *node);

        std::string convert_to_lower(std::string in_string);

        int get_log_2(int arraySize);
    };

#endif //PROJECT_PRINTSKELETONSV_H
