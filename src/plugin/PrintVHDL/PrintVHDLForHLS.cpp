//
// Created by johannes on 02.11.19.
//

#include <cmath>
#include "ExprVisitor.h"
#include "PrintVHDLForHLS.h"
#include "VHDLPrintVisitor.h"
#include "VisitFunctions.h"
#include "VHDLPrintReset.h"
#include "VHDLPrintResetNotify.h"
#include "VHDLPrintVisitorHLS.h"

PrintVHDLForHLS::PrintVHDLForHLS() :
    propertySuite(nullptr),
    currentModule(nullptr),
    utils(nullptr),
    signalFactory(nullptr)
{
}

std::map<std::string, std::string> PrintVHDLForHLS::printModel(Model *model) {
    // Print types that have to be seen from outside of the provided modules
    for (auto &module : model->getModules()) {
        this->propertySuite = module.second->getPropertySuite();
        this->currentModule = module.second;
        utils = std::make_unique<Utilities>(propertySuite, currentModule);
        signalFactory = std::make_unique<SignalFactory>(propertySuite, currentModule);

        pluginOutput.insert(std::make_pair(model->getName() + "_types.vhd", printTypes(model)));

//        // Print module
        std::stringstream ss;
        ss << printModule(model);

        pluginOutput.insert(std::make_pair(propertySuite->getName() + ".vhd", ss.str()));

        // Clean up for the next module
        ss.str("");
    }
    return pluginOutput;
}

std::string PrintVHDLForHLS::printTypes(Model *model) {
    std::stringstream typeStream;
    typeStream << "-- External data type definition package\n";
    typeStream << "library ieee;\n";
    typeStream << "use ieee.std_logic_1164.all;\n";
    typeStream << "use ieee.numeric_std.all;\n";
    typeStream << "\n";

    typeStream << "package " + model->getName() << "_types is\n\n";

    // Operation enumeration
    typeStream << "\ttype " << propertySuite->getName() << "_operation_t is (";
    for (auto op_it = propertySuite->getOperationProperties().begin(); op_it != propertySuite->getOperationProperties().end(); op_it++) {
        typeStream << "op_" << (*op_it)->getName();
        if (std::next(op_it) != propertySuite->getOperationProperties().end())
            typeStream << ", ";
    }
    if (!propertySuite->getWaitProperties().empty())
        typeStream << ", ";
    for (auto op_it = propertySuite->getWaitProperties().begin(); op_it != propertySuite->getWaitProperties().end(); op_it++) {
        typeStream << "op_" << (*op_it)->getName();
        if (std::next(op_it) != propertySuite->getWaitProperties().end())
            typeStream << ", ";
    }
    typeStream << ");\n";

    // State enumeration
    typeStream << "\ttype " + propertySuite->getName() << "_state_t is (";
    for (auto st_it = propertySuite->getStates().begin(); st_it != propertySuite->getStates().end(); st_it++) {
        typeStream << "st_" << (*st_it)->getName();
        if (std::next(st_it) != propertySuite->getStates().end())
            typeStream << ", ";
    }
    typeStream << ");\n";

    for (auto &reg : propertySuite->getVisibleRegisters()) {
        typeStream << printDataTypes(reg->getDataType());
    }

    for (auto &func : propertySuite->getFunctions()) {
        typeStream << printDataTypes(func->getReturnType());
    }

    typeStream << "\n";

    for (auto &module : model->getModules()) {
        for (auto &port : module.second->getPorts()) {
            typeStream << printDataTypes(port.second->getDataType());
        }
    }

    typeStream << "end package " + model->getName() << "_types;\n\n";
    return typeStream.str();
}

std::string PrintVHDLForHLS::printModule(Model *model) {
    std::stringstream ss;
    ss << "library ieee;\n";
    ss << "use ieee.std_logic_1164.all;\n";
    ss << "use ieee.numeric_std.all;\n";
    ss << "use work.operations;\n";
    ss << "use work." + model->getName() + "_types.all;\n\n";

    ss << "entity " + propertySuite->getName() + "_module is\n";
    ss << "port(\n";

    auto portIt = signalFactory->getAllPorts();
    for (auto signal = portIt.begin(); signal != portIt.end(); ++signal) {
        ss << "\t" << signal->name << "_sig: " << signal->direction << " " << signal->type;
        if (std::next(signal) != portIt.end()) {
            ss << ";\n";
        }
    }

    ss << ");\n";
    ss << "end " + propertySuite->getName() << "_module;\n\n";
    ss << "architecture " << propertySuite->getName() << "_arch of " << propertySuite->getName() << "_module is\n";

    ss << "\n\t-- Input registers\n";
    for (const auto& in : signalFactory->getInputs()) {
        ss << "\tsignal " << in.name << ": " << in.type << ";\n";
    }

    ss << "\n\t-- Output registers\n";
    for (const auto& outputReg : utils->getOutputRegisterParents()) {
        ss << "\tsignal " << outputReg->getName() << ": "
                     << convertDataTypeConstrained(outputReg->getDataType()->getName()) << ";\n";
    }
    for (const auto& notify : signalFactory->getNotify()) {
        ss << "\tsignal " << notify.name << "_reg: " << notify.type << ";\n";
    }

    ss << "\n\t-- HLS module output signals\n";
    for (auto &port :currentModule->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            if (port.second->isCompoundType()) {
                for (auto subVar : port.second->getDataSignal()->getSubVarList()) {
                    ss << "\tsignal " << port.second->getName() << "_sig_" << subVar->getName() << "_out: ";
                    if (subVar->getDataType()->isEnumType()) {
                        ss << convertSignalNames(subVar->getDataType()) << ";\n";
                    } else {
                        ss << convertDataType(subVar->getDataType()->getName()) << ";\n";
                    }
                    ss << "\tsignal " << port.second->getName() << "_sig_" << subVar->getName()
                                 << "_vld: std_logic;\n";
                }
            } else {
                ss << "\tsignal " << port.second->getName() << "_out: ";
                if (port.second->getDataType()->isEnumType()) {
                    ss << convertDataType(port.second->getDataType()->getName()) << ";\n";
                } else {
                    ss << convertDataType(port.second->getDataType()->getName()) << ";\n";
                }
                ss << "\tsignal " << port.second->getName() << "_vld: std_logic;\n";
            }
        }
    }
    for (const auto& notifySignal : signalFactory->getNotify()) {
        ss << "\tsignal " << notifySignal.name << "_out: " << notifySignal.type << ";\n";
        ss << "\tsignal " << notifySignal.name << "_vld: " << notifySignal.type << ";\n";
    }

    ss << "\n\t-- Signals for std_logic_vector conversion\n";
    for (auto &port : currentModule->getPorts()) {
        if (port.second->getInterface()->isInput()) {
            if (port.second->getDataSignal()->isCompoundType()) {
                for (auto subVar : port.second->getDataSignal()->getSubVarList()) {
                    if (subVar->getDataType()->isEnumType()) {
                        ss << "\tsignal " << port.second->getName() << "_sig_" << subVar->getName()
                                     << "_std_logic_vector: "
                                     << convertSignalNames(subVar->getDataType()) << ";\n";
                        enumDataSignal.insert(
                                {subVar->getFullName(),
                                 (port.second->getName() + "_sig_" + subVar->getName() + "_std_logic_vector")}
                        );
                    }
                }
            } else if (port.second->getDataType()->isEnumType()) {
                ss << "\tsignal " << port.second->getName() << "_sig_std_logic_vector: "
                             << convertSignalNames(port.second->getDataType()) << ";\n";
                enumDataSignal.insert(
                        {port.second->getName(),
                         (port.second->getName() + "_sig_std_logic_vector")}
                );
            }
        }
    }
    ss << "\tsignal active_operation_std_logic_vector: " << getOperationVector() << ";\n";

    ss << "\n\t-- Signals for handshaking protocol with hls module\n";
    for (const auto& protocolSignal : signalFactory->getHSProtocolSignals()) {
        ss << "\tsignal " << protocolSignal.name << ": " << protocolSignal.type << ";\n";
    }

    ss << "\n\t-- Monitor signals\n";
    for (const auto& monitorSignal : signalFactory->getMonitorSignals()) {
        ss << "\tsignal " << monitorSignal.name << ": " << monitorSignal.type << ";\n";
    }

    ss << functions();
    ss << printComponent();

    // begin of architecture implementation
    ss << "\nbegin\n";
    ss << printComponentInstantiation();
    ss << printMonitor();
    ss << printOutputProcesses();
    ss << "\n";
    ss << mainProcess();

    return ss.str();
}

std::string PrintVHDLForHLS::functions() {
    std::stringstream functionStream;

    std::set<std::string> functionName;
    for (auto state : propertySuite->getStates()) {
        for (auto property : propertySuite->getSuccessorProperties(state)) {
            for (auto assumption : property->getAssumptionList()) {
                auto functionSet = VisitFunctions::printFunctionNames(assumption);
                functionName.insert(functionSet.begin(), functionSet.end());
            }
        }
    }

    if (propertySuite->getFunctions().empty()) return functionStream.str();

    functionStream << "\n\t-- Functions\n";
    // Print function declarations
    for (auto func_it: propertySuite->getFunctions()) {
        if (functionName.find(func_it->getName()) == functionName.end()) {
            continue;
        }
        functionStream << "\tfunction " + func_it->getName() << "(";

        auto paramMap = func_it->getParamMap();
        for (auto param_it = paramMap.begin(); param_it != paramMap.end(); param_it++) {
            if (param_it->second->getDataType()->isCompoundType()) {
                functionStream << param_it->first << ": " << convertDataType(param_it->second->getDataType()->getName());
            } else {
                functionStream << param_it->first << ": " << convertDataType(param_it->second->getDataType()->getName());
            }
            if (param_it != --paramMap.end())
                functionStream << "; ";
        }
        functionStream << ") return " << convertDataType(func_it->getReturnType()->getName()) << ";\n";
    }
    functionStream << "\n";

    // Print function implementations
    for (auto func_it: propertySuite->getFunctions()) {
        if (functionName.find(func_it->getName()) == functionName.end()) {
            continue;
        }
        functionStream << "\tfunction " + func_it->getName() << "(";

        auto paramMap = func_it->getParamMap();
        for (auto param_it = paramMap.begin(); param_it != paramMap.end(); param_it++) {
            if (param_it->second->getDataType()->isCompoundType()) {
                functionStream << param_it->first << ": " << convertDataType(param_it->second->getDataType()->getName());
            } else {
                functionStream << param_it->first << ": " << convertDataType(param_it->second->getDataType()->getName());
            }
            if (param_it != --paramMap.end())
                functionStream << "; ";
        }
        functionStream << ") return " << convertDataType(func_it->getReturnType()->getName()) << " is\n";
        functionStream << "\tbegin\n";

        if (func_it->getReturnValueConditionList().empty())
            throw std::runtime_error("No return value for function " + func_it->getName() + "()");


        auto returnValueConditionList = func_it->getReturnValueConditionList();
        for (auto retValData = returnValueConditionList.begin(); retValData != returnValueConditionList.end(); retValData++) {
            functionStream << "\t\t";
            if (retValData == --returnValueConditionList.end()) {
                if (returnValueConditionList.size() != 1)
                    functionStream << "else ";
            } else {
                if (retValData == returnValueConditionList.begin()) {
                    functionStream << "if ";
                } else {
                    functionStream << "elsif ";
                }
                for (auto cond = retValData->second.begin(); cond != retValData->second.end(); cond++) {
                    functionStream << VHDLPrintVisitor::toString(*cond);
                    if (cond != --retValData->second.end()) functionStream << " and ";
                }
                functionStream << " then ";
            }
            functionStream << VHDLPrintVisitor::toString(retValData->first) << ";\n";
        }
        if (returnValueConditionList.size() != 1) functionStream << "\t\tend if;\n";
        functionStream << "\tend " + func_it->getName() + ";\n\n";
    }
    return functionStream.str();
}

std::string PrintVHDLForHLS::printComponent() {
    std::stringstream componentStream;

    componentStream << "\n\tcomponent operations is\n";
    componentStream << "\tport(\n";
    for (const auto& controlSignal : signalFactory->getControlSignals()) {
        componentStream << "\t\tap_" << controlSignal.name << ": " << controlSignal.direction
            << " " << controlSignal.type << ";\n";
    }
    for (auto &port : currentModule->getPorts()) {
        std::string direction = port.second->getInterface()->getDirection();
        if (port.second->getDataSignal()->isCompoundType()) {
            for (auto subVar : port.second->getDataSignal()->getSubVarList()) {
                std::string dataType;
                if (subVar->getDataType()->isEnumType()) {
                    dataType = convertSignalNames(subVar->getDataType());
                } else {
                    dataType = convertDataTypeConstrained(subVar->getDataType()->getName());
                }
                componentStream << "\t\t" << port.second->getName() << "_sig_" << subVar->getName();
                if (!subVar->isEnumType()) {
                    componentStream << "_V";
                }
                componentStream << ": " << direction << " " << dataType << ";\n";
                if (port.second->getInterface()->isOutput()) {
                    componentStream << "\t\t" << port.second->getName() << "_sig_" << subVar->getName();
                    if (!subVar->isEnumType()) {
                        componentStream << "_V";
                    }
                    componentStream << "_ap_vld: out std_logic;\n";
                }
            }
        } else {
            std::string dataType;
            if (port.second->getDataType()->isEnumType()) {
                dataType = convertSignalNames(port.second->getDataType());
            } else {
                dataType = convertDataTypeConstrained(port.second->getDataType()->getName());
            }
            componentStream << "\t\t" << port.second->getName() << "_sig";
            if (!port.second->getDataType()->isEnumType()) {
                componentStream << "_V";
            }
            componentStream << ": " << direction << " " << dataType << ";\n";
            if (port.second->getInterface()->isOutput()) {
                componentStream << "\t\t" << port.second->getName();
                if (!port.second->getDataType()->isEnumType()) {
                    componentStream << "_V";
                }
                componentStream << "_ap_vld: out std_logic;\n";
            }

        }
    }
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        componentStream << "\t\t" << notifySignal->getName() << ": out std_logic;\n";
        componentStream << "\t\t" << notifySignal->getName() << "_ap_vld: out std_logic;\n";
    }
    componentStream << "\t\tactiveOperation: in " << getOperationVector() << "\n";
    componentStream << "\t);\nend component;\n";
    return componentStream.str();
}

std::string PrintVHDLForHLS::printComponentInstantiation() {
    std::stringstream instantiationStream;

    instantiationStream << "\toperations_inst: operations\n";
    instantiationStream << "\tport map(\n";
    for (const auto& controlSignal : signalFactory->getControlSignals()) {
        instantiationStream << "\t\tap_" << controlSignal.name << " => " << controlSignal.name << ",\n";
    }
    for (const auto &port : currentModule->getPorts()) {
        if (port.second->getInterface()->isInput()) {
            if (port.second->getDataType()->isCompoundType()) {
                for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                    instantiationStream << "\t\t" << port.second->getName() << "_sig_" << subVar->getName();
                    if (!subVar->isEnumType()) {
                        instantiationStream << "_V";
                    }
                    instantiationStream << " => " << port.second->getName() << "_reg" << "."
                        << subVar->getName() << ",\n";
                }
            } else {
                instantiationStream << "\t\t" << port.second->getName() << "_sig";
                if (!port.second->getDataType()->isEnumType()) {
                    instantiationStream << "_V";
                }
                instantiationStream << " => " << port.second->getName() << "_reg,\n";
            }
        }
    }
    for (const auto &port : currentModule->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            if (port.second->getDataSignal()->isCompoundType()) {
                for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                    instantiationStream << "\t\t" << port.second->getName() << "_sig_" << subVar->getName();
                    if (!subVar->isEnumType()) {
                        instantiationStream << "_V";
                    }
                    instantiationStream << " => " << port.second->getName() << "_sig_" << subVar->getName() << "_out,\n";
                    instantiationStream << "\t\t" << port.second->getName() << "_sig_" << subVar->getName();
                    if (!subVar->isEnumType()) {
                        instantiationStream << "_V";
                    }
                    instantiationStream << "_ap_vld => " << port.second->getName() << "_sig_" << subVar->getName()
                        << "_vld,\n";
//                    auto pos = enumDataSignal.find(subVar->getFullName());
//                    if (pos != enumDataSignal.end()) {
//                        instantiationStream << (*pos).second << ",\n";
//                    } else {
//                        instantiationStream << utils->getOutputToRegisterMap().at(subVar)->getFullName() << ",\n";
//                    }
                }
            } else {
                instantiationStream << "\t\t" << port.second->getName() << "_sig";
                if (!port.second->getDataType()->isEnumType()) {
                    instantiationStream << "_V";
                }
                instantiationStream << " => " << port.second->getName() << "_sig_out,\n";
                instantiationStream << "\t\t" << port.second->getName() << "_sig_";
                if (!port.second->getDataType()->isEnumType()) {
                    instantiationStream << "_V";
                }
                instantiationStream << "_ap_vld => " << port.second->getName() << "_sig_vld,\n";
//                auto pos = enumDataSignal.find(port.second->getName());
//                if (pos != enumDataSignal.end()) {
//                    instantiationStream << (*pos).second << ",\n";
//                } else {
//                    instantiationStream << utils->getOutputToRegisterMap().at(port.second->getDataSignal())->getFullName()
//                        << ",\n";
//                }
            }
        }
    }
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        instantiationStream << "\t\t" << notifySignal->getName() << " => " << notifySignal->getName() << "_out,\n";
        instantiationStream << "\t\t" << notifySignal->getName() << "_ap_vld  => " << notifySignal->getName() << "_vld,\n";
    }
    instantiationStream << "\t\t" << "activeOperation => active_operation_std_logic_vector\n";
    instantiationStream << "\t);\n\n";
    return instantiationStream.str();
}

std::string PrintVHDLForHLS::printMonitor() {
    std::stringstream logicStream;

    logicStream << "\t-- Monitor\n";
    logicStream << "\tprocess (" << printSensitivityList() << ")\n";
    logicStream << "\tbegin\n";
    logicStream << "\t\tcase active_state is\n";

    std::set<std::string> waitStateNames;
    for (auto waitState : propertySuite->getWaitProperties()) {
        waitStateNames.insert(waitState->getName());
    }

    for (auto state_it: propertySuite->getStates()) {
        bool commentOutEndIf = false;
        logicStream << "\t\twhen st_" << state_it->getName() << " =>\n";

        auto op_list = propertySuite->getSuccessorProperties(state_it);
        for (auto op_it = op_list.begin(); op_it != op_list.end(); ++op_it) {
            if (op_it == op_list.begin()) {
                if (op_list.size() == 1) {
                    logicStream << "\t\t\t--if (";
                    commentOutEndIf = true;
                } else {
                    logicStream << "\t\t\tif (";
                }
            } else if (std::next(op_it) == op_list.end()) {
                // make last operation as default, saves some logic
                logicStream << "\t\t\telse--if(";
            } else {
                logicStream << "\t\t\telsif (";
            }
            logicStream << printAssumptions((*op_it)->getAssumptionList());
            logicStream << ") then \n";
            if (waitStateNames.find((*op_it)->getName()) == waitStateNames.end()) {
                logicStream << "\t\t\t\tactive_operation <= op_" << (*op_it)->getName() << ";\n";
                logicStream << "\t\t\t\tnext_state <= st_" << (*op_it)->getNextState()->getName() << ";\n";
                logicStream << "\t\t\t\twait_state <= '0';\n";
            } else {
                logicStream << "\t\t\t\twait_state <= '1';\n";
            }
        }
        if (commentOutEndIf) logicStream << "\t\t\t--end if;\n";
        else logicStream << "\t\t\tend if;\n";

    }
    logicStream << "\t\tend case;\n";
    logicStream << "\tend process;\n\n";

    return logicStream.str();
}

std::string PrintVHDLForHLS::printAssumptions(const std::vector<Expr *> &exprList) {
    std::stringstream assumptionsStream;
    if (exprList.empty()) return "true";
    for (auto it = exprList.begin(); it != exprList.end(); ++it) {
        assumptionsStream << VHDLPrintVisitorHLS::toString(*it);
        if (it != --exprList.end()) {
            assumptionsStream << " and ";
        }
    }
    return assumptionsStream.str();
}

std::string PrintVHDLForHLS::mainProcess() {
    std::stringstream mainProcessStream;

    for (const auto& port : currentModule->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            if (port.second->isCompoundType()) {
                for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                    const auto& pos = enumDataSignal.find(subVar->getFullName());
                    if (pos != enumDataSignal.end()) {
                        mainProcessStream << "\t" << utils->getOutputToRegisterMap().at(subVar)->getFullName()
                            << " <= " << subVar->getDataType()->getName()
                            << "'val(to_integer(unsigned(" << pos->second << ")));\n";
                    }
                }
            } else {
                const auto &pos = enumDataSignal.find(port.second->getName());
                if (pos != enumDataSignal.end()) {
                    mainProcessStream << "\t" << utils->getOutputToRegisterMap().at(port.second->getDataSignal())
                        << " <= " << port.second->getDataType()->getName()
                        << "'val(to_integer(unsigned(" << pos->second << ")));\n";
                }
            }
        }
    }

    mainProcessStream << "\n\tprocess(done)\n";
    mainProcessStream << "\tbegin\n";
    mainProcessStream << "\t\tif (done = '1') then\n";
    for (const auto& vars : utils->getParentMap()) {
        mainProcessStream << "\t\t\t" << vars.first->getFullName() << " <= "
            << vars.second->getFullName() << ";\n";
    }
    mainProcessStream << "\t\tend if;\n";
    mainProcessStream << "\tend process;\n\n";

    mainProcessStream << "\tprocess(rst, done, idle)\n";
    mainProcessStream << "\tbegin\n";
    mainProcessStream << "\t\tif (rst = '1') then\n";
    for (auto commitment : propertySuite->getResetProperty()->getCommitmentList()) {
        std::string assignment = VHDLPrintResetNotify::toString(commitment);
        if (!assignment.empty()) {
            mainProcessStream << "\t\t\t" << assignment;
        }
    }
    mainProcessStream << "\t\telse\n";
    mainProcessStream << "\t\t\tif (done = '1') then\n";
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        mainProcessStream << "\t\t\t\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_reg;\n";
    }
    mainProcessStream << "\t\t\telsif (idle = '1') then\n";
    for (auto port : currentModule->getPorts()) {
        if (port.second->getInterface()->isMasterOut()) {
            mainProcessStream << "\t\t\t\t" << port.second->getName() << "_notify <= '0';\n";
        }
    }
    mainProcessStream << "\t\t\telse\n";
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        mainProcessStream << "\t\t\t\t" << notifySignal->getName() << " <= '0';\n";
    }
    mainProcessStream << "\t\t\tend if;\n";
    mainProcessStream << "\t\tend if;\n";
    mainProcessStream << "\tend process;\n\n";

    mainProcessStream << "\t-- Main process\n";
    mainProcessStream << "\tprocess (clk, rst)\n";
    mainProcessStream << "\tbegin\n";
    mainProcessStream << "\t\tif (rst = '1') then\n";
    mainProcessStream << "\t\t\tstart <= '0';\n";
    mainProcessStream << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getNextState()->getName() << ";\n";
    mainProcessStream << "\t\telsif (clk = '1' and clk'event) then\n";
    mainProcessStream << "\t\t\tif ((idle = '1' or ready = '1') and wait_state = '0') then\n";
    mainProcessStream << "\t\t\t\tstart <= '1';\n";
    mainProcessStream << "\t\t\t\tactive_state <= next_state;\n";
    mainProcessStream << "\t\t\t\tactive_operation_std_logic_vector <= std_logic_vector(to_unsigned("
                      << propertySuite->getName() << "_operation_t'pos(active_operation), "
                      << ceil(log2(propertySuite->getOperationProperties().size())) << "));\n";
    for (auto &port : currentModule->getPorts()) {
        if (port.second->getInterface()->isInput()) {
            if (port.second->getDataType()->isEnumType()) {
                mainProcessStream << "\t\t\t\t" << port.second->getName() << "_reg <= "
                                  << "std_logic_vector(to_unsigned(" << port.second->getDataType()->getName() << "'pos("
                                  << port.second->getName() << "_sig), "
                                  << ceil(log2(port.second->getDataType()->getEnumValueMap().size())) << "));\n";
            } else if (port.second->getDataSignal()->isCompoundType()) {
                for (auto subVar : port.second->getDataSignal()->getSubVarList()) {
                    if (subVar->getDataType()->isEnumType()) {
                        mainProcessStream << "\t\t\t\t" << port.second->getName() << "_reg." << subVar->getName()
                                          << " <= " << "std_logic_vector(to_unsigned(" << subVar->getDataType()->getName()
                                          << "'pos(" << port.second->getName() << "_sig." << subVar->getName() << "), "
                                          << ceil(log2(subVar->getDataType()->getEnumValueMap().size())) << "));\n";
                    } else {
                        mainProcessStream << "\t\t\t\t" << port.second->getName() << "_reg." << subVar->getName()
                                          << " <= " << port.second->getName() << "_sig." << subVar->getName() << ";\n";
                    }
                }
            } else {
                mainProcessStream << "\t\t\t\t" << port.second->getName() << "_reg <= "
                                  << port.second->getName() << "_sig;\n";
            }
        }
    }
    mainProcessStream << "\t\t\telsif ((idle = '1' or  ready = '1') and wait_state = '1') then\n";
    mainProcessStream << "\t\t\t\tstart <= '0';\n";
    mainProcessStream << "\t\t\tend if;\n";
    mainProcessStream << "\t\tend if;\n";
    mainProcessStream << "\tend process;\n\n";
    mainProcessStream << "end " << propertySuite->getName() << "_arch;\n";

    return mainProcessStream.str();
}

std::string PrintVHDLForHLS::printDataTypes(const DataType *dataType) {
    std::stringstream dataTypeStream;

    // this function does not print duplicate data types (it remembers printed data types)
    static std::set<const DataType *> printedTypes;

    if (dataType->isEnumType()) {
        if (printedTypes.find(dataType) == printedTypes.end()) {
            printedTypes.insert(dataType);

            dataTypeStream << "\ttype " << convertDataTypeConstrained(dataType->getName()) << " is (";
            for (auto enumVal = dataType->getEnumValueMap().begin(); enumVal != dataType->getEnumValueMap().end(); enumVal++) {
                dataTypeStream << enumVal->first;
                if (enumVal != --dataType->getEnumValueMap().end()) dataTypeStream << ", ";
            }
            dataTypeStream << ");\n";
        }
    } else if (dataType->isCompoundType()) {
        if (printedTypes.find(dataType) == printedTypes.end()) {
            printedTypes.insert(dataType);
            dataTypeStream << "\ttype " + convertDataTypeConstrained(dataType->getName()) << " is record\n";
            for (auto &subVar: dataType->getSubVarMap()) {
                dataTypeStream << "\t\t" + subVar.first << ": " << convertDataTypeConstrained(subVar.second->getName()) << ";\n";
            }
            dataTypeStream << "\tend record;\n";
        }
    } else if (dataType->isArrayType()) {
        if (printedTypes.find(dataType) == printedTypes.end()) {
            printedTypes.insert(dataType);

            dataTypeStream << "\ttype " << dataType->getName() << " is array (" << (dataType->getSubVarMap().size() - 1)
                           << " downto 0) of " << convertDataTypeConstrained(dataType->getSubVarMap().begin()->second->getName())
                           << ";\n";
        }
    }
    return dataTypeStream.str();
}

std::string PrintVHDLForHLS::printOutputProcesses() {
    std::stringstream outputProcessStream;
    for (const auto& port : currentModule->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            if (port.second->getDataType()->isCompoundType()) {
                for (const auto& subVar: port.second->getDataSignal()->getSubVarList()) {
                    outputProcessStream << "\tprocess(rst, " << port.second->getName() << "_sig_" << subVar->getName()
                        << "_vld)\n";
                    outputProcessStream << "\tbegin\n";
                    outputProcessStream << "\t\tif (rst = \'1\') then\n";
                    outputProcessStream << "\t\t\t" << utils->getOutputToRegisterMap().at(subVar)->getFullName()
                        << " <= " << VHDLPrintVisitorHLS::toString(subVar->getInitialValue()) << ";\n";
                    outputProcessStream << "\t\telsif (" << port.second->getName() << "_sig_" << subVar->getName()
                        << "_vld = '1') then\n";
                    outputProcessStream << "\t\t\t" << utils->getOutputToRegisterMap().at(subVar)->getFullName() << " <= ";
                    if (subVar->isEnumType()) {
                        outputProcessStream << subVar->getDataType()->getName() << "'val(to_integer(unsigned("
                            << port.second->getName() << "_sig_" << subVar->getName() << "_out)));\n";
                    } else {
                        outputProcessStream << port.second->getName() << "_sig_" << subVar->getName() << "_out;\n";
                    }
                    outputProcessStream << "\t\tend if;\n";
                    outputProcessStream << "\tend process;\n\n";
                }
            } else {
                outputProcessStream << "\tprocess(rst, " << port.second->getName() << "_sig_vld)\n";
                outputProcessStream << "\tbegin\n";
                outputProcessStream << "\t\tif (rst = \'1\') then\n";
                outputProcessStream << "\t\t\t" << utils->getOutputToRegisterMap().at(port.second->getDataSignal())->getFullName()
                                    << " <= " << VHDLPrintVisitorHLS::toString(port.second->getDataSignal()->getInitialValue()) << ";\n";
                outputProcessStream << "\t\telsif (" << port.second->getName() << "_sig_vld = '1') then\n";
                outputProcessStream << "\t\t\t" << utils->getOutputToRegisterMap().at(port.second->getDataSignal())->getFullName() << " <= ";
                if (port.second->getDataSignal()->isEnumType()) {
                    outputProcessStream << port.second->getDataType()->getName() << "'val(to_integer(unsigned("
                                        << port.second->getName() << "_sig_out)));\n";
                } else {
                    outputProcessStream << port.second->getName() << "_sig_out;\n";
                }
                outputProcessStream << "\t\tend if;\n";
                outputProcessStream << "\tend process;\n\n";
            }
        }
    }

    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        outputProcessStream << "\tprocess(rst, " << notifySignal->getName() << "_vld)\n";
        outputProcessStream << "\tbegin\n";
        outputProcessStream << "\t\tif (" << notifySignal->getName() << "_vld = '1') then\n";
        outputProcessStream << "\t\t\t" << notifySignal->getName() << "_reg <= " << notifySignal->getName()
            << "_out;\n";
        outputProcessStream << "\t\tend if;\n";
        outputProcessStream << "\tend process;\n\n";
    }

    return outputProcessStream.str();
}

std::string PrintVHDLForHLS::convertSignalNames(const DataType *dataType) {
    std::stringstream vectorStream;
    uint32_t vectorSize = ceil(log2(dataType->getEnumValueMap().size()));
    vectorStream << "std_logic_vector(" << vectorSize - 1 << " downto 0)";
    return vectorStream.str();
}

std::string PrintVHDLForHLS::getOperationVector() {
    uint32_t vectorSize = ceil(log2(propertySuite->getOperationProperties().size()));
    return ("std_logic_vector(" + std::to_string(vectorSize - 1) + " downto 0)");
}

std::string PrintVHDLForHLS::convertDataTypeConstrained(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "std_logic";
    } else if (dataTypeName == "int" || dataTypeName == "unsigned") {
        return "std_logic_vector(31 downto 0)";
    } else if (nullptr != propertySuite && dataTypeName == propertySuite->getName() + "_SECTIONS") {
        return propertySuite->getName() + "_sections_t";
    } else {
        return dataTypeName;
    }
}

std::string PrintVHDLForHLS::convertDataType(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "std_logic";
    } else if (dataTypeName == "int" || dataTypeName == "unsigned") {
        return "std_logic_vector";
    } else if (nullptr != propertySuite && dataTypeName == propertySuite->getName() + "_SECTIONS") {
        return propertySuite->getName() + "_sections_t";
    } else {
        return dataTypeName;
    }
}

std::string PrintVHDLForHLS::printSensitivityList() {
    std::stringstream sensitivityListStream;

    std::set<SyncSignal* > sensListSyncSignals;
    std::set<DataSignal* > sensListDataSignals;
    std::set<Variable* > sensListVars;

    auto operationProperties = propertySuite->getOperationProperties();
    for (auto operationProperty : operationProperties) {
        for (auto assumption_it : operationProperty->getAssumptionList()) {
            auto syncSignals = ExprVisitor::getUsedSynchSignals(assumption_it);
            sensListSyncSignals.insert(syncSignals.begin(), syncSignals.end());

            auto dataSignals = ExprVisitor::getUsedDataSignals(assumption_it);
            sensListDataSignals.insert(dataSignals.begin(), dataSignals.end());

            auto vars = ExprVisitor::getUsedVariables(assumption_it);
            sensListVars.insert(vars.begin(), vars.end());
        }
    }

    auto waitProperties = propertySuite->getWaitProperties();
    for (auto waitProperty : waitProperties) {
        for (auto assumption : waitProperty->getAssumptionList()) {
            auto syncSignals = ExprVisitor::getUsedSynchSignals(assumption);
            sensListSyncSignals.insert(syncSignals.begin(), syncSignals.end());

            auto dataSignals = ExprVisitor::getUsedDataSignals(assumption);
            sensListDataSignals.insert(dataSignals.begin(), dataSignals.end());

            auto vars = ExprVisitor::getUsedVariables(assumption);
            sensListVars.insert(vars.begin(), vars.end());
        }
    }

    sensitivityListStream << "active_state";
    for (auto syncSignals : sensListSyncSignals) {
        sensitivityListStream << ", ";
        sensitivityListStream << VHDLPrintVisitor::toString(syncSignals);
    }

    for (auto dataSignals : sensListDataSignals) {
        sensitivityListStream << ", ";
        sensitivityListStream << dataSignals->getFullName();
    }

    for (auto vars : sensListVars) {
        sensitivityListStream << ", ";
        sensitivityListStream << vars->getFullName();
    }
    return sensitivityListStream.str();
}

void PrintVHDLForHLS::print(std::string& msg) {

}

