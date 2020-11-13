//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_INTEGEROPERATOR_H
#define SCAM_INTEGEROPERATOR_H

#include "ConstValue.h"

namespace DESCAM {
    class
    IntegerValue : public ConstValue {
    public:
        IntegerValue(int value, LocationInfo stmtLocationInfo = LocationInfo());

        int getValue();

        std::string getValueAsString() const override;

        void accept(StmtAbstractVisitor &visitor) override;

        bool operator==(const Stmt &other) const override;

    private:
        int value;
    };
}


#endif //SCAM_INTEGEROPERATOR_H
