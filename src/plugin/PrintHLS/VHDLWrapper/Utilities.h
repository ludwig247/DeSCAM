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
#include "Variable.h"

namespace DESCAM {
    namespace HLSPlugin {
        namespace VHDLWrapper {

            class Utilities {

            public:

                static bool isPowerOfTwo(long unsigned n);

                static unsigned int firstSetBitIndex(long unsigned int n);

                static std::string intToBinary(unsigned int n, unsigned int size);

                static std::string typeToString(StmtType type);

                static std::string subTypeBitwiseToString(SubTypeBitwise type);

                static SubTypeBitwise getSubTypeBitwise(const std::string &name);

                template<typename T>
                static std::string getFullName(T *variable, const std::string &delimiter);

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

            template<typename T>
            std::string Utilities::getFullName(T *variable, const std::string &delimiter) {
                if (variable->isSubVar()) {
                    return (variable->getParent()->getName() + delimiter + variable->getName());
                }
                return variable->getName();
            }

        }
    }
}

#endif //PROJECT_Utilities_H
