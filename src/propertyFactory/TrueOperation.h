//
// Created by tobias on 31.01.20.
//

#ifndef DESCAM_TRUEOPERATION_H
#define DESCAM_TRUEOPERATION_H

#include <Module.h>

namespace SCAM{

    /*!
     * \brief Creates operations that span across multiple important state
     *
     * \details
     * All operations have to start in a specific starting state and end in the same state
     * In order to work with completeness the use may add a right_hook specifying the start of the next operation
     */
    class TrueOperation {
    public:
        TrueOperation() = delete;
        explicit  TrueOperation(const Module  *  module);
        ~TrueOperation() = default;

        void findFreezeVars(std::vector<const Operation *> cycle);

        const std::vector<std::vector<const Operation *>> &getCycleMap() const;

        const std::set<SCAM::SyncSignal *> &getSyncSignals() const;
        const std::set<SCAM::Variable *> &getVariables() const;
        const std::set<SCAM::DataSignal *> &getDataSignals() const;

        const std::map<SCAM::SyncSignal *, State *> &getSyncSignalTimepoints() const;
        const std::map<SCAM::Variable *, State *> &getVariablesTimepoints() const;
        const std::map<SCAM::DataSignal *, State *> &getDataSignalsTimepoints() const;

        static bool isRequired2(Variable *const &var,const Operation * op, std::vector<const Operation *> &cycle);
        static bool isRequired(Variable *var, const Operation * currentOperation, const std::vector<const Operation *> &cycle);
    private:
        const Module * module;

        std::vector<std::vector<const Operation *>> cycleMap;
        std::set<SCAM::SyncSignal*> syncSignals;
        std::map<SCAM::SyncSignal*,State*> syncSignalTimepoints; //! Provides the timpoints at which the signal is freezed

        std::set<SCAM::Variable*> variables;
        std::map<SCAM::Variable*,State*> variablesTimepoints; //! Provides the timpoints at which the signal is freezed

        std::set<SCAM::DataSignal*> dataSignals;
        std::map<SCAM::DataSignal*,State*> dataSignalsTimepoints; //! Provides the timpoints at which the signal is freezed


        int loop_detection = 0;

        void findCylces(State *current, State *start, const std::vector<const Operation *> &opList);
        State * getStartState(const std::map<int,State*>& stateMap) const;
        void setRightHook();


        std::string printCycles() const;


    };

}



#endif //DESCAM_TRUEOPERATION_H
