//
// Created by johannes on 05.12.19.
//

#include <tuple>
#include "FatalError.h"
#include "Logger/Logger.h"
#include "SignalFactory.h"

using namespace SCAM::HLSPlugin::VHDLWrapper;

static const std::set<std::tuple<std::string, std::string, std::string>> HANDSHAKING_PROTOCOL_SIGNALS = {
        std::make_tuple("start", "bool", "in"),
        std::make_tuple("done", "bool", "out"),
        std::make_tuple("idle", "bool", "out"),
        std::make_tuple("ready", "bool", "out")
};

static const std::set<std::tuple<std::string, std::string, std::string>> CONTROL_SIGNALS = {
        std::make_tuple("clk", "bool", "in"),
        std::make_tuple("rst", "bool", "in")
};

SignalFactory::SignalFactory(
        std::shared_ptr<PropertySuiteHelper>& propertyHelper,
        Module* module,
        std::shared_ptr<OptimizerHLS>& optimizer,
        bool useWaitState
) :
        propertySuiteHelper(propertyHelper),
        module(module),
        optimizer(optimizer),
        useWaitOp(useWaitState)
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
    auto operationSelectorType = new DataType(propertySuiteHelper->getName() + "_operation_t");
    for (const auto& property : propertySuiteHelper->getOperationProperties()) {
        operationSelectorType->addEnumValue(property->getName());
    }
    if (useWaitOp) {
        operationSelectorType->addEnumValue("state_wait");
    }
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
    auto stateType = new DataType(propertySuiteHelper->getName() + "_state_t");
    for (const auto& state : propertySuiteHelper->getStates()) {
        stateType->addEnumValue(state->getName());
    }
    auto operationType = new DataType(propertySuiteHelper->getName() + "_operation_t");
    for (const auto& operation : propertySuiteHelper->getOperationProperties()) {
        operationType->addEnumValue(operation->getName());
    }
    monitorSignals.insert(new Variable("active_state", stateType));
    monitorSignals.insert(new Variable("next_state", stateType));
    monitorSignals.insert(new Variable("active_operation", operationType));
    if (!useWaitOp) {
        monitorSignals.insert(new Variable("wait_state", new DataType("bool")));
    }
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
    internalRegisterIn = optimizer->getInternalRegisterIn();
    internalRegisterOut = optimizer->getInternalRegisterOut();
}

void SignalFactory::setOutputRegister() {
    outputRegister = optimizer->getOutputRegister();
}

void SignalFactory::setOperationModuleInputs() {
    operationModuleInputs = optimizer->getInputs();
}

void SignalFactory::setOperationModuleOutputs() {
    operationModuleOutputs = optimizer->getOutputs();
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

//std::string SignalFactory::convertDataTypeFunction(const std::string &dataType) {
//    if (dataType == "bool") {
//        return "boolean";
//    } else if (dataType == "int") {
//        return "signed(31 downto 0)";
//    } else if (dataType == "unsigned") {
//        return "unsigned(31 downto 0)";
//    } else {
//        return dataType;
//    }
//}

std::string SignalFactory::convertReturnTypeFunction(const std::string &returnType) {
//    if (returnType == "bool") {
//        return "boolean";
//    } else if (returnType == "int") {
//        return "signed";
//    } else if (returnType == "unsigned") {
//        return "unsigned";
//    } else {
//        return returnType;
//    }
    if (returnType == "bool") {
        return "std_logic";
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
        TERMINATE("Unsupported Print Style!");
    }
}

