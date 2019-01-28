//
// Created by tobias on 24.10.16.
//

#ifndef SCAM_ENUMVALUE_H
#define SCAM_ENUMVALUE_H

#include <DataType.h>
#include "ConstValue.h"

namespace SCAM {
    class EnumValue : public ConstValue {
    public:
        EnumValue(std::string enumValue,const DataType * enumType);

        //GETTER
        const std::string &getEnumValue() const;
        virtual std::string getValueAsString() const override;

        //VISITOR
        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        std::string enumValue;

    };
}


#endif //SCAM_ENUMVALUE_H
