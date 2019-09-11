//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_INTEGEROPERATOR_H
#define SCAM_INTEGEROPERATOR_H

#include "ConstValue.h"

namespace SCAM{
    class
    IntegerValue: public ConstValue {
    public:
        IntegerValue(int value);
        int getValue();

        virtual std::string getValueAsString() const override;

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        int value;
    };
}


#endif //SCAM_INTEGEROPERATOR_H
