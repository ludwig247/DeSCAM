//
// Created by johannes on 05.12.19.
//

#include <memory>
#include <tuple>
#include <Stmts/StmtCastVisitor.h>
#include "Logger/Logger.h"
#include "SignalFactory.h"
#include "PrintStmtVHDL.h"

using namespace DESCAM::HLSPlugin::VHDLWrapper;

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
        std::shared_ptr<PropertySuite>& propertySuite,
        Module* module,
        std::shared_ptr<OptimizerHLS>& optimizer
) :
        propertySuite(propertySuite),
        module(module),
        optimizer(optimizer)
{
    generateTypes();
    setOperationSelector();
    setControlSignals();
    setMonitorSignals();
    splitInputOutput();
    setInternalRegister();
    setOutputRegister();
    setOperationModuleInputs();
    setOperationModuleOutputs();
}

/*
 * Generate enum types for states and operations
 */
void SignalFactory::generateTypes() {
    stateType = new DataType(propertySuite->getName() + "_state_t");
    for (const auto& state : propertySuite->getStates()) {
        stateType->addEnumValue(state->getName());
    }
    operationType = new DataType(propertySuite->getName() + "_operation_t");
    for (const auto& operation : propertySuite->getOperationProperties()) {
        operationType->addEnumValue(operation->getName());
    }
}

/*
 * Generate the active_operation variable
 */
void SignalFactory::setOperationSelector() {
    activeOperation = std::make_shared<Variable> ("active_operation", operationType);
}

/*
 * Generate Vivado protocol and control signals
 */
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

/*
 * Generate control signals for the monitor
 */
void SignalFactory::setMonitorSignals() {
    monitorSignals.insert(std::make_shared<Variable> ("active_state", stateType));
    monitorSignals.insert(std::make_shared<Variable> ("next_state", stateType));
    monitorSignals.insert(activeOperation);
}

/*
 * Split DataSignals based on port direction
 */
void SignalFactory::splitInputOutput() {
    for (const auto& port : module->getPorts()) {
        if (port.second->getInterface()->isInput()) {
            inputs.insert(port.second->getDataSignal());
        } else if (port.second->getInterface()->isOutput()) {
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

/*
 * Print given type as VHDL style return type
 */
std::string SignalFactory::convertReturnType(const DataType &type) {
    if (type.isBoolean()) {
        return "std_logic";
    } else if (type.isInteger() || type.isUnsigned()) {
        return "std_logic_vector";
    } else {
        return type.getName();
    }
}

/*
 * Find the assigned value of a notify signal in the given properties' commitments
 */
std::string SignalFactory::findAssignedValue(const std::shared_ptr<Property> &property, const std::shared_ptr<PropertyMacro> &notify) {
    std::string assignedValue;
    for (const auto &commitment : property->getCommitmentList()) {
        const auto &assignment = StmtCastVisitor<Assignment>(commitment->getStatement()).Get();
        if (assignment == nullptr) {
            continue;
        }
        const auto &lhs = StmtCastVisitor<Notify>(assignment->getLhs()).Get();
        if (lhs == nullptr) {
            continue;
        }
        if (notify->getFullName() == PrintStmtVHDL::toString(lhs)) {
            assignedValue = PrintStmtVHDL::toString(assignment->getRhs());
            break;
        }
    }
    return assignedValue;
}
