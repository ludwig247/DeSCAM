//
// Created by johannes on 29.11.19.
//

#ifndef DESCAM_UTILITIES_H
#define DESCAM_UTILITIES_H

#include <string>

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

class Utilities {

public:
    static std::string typeToString(StmtType type);
    static std::string subTypeBitwiseToString(SubTypeBitwise type);
    static std::string convertDataType(const std::string& type);
    static SubTypeBitwise getSubTypeBitwise(const std::string &name);
};


#endif //DESCAM_UTILITIES_H
