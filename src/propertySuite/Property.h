//
// Created by deutschmann on 30.10.18.
//

#ifndef PROJECT_ABSTRACTPROPERTY_H
#define PROJECT_ABSTRACTPROPERTY_H

#include <string>

#include "TemporalExpr.h"
#include "PropertyMacro.h"
#include "PropertyConstraint.h"

namespace SCAM {
    template< typename T >
    class pointer_comparator : public std::binary_function< T, T, bool >
    {
    public :
        bool operator()( T x, T y ) const { return *x < *y; }
    };

    class Property {

    public:

        // Constructor
        explicit Property(std::string name);

        // Name
        const std::string &getName() const;

        // Constraints
        void addConstraint(PropertyConstraint * constraint);
        const std::vector<PropertyConstraint *> &getConstraints() const;

        // Time Points
        void addTimePoint(TimeExpr* timePoint, Expr* expr);
        const std::map<TimeExpr *, Expr *> &getTimePoints() const;

        // Freeze Signals
        void addFreezeSignal(PropertyMacro* freezeSignal, TimeExpr* timePoint);
        const std::map<PropertyMacro *, TimeExpr *,pointer_comparator<PropertyMacro*>> &getFreezeSignals() const;

        // Assumptions
        void addAssumption(TemporalExpr* assumption);
        const std::vector<TemporalExpr*> &getAssumptionList() const;

        // Commitments
        void addCommitment(TemporalExpr* commitment);
        const std::vector<TemporalExpr*> &getCommitmentList() const;

    private:

        const std::string name;

        std::vector<PropertyConstraint*> constraints;

        std::map<TimeExpr*, Expr*> timePoints;

        std::map<PropertyMacro*, TimeExpr*,pointer_comparator<PropertyMacro*>> freezeSignals;

        std::vector<TemporalExpr*> assumptionList;

        std::vector<TemporalExpr*> commitmentList;

    };

}

#endif //PROJECT_ABSTRACTPROPERTY_H
