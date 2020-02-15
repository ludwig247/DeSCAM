//
// Created by johannes on 05.12.19.
//

#ifndef DESCAM_SIGNALFACTORY_H
#define DESCAM_SIGNALFACTORY_H

#include <string>
#include <set>
#include <cmath>

#include <PluginFactory.h>

#include "OperationModuleInterface.h"
#include "DataSignal.h"

namespace SCAM { namespace HLSPlugin { namespace VHDLWrapper {

            enum class Style {
                DOT,
                UL
            };

            class SignalFactory {

            public:
                SignalFactory(PropertySuite *propertySuite, Module *module, OperationModuleInterface *hlsModule, bool useWaitOp);
                ~SignalFactory() = default;

                template<typename T>
                static std::string asVector(T *dataSignal);

                template<typename T>
                static std::string getDataTypeName(T *dataSignal, bool asVector);

                template<typename T>
                static std::string getName(T *dataSignal, const Style &style, const std::string &suffix = "");

                template<typename T>
                static std::string vectorToEnum(T *dataSignal, const std::string &suffix, const std::string &prefix = "");

                template<typename T>
                static std::string enumToVector(T *dataSignal);

                static std::string convertDataType(const std::string &dataType);
                static std::string convertReturnType(const std::string &returnType);
                std::set<Variable *> getInternalRegister() const;

                inline Variable *getActiveOperation() const;
                inline std::set<Variable *> getMonitorSignals() const;
                inline std::set<Variable *> getInternalRegisterIn() const;
                inline std::set<Variable *> getInternalRegisterOut() const;
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
                OperationModuleInterface *hlsModule;
                bool useWaitOp;

                Variable *activeOperation;
                std::set<Variable *> monitorSignals;
                std::set<Variable *> internalRegisterIn;
                std::set<Variable *> internalRegisterOut;
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

            template<typename T>
            std::string SignalFactory::asVector(T *dataSignal) {
                if (dataSignal->getDataType()->isEnumType()) {
                    uint32_t vectorSize = ceil(log2(dataSignal->getDataType()->getEnumValueMap().size()));
                    return ("std_logic_vector(" + std::to_string(vectorSize - 1) + " downto 0)");
                } else {
                    return convertDataType(dataSignal->getDataType()->getName());
                }
            }

            template<typename T>
            std::string SignalFactory::getDataTypeName(T *dataSignal, bool vector) {
                if (vector) {
                    return asVector(dataSignal);
                } else {
                    return SignalFactory::convertDataType(dataSignal->getDataType()->getName());
                }
            }

            template<typename T>
            std::string SignalFactory::getName(T *dataSignal, const Style &style, const std::string &suffix) {
                if (dataSignal->isSubVar()) {
                    return dataSignal->getParent()->getName() + styleToString(style) + dataSignal->getName() + suffix;
                } else {
                    return dataSignal->getName() + suffix;
                }
            }

            template<typename T>
            std::string
            SignalFactory::vectorToEnum(T *dataSignal, const std::string &suffix, const std::string &prefix) {
                return dataSignal->getDataType()->getName() + "'val(to_integer(unsigned(" + prefix +
                       getName(dataSignal, Style::UL) + suffix + ")))";
            }

            template<typename T>
            std::string SignalFactory::enumToVector(T *dataSignal) {
                return "std_logic_vector(to_unsigned(" + dataSignal->getDataType()->getName() + "\'pos(" +
                       SignalFactory::getName(dataSignal, Style::DOT) + "), " +
                       std::to_string(
                               static_cast<uint32_t>(ceil(log2(dataSignal->getDataType()->getEnumValueMap().size())))) +
                       "))";
            }

            Variable *SignalFactory::getActiveOperation() const {
                return activeOperation;
            }

            std::set<Variable *> SignalFactory::getMonitorSignals() const {
                return monitorSignals;
            }

            std::set<Variable *> SignalFactory::getInternalRegisterIn() const {
                return internalRegisterIn;
            }

            std::set<Variable *> SignalFactory::getInternalRegisterOut() const {
                return internalRegisterOut;
            }

            std::set<Variable *> SignalFactory::getOutputRegister() const {
                return outputRegister;
            }

            std::set<DataSignal *> SignalFactory::getInputs() const {
                return inputs;
            }

            std::set<DataSignal *> SignalFactory::getOutputs() const {
                return outputs;
            }

            std::set<DataSignal *> SignalFactory::getOperationModuleOutputs() const {
                return operationModuleOutputs;
            }

            std::set<DataSignal *> SignalFactory::getOperationModuleInputs() const {
                return operationModuleInputs;
            }

            std::set<DataSignal *> SignalFactory::getControlSignals() const {
                return controlSignals;
            }

            std::set<DataSignal *> SignalFactory::getHandshakingProtocolSignals() const {
                return handshakingProtocolSignals;
            }

}}}

#endif //DESCAM_SIGNALFACTORY_H
