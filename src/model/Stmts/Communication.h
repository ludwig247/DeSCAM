//
// Created by tobias on 05.11.16.
//

#ifndef SCAM_COMMUNICATION_H
#define SCAM_COMMUNICATION_H

#include "Expr.h"
#include "PortOperand.h"

namespace SCAM{

class Communication {
public:
    Communication(Port *port, bool is_non_bocking_access);

    Port *getPort() const;

    bool isRead() const;

    bool isWrite() const;

    bool isBlocking() const;

    bool isShared() const;

    bool isMaster() const;

    bool isSlave() const;

    bool isNonBlockingAccess() const;

private:
    Port* port;
    bool is_non_blocking_access;

};


}
#endif //SCAM_COMMUNICATION_H
