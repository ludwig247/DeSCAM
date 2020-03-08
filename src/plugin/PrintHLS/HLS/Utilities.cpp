//
// Created by johannes on 29.11.19.
//

#include "Utilities.h"

using namespace SCAM::HLSPlugin::HLS;

std::string Utilities::convertDataType(const std::string& type) {
    if (type == "int") {
        return "ap_int<32>";
    } else if (type == "unsigned") {
        return "ap_uint<32>";
    } else {
        return type;
    }
}

std::string Utilities::typeToString(StmtType type) {
    switch (type) {
        case StmtType::ARITHMETIC:
            return "arithmetic";
        case StmtType::RELATIONAL:
            return "relational";
        case StmtType::LOGICAL:
            return "logical";
        case StmtType::BITWISE:
            return "bitwise";
        case StmtType::VARIABLE_OPERAND:
            return "variable operand";
        case StmtType::DATA_SIGNAL_OPERAND:
            return "data signal operand";
        case StmtType::ENUM_VALUE:
            return "enum value";
        case StmtType::UNARY_EXPR:
            return "unary expr";
        case StmtType::INTEGER_VALUE:
            return "integer value";
        case StmtType::UNSIGNED_VALUE:
            return "unsigned value";
        case StmtType::ARRAY_OPERAND:
            return "array operand";
        case StmtType::PARAM_OPERAND:
            return "param operand";
        case StmtType::ASSIGNMENT:
            return "assignment";
        case StmtType::UNKNOWN:
            return "unknown type";
    }
}

std::string Utilities::subTypeBitwiseToString(SubTypeBitwise type) {
    switch (type) {
        case SubTypeBitwise::BITWISE_AND:
            return "&";
        case SubTypeBitwise::BITWISE_OR:
            return "|";
        case SubTypeBitwise::BITWISE_XOR:
            return "^";
        case SubTypeBitwise::LEFT_SHIFT:
            return "<<";
        case SubTypeBitwise::RIGHT_SHIFT:
            return ">>";
        case SubTypeBitwise::UNKNOWN:
            return "unknown operation";
    }
}

SCAM::HLSPlugin::SubTypeBitwise Utilities::getSubTypeBitwise(const std::string &name) {
    if (name == "&") {
        return SubTypeBitwise::BITWISE_AND;
    } else if (name == "|") {
        return SubTypeBitwise::BITWISE_OR;
    } else if (name == "^") {
        return SubTypeBitwise::BITWISE_XOR;
    } else if (name == "<<") {
        return SubTypeBitwise::LEFT_SHIFT;
    } else if (name == ">>") {
        return SubTypeBitwise::RIGHT_SHIFT;
    } else {
        return SubTypeBitwise::UNKNOWN;
    }
}