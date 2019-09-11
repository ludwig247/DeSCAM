//
// Created by deutschmann on 30.10.18.
//

#include "AbstractProperty.h"

namespace SCAM {

    // ------------------------------------------------------------------------------
    //                                Constructor
    // ------------------------------------------------------------------------------

    AbstractProperty::AbstractProperty(const std::string &name) :
            name(name),
            t_end(1){}


    // ------------------------------------------------------------------------------
    //                              Name-Functions
    // ------------------------------------------------------------------------------

    const std::string &AbstractProperty::getName() const {
        return name;
    }

    // ------------------------------------------------------------------------------
    //                           Constraint-Functions
    // ------------------------------------------------------------------------------

    void AbstractProperty::addConstraint(PropertyConstraint * constraint){
        this->constraints.push_back(constraint);
    }

    std::vector<PropertyConstraint *> AbstractProperty::getConstraints(){
        return this->constraints;
    }

    // ------------------------------------------------------------------------------
    //                             t_end-Functions
    // ------------------------------------------------------------------------------

    unsigned int AbstractProperty::getT_end() const {
        return t_end;
    }

    void AbstractProperty::setT_end(unsigned int t_end) {
        AbstractProperty::t_end = t_end;
    }

    // ------------------------------------------------------------------------------
    //                             State-Functions
    // ------------------------------------------------------------------------------

    PropertyMacro * AbstractProperty::getState() const {
        return state;
    }

    void AbstractProperty::setState(PropertyMacro *currentState) {
        AbstractProperty::state = currentState;
    }

    PropertyMacro *AbstractProperty::getNextState() const {
        return nextState;
    }

    void AbstractProperty::setNextState(PropertyMacro *nextState) {
        AbstractProperty::nextState = nextState;
    }

    // ------------------------------------------------------------------------------
    //                            Freeze-Functions
    // ------------------------------------------------------------------------------

    void AbstractProperty::addFreezeSignal(SCAM::PropertyMacro *freezeSignal) {
        if (freezeSignal->isCompoundType()) {
            this->freezeSignals[freezeSignal->getName()+"_"+freezeSignal->getSubVarName()] = freezeSignal;
        } else {
            this->freezeSignals[freezeSignal->getName()] = freezeSignal;
        }
    }

    const std::map<std::string, SCAM::PropertyMacro*> &AbstractProperty::getFreezeSignals() const {
        return freezeSignals;
    }

    void AbstractProperty::setFreezeSignals(const std::map<std::string, SCAM::PropertyMacro *> &freezeSignals) {
        this->freezeSignals = freezeSignals;
    }

    // ------------------------------------------------------------------------------
    //                            Assumption-Functions
    // ------------------------------------------------------------------------------

    void AbstractProperty::addAssumption(Expr *assumption) {
        this->assumptionList.push_back(assumption);
    }

    const std::vector<SCAM::Expr *> &AbstractProperty::getAssumptionList() const {
        return assumptionList;
    }

    void AbstractProperty::setAssumptionList(const std::vector<Expr *> &assumptionList) {
        this->assumptionList = assumptionList;
    }

    // ------------------------------------------------------------------------------
    //                            Commitment-Functions
    // ------------------------------------------------------------------------------

    void AbstractProperty::addCommitment(SCAM::Assignment *stmt) {
        this->commitmentList.push_back(stmt);
    }

    const std::vector<SCAM::Assignment *> &AbstractProperty::getCommitmentList() const {
        return commitmentList;
    }

    void AbstractProperty::setCommitmentList(const std::vector<Assignment *> &commitmentList) {
        this->commitmentList = commitmentList;
    }


}