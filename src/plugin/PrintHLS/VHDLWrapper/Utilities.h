//
// Created by pmorku on 7/29/18.
//

#ifndef PROJECT_Utilities_H
#define PROJECT_Utilities_H

#include <set>
#include <string>

#include "Constants.h"
#include "DataSignal.h"
#include "DataType.h"

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper{

    class Utilities {
    public:
        static bool isPowerOfTwo(long int n);

        static int bitPosition(long int n);

        static std::string typeToString(StmtType type);
        static std::string subTypeBitwiseToString(SubTypeBitwise type);
        static SubTypeBitwise getSubTypeBitwise(const std::string &name);

        template <typename Key, typename Value>
        static std::map<Key *, Value *> getSubVarMap(std::map<Key *, Value *> map);

        template<typename T>
        static std::set<T *> getSubVars(const std::set<T *> &vars);

        template <typename T>
        static std::set<T *> getParents(const std::set<T *> &subVars);
    };

        template<typename Key, typename Value>
        std::map<Key *, Value *> Utilities::getSubVarMap(const std::map<Key *, Value *> map) {
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
        std::set<T *> Utilities::getSubVars(const std::set<T *> &vars) {
            std::set<T *> subVarSet;
            for (const auto& var : vars) {
                if (var->isCompoundType()) {
                    for (const auto& subVar : var->getSubVarList()) {
                        subVarSet.insert(subVar);
                    }
                } else {
                    subVarSet.insert(var);
                }
            }
            return subVarSet;
        }

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

} } }

#endif //PROJECT_Utilities_H
