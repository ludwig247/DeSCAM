//
// Created by deutschmann on 30.10.18.
//

#include "Property.h"

#include <utility>
#include <Behavior/Operation2.h>

namespace SCAM {

    // ------------------------------------------------------------------------------
    //                                Constructor
    // ------------------------------------------------------------------------------

    Property::Property(std::string name, const SCAM::Operation2 * operation) :
            name(std::move(name)),
            operation(operation){
            assert(operation != nullptr && "Passing an operation that is null");
    }


    // ------------------------------------------------------------------------------
    //                              Name-Functions
    // ------------------------------------------------------------------------------

    const std::string &Property::getName() const {
        return name;
    }

    // ------------------------------------------------------------------------------
    //                           Constraint-Functions
    // ------------------------------------------------------------------------------

    void Property::addConstraint(PropertyConstraint * constraint){
        this->constraints.push_back(constraint);
    }

    const std::vector<PropertyConstraint *> &Property::getConstraints() const {
        return constraints;
    }

    // ------------------------------------------------------------------------------
    //                          Time Point-Functions
    // ------------------------------------------------------------------------------

    void Property::addTimePoint(TimeExpr* timePoint, Expr* expr) {
        this->timePoints.insert(std::make_pair(timePoint, expr));
    }

    const std::map<TimeExpr *, Expr *> &Property::getTimePoints() const {
        return timePoints;
    }

    // ------------------------------------------------------------------------------
    //                            Freeze-Functions
    // ------------------------------------------------------------------------------

    void Property::addFreezeSignal(SCAM::PropertyMacro *freezeSignal, TimeExpr* timePoint) {
        this->freezeSignals.insert(std::make_pair(freezeSignal, timePoint));
    }

    const std::map<PropertyMacro *, TimeExpr *,pointer_comparator<PropertyMacro*>> &Property::getFreezeSignals() const {
        return freezeSignals;
    }

    // ------------------------------------------------------------------------------
    //                            Assumption-Functions
    // ------------------------------------------------------------------------------

    void Property::addAssumption(TemporalExpr* assumption) {
        this->assumptionList.push_back(assumption);
    }

    const std::vector<TemporalExpr *> &Property::getAssumptionList() const {
        return assumptionList;
    }

    // ------------------------------------------------------------------------------
    //                            Commitment-Functions
    // ------------------------------------------------------------------------------

    void Property::addCommitment(TemporalExpr* commitment) {
        this->commitmentList.push_back(commitment);
    }

    const std::vector<SCAM::TemporalExpr*> &Property::getCommitmentList() const {
        return commitmentList;
    }

    const Operation2 *Property::getOperation() const {
        return operation;
    }

}