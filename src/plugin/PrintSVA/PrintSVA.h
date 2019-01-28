//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#ifndef SCAM_PRINTSVA_H
#define SCAM_PRINTSVA_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include <PropertyFactory.h>

    class PrintSVA : public PluginFactory {

    public:
        PrintSVA() = default;
        ~PrintSVA() = default;

        std::map<std::string, std::string> printModel(Model *node);
    private:
        std::stringstream ss;

        ////////////////
        std::string Text_ipc();
        std::string Text_body();
        void optimizeCommunicationFSM();
        inline int getOpCnt(std::map<int, State *> stateMap);
        SCAM::Module *module;
        std::map<int, State *> stateMap;
        std::map<std::string ,SCAM::Variable*> stateVarMap;

        std::string functions();
        std::string signals();
        std::string registers();
        std::string states();
        std::string reset_sequence();
        std::string reset_operation();
        std::string operations();
        std::string wait_operations();
    };
#endif //SCAM_PRINTSVA_H
