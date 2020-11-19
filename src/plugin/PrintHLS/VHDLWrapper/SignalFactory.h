//
// Created by johannes on 05.12.19.
//

#ifndef DESCAM_SIGNALFACTORY_H
#define DESCAM_SIGNALFACTORY_H

#include <cmath>

#include "OptimizerHLS.h"

namespace DESCAM {
    namespace HLSPlugin {
        namespace VHDLWrapper {

            class SignalFactory {

            public:
                SignalFactory(
                        std::shared_ptr<PropertySuite> &propertySuite,
                        Module *module,
                        std::shared_ptr<OptimizerHLS> &optimizer
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
                static std::string printComponentSignal(const T &signal,
                                                        const std::string &prefix,
                                                        const std::string &direction,
                                                        const bool &addVld = false);

                template<typename T>
                static std::string printPortMapSignal(const T &signal,
                                                      const std::string &delimiter,
                                                      const std::string &prefix,
                                                      const std::string &suffix,
                                                      const bool &addVld = false);

                template<typename T>
                static std::string convertDataTypeName(T *type, const bool &asVector = false);

                static std::string findAssignedValue(const std::shared_ptr<Property> &property,
                                                     const std::shared_ptr<PropertyMacro> &notify);

                static std::string convertReturnType(const DataType &type);

                std::set<Variable *> getInternalRegister() const;

                inline std::shared_ptr<Variable> getActiveOperation() const;

                inline std::set<std::shared_ptr<Variable>> getMonitorSignals() const;

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

                DataType *stateType;
                DataType *operationType;

                std::shared_ptr<PropertySuite> propertySuite;
                Module *module;
                std::shared_ptr<OptimizerHLS> optimizer;

                std::shared_ptr<Variable> activeOperation;
                std::set<std::shared_ptr<Variable>> monitorSignals;
                std::set<Variable *> internalRegisterIn;
                std::set<Variable *> internalRegisterOut;
                std::set<Variable *> outputRegister;
                std::set<DataSignal *> inputs;
                std::set<DataSignal *> outputs;
                std::set<DataSignal *> operationModuleOutputs;
                std::set<DataSignal *> operationModuleInputs;
                std::set<DataSignal *> controlSignals;
                std::set<DataSignal *> handshakingProtocolSignals;

                void generateTypes();

                void setOperationSelector();

                void setControlSignals();

                void setMonitorSignals();

                void splitInputOutput();

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
            std::string SignalFactory::printComponentSignal(const T &signal,
                                                            const std::string &prefix,
                                                            const std::string &direction,
                                                            const bool &addVld) {
                std::stringstream ss;
                const std::string suffix = ((signal->getDataType()->isInteger() || signal->getDataType()->isUnsigned())
                                            ? "_V" : "");
                ss << "\t\t" << prefix << signal->getFullName("_") << suffix << ": "
                   << direction << " " << convertDataTypeName(signal->getDataType(), true) << ";\n";
                if (addVld) {
                    ss << "\t\t" << prefix << signal->getFullName("_") << suffix << "_ap_vld: out std_logic;\n";
                }
                return ss.str();
            }

            template<typename T>
            std::string SignalFactory::printPortMapSignal(const T &signal,
                                                          const std::string &delimiter,
                                                          const std::string &prefix,
                                                          const std::string &suffix,
                                                          const bool &addVld) {
                std::stringstream ss;
                const auto &varSuffix = (signal->getDataType()->isInteger() || signal->getDataType()->isUnsigned()
                                         ? "_V" : "");
                ss << "\t\t" << prefix << signal->getFullName("_") << varSuffix
                   << " => " << (prefix != "ap_" ? prefix : "") << signal->getFullName(delimiter) << suffix << ",\n";
                if (addVld) {
                    ss << "\t\t" << prefix << signal->getFullName("_") << varSuffix << "_ap_vld"
                       << " => " << prefix << signal->getFullName("_") << "_vld,\n";
                }
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

            std::shared_ptr<Variable> SignalFactory::getActiveOperation() const {
                return activeOperation;
            }

            std::set<std::shared_ptr<Variable>> SignalFactory::getMonitorSignals() const {
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
