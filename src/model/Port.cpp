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

namespace SCAM {

    Port::~Port() {
    }

    Port::Port(const std::string &name, Interface *_interface, SCAM::DataType *datatype) :
            _interface(_interface),
            type(datatype),
            AbstractNode(name) {
        assert(_interface != nullptr);
        assert(datatype != nullptr);
        this->synchSignal = new SyncSignal(this);
        //TODO RIGHT PLACE?
        this->dataSignal = new DataSignal(this, datatype->getDefaultVal());

    }

    void Port::accept(AbstractVisitor &visitor) {
        visitor.visit(*this);
    }

    Interface *Port::getInterface() {
        return this->_interface;
    }

    SCAM::DataType *Port::getDataType() {
        return this->type;
    }

    SyncSignal *Port::getSynchSignal() const {
        return synchSignal;
    }

    DataSignal *Port::getDataSignal() const {
        return dataSignal;
    }


}
