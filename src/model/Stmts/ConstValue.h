//
// Created by ludwig on 04.11.15.
//

#ifndef SCAM_CONSTVALUE_H
#define SCAM_CONSTVALUE_H

#include "Expr.h"

namespace SCAM {

    class ConstValue : public Expr {
    public:
        ConstValue(const DataType *dataType);

        virtual std::string getValueAsString() const = 0;

        // Serialization
        friend class Serializer;

    };
}


#endif //SCAM_CONSTVALUE_H
