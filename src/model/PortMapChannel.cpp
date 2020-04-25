//
// Created by schmitz on 25.04.20.
//

#include "PortMapChannel.h"
#include "Port.h"
#include "ModuleInstance.h"

namespace SCAM {

    PortMapChannel::PortMapChannel(std::string name) :
            lowerPort(nullptr),
            higherPort(nullptr),
            AbstractNode(name) {

    }

    PortMapChannel::~PortMapChannel() {

    }

    void PortMapChannel::accept(AbstractVisitor &visitor) {
        visitor.visit(*this);
    }

    Port *PortMapChannel::getLowerPort() {
        return this->lowerPort;

    }

    Port *PortMapChannel::getHigherPort() {
        return this->higherPort;
    }

    void PortMapChannel::setHigherPort(SCAM::Port *port) {
        if (!port) throw std::runtime_error("setHigherPort: Port is null");
        if (this->higherPort != nullptr) {
            throw "Channel::setFromPort(Port *port): port already set";
        }
        this->higherPort = port;

    }

    void PortMapChannel::setLowerPort(Port *port) {
        if (!port) throw std::runtime_error("setToPort: Port is null");
        if (this->lowerPort != nullptr) {
            throw "Channel::setToPort(Port *port): port already set";
        }
        this->lowerPort = port;
    }


    ModuleInstance *PortMapChannel::getHigherInstance() {
        return this->higherInstance;
    }

    ModuleInstance *PortMapChannel::getLowerInstance() {
        return this->lowerInstance;
    }

    ModuleInstance *PortMapChannel::getParentInstance() {
        return this->parentInstance;
    }

    void PortMapChannel::setLowerInstance(ModuleInstance *instance) {
        this->lowerInstance = instance;

    }

    void PortMapChannel::setHigherInstance(ModuleInstance *instance) {
        this->higherInstance = instance;

    }

    void PortMapChannel::setParentInstance(SCAM::ModuleInstance *instance) {
        this->parentInstance = instance;

    }

    std::string PortMapChannel::getType() {
        return this->type;
    }

    void PortMapChannel::setType(std::string Type) {
        this->type = Type;
    }

}
