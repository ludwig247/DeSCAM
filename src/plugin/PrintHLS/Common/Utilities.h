//
// Created by Deutschmann on 18.09.20.
//

#ifndef DESCAM_UTILITIES_H
#define DESCAM_UTILITIES_H

#include <set>
#include <string>

#include "Constants.h"
#include "Variable.h"

namespace DESCAM {
    namespace HLSPlugin {

        class Utilities {

        public:

            static bool isPowerOfTwo(unsigned int n);

            static unsigned int firstSetBitIndex(unsigned int n);

            static std::pair<const unsigned int, const unsigned int> findBlockOfSetBits(unsigned int value);

            static std::string intToBinary(unsigned int n, unsigned int size);

            static std::string convertDataType(const std::string &type);

            static SubTypeBitwise getSubTypeBitwise(const std::string &name);

            template<typename Key, typename Value>
            static std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);

            template<typename T>
            static std::set<T *> getSubVars(const std::set<T *> &vars);

            template<typename T>
            static std::set<T *> getParents(const std::set<T *> &subVars);
        };

        template<typename T>
        std::set<T *> Utilities::getSubVars(const std::set<T *> &vars) {
            std::set<T *> subVarSet;
            for (const auto &var : vars) {
                if (var->isCompoundType()) {
                    for (const auto &subVar : var->getSubVarList()) {
                        subVarSet.insert(subVar);
                    }
                } else {
                    subVarSet.insert(var);
                }
            }
            return subVarSet;
        }

        template<typename T>
        std::set<T *> Utilities::getParents(const std::set<T *> &subVars) {
            std::set<T *> parents;
            for (const auto &var : subVars) {
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


    }
}

#endif //DESCAM_UTILITIES_H
