//
// Created by ludwig on 22.09.15.
//

#include "Interface.h"
#include "DescamException.h"

DESCAM::Interface::Interface() :
        _direction("UNKNOWN"),
        _interface("UNKNOWN"),
        AbstractNode("UNKNOWN") {
}

DESCAM::Interface::Interface(std::string interfaceName, std::string direction, LocationInfo locationInfo) :
        _direction(direction),
        _interface(interfaceName),
        AbstractNode(interfaceName,locationInfo) {
    if(!(_direction == "in" || direction == "out"))
        throw DescamException("Interface direction can only be either 'in' or 'out'",locationInfo);
    if(!(_interface == "blocking" || _interface == "shared" || _interface == "master" || _interface == "slave")){
        throw DescamException("Interface can only be 'blocking', 'shared', 'master, or 'slave'",locationInfo);
    }
}

DESCAM::Interface::~Interface() {

}

void DESCAM::Interface::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string DESCAM::Interface::getDirection() {
    return this->_direction;
}

bool DESCAM::Interface::isMasterIn() const {
    if (this->_interface == "master" && this->_direction == "in") return true;
    return false;
}

bool DESCAM::Interface::isMasterOut() const {
    if (this->_interface == "master" && this->_direction == "out") return true;
    return false;
}

bool DESCAM::Interface::isShared() const {
    if (this->_interface == "shared") return true;
    return false;
}

bool DESCAM::Interface::isInput() const {
    return this->_direction == "in";
}

bool DESCAM::Interface::isOutput() const {
    return this->_direction == "out";
}

bool DESCAM::Interface::isSlaveIn() const {
    if (this->_interface == "slave" && this->_direction == "in") return true;
    return false;
}

bool DESCAM::Interface::isSlaveOut() const {
    if (this->_interface == "slave" && this->_direction == "out") return true;
    return false;
}

bool DESCAM::Interface::isSlave() const {
    return this->isSlaveOut() || this->isSlaveIn();
}

bool DESCAM::Interface::isMaster() const {
    return this->isMasterIn() || this->isMasterOut();
}

bool DESCAM::Interface::isBlocking() const {
    if (this->_interface == "blocking") return true;
    return false;
}

bool DESCAM::Interface::isBlockingIn() const {
    if (this->_interface == "blocking" && this->_direction == "in") return true;
    return false;
}

bool DESCAM::Interface::isBlockingOut() const {
    if (this->_interface == "blocking" && this->_direction == "out") return true;
    return false;
}
