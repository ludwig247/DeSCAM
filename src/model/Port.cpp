//
// Created by ludwig on 10.09.15.
//

#include <DataTypes.h>
#include "Port.h"
#include <Stmts/SyncSignal.h>
#include <DataSignal.h>
#include <assert.h>
#include <Stmts/EnumValue.h>
#include <Stmts/BoolValue.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/Notify.h>

namespace SCAM {

    Port::~Port() {
    }

    Port::Port(const std::string &name, Interface *_interface, SCAM::DataType *datatype) :
            _interface(_interface),
            TypeInterface(datatype),
            notify(new Notify(this)),
            channel(nullptr),
            AbstractNode(name) {
        assert(_interface != nullptr);
        assert(datatype != nullptr);

        //this->notify = new Notify(this);
        this->synchSignal = new SyncSignal(this);
        //TODO RIGHT PLACE?
        this->dataSignal = new DataSignal(this->getName() + "_sig", datatype, datatype->getDefaultVal(), nullptr, this);

    }

    void Port::accept(AbstractVisitor &visitor) {
        visitor.visit(*this);
    }

    Interface *Port::getInterface() {
        return this->_interface;
    }


    SyncSignal *Port::getSynchSignal() const {
        return synchSignal;
    }

    DataSignal *Port::getDataSignal() const {
        return dataSignal;
    }

    Notify *Port::getNotify() const {
        return notify;
    }

    Channel *Port::getChannel() const {
        return channel;
    }

    void Port::setChannel(Channel * setchannel) {
        channel = setchannel;
    }

    void Port::setMapped(bool mapped) {
        _mapped = mapped;
    }

    bool Port::getMapped() {
        return this->_mapped;
    }

}
