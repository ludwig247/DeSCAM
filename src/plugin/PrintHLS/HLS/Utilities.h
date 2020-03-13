//
// Created by johannes on 29.11.19.
//

#ifndef DESCAM_UTILITIES_H
#define DESCAM_UTILITIES_H

#include <set>
#include <string>

#include "Variable.h"
#include "Constants.h"

namespace SCAM { namespace HLSPlugin { namespace HLS {

    class Utilities {

    public:
        static std::string typeToString(StmtType type);
        static std::string subTypeBitwiseToString(SubTypeBitwise type);
        static std::string convertDataType(const std::string& type);
        static SubTypeBitwise getSubTypeBitwise(const std::string &name);
        static std::string getFullName(Variable* variable, const std::string &delimiter);

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
