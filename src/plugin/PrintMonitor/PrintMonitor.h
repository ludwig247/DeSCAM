//
// Created by tobias on 15.03.18.
//

#ifndef PROJECT_PRINTMONITOR_H
#define PROJECT_PRINTMONITOR_H

#include <sstream>
#include "Model.h"

namespace SCAM{

    class PrintMonitor {
    public:
        PrintMonitor(Module * module);
        virtual ~PrintMonitor();

        std::string print();
    private:
        Module * module;
        int opcnt = 0;
        std::vector<std::string> csm_states;
        std::vector<Operation*> operations;
        std::map<int, State *> stateMap;
        std::map<std::string ,SCAM::Variable*> stateVarMap;
        std::stringstream ss;

        std::string printAssumptions(const std::vector<Expr*>& exprList);
        std::string monitor();
        std::string monitor_pkg(Module * module);

        void optimize();
    };

}

#endif //PROJECT_PRINTMONITOR_H
