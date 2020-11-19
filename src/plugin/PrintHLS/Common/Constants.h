//
// Created by johannes on 08.03.20.
//

#ifndef DESCAM_CONSTANTS_H
#define DESCAM_CONSTANTS_H

namespace DESCAM {
    namespace HLSPlugin {

        enum class HLSOption {
            SCO,   // Single Cycle Operations
            MCO    // Multi Clock Cycle Operations
        };

        enum class Side {
            UNKNOWN,
            LHS,
            RHS
        };

        enum class StmtType {
            UNKNOWN, ARITHMETIC, RELATIONAL, LOGICAL, BITWISE, VARIABLE_OPERAND, DATA_SIGNAL_OPERAND, ENUM_VALUE,
            UNARY_EXPR, INTEGER_VALUE, UNSIGNED_VALUE, ARRAY_OPERAND, PARAM_OPERAND, ASSIGNMENT
        };

        enum class SubTypeBitwise {
            UNKNOWN, BITWISE_AND, BITWISE_OR, BITWISE_XOR, LEFT_SHIFT, RIGHT_SHIFT
        };

    }
}

#endif //DESCAM_CONSTANTS_H
