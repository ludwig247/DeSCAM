//
// Created by johannes on 02.11.19.
//

#include "ExprVisitor.h"
#include "PrintVHDLForHLS.h"
#include "VHDLPrintVisitor.h"
#include "VHDLPrintResetNotify.h"
#include "VHDLPrintVisitorHLS.h"
#include "OtherUtils.h"

using namespace SCAM::VHDL;

PrintVHDLForHLS::PrintVHDLForHLS() :
    propertySuite(nullptr),
    currentModule(nullptr),
    hlsModule(nullptr)
{
}

std::map<std::string, std::string> PrintVHDLForHLS::printModel(Model *model) {
    for (auto &module : model->getModules()) {
        this->propertySuite = module.second->getPropertySuite();
        this->currentModule = module.second;
        hlsModule = std::make_unique<HLSmodule>(propertySuite, currentModule);
        signalFactory = std::make_unique<SignalFactory>(propertySuite, currentModule, hlsModule.get());

        pluginOutput.insert(std::make_pair(model->getName() + "_types.vhd", printTypes(model)));
        pluginOutput.insert(std::make_pair(propertySuite->getName() + ".vhd", printModule(model)));
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
    typeStream << "\t-- Operations\n"
               << "\ttype " << propertySuite->getName() << "_operation_t is (";
    for (auto op = propertySuite->getOperationProperties().begin(); op != propertySuite->getOperationProperties().end(); ++op) {
        typeStream << "op_" << (*op)->getName();
        if (std::next(op) != propertySuite->getOperationProperties().end())
            typeStream << ", ";
    }
    typeStream << ");\n\n";

    // State enumeration
    typeStream << "\t -- States\n"
               << "\ttype " + propertySuite->getName() << "_state_t is (";
    for (auto state = propertySuite->getStates().begin(); state != propertySuite->getStates().end(); ++state) {
        typeStream << "st_" << (*state)->getName();
        if (std::next(state) != propertySuite->getStates().end())
            typeStream << ", ";
    }
    typeStream << ");\n\n";

    std::set<const DataType *> enumTypes;
    std::set<const DataType *> compoundTypes;
    std::set<const DataType *> arrayTypes;

    auto fillTypeSets = [&enumTypes, &compoundTypes, &arrayTypes](const DataType* dataType) {
        if (dataType->isEnumType()) {
            enumTypes.insert(dataType);
        } else if (dataType->isCompoundType()) {
            compoundTypes.insert(dataType);
        }
        else if (dataType->isArrayType()) {
            arrayTypes.insert(dataType);
        }
    };

    for (const auto& reg : propertySuite->getVisibleRegisters()) {
        fillTypeSets(reg->getDataType());
    }
    for (const auto& func : propertySuite->getFunctions()) {
        fillTypeSets(func->getReturnType());
    }
    for (const auto& module : model->getModules()) {
        for (auto &port : module.second->getPorts()) {
            if (port.second->isCompoundType()) {
                for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                    fillTypeSets(subVar->getDataType());
                }
            }
            fillTypeSets(port.second->getDataType());
        }
    }
    for (const auto& var : currentModule->getVariableMap()) {
        fillTypeSets(var.second->getDataType());
    }

    typeStream << "\t-- Enum Types\n";
    for (const auto& type : enumTypes) {
        typeStream << printDataTypes(type);
    }

    typeStream << "\n"
               << "\t-- Compound Types\n";
    for (const auto& type : compoundTypes) {
        typeStream << printDataTypes(type);
    }

    typeStream << "\n"
               << "\t-- Array Types\n";
    for (const auto& type : arrayTypes) {
        typeStream << printDataTypes(type);
    }

    typeStream << "\n"
               << "end package " + model->getName() << "_types;";
    return typeStream.str();
}

std::string PrintVHDLForHLS::printModule(Model *model) {
    std::stringstream ss;

    // Print Include
    ss << "library ieee;\n";
    ss << "use ieee.std_logic_1164.all;\n";
    ss << "use ieee.numeric_std.all;\n";
    ss << "use work.operations;\n";
    ss << "use work." + model->getName() + "_types.all;\n\n";

    entity(ss);

    ss << "architecture " << propertySuite->getName() << "_arch of " << propertySuite->getName() << "_module is\n";

    signals(ss);
    functions(ss);
    component(ss);

    // begin of architecture implementation
    ss << "\nbegin\n\n";

    componentInst(ss);
    monitor(ss);

    // Print Output_Vld Processes
    auto printOutputProcess = [&](DataSignal* dataSignal) {
        bool hasOutputReg = hlsModule->hasOutputReg(dataSignal);
        bool isEnum = dataSignal->isEnumType();
        ss << "\tprocess (rst, " << SignalFactory::getName(dataSignal, Style::UL, "_vld") << ")\n"
           << "\tbegin\n"
           << "\t\tif (rst = \'1\') then\n"
           << "\t\t\t" << (hasOutputReg ? hlsModule->getCorrespondingRegister(dataSignal)->getFullName() : SignalFactory::getName(dataSignal, Style::DOT))
           << " <= " << VHDLPrintVisitorHLS::toString(dataSignal->getInitialValue()) << ";\n"
           << "\t\telsif (" << SignalFactory::getName(dataSignal, Style::UL, "_vld") << " = \'1\') then\n"
           << "\t\t\t" << (hasOutputReg ? hlsModule->getCorrespondingRegister(dataSignal)->getFullName() : SignalFactory::getName(dataSignal, Style::DOT))
           << " <= " << (isEnum ? SignalFactory::vectorToEnum(dataSignal, "_out") : SignalFactory::getName(dataSignal, Style::UL, "_out")) << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    };
    ss << "\t-- Output_Vld Processes\n";
    for (const auto& out : OtherUtils::getSubVars(signalFactory->getOperationModuleOutputs())) {
        printOutputProcess(out);
    }

    auto printOutputProcessRegs = [&](Variable* var) {
        bool isEnum = var->isEnumType();
        ss << "\tprocess (rst, out_" << SignalFactory::getName(var, Style::UL, "_vld") << ")\n"
           << "\tbegin\n"
           << "\t\tif (rst = \'1\') then\n"
           << "\t\t\t" << SignalFactory::getName(var, Style::DOT) << " <= " << VHDLPrintVisitorHLS::toString(var->getInitialValue()) << ";\n"
           << "\t\telsif (out_" << SignalFactory::getName(var, Style::UL, "_vld") << " = \'1\') then\n"
           << "\t\t\t" << SignalFactory::getName(var, Style::DOT) << " <= " << (isEnum ?
                                                SignalFactory::vectorToEnum(var, "", "out_") :
                                                "out_" + SignalFactory::getName(var, Style::UL, "")) << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    };
    for (const auto& internalRegs : signalFactory->getInternalRegisterOut()) {
        printOutputProcessRegs(internalRegs);
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
    for (const auto& out : OtherUtils::getSubVars(signalFactory->getOutputs())) {
//        if (hlsModule->hasOutputReg(out)) {
            ss << "\t\t\t" << SignalFactory::getName(out, Style::DOT) << " <= "
               << VHDLPrintVisitorHLS::toString(out->getInitialValue()) << ";\n";
//        }
    }
    ss << "\t\telsif (done_sig = '1') then\n";
    for (const auto& out : signalFactory->getOperationModuleOutputs()) {
        if (hlsModule->hasOutputReg(out)) {
            if (hlsModule->isModuleSignal(out)) {
                for (const auto& sig : hlsModule->getCorrespondingTopSignals(out)) {
                    ss << "\t\t\t" << sig->getFullName() << " <= " << hlsModule->getCorrespondingRegister(out)->getFullName() << ";\n";
                }
            } else {
                ss << "\t\t\t" << out->getFullName() << " <= " << hlsModule->getCorrespondingRegister(out)->getFullName() << ";\n";
            }
        }
    }
    ss << "\t\tend if;\n"
       << "\tend process;\n\n";

    ss << "\tprocess(rst, done_sig, idle_sig)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (const auto& commitment : propertySuite->getResetProperty()->getCommitmentList()) {
        std::string assignment = VHDLPrintResetNotify::toString(commitment);
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

    auto printModuleInputSignals = [&ss](std::set<DataSignal*> const& dataSignals) {
        for (const auto& dataSignal : dataSignals) {
            ss << "\t\t\t\t" << SignalFactory::getName(dataSignal, Style::UL) << "_in <= "
               << (dataSignal->isEnumType() ?
                   SignalFactory::enumToVector(dataSignal) :
                   SignalFactory::getName(dataSignal, Style::DOT))
               << ";\n";
        }
    };

    auto printModuleInputVars = [&ss](std::set<Variable*> const& vars, std::string const& prefix, std::string const& suffix) {
        for (const auto& var : vars) {
            ss << "\t\t\t\t" << prefix << SignalFactory::getName(var, Style::UL) << suffix << " <= "
               << (var->isEnumType() ?
                   SignalFactory::enumToVector(var) :
                   SignalFactory::getName(var, Style::DOT))
               << ";\n";
        }
    };

    // Print Control Process
    ss << "\t-- Control process\n"
       << "\tprocess (clk, rst)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n"
       << "\t\t\tstart_sig <= '0';\n"
       << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getNextState()->getName() << ";\n"
       << "\t\telsif (clk = '1' and clk'event) then\n"
       << "\t\t\tif ((idle_sig = '1' or ready_sig = '1') and wait_state = '0') then\n"
       << "\t\t\t\tstart_sig <= '1';\n"
       << "\t\t\t\tactive_state <= next_state;\n";

    printModuleInputVars({signalFactory->getActiveOperation()}, "" , "_in");
    printModuleInputSignals(OtherUtils::getSubVars(signalFactory->getOperationModuleInputs()));
    printModuleInputVars(signalFactory->getInternalRegisterIn(), "in_", "");

    ss << "\t\t\telsif ((idle_sig = '1' or  ready_sig = '1') and wait_state = '1') then\n"
       << "\t\t\t\tstart_sig <= '0';\n"
       << "\t\t\tend if;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n"
       << "end " << propertySuite->getName() << "_arch;\n";

    return ss.str();
}

void PrintVHDLForHLS::entity(std::stringstream &ss) {
    // Print Entity
    ss << "entity " + propertySuite->getName() + "_module is\n";
    ss << "port(\n";

    auto printPortSignals = [&ss](std::set<DataSignal* > const& dataSignals, bool lastSet) {
        for (auto dataSignal = dataSignals.begin(); dataSignal != dataSignals.end(); ++dataSignal) {
            ss << "\t" << (*dataSignal)->getFullName() << ": " << (*dataSignal)->getPort()->getInterface()->getDirection()
               << " " << SignalFactory::getDataTypeName(*dataSignal, false);
            if (std::next(dataSignal) != dataSignals.end() || !lastSet) {
                ss << ";\n";
            }
        }
    };
    printPortSignals(signalFactory->getInputs(), false);
    printPortSignals(signalFactory->getOutputs(), false);
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << ": out std_logic;\n";
    }
    for (const auto syncSignal : propertySuite->getSyncSignals()) {
        ss << "\t" << syncSignal->getName() << ": in std_logic;\n";
    }
    printPortSignals(signalFactory->getControlSignals(), true);

    ss << "\n);\n";
    ss << "end " + propertySuite->getName() << "_module;\n\n";
}

// Print Signals
void PrintVHDLForHLS::signals(std::stringstream &ss) {
    auto printVars = [&ss](
            std::set<Variable *> const& vars,
            Style const& style,
            std::string const& prefix,
            std::string const& suffix,
            bool const& vld,
            bool const& asVector) {
        for (const auto& var : vars) {
            ss << "\tsignal " << prefix << SignalFactory::getName(var, style, suffix)
               << ": " << SignalFactory::getDataTypeName(var, asVector) << ";\n";
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
            ss << "\tsignal " << SignalFactory::getName(signal, style, suffix)
               << ": " << SignalFactory::getDataTypeName(signal, asVector) << ";\n";
            if (vld) {
                ss << "\tsignal " << SignalFactory::getName(signal, style, "_vld") << ": std_logic;\n";
            }
        }
    };

    ss << "\n\t-- Internal Registers\n";
    printVars(OtherUtils::getParents(signalFactory->getInternalRegister()),
            Style::DOT, "", "", false, false);
    printVars(signalFactory->getInternalRegisterIn(),Style::UL, "in_", "", false, true);
    printVars(signalFactory->getInternalRegisterOut(),Style::UL, "out_", "", true, true);

    ss << "\n\t-- Input Registers\n";
    printSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleInputs()),
            Style::UL, "_in", false, true);
    printVars({signalFactory->getActiveOperation()}, Style::DOT, "", "_in", false, true);

    ss << "\n\t-- Output Register\n";
    printVars(signalFactory->getOutputRegister(), Style::DOT, "", "", false, false);
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_reg: std_logic;\n";
    }

    ss << "\n\t-- Module Outputs\n";
    printSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleOutputs()),
            Style::UL, "_out", true, true);
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_out: std_logic;\n";
        ss << "\tsignal " << notifySignal->getName() << "_vld: std_logic;\n";
    }

    ss << "\n\t-- Handshaking Protocol Signals (Communication between top and operations_inst)\n";
    printSignal(signalFactory->getHandshakingProtocolSignals(), Style::DOT, "_sig", false, false);
    ss << "\n\t-- Monitor Signals\n";
    printVars(signalFactory->getMonitorSignals(), Style::DOT, "", "", false, false);
}

void PrintVHDLForHLS::component(std::stringstream& ss) {
    // Print Component
    ss << "\n\tcomponent operations is\n";
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
    printComponentSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleInputs()), "", false);
    printComponentSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleOutputs()), "", true);
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
void PrintVHDLForHLS::componentInst(std::stringstream& ss) {
    ss << "\toperations_inst: operations\n"
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
    printComponentInstSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleInputs()), "", "_in", false);
    printComponentInstSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleOutputs()), "", "_out", true);
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
void PrintVHDLForHLS::monitor(std::stringstream &ss) {
    ss << "\t-- Monitor\n"
       << "\tprocess (" << printSensitivityList() << ")\n"
       << "\tbegin\n"
       << "\t\tcase active_state is\n";

    std::set<std::string> waitStateNames;
    for (auto waitState : propertySuite->getWaitProperties()) {
        waitStateNames.insert(waitState->getName());
    }

    auto printAssumptions = [&ss](std::vector<Expr* > exprList) {
        if (exprList.empty()) {
            ss << "true";
        }
        for (auto expr = exprList.begin(); expr != exprList.end(); ++expr) {
            ss << VHDLPrintVisitorHLS::toString(*expr);
            if (std::next(expr) != exprList.end()) {
                ss << " and ";
            }
        }
    };

    for (const auto& state : propertySuite->getStates()) {
        bool noEndIf = false;
        bool skipAssumptions = false;
        ss << "\t\twhen st_" << state->getName() << " =>\n";
        auto properties = propertySuite->getSuccessorProperties(state);
        for (auto property = properties.begin(); property != properties.end(); ++property) {
            if (property == properties.begin()) {
                if (properties.size() == 1) {
                    noEndIf = true;
                } else {
                    ss << "\t\t\tif (";
                }
            } else if (std::next(property) == properties.end()) {
                ss << "\t\t\telse\n";
                skipAssumptions = true;
            } else {
                ss << "\t\t\telsif (";
            }
            if (!skipAssumptions) {
                printAssumptions((*property)->getAssumptionList());
                ss << ") then \n";
            }
            if (waitStateNames.find((*property)->getName()) == waitStateNames.end()) {
                ss << "\t\t\t\tactive_operation <= op_" << (*property)->getName() << ";\n"
                   << "\t\t\t\tnext_state <= st_" << (*property)->getNextState()->getName() << ";\n"
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

void PrintVHDLForHLS::functions(std::stringstream &ss) {
    std::set<Function* > usedFunctions;
    for (const auto& state : propertySuite->getStates()) {
        for (const auto& property : propertySuite->getSuccessorProperties(state)) {
            for (const auto& assumption : property->getAssumptionList()) {
                const auto& funcSet = ExprVisitor::getUsedFunctions(assumption);
                usedFunctions.insert(funcSet.begin(), funcSet.end());
            }
        }
    }

    if (propertySuite->getFunctions().empty()) return;

    ss << "\n\t-- Functions\n";
    for (const auto& func : usedFunctions) {
        ss << "\tfunction " + func->getName() << "(";

        const auto& paramMap = func->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); param++) {
            ss << param->first << ": " << SignalFactory::convertDataType(param->second->getDataType()->getName());
            if (std::next(param) != paramMap.end())
                ss << "; ";
        }
        ss << ") return " << SignalFactory::convertReturnType(func->getReturnType()->getName()) << ";\n";
    }
    ss << "\n";

    for (const auto& func : usedFunctions) {
        ss << "\tfunction " + func->getName() << "(";

        auto paramMap = func->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); param++) {
            ss << param->first << ": " << SignalFactory::convertDataType(param->second->getDataType()->getName());
            if (std::next(param) != paramMap.end())
                ss << "; ";
        }
        ss << ") return " << SignalFactory::convertReturnType(func->getReturnType()->getName()) << " is\n";
        ss << "\tbegin\n";

        if (func->getReturnValueConditionList().empty())
            throw std::runtime_error("No return value for function " + func->getName() + "()");

        auto returnValueConditionList = func->getReturnValueConditionList();
        for (auto retValData = returnValueConditionList.begin(); retValData != returnValueConditionList.end(); retValData++) {
            ss << "\t\t";
            if (retValData == --returnValueConditionList.end()) {
                if (returnValueConditionList.size() != 1)
                    ss << "else ";
            } else {
                if (retValData == returnValueConditionList.begin()) {
                    ss << "if ";
                } else {
                    ss << "elsif ";
                }
                for (auto cond = retValData->second.begin(); cond != retValData->second.end(); cond++) {
                    ss << VHDLPrintVisitorHLS::toString(*cond);
                    if (cond != --retValData->second.end()) ss << " and ";
                }
                ss << " then ";
            }
            ss << VHDLPrintVisitorHLS::toString(retValData->first) << ";\n";
        }
        if (returnValueConditionList.size() != 1) ss << "\t\tend if;\n";
        ss << "\tend " + func->getName() + ";\n\n";
    }
}

std::string PrintVHDLForHLS::printDataTypes(const DataType *dataType) {
    std::stringstream dataTypeStream;

    if (dataType->isEnumType()) {
        dataTypeStream << "\ttype " << SignalFactory::convertDataType(dataType->getName()) << " is (";
        for (auto enumVal = dataType->getEnumValueMap().begin(); enumVal != dataType->getEnumValueMap().end(); enumVal++) {
            dataTypeStream << enumVal->first;
            if (enumVal != --dataType->getEnumValueMap().end()) dataTypeStream << ", ";
        }
        dataTypeStream << ");\n";
    } else if (dataType->isCompoundType()) {
        dataTypeStream << "\ttype " + SignalFactory::convertDataType(dataType->getName()) << " is record\n";
        for (auto &subVar: dataType->getSubVarMap()) {
            dataTypeStream << "\t\t" + subVar.first << ": " << SignalFactory::convertDataType(subVar.second->getName()) << ";\n";
        }
        dataTypeStream << "\tend record;\n";
    } else if (dataType->isArrayType()) {
        dataTypeStream << "\ttype " << dataType->getName() << " is array (" << (dataType->getSubVarMap().size() - 1)
                       << " downto 0) of " << SignalFactory::convertDataType(dataType->getSubVarMap().begin()->second->getName())
                       << ";\n";
    }
    return dataTypeStream.str();
}

std::string PrintVHDLForHLS::printSensitivityList() {
    std::stringstream sensitivityListStream;

    std::set<SyncSignal* > sensListSyncSignals;
    std::set<DataSignal* > sensListDataSignals;
    std::set<Variable* > sensListVars;

    const auto& operationProperties = propertySuite->getOperationProperties();
    for (auto operationProperty : operationProperties) {
        for (const auto& assumption : operationProperty->getAssumptionList()) {
            auto syncSignals = ExprVisitor::getUsedSynchSignals(assumption);
            sensListSyncSignals.insert(syncSignals.begin(), syncSignals.end());

            const auto& dataSignals = ExprVisitor::getUsedDataSignals(assumption);
            sensListDataSignals.insert(dataSignals.begin(), dataSignals.end());

            const auto& vars = ExprVisitor::getUsedVariables(assumption);
            sensListVars.insert(vars.begin(), vars.end());
        }
    }

    const auto& waitProperties = propertySuite->getWaitProperties();
    for (const auto& waitProperty : waitProperties) {
        for (const auto& assumption : waitProperty->getAssumptionList()) {
            const auto& syncSignals = ExprVisitor::getUsedSynchSignals(assumption);
            sensListSyncSignals.insert(syncSignals.begin(), syncSignals.end());

            const auto& dataSignals = ExprVisitor::getUsedDataSignals(assumption);
            sensListDataSignals.insert(dataSignals.begin(), dataSignals.end());

            const auto& vars = ExprVisitor::getUsedVariables(assumption);
            sensListVars.insert(vars.begin(), vars.end());
        }
    }

    sensitivityListStream << "active_state";
    for (const auto& syncSignals : sensListSyncSignals) {
        sensitivityListStream << ", " << VHDLPrintVisitor::toString(syncSignals);
    }

    for (const auto& dataSignals : sensListDataSignals) {
        sensitivityListStream << ", " << dataSignals->getFullName();
    }

    for (const auto& vars : sensListVars) {
        sensitivityListStream << ", " << vars->getFullName();
    }
    return sensitivityListStream.str();
}

