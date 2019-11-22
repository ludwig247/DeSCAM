//
// Created by johannes on 21.11.19.
//

#ifndef DESCAM_SIGNALFACTORY_H
#define DESCAM_SIGNALFACTORY_H

#include <string>

#include <PluginFactory.h>

struct Signal {
    std::string name;
    std::string type;
    std::string direction;
};

class SignalFactory {

public:
    SignalFactory(PropertySuite* propertySuite, Module* module);
    ~SignalFactory() = default;

    inline std::vector<Signal> getControlSignals();
    inline std::vector<Signal> getHSProtocolSignals();
    inline std::vector<Signal> getMonitorSignals();

    std::vector<Signal> getInputs(bool asVector = false, bool destruct = false);
    std::vector<Signal> getOutputs(bool asVector = false, bool destruct = false);
    std::vector<Signal> getNotify();
    std::vector<Signal> getSync();
    std::vector<Signal> getAllPorts();

private:
    void setAllPorts();
    void setMonitorSignals();
    std::string getEnumAsVector(const DataType *dataType);

    std::string convertDataType(std::string dataTypeName);

    PropertySuite* propertySuite;
    Module* module;

    std::vector<Port* > inputs;
    std::vector<Port* > outputs;
    std::vector<PropertyMacro* > notifys;
    std::vector<PropertyMacro* > syncs;
    std::vector<Signal > monitorSignals;

    const Signal START_SIGNAL = {"start", "std_logic", "in"};
    const Signal DONE_SIGNAL = {"done", "std_logic", "out"};
    const Signal IDLE_SIGNAL = {"idle", "std_logic", "out"};
    const Signal READY_SIGNAL = {"ready", "std_logic", "out"};

    const Signal CLK_SIGNAL = {"clk", "std_logic", "in"};
    const Signal RESET_SIGNAL = {"rst", "std_logic", "in"};

    const std::vector<Signal> HANDSHAKING_PROTOCOL_SIGNALS{
            START_SIGNAL,
            DONE_SIGNAL,
            IDLE_SIGNAL,
            READY_SIGNAL
    };

    const std::vector<Signal> ALL_CONTROL_SIGNALS{
            START_SIGNAL,
            DONE_SIGNAL,
            IDLE_SIGNAL,
            READY_SIGNAL,
            CLK_SIGNAL,
            RESET_SIGNAL
    };
};

std::vector<Signal> SignalFactory::getControlSignals() {
    return ALL_CONTROL_SIGNALS;
}

std::vector<Signal> SignalFactory::getHSProtocolSignals() {
    return HANDSHAKING_PROTOCOL_SIGNALS;
}

std::vector<Signal> SignalFactory::getMonitorSignals() {
    return monitorSignals;
}

#endif //DESCAM_SIGNALFACTORY_H
