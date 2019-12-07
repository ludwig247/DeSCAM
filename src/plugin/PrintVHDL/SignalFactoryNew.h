//
// Created by johannes on 05.12.19.
//

#ifndef DESCAM_SIGNALFACTORYNEW_H
#define DESCAM_SIGNALFACTORYNEW_H

#include <string>
#include <cmath>

#include <PluginFactory.h>

#include "HLSmodule.h"
#include "DataSignal.h"

enum class Style {
    DOT,
    UL
};

class SignalFactoryNew {

public:
    SignalFactoryNew(PropertySuite *propertySuite, Module *module, HLSmodule *hlsModule);
    ~SignalFactoryNew() = default;

    static std::string convertDataType(const std::string &dataType);

    template <typename T>
    static std::string asVector(T *dataSignal);

    template <typename T>
    static std::string getDataTypeName(T* dataSignal, bool asVector);

    template <typename T>
    static std::string getName(T *dataSignal, const Style &style, const std::string &suffix = "");

    template <typename T>
    static std::string vectorToEnum(T *dataSignal, const std::string &suffix, const std::string &prefix = "");

    template <typename T>
    static std::string enumToVector(T *dataSignal);

    inline Variable * getActiveOperation() const;
    inline std::set<Variable *> getMonitorSignals() const;
    inline std::set<Variable *> getInternalRegister() const;
    inline std::set<Variable *> getOutputRegister() const;
    inline std::set<DataSignal *> getInputs() const;
    inline std::set<DataSignal *> getOutputs() const;
    inline std::set<DataSignal *> getOperationModuleOutputs() const;
    inline std::set<DataSignal *> getOperationModuleInputs() const;
    inline std::set<DataSignal *> getControlSignals() const;
    inline std::set<DataSignal *> getHandshakingProtocolSignals() const;

private:

    PropertySuite *propertySuite;
    Module *module;
    HLSmodule *hlsModule;

    Variable *activeOperation;
    std::set<Variable *> monitorSignals;
    std::set<Variable *> internalRegister;
    std::set<Variable *> outputRegister;
    std::set<DataSignal *> inputs;
    std::set<DataSignal *> outputs;
    std::set<DataSignal *> operationModuleOutputs;
    std::set<DataSignal *> operationModuleInputs;
    std::set<DataSignal *> controlSignals;
    std::set<DataSignal *> handshakingProtocolSignals;

    void setOperationSelector();
    void setControlSignals();
    void setMonitorSignals();
    void setInputs();
    void setOutputs();
    void setInternalRegister();
    void setOutputRegister();
    void setOperationModuleInputs();
    void setOperationModuleOutputs();

    static std::string styleToString(const Style &style);
};

template <typename T>
std::string SignalFactoryNew::asVector(T *dataSignal) {
    if (dataSignal->getDataType()->isEnumType()) {
        uint32_t vectorSize = ceil(log2(dataSignal->getDataType()->getEnumValueMap().size()));
        return  ("std_logic_vector(" + std::to_string(vectorSize - 1) + " downto 0)");
    } else {
        return convertDataType(dataSignal->getDataType()->getName());
    }
}

template <typename T>
std::string SignalFactoryNew::getDataTypeName(T* dataSignal, bool vector)
{
    if (vector) {
        return asVector(dataSignal);
    } else {
        return SignalFactoryNew::convertDataType(dataSignal->getDataType()->getName());
    }
}

template <typename T>
std::string SignalFactoryNew::getName(T *dataSignal, const Style& style, const std::string& suffix)
{
    if (dataSignal->isSubVar()) {
        return dataSignal->getParent()->getName() + styleToString(style) + dataSignal->getName() + suffix;
    } else {
        return dataSignal->getName() + suffix;
    }
}

template <typename T>
std::string SignalFactoryNew::vectorToEnum(T *dataSignal, const std::string &suffix, const std::string &prefix) {
    return dataSignal->getDataType()->getName() + "'val(to_integer(unsigned(" + prefix + getName(dataSignal, Style::UL) + suffix + ")))";
}

template<typename T>
std::string SignalFactoryNew::enumToVector(T* dataSignal)
{
    return "std_logic_vector(to_unsigned(" + dataSignal->getDataType()->getName() + "\'pos(" +
    SignalFactoryNew::getName(dataSignal, Style::DOT) + "), " +
    std::to_string(static_cast<uint32_t>(ceil(log2(dataSignal->getDataType()->getEnumValueMap().size())))) + "))";
}

Variable * SignalFactoryNew::getActiveOperation() const{
    return activeOperation;
}
std::set<Variable *> SignalFactoryNew::getMonitorSignals() const {
    return monitorSignals;
}

std::set<Variable *> SignalFactoryNew::getInternalRegister() const {
    return internalRegister;
}

std::set<Variable *> SignalFactoryNew::getOutputRegister() const {
    return outputRegister;
}

std::set<DataSignal *> SignalFactoryNew::getInputs() const {
    return inputs;
}

std::set<DataSignal *> SignalFactoryNew::getOutputs() const {
    return outputs;
}

std::set<DataSignal *> SignalFactoryNew::getOperationModuleOutputs() const {
    return operationModuleOutputs;
}

std::set<DataSignal *> SignalFactoryNew::getOperationModuleInputs() const {
    return operationModuleInputs;
}

std::set<DataSignal *> SignalFactoryNew::getControlSignals() const {
    return controlSignals;
}

std::set<DataSignal *> SignalFactoryNew::getHandshakingProtocolSignals() const {
    return handshakingProtocolSignals;
}

#endif //DESCAM_SIGNALFACTORYNEW_H
