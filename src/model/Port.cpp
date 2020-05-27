//
// Created by ludwig on 10.09.15.
//

#include <DataTypes.h>
#include "Port.h"
#include <Stmts/SyncSignal.h>
#include <DataSignal.h>
#include <Stmts/EnumValue.h>
#include <Stmts/BoolValue.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/Notify.h>
#include "DescamException.h"

namespace DESCAM {

    Port::~Port() {
    }

    Port::Port(const std::string &name, Interface *_interface, DESCAM::DataType *datatype, LocationInfo locationInfo) :
            _interface(_interface),
            TypeInterface(datatype),
            notify(new Notify(this)),
            AbstractNode(name,locationInfo) {
        if(!_interface)  throw DescamException("Interface of port '" + name + "' is null",locationInfo);
        if(!datatype)  throw DescamException("datatype of port '" + name + "' is null",locationInfo);

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


}
