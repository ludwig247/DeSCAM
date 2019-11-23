//
// Created by johannes on 02.11.19.
//

#include <cmath>
#include "ExprVisitor.h"
#include "PrintVHDLForHLS.h"
#include "VHDLPrintVisitor.h"
#include "VisitFunctions.h"
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
        ss << "\t" << signal->name << "_sig: " << signal->direction << " " << signal->type;
        if (std::next(signal) != portIt.end()) {
            ss << ";\n";
        }
    }
    ss << ");\n";
    ss << "end " + propertySuite->getName() << "_module;\n\n";

    ss << "architecture " << propertySuite->getName() << "_arch of " << propertySuite->getName() << "_module is\n";

    const auto& operationSelectorVector = signalFactory->getOperationSelector(true);

    // Print Signals
    auto printRegSignals = [&ss](std::vector<Signal> const& signals) {
        for (const auto& sig : signals) {
            ss << "\tsignal " << sig.name << "_reg: " << sig.type << ";\n";
        }
    };

    ss << "\n\t-- Input registers\n";
    printRegSignals(signalFactory->getInputs(true, true));
    ss << "\tsignal " << operationSelectorVector.name << "_reg: " << operationSelectorVector.type << ";\n";

    ss << "\n\t-- Output registers\n";
    for (const auto& outputReg : utils->getOutputRegisterParents()) {
        ss << "\tsignal " << outputReg->getName() << ": "
           << convertDataTypeConstrained(outputReg->getDataType()->getName()) << ";\n";
    }
    printRegSignals(signalFactory->getNotify());

    ss << "\n\t-- HLS module output signals\n";
    auto printVldSignals = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\tsignal " << signal.name << "_out: " << signal.type << ";\n"
               << "\tsignal " << signal.name << "_vld: " << "std_logic" << ";\n";
        }
    };
    printVldSignals(signalFactory->getOutputs(true, true));
    printVldSignals(signalFactory->getNotify());

    auto printSignals = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\tsignal " << signal.name << ": " << signal.type << ";\n";
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
            ss << "\t\tap_" << signal.name << ": " << signal.direction << " " << signal.type << ";\n";
        }
    };
    printControlSignals(signalFactory->getBaseSignals());
    printControlSignals(signalFactory->getHSProtocolSignals());

    auto printComponentSignals = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\t\t" << signal.name << (signal.isEnum ? "" : "_V" ) << ": " << signal.direction
               << " " << signal.type << ";\n";
            if (signal.direction == "out") {
                ss << "\t\t" << signal.name << (signal.isEnum ? "_ap_vld" : "_V_ap_vld" ) << ": " << signal.direction
                   << " std_logic;\n";
            }
        }
    };
    printComponentSignals(signalFactory->getInputs(true, true));
    printComponentSignals(signalFactory->getOutputs(true, true));
    for (const auto& notifySignal : signalFactory->getNotify()) {
        ss << "\t\t" << notifySignal.name << ": out std_logic;\n"
           << "\t\t" << notifySignal.name << "_ap_vld: out std_logic;\n";
    }
    ss << "\t\t" << operationSelectorVector.name << ": in " << operationSelectorVector.type << "\n";
    ss << "\t);\n;"
       << "\tend component;\n";

    // begin of architecture implementation
    ss << "\nbegin\n";

    // Print Component Instantiation
    ss << "\toperations_inst: operations\n"
       << "\tport map(\n";
    auto printControlInstantiation = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\t\tap_" << signal.name << " => " << signal.name << ",\n";
        }
    };
    printControlInstantiation(signalFactory->getHSProtocolSignals());
    printControlInstantiation(signalFactory->getBaseSignals());

    auto printComponentInstantiation = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            if (signal.direction == "out") {
                ss << "\t\t" << signal.name << (signal.isEnum ? "" : "_V" ) << " => "
                   << signal.name << "_out,\n";
                ss << "\t\t" << signal.name << (signal.isEnum ? "_ap_vld" : "_V_ap_vld" ) << " => " << signal.name
                   << "_vld,\n";
            } else {
                ss << "\t\t" << signal.name << (signal.isEnum ? "" : "_V" ) << " => "
                   << signal.name << "_reg,\n";
            }
        }
    };
    printComponentInstantiation(signalFactory->getInputs(true, true));
    printComponentInstantiation(signalFactory->getOutputs(true, true));
    for (const auto& notifySignal : signalFactory->getNotify()) {
        ss << "\t\t" << notifySignal.name << " => " << notifySignal.name << "_out,\n";
        ss << "\t\t" << notifySignal.name << "_ap_vld  => " << notifySignal.name << "_vld,\n";
    }
    ss << "\t\t" << operationSelectorVector.name << " => " << operationSelectorVector.name << "_reg\n"
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
    ss << "\t-- Output_Vld Processes\n";
    auto printOutputProcess = [&](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            std::string registerName = utils->getCorrespondingRegisterName(signal.name);
            ss << "\tprocess(rst, " << signal.name << "_vld)\n"
               << "\tbegin\n"
               << "\t\tif (rst = \'1\') then\n"
               << "\t\t\t" << registerName << " <= " << signal.initialValue << ";\n"
               << "\t\telsif (" << signal.name << "_vld = '1') then\n"
               << "\t\t\t" << registerName << " <= " << (signal.isEnum ?
                                                         signal.type + "'val(to_integer(unsigned(" + signal.name + "_out)));\n" :
                                                         signal.name + "_out;\n")
               << "\t\tend if;\n"
               << "\tend process;\n\n";
        }
    };
    printOutputProcess(signalFactory->getOutputs(false, true));

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
       << "\tprocess(done)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (const auto& out : signalFactory->getOutputs(false, true, Separator::DOT)) {
        ss << "\t\t\t" << out.name << " <= " << out.initialValue << ";\n";
    }
       ss << "\t\telsif (done = '1') then\n";
    for (const auto& out : signalFactory->getOutputs(false, true, Separator::DOT)) {
        ss << "\t\t\t" << out.name << " <= " << utils->getCorrespondingRegisterName(out.name) << ";\n";
    }
    ss << "\t\tend if;\n"
       << "\tend process;\n\n";

    ss << "\tprocess(rst, done, idle)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n";
    for (auto commitment : propertySuite->getResetProperty()->getCommitmentList()) {
        std::string assignment = VHDLPrintResetNotify::toString(commitment);
        if (!assignment.empty()) {
            ss << "\t\t\t" << assignment;
        }
    }
    ss << "\t\telse\n"
       << "\t\t\tif (done = '1') then\n";
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t\t\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_reg;\n";
    }
    ss << "\t\t\telsif (idle = '1') then\n";
    for (auto port : currentModule->getPorts()) {
        if (port.second->getInterface()->isMasterOut()) {
            ss << "\t\t\t\t" << port.second->getName() << "_notify <= '0';\n";
        }
    }
    ss << "\t\t\telse\n";
    for (auto notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t\t\t" << notifySignal->getName() << " <= '0';\n";
    }
    ss << "\t\t\tend if;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n";

    auto printModuleInput = [&ss](std::vector<Signal> const& signals) {
        for (const auto& signal : signals) {
            ss << "\t\t\t\t" << signal.name << "_reg <= "
               << (signal.isEnum ?
                   "std_logic_vector(to_unsigned(" + signal.type + "'pos(" + signal.name + ")," + std::to_string(signal.vectorSize) + "))" :
                   signal.name)
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

        auto paramMap = func->getParamMap();
        for (auto param_it = paramMap.begin(); param_it != paramMap.end(); param_it++) {
            if (param_it->second->getDataType()->isCompoundType()) {
                functionStream << param_it->first << ": " << convertDataType(param_it->second->getDataType()->getName());
            } else {
                functionStream << param_it->first << ": " << convertDataType(param_it->second->getDataType()->getName());
            }
            if (param_it != --paramMap.end())
                functionStream << "; ";
        }
        functionStream << ") return " << convertDataType(func->getReturnType()->getName()) << ";\n";
    }
    functionStream << "\n";

    for (const auto& func : usedFunctions) {
        functionStream << "\tfunction " + func->getName() << "(";

        auto paramMap = func->getParamMap();
        for (auto param_it = paramMap.begin(); param_it != paramMap.end(); param_it++) {
            if (param_it->second->getDataType()->isCompoundType()) {
                functionStream << param_it->first << ": " << convertDataType(param_it->second->getDataType()->getName());
            } else {
                functionStream << param_it->first << ": " << convertDataType(param_it->second->getDataType()->getName());
            }
            if (param_it != --paramMap.end())
                functionStream << "; ";
        }
        functionStream << ") return " << convertDataType(func->getReturnType()->getName()) << " is\n";
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

