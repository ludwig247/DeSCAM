//
// Created by tobias on 15.03.18.
//

#ifndef PROJECT_PRINTMONITOR_H
#define PROJECT_PRINTMONITOR_H

#include <sstream>
#include "Model.h"

namespace DESCAM {

    class PrintMonitor {
    public:
        PrintMonitor(Module *module);

        virtual ~PrintMonitor();

        std::string print();

    private:
        Module *module;
        int opcnt = 0;
        std::vector<std::string> csm_states;
        std::vector<Operation2 *> operations;
        std::map<int, State2 *> stateMap;
        std::map<std::string, DESCAM::Variable *> stateVarMap;
        std::stringstream ss;

        std::string printAssumptions(const std::vector<Expr *> &exprList);

        std::string monitor();

        std::string monitor_pkg(Module *module);

        void optimize();
    };

}

#endif //PROJECT_PRINTMONITOR_H
