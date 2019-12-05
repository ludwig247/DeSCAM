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
    hlsModule(nullptr),
    signalFactory(nullptr)
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
    if (!propertySuite->getWaitProperties().empty())
        typeStream << ", ";
    for (auto op = propertySuite->getWaitProperties().begin(); op != propertySuite->getWaitProperties().end(); ++op) {
        typeStream << "op_" << (*op)->getName();
        if (std::next(op) != propertySuite->getWaitProperties().end())
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

    for (auto &reg : propertySuite->getVisibleRegisters()) {
        fillTypeSets(reg->getDataType());
    }

    for (auto &func : propertySuite->getFunctions()) {
        fillTypeSets(func->getReturnType());
    }
    for (auto &module : model->getModules()) {
        for (auto &port : module.second->getPorts()) {
            fillTypeSets(port.second->getDataType());
        }
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

    // Print Entity
    ss << "entity " + propertySuite->getName() + "_module is\n";
    ss << "port(\n";

    auto portIt = signalFactory->getAllPorts();
    for (auto signal = portIt.begin(); signal != portIt.end(); ++signal) {
        ss << "\t" << signal->name << ": " << signal->direction << " " << signal->type;
        if (std::next(signal) != portIt.end()) {
            ss << ";\n";
        }
    }
    ss << "\n);\n";
    ss << "end " + propertySuite->getName() << "_module;\n\n";

    ss << "architecture " << propertySuite->getName() << "_arch of " << propertySuite->getName() << "_module is\n";

    const auto& operationSelectorVector = signalFactory->getOperationSelector(true);

    // Print Signals
    ss << "\n\t-- Internal Registers\n";
    auto printInternalRegs = [&ss, this]() {
        for (const auto& sig : signalFactory->getInternalRegs(false, false)) {
            ss << "\tsignal " << sig.name << ": " << sig.type << ";\n";
        }
        for (const auto& sig : signalFactory->getInternalRegs(true, true)) {
            ss << "\tsignal " << sig.getName(SubVarStyle::UL) << "_in: " << sig.type << ";\n";
            ss << "\tsignal " << sig.getName(SubVarStyle::UL) << "_out: " << sig.type << ";\n";
            ss << "\tsignal " << sig.getName(SubVarStyle::UL) << "_vld: std_logic" << ";\n";
        }
    };
    printInternalRegs();

    auto printRegSignals = [&ss](std::vector<Signal> const& signals, std::string const& suffix) {
        for (const auto& sig : signals) {
            ss << "\tsignal " << sig.getName(SubVarStyle::UL) << "_" << suffix << ": " << sig.type << ";\n";
        }
    };

    ss << "\n\t-- Input Registers\n";
    printRegSignals(signalFactory->getInputs(true, true), "in");
    ss << "\tsignal " << operationSelectorVector.name << "_in: " << operationSelectorVector.type << ";\n";

    ss << "\n\t-- Output Registers\n";
    for (const auto& output : hlsModule->getModuleOutputs()) {
        if (hlsModule->hasOutputReg(output)) {
            ss << "\tsignal " << hlsModule->getCorrespondingRegister(output)->getName() << ": "
               << OtherUtils::convertDataType(hlsModule->getCorrespondingRegister(output)->getDataType()->getName())
               << ";\n";
        } else {
            ss << "\tsignal " << SignalFactory::printWithUL(output) << "_reg: "
               << OtherUtils::convertDataType(output->getDataType()->getName()) << ";\n";
        }
    }
    printRegSignals(signalFactory->getNotify(), "reg");

    ss << "\n\t-- HLS module output signals\n";
    auto printVldSignals = [&ss](std::vector<DataSignal* > const& dataSignals) {
        for (const auto& dataSignal : dataSignals) {
            ss << "\tsignal " << SignalFactory::printWithUL(dataSignal) << "_out: " << OtherUtils::getEnumAsVector(dataSignal->getDataType()) << ";\n"
                    << "\tsignal " << SignalFactory::printWithUL(dataSignal) << "_vld: " << "std_logic" << ";\n";
        }
    };
    printVldSignals(OtherUtils::getSubVars(hlsModule->getModuleOutputs()));

    for (const auto& signal : signalFactory->getNotify()) {
        ss << "\tsignal " << signal.getName(SubVarStyle::UL) << "_out: " << signal.type << ";\n"
           << "\tsignal " << signal.getName(SubVarStyle::UL) << "_vld: " << "std_logic" << ";\n";
    }

    auto printSignals = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\tsignal " << signal.getName(SubVarStyle::UL) << ": " << signal.type << ";\n";
        }
    };
    ss << "\n\t-- Signals for handshaking protocol with hls module\n";
    printSignals(signalFactory->getHSProtocolSignals());
    ss << "\n\t-- Monitor signals\n";
    printSignals(signalFactory->getMonitorSignals());

    ss << functions();

    // Print Component
    ss << "\n\tcomponent operations is\n";
    ss << "\tport(\n";
    auto printControlSignals = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\t\tap_" << signal.getName(SubVarStyle::UL) << ": " << signal.direction << " " << signal.type << ";\n";
        }
    };
    printControlSignals(signalFactory->getBaseSignals());
    printControlSignals(signalFactory->getHSProtocolSignals());

    auto printComponentSignals = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\t\t" << signal.getName(SubVarStyle::UL) << (signal.isEnum ? "" : "_V" ) << ": " << signal.direction
               << " " << signal.type << ";\n";
        }
    };
    printComponentSignals(signalFactory->getInputs(true, true));

    auto printComponentOutputs = [&ss](std::vector<DataSignal* > const& dataSignals) {
        for (const auto& dataSignal : dataSignals) {
            ss << "\t\t" << SignalFactory::printWithUL(dataSignal) << (dataSignal->isEnumType() ? ": " : "_V: " )
               << "out " << OtherUtils::getEnumAsVector(dataSignal->getDataType()) << ";\n"
               << "\t\t" << SignalFactory::printWithUL(dataSignal) << (dataSignal->isEnumType() ? "_ap_vld" : "_V_ap_vld" )
               << ": out std_logic;\n";
        }
    };
    printComponentOutputs(OtherUtils::getSubVars(hlsModule->getModuleOutputs()));

    auto printComponentInternalRegs = [&ss](Signal const& signal) {
        ss << "\t\t" << signal.getName(SubVarStyle::UL) << "_in" << (signal.isEnum ? ": " :  "_V: ") << "in " << signal.type << ";\n";
        ss << "\t\t" << signal.getName(SubVarStyle::UL) << "_out" << (signal.isEnum ? ": " :  "_V: ") << "out " << signal.type << ";\n";
        ss << "\t\t" << signal.getName(SubVarStyle::UL) << (signal.isEnum ? "_ap_vld: " :  "_V_ap_vld: ") << "out std_logic;\n";
    };
    for (const auto& internalReg : signalFactory->getInternalRegs(true, true)) {
        printComponentInternalRegs(internalReg);
    }

    for (const auto& notifySignal : signalFactory->getNotify()) {
        ss << "\t\t" << notifySignal.name << ": out std_logic;\n"
           << "\t\t" << notifySignal.name << "_ap_vld: out std_logic;\n";
    }
    ss << "\t\t" << operationSelectorVector.name << ": in " << operationSelectorVector.type << "\n";
    ss << "\t);\n"
       << "\tend component;\n";

    // begin of architecture implementation
    ss << "\nbegin\n\n";

    // Print Component Instantiation
    ss << "\toperations_inst: operations\n"
       << "\tport map(\n";
    auto printControlInstantiation = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\t\tap_" << signal.getName(SubVarStyle::UL) << " => " << signal.getName(SubVarStyle::UL) << ",\n";
        }
    };
    printControlInstantiation(signalFactory->getHSProtocolSignals());
    printControlInstantiation(signalFactory->getBaseSignals());

    auto printComponentInstantiation = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            bool input = signal.direction == "in";
            bool output = signal.direction == "out";
            bool reg = signal.direction.empty();
            if (output || reg) {
                ss << "\t\t" << signal.getName(SubVarStyle::UL) << (reg ? "_out" : "") << (signal.isEnum ? "" : "_V" )
                   << " => " << signal.getName(SubVarStyle::UL) << "_out,\n";
                ss << "\t\t" << signal.getName(SubVarStyle::UL) << (signal.isEnum ? "_ap_vld" : "_V_ap_vld" )
                   << " => " << signal.getName(SubVarStyle::UL) << "_vld,\n";
            }
            if (input || reg) {
                ss << "\t\t" << signal.getName(SubVarStyle::UL) << (reg ? "_in" : "") << (signal.isEnum ? "" : "_V" )
                   << " => " << signal.getName(SubVarStyle::UL) << "_in,\n";
            }
        }
    };
    printComponentInstantiation(signalFactory->getInputs(true, true));
    printComponentInstantiation(signalFactory->getInternalRegs(true, true));

    auto printComponentInstantiationOutputs = [&ss](std::vector<DataSignal* > const& dataSignals) {
        for (const auto& dataSignal : dataSignals) {
            ss << "\t\t" << SignalFactory::printWithUL(dataSignal) << (dataSignal->isEnumType() ? "" : "_V") << " => "
               << SignalFactory::printWithUL(dataSignal) << "_out,\n";
            ss << "\t\t" << SignalFactory::printWithUL(dataSignal) << (dataSignal->isEnumType() ? "_ap_vld" : "_V_ap_vld")
               << " => " << SignalFactory::printWithUL(dataSignal) << "_vld,\n";
        }
    };
    printComponentInstantiationOutputs(OtherUtils::getSubVars(hlsModule->getModuleOutputs()));

    for (const auto& notifySignal : signalFactory->getNotify()) {
        ss << "\t\t" << notifySignal.name << " => " << notifySignal.name << "_out,\n";
        ss << "\t\t" << notifySignal.name << "_ap_vld  => " << notifySignal.name << "_vld,\n";
    }
    ss << "\t\t" << operationSelectorVector.name << " => " << operationSelectorVector.name << "_in\n"
       << "\t);\n\n";

    // Print Monitor
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

    // Print Output_Vld Processes
    auto printOutputProcess = [&](DataSignal* dataSignal) {
        bool hasOutputReg = hlsModule->hasOutputReg(dataSignal);
        bool isEnum = dataSignal->isEnumType();
        ss << "\tprocess (rst, " << SignalFactory::printWithUL(dataSignal) << "_vld)\n"
           << "\tbegin\n"
           << "\t\tif (rst = \'1\') then\n"
           << "\t\t\t" << (hasOutputReg ? hlsModule->getCorrespondingRegister(dataSignal)->getFullName() : SignalFactory::printWithUL(dataSignal) + "_reg")
           << " <= " << VHDLPrintVisitorHLS::toString(dataSignal->getInitialValue()) << ";\n"
           << "\t\telsif (" << SignalFactory::printWithUL(dataSignal) << "_vld = \'1\') then\n"
           << "\t\t\t" << (hasOutputReg ? hlsModule->getCorrespondingRegister(dataSignal)->getFullName() : SignalFactory::printWithUL(dataSignal) + "_reg")
           << " <= " << (isEnum ? SignalFactory::vectorToEnum(dataSignal, "_out") : SignalFactory::printWithUL(dataSignal) + "_out") << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    };
    ss << "\t-- Output_Vld Processes\n";
    for (const auto& out : OtherUtils::getSubVars(hlsModule->getModuleOutputs())) {
        printOutputProcess(out);
    }

    auto printOutputProcessRegs = [&](Signal const& signal) {
        bool isEnum = signal.isEnum;
        ss << "\tprocess (rst, " << signal.getName(SubVarStyle::UL) << "_vld)\n"
           << "\tbegin\n"
           << "\t\tif (rst = \'1\') then\n"
           << "\t\t\t" << signal.getName(SubVarStyle::DOT) << " <= " << signal.initialValue << ";\n"
           << "\t\telsif (" << signal.getName(SubVarStyle::UL) << "_vld = \'1\') then\n"
           << "\t\t\t" << signal.getName(SubVarStyle::DOT) << " <= " << (isEnum ?
               signal.type + "'val(to_integer(unsigned(" + signal.getName(SubVarStyle::UL) + "_out)))" :
               signal.getName(SubVarStyle::UL)+ "_out") << ";\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    };
    for (const auto& internalRegs : signalFactory->getInternalRegs()) {
        printOutputProcessRegs(internalRegs);
    }

    for (const auto& notifySignal : signalFactory->getNotify()) {
        ss << "\tprocess(" << notifySignal.name << "_vld)\n"
           << "\tbegin\n"
           << "\t\tif (" << notifySignal.name << "_vld = '1') then\n"
           << "\t\t\t" << notifySignal.name << "_reg <= " << notifySignal.name << "_out;\n"
           << "\t\tend if;\n"
           << "\tend process;\n\n";
    }

    // Print Output Processes
    ss << "\t-- Output Processes\n"
       << "\tprocess(rst, done)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (const auto& out : signalFactory->getOutputs(false, true)) {
        ss << "\t\t\t" << out.getName(SubVarStyle::DOT) << " <= " << out.initialValue << ";\n";
    }
    ss << "\t\telsif (done = '1') then\n";
    for (const auto& out : hlsModule->getModuleOutputs()) {
        if (hlsModule->isModuleSignal(out)) {
            for (const auto& sig : hlsModule->getCorrespondingTopSignals(out)) {
                ss << "\t\t\t" << sig->getFullName() << " <= " << hlsModule->getCorrespondingRegister(out)->getFullName() << ";\n";
            }
        } else {
            ss << "\t\t\t" << out->getFullName() << " <= "
               << (hlsModule->hasOutputReg(out) ?
                   hlsModule->getCorrespondingRegister(out)->getFullName() :
                   SignalFactory::printWithUL(out) + "_reg")
               << ";\n";
        }
    }
    ss << "\t\tend if;\n"
       << "\tend process;\n\n";

    ss << "\tprocess(rst, done, idle)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (const auto& commitment : propertySuite->getResetProperty()->getCommitmentList()) {
        std::string assignment = VHDLPrintResetNotify::toString(commitment);
        if (!assignment.empty()) {
            ss << "\t\t\t" << assignment;
        }
    }
    ss << "\t\telse\n"
       << "\t\t\tif (done = '1') then\n";
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t\t\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_reg;\n";
    }
    ss << "\t\t\telsif (idle = '1') then\n";
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

    auto printModuleInput = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\t\t\t\t" << signal.getName(SubVarStyle::UL) << "_in <= "
               << (signal.isEnum ?
                   "std_logic_vector(to_unsigned(" + signal.type + "'pos(" + signal.getName(SubVarStyle::DOT) + "), " +
                   std::to_string(signal.vectorSize) + "))" :
                   signal.getName(SubVarStyle::DOT))
               << ";\n";
        }
    };

    // Print Control Process
    ss << "\t-- Control process\n"
       << "\tprocess (clk, rst)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n"
       << "\t\t\tstart <= '0';\n"
       << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getNextState()->getName() << ";\n"
       << "\t\telsif (clk = '1' and clk'event) then\n"
       << "\t\t\tif ((idle = '1' or ready = '1') and wait_state = '0') then\n"
       << "\t\t\t\tstart <= '1';\n"
       << "\t\t\t\tactive_state <= next_state;\n";

    printModuleInput({signalFactory->getOperationSelector(false)});
    printModuleInput(signalFactory->getInputs(false, true));
    printModuleInput(signalFactory->getInternalRegs(false, true));

    ss << "\t\t\telsif ((idle = '1' or  ready = '1') and wait_state = '1') then\n"
       << "\t\t\t\tstart <= '0';\n"
       << "\t\t\tend if;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n"
       << "end " << propertySuite->getName() << "_arch;\n";

    return ss.str();
}

std::string PrintVHDLForHLS::functions() {
    std::stringstream functionStream;

    std::set<Function* > usedFunctions;
    for (const auto& state : propertySuite->getStates()) {
        for (const auto& property : propertySuite->getSuccessorProperties(state)) {
            for (const auto& assumption : property->getAssumptionList()) {
                const auto& funcSet = ExprVisitor::getUsedFunctions(assumption);
                usedFunctions.insert(funcSet.begin(), funcSet.end());
            }
        }
    }

    if (propertySuite->getFunctions().empty()) return functionStream.str();

    functionStream << "\n\t-- Functions\n";
    for (const auto& func : usedFunctions) {
        functionStream << "\tfunction " + func->getName() << "(";

        const auto& paramMap = func->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); param++) {
            functionStream << param->first << ": " << OtherUtils::convertDataType(param->second->getDataType()->getName());
            if (std::next(param) != paramMap.end())
                functionStream << "; ";
        }
        functionStream << ") return " << OtherUtils::convertDataType(func->getReturnType()->getName()) << ";\n";
    }
    functionStream << "\n";

    for (const auto& func : usedFunctions) {
        functionStream << "\tfunction " + func->getName() << "(";

        auto paramMap = func->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); param++) {
            functionStream << param->first << ": " << OtherUtils::convertDataType(param->second->getDataType()->getName());
            if (std::next(param) != paramMap.end())
                functionStream << "; ";
        }
        functionStream << ") return " << OtherUtils::convertDataType(func->getReturnType()->getName()) << " is\n";
        functionStream << "\tbegin\n";

        if (func->getReturnValueConditionList().empty())
            throw std::runtime_error("No return value for function " + func->getName() + "()");

        auto returnValueConditionList = func->getReturnValueConditionList();
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
        functionStream << "\tend " + func->getName() + ";\n\n";
    }
    return functionStream.str();
}

std::string PrintVHDLForHLS::printDataTypes(const DataType *dataType) {
    std::stringstream dataTypeStream;

    if (dataType->isEnumType()) {
        dataTypeStream << "\ttype " << OtherUtils::convertDataTypeConstrained(dataType->getName()) << " is (";
        for (auto enumVal = dataType->getEnumValueMap().begin(); enumVal != dataType->getEnumValueMap().end(); enumVal++) {
            dataTypeStream << enumVal->first;
            if (enumVal != --dataType->getEnumValueMap().end()) dataTypeStream << ", ";
        }
        dataTypeStream << ");\n";
    } else if (dataType->isCompoundType()) {
        dataTypeStream << "\ttype " + OtherUtils::convertDataTypeConstrained(dataType->getName()) << " is record\n";
        for (auto &subVar: dataType->getSubVarMap()) {
            dataTypeStream << "\t\t" + subVar.first << ": " << OtherUtils::convertDataTypeConstrained(subVar.second->getName()) << ";\n";
        }
        dataTypeStream << "\tend record;\n";
    } else if (dataType->isArrayType()) {
        dataTypeStream << "\ttype " << dataType->getName() << " is array (" << (dataType->getSubVarMap().size() - 1)
                       << " downto 0) of " << OtherUtils::convertDataTypeConstrained(dataType->getSubVarMap().begin()->second->getName())
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

