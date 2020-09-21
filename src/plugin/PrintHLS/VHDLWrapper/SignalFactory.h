//
// Created by johannes on 05.12.19.
//

#ifndef DESCAM_SIGNALFACTORY_H
#define DESCAM_SIGNALFACTORY_H

#include <cmath>
#include <memory>
#include <string>
#include <set>

#include "DataSignal.h"
#include "OptimizerHLS.h"
#include "PluginFactory.h"
#include "NodePeekVisitor.h"

namespace DESCAM {
    namespace HLSPlugin {
        namespace VHDLWrapper {

            class SignalFactory {

            public:
                SignalFactory(
                        std::shared_ptr<PropertySuite> &propertySuite,
                        Module *module,
                        std::shared_ptr<OptimizerHLS> &optimizer,
                        bool useWaitOp
                );

                ~SignalFactory() = default;

                template<typename T>
                static std::string printSignalDefinition(const T &signal,
                                                         const std::string &delimiter,
                                                         const std::string &prefix,
                                                         const std::string &suffix,
                                                         const bool &asVector,
                                                         const bool &addVld = false);

                template<typename T>
                static std::string printPortMapSignal(const T &signal,
                                                      const std::string &delimiter,
                                                      const std::string &prefix,
                                                      const std::string &suffix);

                template<typename T>
                static std::string convertDataTypeName(T *type, const bool &asVector = false);

                template<typename T>
                static std::string
                vectorToEnum(T *dataSignal, const std::string &suffix, const std::string &prefix = "");

                template<typename T>
                static std::string enumToVector(T *dataSignal);

                static std::string convertReturnTypeFunction(const std::string &returnType);

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

                std::shared_ptr<PropertySuite> propertySuite;
                Module *module;
                std::shared_ptr<OptimizerHLS> optimizer;
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
            };

            template<typename T>
            std::string SignalFactory::printSignalDefinition(const T &signal,
                                                             const std::string &delimiter,
                                                             const std::string &prefix,
                                                             const std::string &suffix,
                                                             const bool &asVector,
                                                             const bool &addVld) {
                std::stringstream ss;
                ss << "\tsignal " << prefix << signal->getFullName(delimiter) << suffix << ": "
                   << convertDataTypeName(signal->getDataType(), asVector) << ";\n";
                if (addVld) {
                    ss << "\tsignal " << prefix << signal->getFullName(delimiter) << "_vld: std_logic;\n";
                }
                return ss.str();
            }

            template<typename T>
            std::string SignalFactory::printPortMapSignal(const T &signal,
                                                          const std::string &delimiter,
                                                          const std::string &prefix,
                                                          const std::string &suffix) {
                std::stringstream ss;
                ss << "\t\t" << prefix << signal->getFullName("_");
                ss << (signal->getDataType()->isInteger() || signal->getDataType()->isUnsigned() ? "_V" : "");
                ss << " => " << signal->getFullName(delimiter) << suffix << ",\n";
                return ss.str();
            }

            template<typename T>
            std::string SignalFactory::convertDataTypeName(T *type, const bool &asVector) {

                if (type->isEnumType() && asVector) {
                    uint32_t vectorSize = ceil(log2(type->getEnumValueMap().size()));
                    if (vectorSize == 0) {
                        vectorSize++;
                    }
                    return ("std_logic_vector(" + std::to_string(vectorSize - 1) + " downto 0)");
                } else {
                    if (type->getName() == "bool") {
                        return "std_logic";
                    } else if (type->getName() == "int" || type->getName() == "unsigned") {
                        return "std_logic_vector(31 downto 0)";
                    } else {
                        return type->getName();
                    }
                }

            }

            template<typename T>
            std::string
            SignalFactory::vectorToEnum(T *dataSignal, const std::string &suffix, const std::string &prefix) {
                return (dataSignal->getDataType()->getName() + "'val(to_integer(unsigned(" + prefix +
                        dataSignal->getFullName("_") + suffix + ")))");
            }

            template<typename T>
            std::string SignalFactory::enumToVector(T *dataSignal) {
                uint32_t vectorSize = ceil(log2(dataSignal->getDataType()->getEnumValueMap().size()));
                if (vectorSize == 0) {
                    vectorSize++;
                }
                return "std_logic_vector(to_unsigned(" + dataSignal->getDataType()->getName() + "\'pos(" +
                       dataSignal->getFullName(".") + "), " + std::to_string(vectorSize) + "))";
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

        }
    }
}

#endif //DESCAM_SIGNALFACTORY_H
