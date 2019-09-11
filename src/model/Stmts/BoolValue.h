//
// Created by tobias on 06.11.15.
//

#ifndef SCAM_BOOLVALUE_H
#define SCAM_BOOLVALUE_H

#include "ConstValue.h"

namespace SCAM{

    class BoolValue : public ConstValue {
    public:
        BoolValue(bool value);
        //GETTER
        bool getValue();

        virtual std::string getValueAsString() const override;

        //ACCEPT
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        bool value;
    };

}


#endif //SCAM_BOOLVALUE_H
