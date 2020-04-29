//
// Created by tobias on 23.10.15.
//

#ifndef SCAM_OPERAND_H
#define SCAM_OPERAND_H

#include "Expr.h"

namespace SCAM {
    /**
     * \brief Abstract class that bundles member and const value
     */
    class Operand : public SCAM::Expr {
    public:
        Operand(const DataType *type, LocationInfo stmtLocationInfo = LocationInfo());

        virtual std::string getOperandName() const = 0;

    private:
    };
}


#endif //SCAM_OPERATOR_H
