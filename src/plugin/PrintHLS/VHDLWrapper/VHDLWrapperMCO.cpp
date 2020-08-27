//
// Created by johannes on 02.11.19.
//

#include "PrintCondition.h"
#include "PrintFunction.h"
#include "PrintReset.h"
#include "Utilities.h"
#include "VHDLWrapperMCO.h"

using namespace DESCAM::HLSPlugin::VHDLWrapper;

VHDLWrapperMCO::VHDLWrapperMCO(
        Module* module,
        const std::string &moduleName,
        std::shared_ptr<PropertySuite> propertySuite,
        std::shared_ptr<OptimizerHLS>& optimizer
)
{
    this->propertySuite = propertySuite;
    this->currentModule = module;
    this->moduleName = moduleName;
    this->optimizer = optimizer;
    this->signalFactory = nullptr;
}

std::map<std::string, std::string> VHDLWrapperMCO::printModule() {
    std::map<std::string, std::string> pluginOutput;
    signalFactory = std::make_unique<SignalFactory>(propertySuite, currentModule, optimizer, false);

    pluginOutput.insert(std::make_pair(moduleName + "_types.vhd", printTypes()));
    pluginOutput.insert(std::make_pair(moduleName + ".vhd", printArchitecture()));

    return pluginOutput;
}

// Print Signals
void VHDLWrapperMCO::signals(std::stringstream &ss) {
    auto printVars = [&ss](
            std::set<Variable *> const& vars,
            Style const& style,
            std::string const& prefix,
            std::string const& suffix,
            bool const& vld,
            bool const& asVector) {
        for (const auto& var : vars) {
            ss << "\tsignal " << prefix << SignalFactory::getName(var, style, suffix) << ": " << SignalFactory::getDataTypeName(var, asVector) << ";\n";
            if (vld) {
                ss << "\tsignal " << prefix << SignalFactory::getName(var, style, "_vld") << ": std_logic;\n";
            }
        }
    };

    auto printSignal = [&ss](
            std::set<DataSignal *> const& signals,
            Style const& style,
            std::string const& suffix,
            bool const& vld,
            bool const& asVector) {
        for (const auto& signal : signals) {
            ss << "\tsignal " << SignalFactory::getName(signal, style, suffix) << ": " << SignalFactory::getDataTypeName(signal, asVector) << ";\n";
            if (vld) {
                ss << "\tsignal " << SignalFactory::getName(signal, style, "_vld") << ": std_logic;\n";
            }
        }
    };

    ss << "\n\t-- Internal Registers\n";
    printVars(Utilities::getParents(signalFactory->getInternalRegister()),
            Style::DOT, "", "", false, false);
    printVars(signalFactory->getInternalRegisterIn(),Style::UL, "in_", "", false, true);
    printVars(signalFactory->getInternalRegisterOut(),Style::UL, "out_", "", true, true);

    ss << "\n\t-- Module Inputs\n";
    printSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()),
            Style::UL, "_in", false, true);
    printVars({signalFactory->getActiveOperation()}, Style::DOT, "", "_in", false, true);

    ss << "\n\t-- Module Outputs\n";
    printSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()),
            Style::UL, "_out", true, true);
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_out: std_logic;\n";
        ss << "\tsignal " << notifySignal->getName() << "_vld: std_logic;\n";
    }
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_reg: std_logic;\n";
    }

    ss << "\n\t-- Handshaking Protocol Signals (Communication between top and operations_inst)\n";
    printSignal(signalFactory->getHandshakingProtocolSignals(), Style::DOT, "_sig", false, false);
    ss << "\n\t-- Monitor Signals\n";
    printVars(signalFactory->getMonitorSignals(), Style::DOT, "", "", false, false);
}

void VHDLWrapperMCO::component(std::stringstream& ss) {
    // Print Component
    ss << "\n\tcomponent " << moduleName << "_operations is\n";
    ss << "\tport(\n";

    auto printComponentSignal = [&ss](std::set<DataSignal *> const& signals, std::string const& prefix, bool const& vld) {
        for (const auto& signal : signals) {
            bool vectorType = signal->getDataType()->isInteger() || signal->getDataType()->isUnsigned();
            std::string suffix = (vectorType ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(signal, Style::UL, suffix) << ": "
               << signal->getPort()->getInterface()->getDirection() << " " << SignalFactory::getDataTypeName(signal, true)
               << ";\n";
            if (vld) {
                ss << "\t\t" << prefix << SignalFactory::getName(signal, Style::UL, suffix + "_ap_vld")
                   << ": out std_logic;\n";
            }
        }
    };

    auto printComponentVars = [&ss](std::set<Variable *> const& vars, std::string const& prefix, bool const& vld) {
        for (const auto& var : vars) {
            std::string type = var->getDataType()->getName();
            std::string suffix = (type=="int" || type=="unsigned" ? "_V" : "");
            ss << "\t\t" << prefix + "_" << SignalFactory::getName(var, Style::UL, suffix) << ": "
               << prefix << " " << SignalFactory::getDataTypeName(var, true)
               << ";\n";
            if (vld) {
                ss << "\t\t" << prefix + "_" << SignalFactory::getName(var, Style::UL, suffix + "_ap_vld")
                   << ": out std_logic;\n";
            }
        }
    };

    printComponentSignal(signalFactory->getControlSignals(), "ap_", false);
    printComponentSignal(signalFactory->getHandshakingProtocolSignals(), "ap_", false);
    printComponentSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()), "", false);
    printComponentSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()), "", true);
    printComponentVars(signalFactory->getInternalRegisterIn(), "in", false);
    printComponentVars(signalFactory->getInternalRegisterOut(), "out", true);

    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << ": out std_logic;\n";
        ss << "\t\t" << notifySignal->getName() << "_ap_vld: out std_logic;\n";
    }

    const auto& activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << ": in " << SignalFactory::getDataTypeName(activeOp, true) << "\n";

    ss << "\t);\n"
       << "\tend component;\n";
}

// Print Component Instantiation
void VHDLWrapperMCO::componentInst(std::stringstream& ss) {
    ss << "\toperations_inst: " << moduleName << "_operations\n"
       << "\tport map(\n";

    auto printComponentInstSignal = [&ss](
            std::set<DataSignal *> const& signals,
            std::string const& prefix,
            std::string const& suffix,
            bool const& vld) {
        for (const auto& signal : signals) {
            std::string type = signal->getDataType()->getName();
            std::string moduleSuffix = (type == "int" || type == "unsigned" ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(signal, Style::UL, moduleSuffix) << " => "
               << SignalFactory::getName(signal, Style::UL, suffix) << ",\n";
            if (vld) {
                ss << "\t\t" << prefix << SignalFactory::getName(signal, Style::UL, moduleSuffix + "_ap_vld")
                   << " => " << SignalFactory::getName(signal, Style::UL, "_vld") << ",\n";
            }
        }
    };

    auto printComponentInstVars = [&ss](std::set<Variable *> const& vars, std::string const& prefix, bool const& vld) {
        for (const auto& var : vars) {
            std::string type = var->getDataType()->getName();
            std::string suffix = (type=="int" || type=="unsigned" ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(var, Style::UL, suffix) << " => "
               << prefix << SignalFactory::getName(var, Style::UL, "") << ",\n";
            if (vld) {
                ss << "\t\t" << prefix << SignalFactory::getName(var, Style::UL, suffix + "_ap_vld")
                   << " => " << prefix << SignalFactory::getName(var, Style::UL, "_vld") << ",\n";
            }
        }
    };

    printComponentInstSignal(signalFactory->getControlSignals(), "ap_", "", false);
    printComponentInstSignal(signalFactory->getHandshakingProtocolSignals(), "ap_", "_sig", false);
    printComponentInstSignal(Utilities::getSubVars(signalFactory->getOperationModuleInputs()), "", "_in", false);
    printComponentInstSignal(Utilities::getSubVars(signalFactory->getOperationModuleOutputs()), "", "_out", true);
    printComponentInstVars(signalFactory->getInternalRegisterIn(), "in_", false);
    printComponentInstVars(signalFactory->getInternalRegisterOut(), "out_", true);

    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << " => " << notifySignal->getName() << "_out,\n";
        ss << "\t\t" << notifySignal->getName() << "_ap_vld  => " << notifySignal->getName() << "_vld,\n";
    }

    const auto& activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << " => " << SignalFactory::getName(activeOp, Style::UL, "_in") << "\n"
       << "\t);\n\n";
}

// Print Monitor
void VHDLWrapperMCO::monitor(std::stringstream &ss) {
    ss << "\t-- Monitor\n"
       << "\tprocess (" << sensitivityList() << ")\n"
       << "\tbegin\n"
       << "\t\tcase active_state is\n";

    auto printAssumptions = [&ss](std::vector<Expr* > exprList) {
        if (exprList.empty()) {
            ss << "true";
        }
        for (auto expr = exprList.begin(); expr != exprList.end(); ++expr) {
            ss << PrintCondition::toString(*expr);
            if (std::next(expr) != exprList.end()) {
                ss << " and ";
            }
        }
    };

    for (const auto& state : currentModule->getFSM()->getStateMap()) {
        if (state.second->isInit()) {
            continue;
        }
        bool noEndIf = false;
        bool skipAssumptions = false;
        ss << "\t\twhen st_" << state.second->getName() << " =>\n";
        auto operations = state.second->getOutgoingOperationsList();
        for (auto operation = operations.begin(); operation != operations.end(); ++operation) {
            if (operation == operations.begin()) {
                if (operations.size() == 1) {
                    noEndIf = true;
                    skipAssumptions = true;
                } else {
                    ss << "\t\t\tif (";
                }
            } else if (std::next(operation) == operations.end()) {
                ss << "\t\t\telse\n";
                skipAssumptions = true;
            } else {
                ss << "\t\t\telsif (";
            }
            if (!skipAssumptions) {
                printAssumptions((*operation)->getAssumptionsList());
                ss << ") then \n";
            }
            if (!(*operation)->IsWait()) {
                const std::string& stateName = (*operation)->getState()->getName();
                const std::string& nextStateName = (*operation)->getNextState()->getName();
                const std::string operationName = stateName + "_" + std::to_string((*operation)->getId());

                ss << "\t\t\t\tactive_operation <= op_" << operationName << ";\n"
                   << "\t\t\t\tnext_state <= st_" << nextStateName << ";\n"
                   << "\t\t\t\twait_state <= '0';\n";
            } else {
                ss << "\t\t\t\twait_state <= '1';\n";
            }
        }
        if (!noEndIf) {
            ss << "\t\t\tend if;\n";
        }
    }
    ss << "\t\tend case;\n"
       << "\tend process;\n\n";
}

void VHDLWrapperMCO::moduleOutputHandling(std::stringstream& ss)
{
    // Print Output_Vld Processes
    auto printOutputProcess = [&](DataSignal* dataSignal) {
        bool hasOutputReg = optimizer->hasOutputReg(dataSignal);
        bool isEnum = dataSignal->isEnumType();
        ss << "\tprocess (rst, " << SignalFactory::getName(dataSignal, Style::UL, "_vld") << ")\n"
           << "\tbegin\n"
           << "\t\tif (rst = \'1\') then\n"
           << "\t\t\t" << (hasOutputReg ? optimizer->getCorrespondingRegister(dataSignal)->getFullName() : SignalFactory::getName(dataSignal, Style::DOT))
           << " <= " << getResetValue(dataSignal) << ";\n"
           << "\t\telsif (" << SignalFactory::getName(dataSignal, Style::UL, "_vld") << " = \'1\') then\n"
           << "\t\t\t" << (hasOutputReg ? optimizer->getCorrespondingRegister(dataSignal)->getFullName() : SignalFactory::getName(dataSignal, Style::DOT))
           << " <= " << (isEnum ? SignalFactory::vectorToEnum(dataSignal, "_out") : SignalFactory::getName(dataSignal, Style::UL, "_out")) << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    };
    ss << "\t-- Output_Vld Processes\n";
    for (const auto& out : Utilities::getSubVars(signalFactory->getOperationModuleOutputs())) {
        printOutputProcess(out);
    }

    auto printOutputProcessRegs = [&](Variable* var) {
        bool isEnum = var->isEnumType();
        ss << "\tprocess (rst, out_" << SignalFactory::getName(var, Style::UL, "_vld") << ")\n"
           << "\tbegin\n"
           << "\t\tif (rst = \'1\') then\n"
           << "\t\t\t" << SignalFactory::getName(var, Style::DOT) << " <= " << getResetValue(var) << ";\n"
           << "\t\telsif (out_" << SignalFactory::getName(var, Style::UL, "_vld") << " = \'1\') then\n"
           << "\t\t\t" << SignalFactory::getName(var, Style::DOT) << " <= " << (isEnum ?
                                                                                SignalFactory::vectorToEnum(var, "", "out_") :
                                                                                "out_" + SignalFactory::getName(var, Style::UL, "")) << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    };

    std::set<Variable * > inOutReg;
    for (const auto& internalRegsOut : signalFactory->getInternalRegisterOut()) {
        auto internalRegsIn = signalFactory->getInternalRegisterIn();
        if (internalRegsIn.find(internalRegsOut) != internalRegsIn.end()) {
            inOutReg.insert(internalRegsOut);
            continue;
        }
        printOutputProcessRegs(internalRegsOut);
    }

    for (const auto& reg : inOutReg) {
        bool isEnum = reg->isEnumType();
        std::string signalIn;
        std::string signalOut;
        if (isEnum) {
            signalIn = SignalFactory::vectorToEnum(reg, "", "in_");
            signalOut = SignalFactory::vectorToEnum(reg, "", "out_");
        } else {
            signalIn = "in_" + SignalFactory::getName(reg, Style::UL);
            signalOut = "out_" + SignalFactory::getName(reg, Style::UL);
        }
        ss << "\twith out_" << SignalFactory::getName(reg, Style::UL, "_vld") << " select\n"
           << "\t\t" << SignalFactory::getName(reg, Style::DOT) << " <= " << signalIn << " when '0',\n"
           << "\t\t\t" << signalOut << " when others;\n\n";
    }

    for (const auto& reg : inOutReg) {
        bool isEnum = reg->isEnumType();
        std::string SignalRegister;
        std::string SignalReset;
        if (isEnum) {
            SignalRegister = SignalFactory::enumToVector(reg);
            SignalReset = SignalRegister;
            std::string replaceWith = getResetValue(reg);
            std::string toReplace = SignalFactory::getName(reg, Style::DOT);
            SignalReset.replace(SignalReset.find(toReplace), toReplace.length(), replaceWith);
        } else {
            SignalRegister = SignalFactory::getName(reg, Style::DOT);
            SignalReset = getResetValue(reg);
        }
        ss << "\tprocess(clk, rst)\n"
           << "\tbegin\n"
           << "\t\tif (rst = '1') then\n"
           << "\t\t\tin_" << SignalFactory::getName(reg, Style::UL) << " <= " << SignalReset << ";\n"
           << "\t\telsif (clk = '1' and clk'event) then\n"
           << "\t\t\tin_" << SignalFactory::getName(reg, Style::UL) << " <= " << SignalRegister << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    }

    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tprocess(" << notifySignal->getName() << "_vld)\n"
           << "\tbegin\n"
           << "\t\tif (" << notifySignal->getName() << "_vld = '1') then\n"
           << "\t\t\t" << notifySignal->getName() << "_reg <= " << notifySignal->getName() << "_out;\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    }

    // Print Output Processes
    ss << "\t-- Output Processes\n"
       << "\tprocess(rst, done_sig)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (const auto& registerOutputMap : optimizer->getOutputRegisterMap()) {
        if (optimizer->hasMultipleOutputs(registerOutputMap.second)) {
            for (const auto& output : optimizer->getCorrespondingTopSignals(registerOutputMap.second)) {
                if (output->isCompoundType()) {
                    for (const auto& subVar : output->getSubVarList()) {
                        ss << "\t\t\t" << SignalFactory::getName(subVar, Style::DOT) << " <= " << getResetValue(subVar) << ";\n";
                    }
                } else {
                    ss << "\t\t\t" << SignalFactory::getName(registerOutputMap.second, Style::DOT) << " <= "
                       << getResetValue(registerOutputMap.second) << ";\n";
                }
            }
        } else {
            if (registerOutputMap.second->isCompoundType()) {
                for (const auto& subVar : registerOutputMap.second->getSubVarList()) {
                    ss << "\t\t\t" << SignalFactory::getName(subVar, Style::DOT) << " <= " << getResetValue(subVar) << ";\n";
                }
            } else {
                ss << "\t\t\t" << SignalFactory::getName(registerOutputMap.second, Style::DOT) << " <= "
                   << getResetValue(registerOutputMap.second) << ";\n";
            }
        }
    }
    ss << "\t\telsif (done_sig = '1') then\n";
    for (const auto& registerOutputMap : optimizer->getOutputRegisterMap()) {
        if (optimizer->hasMultipleOutputs(registerOutputMap.second)) {
            for (const auto& output : optimizer->getCorrespondingTopSignals(registerOutputMap.second)) {
                ss << "\t\t\t" << output->getFullName() << " <= " << registerOutputMap.first->getFullName() << ";\n";
            }
        } else {
            ss << "\t\t\t" << registerOutputMap.second->getFullName() << " <= " << registerOutputMap.first->getFullName() << ";\n";
        }
    }
    ss << "\t\tend if;\n"
       << "\tend process;\n\n";

    ss << "\tprocess(rst, done_sig, idle_sig)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (const auto& commitment : propertySuite->getResetProperty()->getCommitmentList()) {
        std::string assignment = PrintResetNotify::toString(commitment->getStatement());
        if (!assignment.empty()) {
            ss << "\t\t\t" << assignment;
        }
    }
    ss << "\t\telse\n"
       << "\t\t\tif (done_sig = '1') then\n";
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t\t\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_reg;\n";
    }
    ss << "\t\t\telsif (idle_sig = '1') then\n";
    for (const auto& port : currentModule->getPorts()) {
        if (port.second->getInterface()->isMasterOut()) {
            ss << "\t\t\t\t" << port.second->getName() << "_notify <= '0';\n";
        }
    }
    ss << "\t\t\telse\n";
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t\t\t" << notifySignal->getName() << " <= '0';\n";
    }
    ss << "\t\t\tend if;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
}

void VHDLWrapperMCO::controlProcess(std::stringstream& ss)
{
    auto printModuleInputSignals = [this, &ss](std::set<DataSignal*> const& dataSignals) {
        for (const auto& dataSignal : dataSignals) {
            if (!dataSignal->getPort()->isArrayType()) {
                ss << "\t\t\t\t" << SignalFactory::getName(dataSignal, Style::UL) << "_in <= "
                   << (dataSignal->isEnumType() ?
                       SignalFactory::enumToVector(dataSignal) :
                       SignalFactory::getName(dataSignal, Style::DOT))
                   << ";\n";
            }
        }
    };

    auto printModuleInputVars = [&ss](Variable* var, std::string const& prefix, std::string const& suffix) {
        ss << "\t\t\t\t" << prefix << SignalFactory::getName(var, Style::UL) << suffix << " <= "
           << (
//               var->isEnumType() ?
//               SignalFactory::enumToVector(var) :
               SignalFactory::getName(var, Style::DOT))
           << ";\n";
    };

    // Print Control Process
    ss << "\t-- Control process\n"
       << "\tprocess (clk, rst)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n"
       << "\t\t\tstart_sig <= '0';\n"
       << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getOperation()->getNextState()->getName() << ";\n"
       << "\t\telsif (clk = '1' and clk'event) then\n"
       << "\t\t\tif ((idle_sig = '1' or ready_sig = '1') and wait_state = '0') then\n"
       << "\t\t\t\tstart_sig <= '1';\n"
       << "\t\t\t\tactive_state <= next_state;\n";

    printModuleInputVars({signalFactory->getActiveOperation()}, "" , "_in");
    printModuleInputSignals(Utilities::getSubVars(signalFactory->getOperationModuleInputs()));

    for (auto&& internalRegIn : signalFactory->getInternalRegisterIn()) {
        auto internalRegsOut = signalFactory->getInternalRegisterOut();
        if (internalRegsOut.find(internalRegIn) != internalRegsOut.end()) {
            continue;
        }
        printModuleInputVars(internalRegIn, "in_", "");
    }

    for (const auto &arrayPort : optimizer->getArrayPorts()) {
        uint32_t exprNumber = 0;
        for (const auto &expr : arrayPort.second) {
            ss << "\t\t\t\t" << arrayPort.first->getDataSignal()->getName() << "_" << exprNumber << "_in"
               << " <= " << arrayPort.first->getDataSignal()->getName() << "(to_integer(unsigned("
               << PrintFunction::toString(expr) << ")));\n";
            exprNumber++;
        }
    }

    ss << "\t\t\telsif ((idle_sig = '1' or  ready_sig = '1') and wait_state = '1') then\n"
       << "\t\t\t\tstart_sig <= '0';\n"
       << "\t\t\tend if;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";
}
