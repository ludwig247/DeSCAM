//
// Created by johannes on 29.11.19.
//

#ifndef DESCAM_UTILITIES_H
#define DESCAM_UTILITIES_H

#include <set>
#include <string>

namespace SCAM { namespace HLSPlugin { namespace HLS {

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

        template <typename T>
        static std::set<T *> getParents(const std::set<T *> &subVars);
    };

    template <typename T>
    std::set<T *> Utilities::getParents(const std::set<T *> &subVars) {
        std::set<T *> parents;
        for (const auto& var : subVars) {
            if (var->isSubVar()) {
                if (parents.find(var->getParent()) == parents.end()) {
                    parents.insert(var->getParent());
                }
            } else {
                if (parents.find(var) == parents.end()) {
                    parents.insert(var);
                }
            }
        }
        return parents;
    }

}}}

#endif //DESCAM_UTILITIES_H
