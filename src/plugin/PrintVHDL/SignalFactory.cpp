//
// Created by johannes on 21.11.19.
//

#include <cmath>

#include "SignalFactory.h"
#include "DataSignal.h"
#include "VHDLPrintVisitorHLS.h"
#include "OtherUtils.h"

using namespace SCAM::VHDL;

SignalFactory::SignalFactory(PropertySuite* propertySuite, Module* module, HLSmodule *hlsModule) :
    propertySuite(propertySuite),
    module(module),
    hlsModule(hlsModule)
{
    setOperationSelector();
    setAllPorts();
    setInternalRegister();
    setMonitorSignals();
}

void SignalFactory::setOperationSelector() {
    uint32_t vectorSize = ceil(log2(propertySuite->getOperationProperties().size()));
    active_operation = {
            "active_operation",
            propertySuite->getName() + "_operation_t",
            "in",
            false,
            "",
            "",
            true,
            vectorSize,
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

void SignalFactory::setInternalRegister() {
    for (const auto& internalReg : OtherUtils::getParents(hlsModule->getVariables())) {
        internalRegs.push_back(internalReg);
    }
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
    monitorSignals.push_back({"active_state", propertySuite->getName() + "_state_t"});
    monitorSignals.push_back({"next_state", propertySuite->getName() + "_state_t"});
    monitorSignals.push_back({"active_operation", propertySuite->getName() + "_operation_t"});
    monitorSignals.push_back({"wait_state", "std_logic"});
}

std::vector<Signal> SignalFactory::getInputs(bool asVector, bool destruct) const {
    std::vector<Signal> ports;
    if (destruct) {
        for (const auto& in : inputs) {
            getCompoundSignals(in, asVector, ports);
        }
    } else {
        for (const auto& in : inputs) {
            std::string name = in->getName() + "_sig";
            std::string type = asVector ? OtherUtils::getEnumAsVector(in->getDataType()) : OtherUtils::convertDataType(in->getDataType()->getName());
            std::string direction = in->getInterface()->getDirection();
            std::string initialValue = VHDLPrintVisitorHLS::toString(in->getDataSignal()->getInitialValue());
            bool isEnum = in->isEnumType();
            ports.push_back({name, type, direction, false, "", initialValue, isEnum});
        }
    }
    return ports;
}

std::vector<Signal> SignalFactory::getOutputs(bool asVector, bool destruct) const{
    std::vector<Signal> ports;
    if (destruct) {
        for (const auto& out : outputs) {
            getCompoundSignals(out, asVector, ports);
        }
    } else {
        for (const auto &out : outputs) {
            std::string name = out->getName() + "_sig";
            std::string type = asVector ? OtherUtils::getEnumAsVector(out->getDataType()) : OtherUtils::convertDataType(
                    out->getDataType()->getName());
            std::string direction = out->getInterface()->getDirection();
            std::string initialValue = VHDLPrintVisitorHLS::toString(out->getDataSignal()->getInitialValue());
            bool isEnum = out->isEnumType();
            uint32_t vectorSize = isEnum ? ceil(log2(out->getDataType()->getEnumValueMap().size())) : 32;
            ports.push_back({name, type, direction, false, "", initialValue, isEnum, vectorSize});
        }
    }
    return ports;
}

std::vector<Signal> SignalFactory::getInternalRegs(bool asVector, bool destruct) const
{
    std::vector<Signal> registerSignals;
    if (destruct) {
        for (const auto& internalReg :internalRegs) {
            getCompoundSignalsReg(internalReg, asVector, registerSignals);
        }
    } else {
        for (const auto& internalReg :internalRegs) {
            std::string name = internalReg->getFullName();
            std::string type = asVector ? OtherUtils::getEnumAsVector(internalReg->getDataType()) : OtherUtils::convertDataType(
                    internalReg->getDataType()->getName());
            std::string initialValue = VHDLPrintVisitorHLS::toString(internalReg->getInitialValue());
            bool isEnum = internalReg->isEnumType();
            uint32_t vectorSize = isEnum ? ceil(log2(internalReg->getDataType()->getEnumValueMap().size())) : 32;
            registerSignals.push_back({name, type, "", false, "", initialValue, isEnum, vectorSize});
        }
    }
    return registerSignals;
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

void SignalFactory::getCompoundSignals(Port *port, bool asVector, std::vector<Signal> &signals) const {
    std::vector<Signal> ports;
    if (port->isCompoundType()) {
        for (const auto& subVar : port->getDataSignal()->getSubVarList()) {
            std::string name = port->getName() + "_sig";
            std::string subVarName = subVar->getName();
            std::string type = asVector ? OtherUtils::getEnumAsVector(subVar->getDataType()) : OtherUtils::convertDataType(subVar->getDataType()->getName());
            std::string direction = port->getInterface()->getDirection();
            std::string initialValue = VHDLPrintVisitorHLS::toString(subVar->getInitialValue());
            bool isEnum = subVar->isEnumType();
            uint32_t vectorSize = isEnum ? ceil(log2(subVar->getDataType()->getEnumValueMap().size())) : 32;
            signals.push_back({name, type, direction, true, subVarName, initialValue, isEnum, vectorSize});
        }
    } else {
        std::string name = port->getName() + "_sig";
        std::string type = asVector ? OtherUtils::getEnumAsVector(port->getDataType()) : OtherUtils::convertDataType(port->getDataType()->getName());
        std::string direction = port->getInterface()->getDirection();
        std::string initialValue = VHDLPrintVisitorHLS::toString(port->getDataSignal()->getInitialValue());
        bool isEnum = port->isEnumType();
        uint32_t vectorSize = isEnum ? ceil(log2(port->getDataType()->getEnumValueMap().size())) : 32;
        signals.push_back({name, type, direction, false, "", initialValue, isEnum, vectorSize});
    }
}

void SignalFactory::getCompoundSignalsReg(Variable *signal, bool asVector, std::vector<Signal> &signals) const {
    std::vector<Signal> ports;
    if (signal->isCompoundType()) {
        for (const auto& subVar : signal->getSubVarList()) {
            std::string name = signal->getName();
            std::string subVarName = subVar->getName();
            std::string type = asVector ? OtherUtils::getEnumAsVector(subVar->getDataType()) : OtherUtils::convertDataType(subVar->getDataType()->getName());
            std::string initialValue = VHDLPrintVisitorHLS::toString(subVar->getInitialValue());
            bool isEnum = subVar->isEnumType();
            uint32_t vectorSize = isEnum ? ceil(log2(subVar->getDataType()->getEnumValueMap().size())) : 32;
            signals.push_back({name, type, "", true, subVarName, initialValue, isEnum, vectorSize});
        }
    } else {
        std::string name = signal->getName();
        std::string type = asVector ? OtherUtils::getEnumAsVector(signal->getDataType()) : OtherUtils::convertDataType(signal->getDataType()->getName());
        std::string initialValue = VHDLPrintVisitorHLS::toString(signal->getInitialValue());
        bool isEnum = signal->isEnumType();
        uint32_t vectorSize = isEnum ? ceil(log2(signal->getDataType()->getEnumValueMap().size())) : 32;
        signals.push_back({name, type, "", false, "", initialValue, isEnum, vectorSize});
    }
}

std::string SignalFactory::vectorToEnum(DataSignal *dataSignal, const std::string &suffix) {
    return dataSignal->getDataType()->getName() + "'val(to_integer(unsigned(" + printWithUL(dataSignal) + suffix + ")))";
}
