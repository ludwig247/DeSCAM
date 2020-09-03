#include "Utilities.h"
#include <cassert>
#include <algorithm>

using namespace DESCAM::HLSPlugin::VHDLWrapper;

/*
 * Returns True, if the given number n is a power of two
 */
bool Utilities::isPowerOfTwo(long unsigned int n) {
    return !((n < 1) || (n & (n - 1)));
}

/*
 * Returns the index of the foremost set bit in a given number n
 *
 * If no bit is set (n = 0), zero is returned
 */
unsigned int Utilities::firstSetBitIndex(long unsigned int n) {
    unsigned int count = 0;
    while (n > 1) {
        count++;
        n >>= 1u;
    }
    return count;
}

/*
 * Converts the given number n to a binary string with leading zeros
 */
std::string Utilities::intToBinary(unsigned int n, unsigned int size) {

    // Assert that the given number can be displayed in size bits
    assert(size > firstSetBitIndex(n));

    std::string res;
    for (int i = 0; i < size; i++) {
        res += std::to_string(n % 2);
        n = n / 2;
    }
    std::reverse(res.begin(), res.end());
    return res;
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

DESCAM::HLSPlugin::SubTypeBitwise Utilities::getSubTypeBitwise(const std::string &name) {
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

template<typename Key, typename Value>
std::map<Key *, Value *> Utilities::getSubVarMap(const std::map<Key *, Value *> map) {
    std::vector<Key *> keys;
    for (const auto &var : map) {
        if (var.first->isCompoundType()) {
            for (const auto &subVar : var.first->getSubVarList()) {
                keys.push_back(subVar);
            }
        } else {
            keys.push_back(var.first);
        }
    }
    std::vector<Value *> values;
    for (const auto &var : map) {
        if (var.second->isCompoundType()) {
            for (const auto &subVar : var.second->getSubVarList()) {
                values.push_back(subVar);
            }
        } else {
            values.push_back(var.second);
        }
    }
    std::map<Key *, Value *> subVarMap;
    for (std::size_t it = 0; it < keys.size(); ++it) {
        subVarMap.insert({keys.at(it), values.at(it)});
    }
    return subVarMap;
}
