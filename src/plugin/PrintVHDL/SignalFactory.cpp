//
// Created by johannes on 21.11.19.
//

#include <cmath>

#include "SignalFactory.h"

SignalFactory::SignalFactory(PropertySuite* propertySuite, Module* module) :
    propertySuite(propertySuite),
    module(module)
{
    setAllPorts();
    setMonitorSignals();
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

std::vector<Signal> SignalFactory::getInputs(bool asVector, bool destruct) {
    std::vector<Signal> ports;
    for (const auto& in : inputs) {
        std::string name = in->getName();
        std::string type = asVector ? getEnumAsVector(in->getDataType()) : convertDataType(in->getDataType()->getName());
        std::string direction = in->getInterface()->getDirection();
        ports.push_back({name, type, direction});
    }
    return ports;
}

std::vector<Signal> SignalFactory::getOutputs(bool asVector, bool destruct) {
    std::vector<Signal> ports;
    if (destruct) {
        for (const auto& out : outputs) {
            if (out->isCompoundType()) {
//                for () {
//
//                }
            } else {
                std::string name = out->getName();
                std::string type = asVector ? getEnumAsVector(out->getDataType()) : convertDataType(out->getDataType()->getName());
                std::string direction = out->getInterface()->getDirection();
                ports.push_back({name, type, direction});
            }
        }
    } else {
        for (const auto& out : outputs) {
            std::string name = out->getName();
            std::string type = asVector ? getEnumAsVector(out->getDataType()) : convertDataType(out->getDataType()->getName());
            std::string direction = out->getInterface()->getDirection();
            ports.push_back({name, type, direction});
        }
    }

    return ports;
}

std::vector<Signal> SignalFactory::getNotify() {
    std::vector<Signal> ports;
    for (const auto& notify : notifys) {
        const std::string& name = notify->getName();
        std::string type = "std_logic";
        std::string direction = "out";
        ports.push_back({name, type, direction});
    }
    return ports;
}

std::vector<Signal> SignalFactory::getSync() {
    std::vector<Signal> ports;
    for (const auto& sync : syncs) {
        const std::string& name = sync->getName();
        std::string type = "std_logic";
        std::string direction = "in";
        ports.push_back({name, type, direction});
    }
    return ports;
}

std::vector<Signal> SignalFactory::getAllPorts() {
    std::vector<Signal> ports;
    auto in = getInputs();
    ports.insert(in.begin(), in.end(), in.end());
    auto out = getOutputs();
    ports.insert(out.begin(), out.end(), out.end());
    auto notify = getNotify();
    ports.insert(notify.begin(), notify.end(), notify.end());
    auto sync = getSync();
    ports.insert(notify.begin(), notify.end(), notify.end());
    ports.push_back(CLK_SIGNAL);
    ports.push_back(RESET_SIGNAL);

    return ports;
}

std::string SignalFactory::convertDataType(std::string dataTypeName) {
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

std::string SignalFactory::getEnumAsVector(const DataType *dataType) {
    if (dataType->isEnumType()) {
        uint32_t vectorSize = ceil(log2(dataType->getEnumValueMap().size()));
        return  ("std_logic_vector(" + std::to_string(vectorSize - 1) + " downto 0)");
    } else {
        return convertDataType(dataType->getName());
    }
}


