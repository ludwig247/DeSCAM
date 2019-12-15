//
// Created by tobias on 05.11.16.
//

#ifndef SCAM_COMMUNICATION_H
#define SCAM_COMMUNICATION_H

#include "Expr.h"
#include "PortOperand.h"

namespace SCAM {

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

        const std::string &getStateName() const;
        void setStateName(const std::string &stateName);

    private:
        Port *port;
        bool is_non_blocking_access;

        std::string stateName = "";

    };


}
#endif //SCAM_COMMUNICATION_H
