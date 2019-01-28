//
// Created by ludwig on 19.01.18.
//

#ifndef PROJECT_UNSIGNEDINT_H
#define PROJECT_UNSIGNEDINT_H


#include "ConstValue.h"

namespace SCAM{
    class UnsignedValue: public ConstValue {
    public:
        UnsignedValue(unsigned int value);
        unsigned int getValue();

        virtual std::string getValueAsString() const override;

        virtual void accept(StmtAbstractVisitor &visitor) override;

        virtual bool operator==(const Stmt &other) const override;


    private:
        unsigned int value;
    };
}


#endif //PROJECT_UNSIGNEDINT_H
