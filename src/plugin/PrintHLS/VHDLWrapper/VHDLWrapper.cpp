//
// Created by johannes on 02.11.19.
//

#include "ExprVisitor.h"
#include "VHDLWrapper.h"
#include "VHDLPrintVisitor.h"
#include "VHDLPrintReset.h"
#include "VHDLPrintVisitorHLS.h"
#include "OtherUtils.h"

using namespace HLSPlugin::VHDLWrapper;

VHDLWrapper::VHDLWrapper() :
    propertySuite(nullptr),
    currentModule(nullptr),
    hlsModule(nullptr)
{
}

std::map<std::string, std::string> VHDLWrapper::printModel(Model *model) {
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

std::string VHDLWrapper::printTypes(Model *model) {
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
    auto operations = propertySuite->getOperationProperties();
    for (auto op : operations) {
        typeStream << "op_" << op->getName() << ", ";
    }
    typeStream << "op_state_wait);\n\n";

    // State enumeration
    typeStream << "\t -- States\n"
               << "\ttype " + propertySuite->getName() << "_state_t is (";
    auto states = propertySuite->getStates();
    for (auto state = states.begin(); state != states.end(); ++state) {
        typeStream << "st_" << (*state)->getName();
        if (std::next(state) != states.end()) {
            typeStream << ", ";
        }
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
               << "\t-- Constants\n";
    for (const auto& var : hlsModule->getVariables()) {
        if (hlsModule->isConstant(var)) {
            typeStream << "\tconstant " << var->getName() << ": " << SignalFactory::convertDataType(var->getDataType()->getName())
                       << " := " << getResetValue(var) << ";\n";
        }
    }

    typeStream << "\n"
               << "end package " + model->getName() << "_types;";
    return typeStream.str();
}

std::string VHDLWrapper::printModule(Model *model) {
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
        bool isEnum = dataSignal->isEnumType();
        bool hasOutputReg = hlsModule->hasOutputReg(dataSignal);
        std::string name;
        if (hasOutputReg) {
            name = SignalFactory::getName(hlsModule->getCorrespondingRegister(dataSignal), Style::DOT);
        } else {
            name = SignalFactory::getName(dataSignal, Style::DOT);
        }
        ss << "\t" << name << " <= "
           << (
                   isEnum ?
                   SignalFactory::vectorToEnum(dataSignal, "_out") :
                   SignalFactory::getName(dataSignal, Style::UL, "_out"))
           << ";\n";
    };
    ss << "\n\t-- Operation Module Outputs\n";
    for (const auto& out : OtherUtils::getSubVars(signalFactory->getOperationModuleOutputs())) {
        printOutputProcess(out);
    }

    ss << "\n\t-- Output Register to Output Mapping\n";
    for (const auto& out : signalFactory->getOperationModuleOutputs()) {
        if (hlsModule->hasOutputReg(out)) {
            if (hlsModule->isModuleSignal(out)) {
                for (const auto& sig : hlsModule->getCorrespondingTopSignals(out)) {
                    ss << "\t" << sig->getFullName() << " <= " << hlsModule->getCorrespondingRegister(out)->getFullName() << ";\n";
                }
            } else {
                ss << "\t" << out->getFullName() << " <= " << hlsModule->getCorrespondingRegister(out)->getFullName() << ";\n";
            }
        }
    }

    ss << "\n\t-- Internal Register\n";
    auto printOutputProcessRegs = [&](Variable* var) {
        bool isEnum = var->isEnumType();
        ss << "\t" << SignalFactory::getName(var, Style::DOT) << " <= "
           << (
                   isEnum ?
                   SignalFactory::vectorToEnum(var, "", "out_") :
                   "out_" + SignalFactory::getName(var, Style::UL, ""))
           << ";\n";
    };
    for (const auto& internalRegs : signalFactory->getInternalRegisterOut()) {
        printOutputProcessRegs(internalRegs);
    }

    ss << "\n\t-- Notify Signals\n";
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << " <= " << notifySignal->getName() << "_out;\n";
    }

    auto printModuleInputSignals = [this, &ss](std::set<DataSignal*> const& dataSignals) {
        for (const auto& dataSignal : dataSignals) {
            if (!dataSignal->getPort()->isArrayType()) {
                ss << "\t" << SignalFactory::getName(dataSignal, Style::UL) << "_in <= "
                   << (
                           dataSignal->isEnumType() ?
                           SignalFactory::enumToVector(dataSignal) :
                           SignalFactory::getName(dataSignal, Style::DOT))
                   << ";\n";
            }
        }
    };

    auto printModuleInputVars = [&ss](std::set<Variable*> const& vars, std::string const& prefix, std::string const& suffix) {
        for (const auto& var : vars) {
            ss << "\t" << prefix << SignalFactory::getName(var, Style::UL) << suffix << " <= "
               << (
                       var->isEnumType() ?
                       SignalFactory::enumToVector(var) :
                       SignalFactory::getName(var, Style::DOT))
               << ";\n";
        }
    };

    ss << "\n\t-- Operation Module Inputs\n";
    printModuleInputVars({signalFactory->getActiveOperation()}, "" , "_in");
    printModuleInputSignals(OtherUtils::getSubVars(signalFactory->getOperationModuleInputs()));

    for (const auto &arrayPort : hlsModule->getArrayPorts()) {
        uint32_t exprNumber = 0;
        for (const auto &expr : arrayPort.second) {
            ss << "\t\t" << arrayPort.first->getDataSignal()->getName() << "_" << exprNumber << "_in"
               << " <= " << arrayPort.first->getDataSignal()->getName() << "(to_integer(unsigned("
               << VHDLPrintVisitorHLS::toString(expr) << ")));\n";
            exprNumber++;
        }
    }

    // Print Control Process
    ss << "\n\t-- Control process\n"
       << "\tprocess (clk, rst)\n"
       << "\tbegin\n"
       << "\t\tif (rst = '1') then\n"
       << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getNextState()->getName() << ";\n"
       << "\t\telsif (clk = '1' and clk'event) then\n"
       << "\t\t\tactive_state <= next_state;\n"
       << "\t\tend if;\n"
       << "\tend process;\n\n"
       << "end " << propertySuite->getName() << "_arch;\n";

    return ss.str();
}

void VHDLWrapper::entity(std::stringstream &ss) {
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
void VHDLWrapper::signals(std::stringstream &ss) {
    auto printVars = [&ss](
            std::set<Variable *> const& vars,
            Style const& style,
            std::string const& prefix,
            std::string const& suffix,
            bool const& asVector) {
        for (const auto& var : vars) {
            ss << "\tsignal " << prefix << SignalFactory::getName(var, style, suffix)
               << ": " << SignalFactory::getDataTypeName(var, asVector) << ";\n";
        }
    };

    auto printSignal = [&ss](
            std::set<DataSignal *> const& signals,
            Style const& style,
            std::string const& suffix,
            bool const& asVector) {
        for (const auto& signal : signals) {
            ss << "\tsignal " << SignalFactory::getName(signal, style, suffix)
               << ": " << SignalFactory::getDataTypeName(signal, asVector) << ";\n";
        }
    };

    ss << "\n\t-- Internal Registers\n";
    printVars(OtherUtils::getParents(signalFactory->getInternalRegisterOut()),Style::UL, "", "", false);
    printVars(signalFactory->getInternalRegisterOut(),Style::UL, "out_", "", true);
    printVars(signalFactory->getOutputRegister(), Style::DOT, "", "", false);

    ss << "\n\t-- Operation Module Inputs\n";
    printSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleInputs()),
            Style::UL, "_in", true);
    printVars({signalFactory->getActiveOperation()}, Style::DOT, "", "_in", true);

    ss << "\n\t-- Module Outputs\n";
    printSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleOutputs()),
            Style::UL, "_out", true);
    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\tsignal " << notifySignal->getName() << "_out: std_logic;\n";
    }

    ss << "\n\t-- Monitor Signals\n";
    printVars(signalFactory->getMonitorSignals(), Style::DOT, "", "", false);

}

void VHDLWrapper::component(std::stringstream& ss) {
    // Print Component
    ss << "\n\tcomponent operations is\n";
    ss << "\tport(\n";

    auto printComponentSignal = [&ss](std::set<DataSignal *> const& signals, std::string const& prefix) {
        for (const auto& signal : signals) {
            bool vectorType = signal->getDataType()->isInteger() || signal->getDataType()->isUnsigned();
            std::string suffix = (vectorType ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(signal, Style::UL, suffix) << ": "
               << signal->getPort()->getInterface()->getDirection() << " " << SignalFactory::getDataTypeName(signal, true)
               << ";\n";
        }
    };

    auto printComponentVars = [&ss](std::set<Variable *> const& vars, std::string const& prefix) {
        for (const auto& var : vars) {
            std::string type = var->getDataType()->getName();
            std::string suffix = (type=="int" || type=="unsigned" ? "_V" : "");
            ss << "\t\t" << prefix + "_" << SignalFactory::getName(var, Style::UL, suffix) << ": "
               << prefix << " " << SignalFactory::getDataTypeName(var, true)
               << ";\n";
        }
    };

    printComponentSignal(signalFactory->getControlSignals(), "ap_");
    printComponentSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleInputs()), "");
    printComponentSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleOutputs()), "");
    printComponentVars(signalFactory->getInternalRegisterOut(), "out");

    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << ": out std_logic;\n";
    }

    const auto& activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << ": in " << SignalFactory::getDataTypeName(activeOp, true) << "\n";

    ss << "\t);\n"
       << "\tend component;\n";
}

// Print Component Instantiation
void VHDLWrapper::componentInst(std::stringstream& ss) {
    ss << "\toperations_inst: operations\n"
       << "\tport map(\n";

    auto printComponentInstSignal = [&ss](
            std::set<DataSignal *> const& signals,
            std::string const& prefix,
            std::string const& suffix) {
        for (const auto& signal : signals) {
            std::string type = signal->getDataType()->getName();
            std::string moduleSuffix = (type == "int" || type == "unsigned" ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(signal, Style::UL, moduleSuffix) << " => "
               << SignalFactory::getName(signal, Style::UL, suffix) << ",\n";
        }
    };

    auto printComponentInstVars = [&ss](std::set<Variable *> const& vars, std::string const& prefix) {
        for (const auto& var : vars) {
            std::string type = var->getDataType()->getName();
            std::string suffix = (type == "int" || type == "unsigned" ? "_V" : "");
            ss << "\t\t" << prefix << SignalFactory::getName(var, Style::UL, suffix) << " => "
               << prefix << SignalFactory::getName(var, Style::UL, "") << ",\n";
        }
    };

    printComponentInstSignal(signalFactory->getControlSignals(), "ap_", "");
    printComponentInstSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleInputs()), "", "_in");
    printComponentInstSignal(OtherUtils::getSubVars(signalFactory->getOperationModuleOutputs()), "", "_out");
    printComponentInstVars(signalFactory->getInternalRegisterOut(), "out_");

    for (const auto& notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t\t" << notifySignal->getName() << " => " << notifySignal->getName() << "_out,\n";
    }

    const auto& activeOp = signalFactory->getActiveOperation();
    ss << "\t\t" << activeOp->getFullName() << " => " << SignalFactory::getName(activeOp, Style::UL, "_in") << "\n"
       << "\t);\n\n";
}

// Print Monitor
void VHDLWrapper::monitor(std::stringstream &ss) {
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
                   << "\t\t\t\tnext_state <= st_" << (*property)->getNextState()->getName() << ";\n";
            } else {
                ss << "\t\t\t\tactive_operation <= op_state_wait;\n";
                ss << "\t\t\t\tnext_state <= active_state;\n";
            }
        }
        if (!noEndIf) {
            ss << "\t\t\tend if;\n";
        }
    }
    ss << "\t\tend case;\n"
       << "\tend process;\n\n";
}

void VHDLWrapper::functions(std::stringstream &ss) {
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

std::string VHDLWrapper::printDataTypes(const DataType *dataType) {
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

std::string VHDLWrapper::printSensitivityList() {
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
            for (const auto& var : vars) {
                if (!hlsModule->isConstant(var)) {
                    sensListVars.insert(var);
                }
            }
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
            for (const auto& var : vars) {
                if (!hlsModule->isConstant(var)) {
                    sensListVars.insert(var);
                }
            }
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

std::string VHDLWrapper::getResetValue(Variable* variable)
{
    for (const auto& commitment : propertySuite->getResetProperty()->getCommitmentList()) {
        auto printResetValue = VHDLPrintResetValue(commitment, variable->getName());
        if (printResetValue.toString()) {
            return printResetValue.getString();
        }
    }
    return VHDLPrintVisitorHLS::toString(variable->getInitialValue());
}

std::string VHDLWrapper::getResetValue(DataSignal* dataSignal)
{
    for (const auto& commitment : propertySuite->getResetProperty()->getCommitmentList()) {
        auto printResetValue = VHDLPrintResetValue(commitment, dataSignal->getFullName());
        if (printResetValue.toString()) {
            return printResetValue.getString();
        }
    }
    return VHDLPrintVisitorHLS::toString(dataSignal->getInitialValue());
}

