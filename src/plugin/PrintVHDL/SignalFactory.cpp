//
// Created by johannes on 21.11.19.
//

#include <cmath>

#include "SignalFactory.h"
#include "DataSignal.h"
#include "VHDLPrintVisitorHLS.h"

SignalFactory::SignalFactory(PropertySuite* propertySuite, Module* module) :
    propertySuite(propertySuite),
    module(module)
{
    setOperationSelector();
    setAllPorts();
    setMonitorSignals();
}

void SignalFactory::setOperationSelector() {
    uint32_t vectorSize = ceil(log2(propertySuite->getOperationProperties().size()));
    active_operation = {
            "active_operation",
            propertySuite->getName() + "_operation_t",
            "",
            "in",
            vectorSize,
            true
    };
}

Signal SignalFactory::getOperationSelector(bool asVector) {
    if (asVector) {
        uint32_t vectorSize = ceil(log2(propertySuite->getOperationProperties().size()));
        active_operation.type = "std_logic_vector(" + std::to_string(vectorSize - 1) + " downto 0)";
    } else {
        active_operation.type = propertySuite->getName() + "_operation_t";
    }
    return active_operation;
}

void SignalFactory::setAllPorts() {
    for (const auto& port : module->getPorts()) {
        if (port.second->getInterface()->isInput()) {
            inputs.push_back(port.second);
        } else {
            outputs.push_back(port.second);
        }
    }
    for (const auto& notifySig : propertySuite->getNotifySignals()) {
        notifys.push_back(notifySig);
    }
    for (const auto& syncSig : propertySuite->getSyncSignals()) {
        syncs.push_back((syncSig));
    }
}

void SignalFactory::setMonitorSignals() {
    monitorSignals.push_back({"active_state", propertySuite->getName() + "_state_t", ""});
    monitorSignals.push_back({"next_state", propertySuite->getName() + "_state_t" , ""});
    monitorSignals.push_back({"active_operation", propertySuite->getName() + "_operation_t" , ""});
    monitorSignals.push_back({"wait_state", "std_logic" , ""});
}

std::vector<Signal> SignalFactory::getInputs(bool asVector, bool destruct, Separator separator) const {
    std::vector<Signal> ports;
    if (destruct) {
        for (const auto& in : inputs) {
            getCompoundSignals(in, asVector, separator, ports);
        }
    } else {
        for (const auto& in : inputs) {
            std::string name = in->getName();
            std::string type = asVector ? getEnumAsVector(in->getDataType()) : convertDataType(in->getDataType()->getName());
            std::string direction = in->getInterface()->getDirection();
            std::string initialValue = VHDLPrintVisitorHLS::toString(in->getDataSignal()->getInitialValue());
            bool isEnum = in->isEnumType();
            ports.push_back({name, type, direction, initialValue ,isEnum});
        }
    }
    return ports;
}

std::vector<Signal> SignalFactory::getOutputs(bool asVector, bool destruct, Separator separator) const{
    std::vector<Signal> ports;
    if (destruct) {
        for (const auto& out : outputs) {
            getCompoundSignals(out, asVector, separator, ports);
        }
    } else {
        for (const auto& out : outputs) {
            std::string name = out->getName();
            std::string type = asVector ? getEnumAsVector(out->getDataType()) : convertDataType(out->getDataType()->getName());
            std::string direction = out->getInterface()->getDirection();
            std::string initialValue = VHDLPrintVisitorHLS::toString(out->getDataSignal()->getInitialValue());
            bool isEnum = out->isEnumType();
            uint32_t vectorSize = isEnum ? ceil(log2(out->getDataType()->getEnumValueMap().size())) : 32;
            ports.push_back({name, type, direction, initialValue, vectorSize, isEnum});
        }
    }
    return ports;
}

std::vector<Signal> SignalFactory::getNotify() const {
    std::vector<Signal> ports;
    for (const auto& notify : notifys) {
        const std::string& name = notify->getName();
        std::string type = "std_logic";
        std::string direction = "out";
        ports.push_back({name, type, direction});
    }
    return ports;
}

std::vector<Signal> SignalFactory::getSync() const {
    std::vector<Signal> ports;
    for (const auto& sync : syncs) {
        const std::string& name = sync->getName();
        std::string type = "std_logic";
        std::string direction = "in";
        ports.push_back({name, type, direction});
    }
    return ports;
}

std::vector<Signal> SignalFactory::getAllPorts() const {
    std::vector<Signal> ports;
    auto in = getInputs();
    ports.insert(ports.end(), in.begin(), in.end());
    auto out = getOutputs();
    ports.insert(ports.end(), out.begin(), out.end());
    auto notify = getNotify();
    ports.insert(ports.end(), notify.begin(), notify.end());
    auto sync = getSync();
    ports.insert(ports.end(), sync.begin(), sync.end());
    ports.push_back(CLK_SIGNAL);
    ports.push_back(RESET_SIGNAL);

    return ports;
}

void SignalFactory::getCompoundSignals(Port *port, bool asVector, Separator separator, std::vector<Signal> &signals) const {
    std::vector<Signal> ports;
    if (port->isCompoundType()) {
        for (const auto& subVar : port->getDataSignal()->getSubVarList()) {
            std::string name = port->getName() + "_sig" + separatorToString(separator) + subVar->getName();
            std::string type = asVector ? getEnumAsVector(subVar->getDataType()) : convertDataType(subVar->getDataType()->getName());
            std::string direction = port->getInterface()->getDirection();
            std::string initialValue = VHDLPrintVisitorHLS::toString(subVar->getInitialValue());
            bool isEnum = subVar->isEnumType();
            uint32_t vectorSize = isEnum ? ceil(log2(subVar->getDataType()->getEnumValueMap().size())) : 32;
            signals.push_back({name, type, direction, initialValue, vectorSize, isEnum});
        }
    } else {
        std::string name = port->getName();
        std::string type = asVector ? getEnumAsVector(port->getDataType()) : convertDataType(port->getDataType()->getName());
        std::string direction = port->getInterface()->getDirection();
        std::string initialValue = VHDLPrintVisitorHLS::toString(port->getDataSignal()->getInitialValue());
        bool isEnum = port->isEnumType();
        uint32_t vectorSize = isEnum ? ceil(log2(port->getDataType()->getEnumValueMap().size())) : 32;
        signals.push_back({name, type, direction, initialValue, vectorSize, isEnum});
    }
}

std::string SignalFactory::convertDataType(std::string dataTypeName) const {
    if (dataTypeName == "bool") {
        return "std_logic";
    } else if (dataTypeName == "int" || dataTypeName == "unsigned") {
        return "std_logic_vector(31 downto 0)";
    } else if (nullptr != propertySuite && dataTypeName == propertySuite->getName() + "_SECTIONS") {
        return propertySuite->getName() + "_sections_t";
    } else {
        return dataTypeName;
    }
}

std::string SignalFactory::getEnumAsVector(const DataType *dataType) const {
    if (dataType->isEnumType()) {
        uint32_t vectorSize = ceil(log2(dataType->getEnumValueMap().size()));
        return  ("std_logic_vector(" + std::to_string(vectorSize - 1) + " downto 0)");
    } else {
        return convertDataType(dataType->getName());
    }
}

std::string SignalFactory::separatorToString(Separator separator) const{
    switch (separator) {
        case Separator::UNDERLINE :
            return "_";
        case Separator::DOT :
            return  ".";
    }
}


