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

        void findFreezeVars(std::vector<const Operation2 *> cycle);

        const std::vector<std::vector<const Operation2 *>> &getCycleMap() const;

        const std::set<SCAM::SyncSignal *> &getSyncSignals() const;
        const std::set<SCAM::Variable *> &getVariables() const;
        const std::set<SCAM::DataSignal *> &getDataSignals() const;

        const std::map<SCAM::SyncSignal *, State2 *> &getSyncSignalTimepoints() const;
        const std::map<SCAM::Variable *, State2 *> &getVariablesTimepoints() const;
        const std::map<SCAM::DataSignal *, State2 *> &getDataSignalsTimepoints() const;


    private:
        const Module * module;

        std::vector<std::vector<const Operation2 *>> cycleMap;
        std::set<SCAM::SyncSignal*> syncSignals;
        std::map<SCAM::SyncSignal*,State2*> syncSignalTimepoints; //! Provides the timpoints at which the signal is freezed

        std::set<SCAM::Variable*> variables;
        std::map<SCAM::Variable*,State2*> variablesTimepoints; //! Provides the timpoints at which the signal is freezed

        std::set<SCAM::DataSignal*> dataSignals;
        std::map<SCAM::DataSignal*,State2*> dataSignalsTimepoints; //! Provides the timpoints at which the signal is freezed


        int loop_detection = 0;

        void findCylces(State2 *current, State2 *start, const std::vector<const Operation2 *> &opList);
        State2 * getStartState(const std::map<int,State2*>& stateMap) const;
        void setRightHook();
        bool isRequired2(Variable *const &var,const Operation2 * op, std::vector<const Operation2 *> &cycle);
        bool isRequired(Variable *var, const Operation2 * currentOperation, const std::vector<const Operation2 *> &cycle);

        std::string printCycles() const;


    };

}



#endif //DESCAM_TRUEOPERATION_H
