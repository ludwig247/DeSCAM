//
// Created by tobias on 20.09.17.
//

#ifndef PROJECT_OPTIMIZEMASTER_H
#define PROJECT_OPTIMIZEMASTER_H

#include <operationGraph/State.h>
#include <set>
#include "Path.h"
#include "toPPA/ValuePropagation.h"
#include "CleanUpPaths.h"
#include "toPPA/ConditionOptimizer.h"
#include "toPPA/DataPathOptimizer.h"
#include "ExprVisitor.h"


namespace SCAM{
    class OptimizeMaster {
    public:
        OptimizeMaster(const std::map<int, State *>& stateMap, Module *module, const std::map<Operation *, SCAM::Path *>& operationPathMap);

        const std::map<int, State *> &getNewStateMap() const;
        const std::map<Operation *, Path *> &getOperationPathMap() const;

    private:
        std::map<int, State *> newStateMap;
        std::map<Operation *, SCAM::Path *> operationPathMap;
        Module * module;
        std::set<Operation*> opertations_for_deleting;
        std::vector<std::pair<Path*,std::pair<State*, State *> > > addOperations;

        //AlwaysReady Output
        bool isBlockingForwards(SCAM::State *current, SCAM::State *start, std::set<State *> visited);
        bool isBlockingBackwards(SCAM::State * current,SCAM::State * start,std::set<State*> visited);

        SCAM::State *findNextStateToRemove();

        //Both
        void mergeOperations(SCAM::State * state);
        void cleanUpStateMap(State *state);

        void simplify();

    };
}



#endif //PROJECT_OPTIMIZEMASTER_H
