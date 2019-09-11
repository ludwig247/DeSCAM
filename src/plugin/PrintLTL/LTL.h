//
// Created by anna on 06.07.18.
//

#ifndef PROJECT_LTL_H
#define PROJECT_LTL_H

#include <Module.h>

namespace SCAM{
    class LTL {

    public:
        LTL(SCAM::Module *module);
        void optimizeCommunicationFSM();
        std::string print();

    private:
        std::string reset_ltl();
        std::string wait_ltl();
        std::string run_ltl();
        std::string helper_ltl();

        SCAM::Module * module;

        std::map<int, State *> stateMap;
        std::map<std::string ,SCAM::Variable*> stateVarMap;

        int getOpCnt(std::map<int, State *> stateMap);
    };
}

#endif //PROJECT_LTL_H
