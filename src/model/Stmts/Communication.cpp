//
// Created by tobias on 05.11.16.
//


#include "Communication.h"

SCAM::Communication::Communication(Port *port,bool is_non_blocking_access):
    port(port),
    is_non_blocking_access(is_non_blocking_access){

}

bool SCAM::Communication::isRead() const {
    return port->getInterface()->getDirection() == "in";
}

bool SCAM::Communication::isWrite() const {
    return port->getInterface()->getDirection() == "out";
}

bool SCAM::Communication::isBlocking() const {
    return port->getInterface()->getName() == "blocking";
}

SCAM::Port *SCAM::Communication::getPort() const {
    return port;
}

bool SCAM::Communication::isShared() const {
    return port->getInterface()->getName() == "shared";
}

bool SCAM::Communication::isMaster()  const {
    return port->getInterface()->getName() == "master";
}


bool SCAM::Communication::isSlave()  const {
    return port->getInterface()->getName() == "slave";
}

bool SCAM::Communication::isNonBlockingAccess() const {
    return is_non_blocking_access;
}