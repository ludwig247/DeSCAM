//
// Created by pmorku on 7/29/18.
//

#ifndef PROJECT_OTHERUTILS_H
#define PROJECT_OTHERUTILS_H

#include <string>

#include "DataType.h"

namespace SCAM { namespace VHDL{

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

    class OtherUtils {
    public:
        static bool isPowerOfTwo(long int n);

        static int bitPosition(long int n);

        static std::string typeToString(StmtType type);
        static std::string subTypeBitwiseToString(SubTypeBitwise type);
        static std::string convertDataType(const std::string& type);
        static std::string getEnumAsVector(const DataType *dataType);
        static SubTypeBitwise getSubTypeBitwise(const std::string &name);
    };

} }

#endif //PROJECT_OTHERUTILS_H
