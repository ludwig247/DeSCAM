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

    private:
        const Module * module;
        //std::map<int,State2*> stateMap;
        std::vector<std::vector<const Operation2 *>> cycleMap;
        int loop_detection = 0;

        void findCylces(State2 *current, State2 *start, const std::vector<const Operation2 *> &opList);
        State2 * getStartState(const std::map<int,State2*>& stateMap) const;
        void setRightHook();

        std::string printCycles() const;

        std::string printProperty(Property *property);

        void createPropertySuite();
    };

}



#endif //DESCAM_TRUEOPERATION_H
