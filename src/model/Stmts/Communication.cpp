//
// Created by tobias on 05.11.16.
//


#include "Communication.h"

DESCAM::Communication::Communication(Port *port, bool is_non_blocking_access) :
        port(port),
        is_non_blocking_access(is_non_blocking_access) {

}

bool DESCAM::Communication::isRead() const {
    return port->getInterface()->getDirection() == "in";
}

bool DESCAM::Communication::isWrite() const {
    return port->getInterface()->getDirection() == "out";
}

bool DESCAM::Communication::isBlocking() const {
    return port->getInterface()->getName() == "blocking";
}

DESCAM::Port *DESCAM::Communication::getPort() const {
    return port;
}

bool DESCAM::Communication::isShared() const {
    return port->getInterface()->getName() == "shared";
}

bool DESCAM::Communication::isMaster() const {
    return port->getInterface()->getName() == "master";
}


bool DESCAM::Communication::isSlave() const {
    return port->getInterface()->getName() == "slave";
}

bool DESCAM::Communication::isNonBlockingAccess() const {
    return is_non_blocking_access;
}

const std::string &DESCAM::Communication::getStateName() const {
    return stateName;
}

void DESCAM::Communication::setStateName(const std::string &stateName) {
    Communication::stateName = stateName;
}
