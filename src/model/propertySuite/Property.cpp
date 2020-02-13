//
// Created by deutschmann on 30.10.18.
//

#include "Property.h"

#include <utility>
#include <Behavior/Operation.h>

namespace SCAM {

    // ------------------------------------------------------------------------------
    //                                Constructor
    // ------------------------------------------------------------------------------

    Property::Property(std::string name, const SCAM::Operation * operation) :
            name(name){
            this->operationList.push_back(operation);
            assert(operation != nullptr && "Passing an operation that is null");
    }


    Property::Property(std::string name, std::vector<const SCAM::Operation *> operationList):
        name(name),
        operationList(operationList){
        assert(!operationList.empty() && "Passing an empty list of operations");
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

    void Property::addTimePoint(Timepoint* timePoint, Expr* expr) {
        this->timePoints.insert(std::make_pair(timePoint, expr));
        this->timePointsOrdered.emplace_back(std::make_pair(timePoint, expr));
    }

    const std::map<Timepoint *, Expr *> &Property::getTimePoints() const {
        return timePoints;
    }

    // ------------------------------------------------------------------------------
    //                            Freeze-Functions
    // ------------------------------------------------------------------------------

    void Property::addFreezeSignal(SCAM::PropertyMacro *freezeSignal, Timepoint* timePoint) {
        this->freezeSignals.insert(std::make_pair(freezeSignal, timePoint));
    }

    const std::map<PropertyMacro *, Timepoint *,pointer_comparator<PropertyMacro*>> &Property::getFreezeSignals() const {
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

    const Operation *Property::getOperation() const {
        if(operationList.size() > 1){
            throw std::runtime_error("Property is build from more then 1 operation. Please use getOperations()");
        }
        return operationList.front();
    }

    const std::vector<std::pair<Timepoint *, Expr *>> &Property::getTimePointsOrdered() const {
        return timePointsOrdered;
    }

}