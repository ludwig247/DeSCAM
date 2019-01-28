//
// Created by ludwig on 10.09.15.
//

#include "Channel.h"
#include "Port.h"
#include "ModuleInstance.h"

namespace SCAM{

    Channel::Channel(std::string name):
            fromPort(nullptr),
            toPort(nullptr),
            AbstractNode(name) {

    }

    Channel::~Channel() {

    }

    void Channel::accept(AbstractVisitor &visitor) {
        visitor.visit(*this);
    }

    Port* Channel::getFromPort() {
        return this->fromPort;

    }

    Port* Channel::getToPort() {
        return this->toPort;
    }

    void Channel::setFromPort(Port* port) {
        if(!port) throw std::runtime_error("setFromPort: Port is null");
        if(this->fromPort != nullptr){
            throw "Channel::setFromPort(Port *port): port already set";
        }
        this->fromPort = port;

    }

    void Channel::setToPort(Port *port) {
        if(!port) throw std::runtime_error("setToPort: Port is null");
        if (this->toPort != nullptr) {
            throw "Channel::setToPort(Port *port): port already set";
        }
        this->toPort = port;
    }


    ModuleInstance* Channel::getFromInstance() {
        return this->fromInstance;
    }

    ModuleInstance *Channel::getToInstance() {
        return this->toInstance;
    }

    void Channel::setFromInstance(ModuleInstance *instance) {
        this->fromInstance = instance;

    }

    void Channel::setToInstance(ModuleInstance *instance) {
        this->toInstance = instance;

    }
}
