//
// Created by tobias on 04.11.16.
//

#ifndef SCAM_SYNCH_H
#define SCAM_SYNCH_H


#include "PortOperand.h"

namespace SCAM {

    class SyncSignal : public Expr {
    public:
        SyncSignal(SCAM::Port *port);
        SyncSignal(std::string name);

        Port *getPort() const;
        std::string getPortname();

        virtual void accept(StmtAbstractVisitor &visitor);

        virtual bool operator==(const Stmt &other) const;

    private:
        Port *port;
        std::string portname;
    };


}

#endif //SCAM_SYNCH_H
