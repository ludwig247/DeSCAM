//
// Created by johannes on 05.12.19.
//

#include <tuple>

#include "SignalFactory.h"

using namespace SCAM::HLSPlugin::VHDLWrapper;

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

SignalFactory::SignalFactory(PropertySuite* propertySuite, Module* module, OperationModuleInterface* hlsModule) :
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

void SignalFactory::setOperationSelector() {
    auto operationSelectorType = new DataType(propertySuite->getName() + "_operation_t");
    for (const auto& property : propertySuite->getOperationProperties()) {
        operationSelectorType->addEnumValue(property->getName());
    }
    operationSelectorType->addEnumValue("state_wait");
    activeOperation = new Variable("active_operation", operationSelectorType);
}

void SignalFactory::setControlSignals() {
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

void SignalFactory::setMonitorSignals() {
    auto stateType = new DataType(propertySuite->getName() + "_state_t");
    for (const auto& state : propertySuite->getStates()) {
        stateType->addEnumValue(state->getName());
    }
    auto operationType = new DataType(propertySuite->getName() + "_operation_t");
    for (const auto& operation : propertySuite->getOperationProperties()) {
        operationType->addEnumValue(operation->getName());
    }
    monitorSignals.insert(new Variable("active_state", stateType));
    monitorSignals.insert(new Variable("next_state", stateType));
    monitorSignals.insert(new Variable("active_operation", operationType));
}

void SignalFactory::setInputs() {
    for (const auto& port : module->getPorts()) {
        if (port.second->getInterface()->isInput()) {
            inputs.insert(port.second->getDataSignal());
        }
    }
}

void SignalFactory::setOutputs() {
    for (const auto& port : module->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            outputs.insert(port.second->getDataSignal());
        }
    }
}

void SignalFactory::setInternalRegister() {
    internalRegisterIn = hlsModule->getInternalRegisterIn();
    internalRegisterOut = hlsModule->getInternalRegisterOut();
}

void SignalFactory::setOutputRegister() {
    outputRegister = hlsModule->getOutputRegister();
}

void SignalFactory::setOperationModuleInputs() {
    operationModuleInputs = hlsModule->getInputs();
}

void SignalFactory::setOperationModuleOutputs() {
    operationModuleOutputs = hlsModule->getOutputs();
}

std::set<Variable *> SignalFactory::getInternalRegister() const {
    std::set<Variable *> vars;
    vars.insert(internalRegisterIn.begin(), internalRegisterIn.end());
    vars.insert(internalRegisterOut.begin(), internalRegisterOut.end());
    return vars;
}

std::string SignalFactory::convertDataType(const std::string& dataType)
{
    if (dataType == "bool") {
        return "std_logic";
    } else if (dataType == "int" || dataType == "unsigned") {
        return "std_logic_vector(31 downto 0)";
    } else {
        return dataType;
    }
}

std::string SignalFactory::convertReturnType(const std::string &returnType) {
    if (returnType == "bool") {
        return "boolean";
    } else if (returnType == "int" || returnType == "unsigned") {
        return "std_logic_vector";
    } else {
        return returnType;
    }
}

std::string SignalFactory::styleToString(const Style& style)
{
    if (style == Style::UL) {
        return "_";
    } else if (style == Style::DOT) {
        return ".";
    } else {
        throw std::runtime_error("Unsupported Print Style!");
    }
}

