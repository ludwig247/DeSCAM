//
// Created by tobias on 06.11.15.
//

#ifndef SCAM_BOOLVALUE_H
#define SCAM_BOOLVALUE_H

#include "ConstValue.h"

namespace DESCAM {

    class BoolValue : public ConstValue {
    public:
        explicit BoolValue(bool value, LocationInfo stmtLocationInfo = LocationInfo());

        //GETTER
        bool getValue();

        std::string getValueAsString() const override;

        //ACCEPT
        void accept(StmtAbstractVisitor &visitor) override;

        bool operator==(const Stmt &other) const override;

    private:
        bool value;
    };

}


#endif //SCAM_BOOLVALUE_H
