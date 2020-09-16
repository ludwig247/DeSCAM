//
// Created by deutschmann on 30.10.18.
//

#ifndef PROJECT_ABSTRACTPROPERTY_H
#define PROJECT_ABSTRACTPROPERTY_H

#include <string>

#include "PropertyMacro.h"
#include "PropertyConstraint.h"

namespace DESCAM {

    class AbstractProperty {

    public:

        // Constructor
        explicit AbstractProperty(const std::string &name);

        // Name
        const std::string &getName() const;

        // Constraints
        void addConstraint(PropertyConstraint * constraint);
        std::vector<PropertyConstraint *> getConstraints();
        //TODO: ADD FIND AND REMOVE FUNCTIONS

        // t_end
        unsigned int getT_end() const;
        void setT_end(unsigned int t_end);

        // States
        PropertyMacro *getState() const;
        PropertyMacro *getNextState() const;
        void setState(PropertyMacro *state);
        void setNextState(PropertyMacro *nextState);

        // Freeze/Hold Signals
        void addFreezeSignal(PropertyMacro* freezeSignal);
        const std::map<std::string, PropertyMacro*> &getFreezeSignals() const;
        void setFreezeSignals(const std::map<std::string, PropertyMacro*> &freezeSignals);
        //TODO: ADD FIND AND REMOVE FUNCTIONS


        // Assumptions
        void addAssumption(Expr * assumption);
        const std::vector<Expr *> &getAssumptionList() const;
        void setAssumptionList(const std::vector<Expr *> &assumptionList);

        // Commitments
        void addCommitment(Assignment* stmt);
        const std::vector<Assignment *> &getCommitmentList() const;
        void setCommitmentList(const std::vector<Assignment *> &commitmentList);

    private:

        const std::string name;
        PropertyMacro * state;
        PropertyMacro * nextState;
        unsigned int t_end;

        std::map<std::string, PropertyMacro*> freezeSignals;
        std::vector<Expr*> assumptionList;
        std::vector<Assignment*> commitmentList;

        std::vector<PropertyConstraint *> constraints;

    };

}

#endif //PROJECT_ABSTRACTPROPERTY_H
