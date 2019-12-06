//
// Created by johannes on 05.12.19.
//

#include <tuple>

#include "SignalFactoryNew.h"

const std::set<std::tuple<std::string, std::string, std::string>> HANDSHAKING_PROTOCOL_SIGNALS = {
        {"start", "bool", "in"},
        {"done", "bool", "out"},
        {"idle", "bool", "out"},
        {"ready", "bool", "out"}
};

const std::set<std::tuple<std::string, std::string, std::string>> CONTROL_SIGNALS = {
        {"clk", "bool", "in"},
        {"rst", "bool", "in"}
};

SignalFactoryNew::SignalFactoryNew(PropertySuite* propertySuite, Module* module, HLSmodule* hlsModule) :
    propertySuite(propertySuite),
    module(module),
    hlsModule(hlsModule)
{
    setOperationSelector();
    setControlSignals();
    setMonitorSignals();
    setInputs();
    setOutputs();
    setInternalRegister();
    setOutputRegister();
    setOperationModuleInputs();
    setOperationModuleOutputs();
}

void SignalFactoryNew::setOperationSelector() {
    auto operationSelectorType = new DataType(propertySuite->getName() + "_operation_t");
    for (const auto& property : propertySuite->getOperationProperties()) {
        operationSelectorType->addEnumValue(property->getName());
    }
    activeOperation = new Variable("active_operation", operationSelectorType);
}

void SignalFactoryNew::setControlSignals() {
    for (const auto& signal : HANDSHAKING_PROTOCOL_SIGNALS) {
        handshakingProtocolSignals.insert( new DataSignal(std::get<0>(signal),
                DataTypes::getDataType(std::get<1>(signal)),
                (DataTypes::getDataType(std::get<1>(signal)))->getDefaultVal(),
                nullptr,
                new Port(std::get<0>(signal),
                        new Interface( "shared", std::get<2>(signal)),
                        DataTypes::getDataType(std::get<1>(signal)))
                )
        );
    }
    for (const auto& signal : CONTROL_SIGNALS) {
        controlSignals.insert( new DataSignal(std::get<0>(signal),
                DataTypes::getDataType(std::get<1>(signal)),
                (DataTypes::getDataType(std::get<1>(signal)))->getDefaultVal(),
                nullptr,
                new Port(std::get<0>(signal),
                        new Interface( "shared", std::get<2>(signal)),
                        DataTypes::getDataType(std::get<1>(signal)))
                )
        );
    }
}

void SignalFactoryNew::setMonitorSignals() {
    auto stateType = new DataType(propertySuite->getName() + "_operation_t");
    for (const auto& state : propertySuite->getStates()) {
        stateType->addEnumValue(state->getName());
    }
    monitorSignals.insert(new Variable("active_state", stateType));
    monitorSignals.insert(new Variable("next_state", stateType));
    monitorSignals.insert(new Variable("active_operation", stateType));
    monitorSignals.insert(new Variable("wait_state", new DataType("bool")));
}

void SignalFactoryNew::setInputs() {
    for (const auto& port : module->getPorts()) {
        if (port.second->getInterface()->isInput()) {
            inputs.insert(port.second->getDataSignal());
        }
    }
}

void SignalFactoryNew::setOutputs() {
    for (const auto& port : module->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            inputs.insert(port.second->getDataSignal());
        }
    }
}

void SignalFactoryNew::setInternalRegister() {
    internalRegister = hlsModule->getInternalRegister();
}

void SignalFactoryNew::setOutputRegister() {
    outputRegister = hlsModule->getOutputRegister();
}

void SignalFactoryNew::setOperationModuleInputs() {
    operationModuleInputs = hlsModule->getInputs();
}

void SignalFactoryNew::setOperationModuleOutputs() {
    operationModuleOutputs = hlsModule->getOutputs();
}

std::string SignalFactoryNew::convertDataType(const std::string& dataType)
{
    if (dataType == "bool") {
        return "std_logic";
    } else if (dataType == "int" || dataType == "unsigned") {
        return "std_logic_vector(31 downto 0)";
    } else {
        return dataType;
    }
}

std::string SignalFactoryNew::styleToString(const Style& style)
{
    if (style == Style::UL) {
        return "_";
    } else if (style == Style::DOT) {
        return ".";
    } else {
        throw std::runtime_error("Unsupported Print Style!");
    }
}

