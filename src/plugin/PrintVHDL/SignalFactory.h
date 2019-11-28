//
// Created by johannes on 21.11.19.
//

#ifndef DESCAM_SIGNALFACTORY_H
#define DESCAM_SIGNALFACTORY_H

#include <string>

#include <PluginFactory.h>
#include <functional>

enum class SubVarStyle {
    DOT,
    UL
};

struct Signal {
    std::string name;
    std::string type;
    std::string direction;
    bool subVar = false;
    std::string subVarName = "";
    std::string initialValue = "";
    bool isEnum = false;
    uint32_t vectorSize = 32;

    std::string getName(SubVarStyle style) const {
        if (subVar) {
            return style == SubVarStyle::UL ? name + "_" + subVarName : name + "." + subVarName;
        } else {
            return name;
        }
    };
};

class SignalFactory {

public:
    SignalFactory(PropertySuite* propertySuite, Module* module);
    ~SignalFactory() = default;

    inline std::vector<Signal> getBaseSignals() const;
    inline std::vector<Signal> getHSProtocolSignals() const;
    inline std::vector<Signal> getMonitorSignals() const;

    Signal getOperationSelector(bool asVector);

    std::vector<Signal> getInputs(bool asVector = false, bool destruct = false) const;
    std::vector<Signal> getOutputs(bool asVector = false, bool destruct = false) const;
    std::vector<Signal> getNotify() const;
    std::vector<Signal> getSync() const;
    std::vector<Signal> getAllPorts() const;

private:
    void setAllPorts();
    void setMonitorSignals();
    void setOperationSelector();
    std::string getEnumAsVector(const DataType *dataType) const;
    std::string convertDataType(std::string dataTypeName) const;
    void getCompoundSignals(Port *port, bool asVector, std::vector<Signal> &signals) const;

    PropertySuite* propertySuite;
    Module* module;

    std::vector<Port* > inputs;
    std::vector<Port* > outputs;
    std::vector<PropertyMacro* > notifys;
    std::vector<PropertyMacro* > syncs;
    std::vector<Signal > monitorSignals;
    Signal active_operation;

    const Signal START_SIGNAL = {"start", "std_logic", "in"};
    const Signal DONE_SIGNAL = {"done",  "std_logic", "out"};
    const Signal IDLE_SIGNAL = {"idle", "std_logic", "out"};
    const Signal READY_SIGNAL = {"ready","std_logic", "out"};
    const Signal CLK_SIGNAL = {"clk", "std_logic", "in"};
    const Signal RESET_SIGNAL = {"rst","std_logic", "in"};

    const std::vector<Signal> HANDSHAKING_PROTOCOL_SIGNALS {
            START_SIGNAL,
            DONE_SIGNAL,
            IDLE_SIGNAL,
            READY_SIGNAL
    };

    const std::vector<Signal> BASE_SIGNALS {
            CLK_SIGNAL,
            RESET_SIGNAL
    };
};

std::vector<Signal> SignalFactory::getBaseSignals() const {
    return BASE_SIGNALS;
}

std::vector<Signal> SignalFactory::getHSProtocolSignals() const{
    return HANDSHAKING_PROTOCOL_SIGNALS;
}

std::vector<Signal> SignalFactory::getMonitorSignals() const{
    return monitorSignals;
}

#endif //DESCAM_SIGNALFACTORY_H
