#include "Utilities.h"
#include <cassert>
#include <algorithm>

using namespace DESCAM::HLSPlugin;

/*
 * Returns True, if the given number n is a power of two
 */
bool Utilities::isPowerOfTwo(unsigned int n) {
    return !((n < 1) || (n & (n - 1)));
}

/*
 * Returns the index of the foremost set bit in a given number n
 *
 * If no bit is set (n = 0), zero is returned
 */
unsigned int Utilities::firstSetBitIndex(unsigned int n) {
    unsigned int count = 0;
    while (n > 1) {
        count++;
        n >>= 1u;
    }
    return count;
}

/*
 * Checks if the given value consists of a single block of set bits
 *
 * The function returns the indices of the found block, e.g.
 * "0001 1100" -> (4, 2)
 * If no block is found, (0, 1) is returned
 */
std::pair<const unsigned int, const unsigned int> Utilities::findBlockOfSetBits(unsigned int value) {

    if (value == 0) {
        return std::make_pair(0, 1);
    }

    auto rightIndex = 0;
    while ((value % 2) == 0) {
        rightIndex++;
        value >>= 1u;
    }

    if (isPowerOfTwo(value + 1)) {
        auto leftIndex = firstSetBitIndex(value);
        return std::make_pair(leftIndex, rightIndex);
    } else {
        return std::make_pair(0, 1);
    }

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

std::string Utilities::convertDataType(const std::string &type) {
    if (type == "int") {
        return "ap_int<32>";
    } else if (type == "unsigned") {
        return "ap_uint<32>";
    } else {
        return type;
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
