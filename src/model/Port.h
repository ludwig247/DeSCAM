//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_PORT_H
#define SCAM_PORT_H


#include "Interface.h"
#include "enums.h"
#include "DataType.h"
#include "TypeInterface.h"

namespace SCAM {

    class Module;

    class SyncSignal;

    class DataSignal;

    class Notify;

    class Port : public TypeInterface, public AbstractNode {
    public:
        Port(const std::string &name, Interface *_interface, DataType *datatype);

        Port() = delete;

        virtual ~Port();

        //Accept
        void accept(AbstractVisitor &visitor);

        //Get
        Notify *getNotify() const;

        Interface *getInterface();

        SyncSignal *getSynchSignal() const;

        DataSignal *getDataSignal() const;

    private:
        Interface *_interface; //! Interface of this port
        SyncSignal *synchSignal;
        DataSignal *dataSignal;
        Notify *notify;
    };

}


#endif //SCAM_PORT_H
