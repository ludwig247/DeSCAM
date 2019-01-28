//
// Created by ludwig on 27.10.16.
//

#ifndef SCAM_SYNTHESIZE_H
#define SCAM_SYNTHESIZE_H

#include <PluginFactory.h>
#include <sstream>
#include "Model.h"
#include <PropertyFactory.h>

    class PrintITL : public PluginFactory {

    public:
        PrintITL() = default;
        ~PrintITL() = default;

        std::map<std::string, std::string> printModel(Model *node);
        std::map<std::string, std::string> printModule(SCAM::Module *node);
        std::string print();

    private:
        std::stringstream ss;
        void optimizeCommunicationFSM();

        std::string signals();
        std::string constraints();
        std::string functions();
        std::string registers();
        std::string states();
        std::string operations();
        std::string reset_operation();
        std::string wait_operations();
        std::string convertDataType(std::string dataTypeName);
        std::string location(bool loc);
        SCAM::Module * module;

        std::set<Port*> usedPortsList;
        std::map<int, State *> stateMap;
        std::map<std::string ,SCAM::Variable*> stateVarMap;

        int getOpCnt(std::map<int, State *> stateMap);

    };



#endif //SCAM_SYNTHESIZE_H
