//
// Created by ludwig on 22.09.15.
//

#include <assert.h>
#include "Interface.h"

SCAM::Interface::Interface():
    _direction("UNKNOWN"),
    _interface("UNKNOWN"),
    AbstractNode("UNKNOWN"){
}

SCAM::Interface::Interface(std::string interfaceName, std::string direction):
    _direction(direction),
    _interface(interfaceName),
    AbstractNode(interfaceName){
    assert(_direction == "in" || direction == "out");
    assert(_interface == "blocking" || _interface == "shared" || _interface == "master" ||  _interface == "slave");
}

SCAM::Interface::~Interface() {

}

void SCAM::Interface::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);

}

std::string SCAM::Interface::getDirection() {
    return this->_direction;
}

bool SCAM::Interface::isMasterIn()const {
    if(this->_interface == "master" && this->_direction == "in") return true;
    return false;
}

bool SCAM::Interface::isMasterOut()const {
    if(this->_interface == "master" && this->_direction == "out") return true;
    return false;
}

bool SCAM::Interface::isShared() const {
    if(this->_interface == "shared") return true;
    return false;
}

bool SCAM::Interface::isInput() const {
    return this->_direction == "in";
}

bool SCAM::Interface::isOutput() const {
    return this->_direction == "out";
}

bool SCAM::Interface::isSlaveIn() const {
    if(this->_interface == "slave" && this->_direction == "in") return true;
    return false;
}

bool SCAM::Interface::isSlaveOut() const {
    if(this->_interface == "slave" && this->_direction == "out")  return true;
    return false;
}

bool SCAM::Interface::isSlave() const {
    return this->isSlaveOut() || this->isSlaveIn();
}

bool SCAM::Interface::isMaster() const {
    return this->isMasterIn() || this->isMasterOut();
}

bool SCAM::Interface::isBlocking() const {
    if(this->_interface == "blocking") return true;
    return false;
}

bool SCAM::Interface::isBlockingIn() const {
    if(this->_interface == "blocking" && this->_direction == "in") return true;
    return false;
}

bool SCAM::Interface::isBlockingOut() const {
    if(this->_interface == "blocking" && this->_direction == "out") return true;
    return false;
}
