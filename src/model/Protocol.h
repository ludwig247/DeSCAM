//
// Created by wezel on 2/26/20.
//

#include <map>
#include "Module.h"

#ifndef DESCAM_PROTOCOL3_H
#define DESCAM_PROTOCOL3_H

#endif //DESCAM_PROTOCOL_H
namespace SCAM {
class Protocol : public SCAM::Module {
    public:
        Protocol() = default;
        explicit  Protocol(std::string name);
        ~Protocol() = default;
//
//        const std::map<std::string, Function *> &getMethodMap() const;
//        void addFunction(Function *function);
//        void accept(AbstractVisitor &visitor);
//        Function *getMethod(std::string name);

    private:
        //std::map<std::string, Function *> MethodMap;

    };
}