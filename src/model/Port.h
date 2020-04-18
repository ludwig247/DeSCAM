//
// Created by ludwig on 10.09.15.
//

#ifndef SCAM_PORT_H
#define SCAM_PORT_H


#include "Interface.h"
#include "enums.h"
#include "DataType.h"
#include "TypeInterface.h"
#include "Channel.h"

namespace SCAM {

    class Module;

    class SyncSignal;

    class DataSignal;

    class Notify;

    class Port : public TypeInterface, public AbstractNode {
    public:
        Port(const std::string &name, Interface *_interface, DataType *datatype);
        Port() = delete;
        Port(Port&)= delete;

        ~Port() override ;

        //Accept
        void accept(AbstractVisitor &visitor) override ;

        //Get
        Notify *getNotify() const;

        Interface *getInterface();

        SyncSignal *getSynchSignal() const;

        DataSignal *getDataSignal() const;

        Channel *getChannel() const;

        void setChannel(Channel * setchannel);

    private:
        Interface *_interface; //! Interface of this port
        SyncSignal *synchSignal;
        DataSignal *dataSignal;
        Notify *notify;
        Channel* channel;

    };

}


#endif //SCAM_PORT_H
