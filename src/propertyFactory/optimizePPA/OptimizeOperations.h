//
// Created by tobias on 26.10.17.
//

#ifndef PROJECT_OPTIMIZEOPERATIONS_H
#define PROJECT_OPTIMIZEOPERATIONS_H

#include <Module.h>

namespace  SCAM{
    class OptimizeOperations {
    public:
        OptimizeOperations(const std::map<int, State *> &stateMap, SCAM::Module *module);

        const std::map<int, State *> &getNewStateMap() const;
        const std::map<std::string, Variable *> &getStateVarMap() const;
        const std::map<std::string, Variable *> &getStateTopVarMap() const;


    private:
        std::map<Variable *, bool> removeVars;
        std::map<std::string, Variable*> stateVarMap;
        std::map<std::string, Variable*> stateTopVarMap;
        void removeVariables(); //! Finds all variable that are not necessary for the hardware properties
        std::map<int, State *> newStateMap;
        SCAM::Module * module;
    };
}



#endif //PROJECT_OPTIMIZEOPERATIONS_H
