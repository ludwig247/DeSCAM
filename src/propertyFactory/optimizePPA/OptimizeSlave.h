//
// Created by tobias on 20.09.17.
//

#ifndef PROJECT_OPTZIMIZESLAVE_H
#define PROJECT_OPTZIMIZESLAVE_H

#include <operationGraph/State.h>
#include <set>
#include "Path.h"
#include "toPPA/ValuePropagation.h"
#include "CleanUpPaths.h"
#include "toPPA/ConditionOptimizer.h"
#include "toPPA/DataPathOptimizer.h"
#include "ExprVisitor.h"

namespace SCAM {
    class OptimizeSlave {
    public:
        OptimizeSlave(const std::map<int, State *>& stateMap, Module *module, const std::map<Operation *, SCAM::Path *>& operationPathMap);

        const std::map<int, State *> &getNewStateMap() const;

    private:
        std::map<int, State *> newStateMap;
        std::map<Operation *, SCAM::Path *> operationPathMap;
        Module * module;

        //Sanity checks
        bool sequenceCheck(State *current, State *start, std::set<State *> visitedStates, std::set<Port *> visitedPorts);
        bool allSlavesUsed() const ;
        bool checkModuleIO() const ;
        bool isEverySequenceCorrect(const std::vector<std::vector<SCAM::State *>> &sequenceList) const;
        bool isSlave() const;

        //Input sequences
        std::vector<std::vector<SCAM::State *>> findInputSequences();
        void mergeSequences(const std::vector<std::vector<SCAM::State *>> &sequenceList);
        SCAM::Port * findSlavePort(SCAM::State *state) const;
        void mergeStateIntoNextstate(State *pState);

        //Cleaning up
        void cleanUp(const std::set<SCAM::Operation *> &opertations_for_deleting,
                                          const std::vector<std::pair<SCAM::Path *, std::pair<SCAM::State *, SCAM::State *>>> &addOperations);
        void cleanUpStateMap();
    };
}

#endif //PROJECT_OPTZIMIZESLAVE_H
