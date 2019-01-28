//
// Created by ludwig on 10.11.16.
//

#include <assert.h>
#include "DataSignal.h"

SCAM::DataSignal::DataSignal(SCAM::Port *port, const ConstValue *initvalue) :
        port(port),
        subSig(false),
        dataType(port->getDataType()),
        initialValue(initvalue),
        AbstractNode(port->getName() + "_sig") {
    assert(initialValue != nullptr);
    if (initvalue->getDataType() != port->getDataType()) throw std::runtime_error("DataSignal Constructor, the initial value does not match the compound data type");
    if (port->getDataType()->isCompoundType()) {
        for (auto &&subvar : port->getDataType()->getSubVarMap()) {
            subSigList.push_back(new DataSignal(subvar.first, subvar.second, this, port));
        }
    }

}

SCAM::DataSignal::DataSignal(std::string name, SCAM::DataType *type, DataSignal *parent, Port *port) :
        port(port),
        subSig(parent != nullptr),
        parent(parent),
        dataType(type),
        AbstractNode(name) {
    //not explicit init value, use default init values
    initialValue = type->getDefaultVal();
    if (type->isCompoundType()) {
        //if compound type (all data (and initial values of those) in sub-variables
        //we do not allow sub-variables to be compound (allow only one level nesting)
        throw std::runtime_error("Datasignal Constructor, a compound sub-signal is not allowed");
    }

}


bool SCAM::DataSignal::isSubSig() const {
    return subSig;
}

SCAM::Port *SCAM::DataSignal::getPort() const {
    return port;
}



SCAM::DataType *SCAM::DataSignal::getDataType() {
    return dataType;
}

const std::vector<SCAM::DataSignal *> &SCAM::DataSignal::getSubSigList() const {
    return subSigList;
}

SCAM::DataSignal *SCAM::DataSignal::getParent() const {
    return parent;
}


bool SCAM::DataSignal::isCompoundType() {
    return port->getDataType()->isCompoundType();
}

SCAM::DataSignal *SCAM::DataSignal::getSubSig(const std::string &n) {
    if (!this->isCompoundType())  throw std::runtime_error("Variable getSubVar, called for a non-compound variable");

    for (auto &&subSig : subSigList) {
        if (subSig->getName() == n) {
            return subSig;
        }
    }
    throw std::runtime_error("Variable getSubVar called with \"" + n + "\", not a sub-variable name");
}

const SCAM::ConstValue *SCAM::DataSignal::getInitialValue() const {
    return nullptr;
}

std::string SCAM::DataSignal::getFullName() const {
    if(this->isSubSig()){
        return this->parent->getName() + "." + this->getName();
    }return this->getName();
}

void SCAM::DataSignal::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}
