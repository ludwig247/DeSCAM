//
// Created by tobias on 24.10.16.
//

#ifndef SCAM_ENUMVALUE_H
#define SCAM_ENUMVALUE_H

#include <DataType.h>
#include "ConstValue.h"

namespace DESCAM {
    class EnumValue : public ConstValue {
    public:
        EnumValue(std::string enumValue, const DataType *enumType, LocationInfo stmtLocationInfo = LocationInfo());

        //GETTER
        const std::string &getEnumValue() const;

        std::string getValueAsString() const override;

        //VISITOR
        void accept(StmtAbstractVisitor &visitor) override;

        bool operator==(const Stmt &other) const override;

    private:
        std::string enumValue;

    };
}


#endif //SCAM_ENUMVALUE_H
