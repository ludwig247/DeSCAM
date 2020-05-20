
//
// Created by wezel on 2/26/20.
//

#include "Protocol.h"

namespace SCAM {

    Protocol::Protocol  (std::string name):
            Module(name)
    {
    };



//    const std::map<std::string, Function *> &Protocol::getMethodMap() const {
//        return MethodMap;
//    }
//
//    void Protocol::addFunction(Function *function) {
//        this->MethodMap.insert(std::make_pair(function->getName(), function));
//    }
//
//    Function *Protocol::getMethod(std::string name) {
//        if (MethodMap.find(name) == MethodMap.end()) {
//            throw std::runtime_error("Function " + name + " is not part of module " + this->getName());
//        } else return MethodMap.find(name)->second;
//    }
//
//    void Protocol::accept(AbstractVisitor &visitor) {
//        visitor.visit(*this);
//    }
}