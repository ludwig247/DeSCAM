//
// Created by pmorku on 7/29/18.
//

#ifndef PROJECT_OTHERUTILS_H
#define PROJECT_OTHERUTILS_H

#include <string>
#include <set>

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
        static std::string convertDataTypeConstrained(std::string dataTypeName);
        static std::string getEnumAsVector(const DataType *dataType);
        static SubTypeBitwise getSubTypeBitwise(const std::string &name);

        template <typename Key, typename Value>
        static std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);

        template<typename T>
        static std::vector<T *> getSubVars(const std::set<T *> &vars);
    };

        template<typename Key, typename Value>
        std::map<Key *, Value *> OtherUtils::getSubVarMap(const std::map<Key *, Value *> map) {
            std::vector<Key* > keys;
            for (const auto& var : map) {
                if (var.first->isCompoundType()) {
                    for (const auto& subVar : var.first->getSubVarList()) {
                        keys.push_back(subVar);
                    }
                } else {
                    keys.push_back(var.first);
                }
            }
            std::vector<Value* > values;
            for (const auto& var : map) {
                if (var.second->isCompoundType()) {
                    for (const auto& subVar : var.second->getSubVarList()) {
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

        template<typename T>
        std::vector<T *> OtherUtils::getSubVars(const std::set<T *> &vars) {
            std::vector<T *> subVarSet;
            for (const auto& var : vars) {
                if (var->isCompoundType()) {
                    for (const auto& subVar : var->getSubVarList()) {
                        subVarSet.push_back(subVar);
                    }
                } else {
                    subVarSet.push_back(var);
                }
            }
            return subVarSet;
        }

} }

#endif //PROJECT_OTHERUTILS_H
