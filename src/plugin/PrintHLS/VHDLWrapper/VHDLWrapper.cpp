//
// Created by johannes on 13.02.20.
//

#include "ExprVisitor.h"
#include "PrintReset.h"
#include "PrintStatement.h"
#include "Utilities.h"
#include "VHDLWrapper.h"

using namespace SCAM::HLSPlugin::VHDLWrapper;

std::string VHDLWrapper::printTypes() {
    std::stringstream typeStream;
    typeStream << "-- External data type definition package\n";
    typeStream << "library ieee;\n";
    typeStream << "use ieee.std_logic_1164.all;\n";
    typeStream << "use ieee.numeric_std.all;\n";
    typeStream << "\n";

    typeStream << "package " + moduleName << "_types is\n\n";

    // State enumeration
    typeStream << "\t -- States\n"
               << "\ttype " + propertySuiteHelper->getName() << "_state_t is (";
    auto states = propertySuiteHelper->getStates();
    for (auto state = states.begin(); state != states.end(); ++state) {
        typeStream << "st_" << (*state)->getName();
        if (std::next(state) != states.end()) {
            typeStream << ", ";
        }
    }
    typeStream << ");\n\n";

    typeStream << operationEnum();

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

    for (const auto& reg : propertySuiteHelper->getVisibleRegisters()) {
        fillTypeSets(reg->getDataType());
    }
    for (const auto& func : propertySuiteHelper->getFunctions()) {
        fillTypeSets(func->getReturnType());
    }
    for (auto &port : currentModule->getPorts()) {
        if (port.second->isCompoundType()) {
            for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                fillTypeSets(subVar->getDataType());
            }
        }
        fillTypeSets(port.second->getDataType());
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
//    std::set<std::string> uniqueNames;
    for (const auto& var : Utilities::getParents(optimizer->getConstantVariables())) {
//        if (uniqueNames.find(var->getName()) != uniqueNames.end()) {
//            continue;
//        }
        typeStream << "\tconstant " << var->getName() << ": " << SignalFactory::convertDataType(var->getDataType()->getName())
                   << " := " << getResetValue(var) << ";\n";
    }

    typeStream << "\n"
               << "end package " + moduleName << "_types;";
    return typeStream.str();
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

void VHDLWrapper::functions(std::stringstream &ss) {
    std::set<Function *> usedFunctions;
    for (const auto& property : propertySuiteHelper->getOperationProperties()) {
        for (const auto& assumption : property->getOperation()->getAssumptionsList()) {
            const auto& funcSet = ExprVisitor::getUsedFunction(assumption);
            usedFunctions.insert(funcSet.begin(), funcSet.end());
        }
    }

    if (usedFunctions.empty()) {
        return;
    }

    ss << "\n\t-- Functions\n";
    for (const auto& func : usedFunctions) {
        ss << "\tfunction " + func->getName() << "(";

        const auto& parameterMap = func->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); parameter++) {
            if (parameter->second->isCompoundType()) {
                auto subVarList = parameter->second->getSubVarList();
                for (auto subVar = subVarList.begin(); subVar!=subVarList.end(); ++subVar) {
                    ss << Utilities::getFullName(*subVar, "_") << ": " << SignalFactory::convertDataType((*subVar)->getDataType()->getName());
                    if (std::next(subVar) != subVarList.end()) {
                        ss << "; ";
                    }
                }
            } else {
                ss << parameter->first << ": " << SignalFactory::convertDataType(parameter->second->getDataType()->getName());
            }
            if (std::next(parameter) != parameterMap.end()) {
                ss << "; ";
            }
        }
        ss << ") return " << SignalFactory::convertReturnTypeFunction(func->getReturnType()->getName()) << ";\n";
    }
    ss << "\n";

    for (const auto& func : usedFunctions) {
        ss << "\tfunction " + func->getName() << "(";

        auto parameterMap = func->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); parameter++) {
            if (parameter->second->isCompoundType()) {
                auto subVarList = parameter->second->getSubVarList();
                for (auto subVar = subVarList.begin(); subVar!=subVarList.end(); ++subVar) {
                    ss << Utilities::getFullName(*subVar, "_") << ": " << SignalFactory::convertDataType((*subVar)->getDataType()->getName());
                    if (std::next(subVar) != subVarList.end()) {
                        ss << "; ";
                    }
                }
            } else {
                ss << parameter->first << ": " << SignalFactory::convertDataType(parameter->second->getDataType()->getName());
            }
            if (std::next(parameter) != parameterMap.end()) {
                ss << "; ";
            }
        }
        ss << ") return " << SignalFactory::convertReturnTypeFunction(func->getReturnType()->getName()) << " is\n";
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
                    ss << PrintStatement::toString(*cond, true);
                    if (cond != --retValData->second.end()) ss << " and ";
                }
                ss << " then ";
            }
            ss << PrintStatement::toString(retValData->first, false) << ";\n";
        }
        if (returnValueConditionList.size() != 1) ss << "\t\tend if;\n";
        ss << "\tend " + func->getName() + ";\n\n";
    }
}

std::string VHDLWrapper::printArchitecture() {
    std::stringstream ss;

    // Print Include
    ss << "library ieee;\n";
    ss << "use ieee.std_logic_1164.all;\n";
    ss << "use ieee.numeric_std.all;\n";
    ss << "use work.operations;\n";
    ss << "use work." + moduleName + "_types.all;\n\n";

    entity(ss);

    ss << "architecture " << propertySuiteHelper->getName() << "_arch of " << propertySuiteHelper->getName() << "_module is\n";

    signals(ss);
    functions(ss);

    bool emptyOperationModule = optimizer->getInternalRegisterOut().empty() && optimizer->getOutputs().empty() && propertySuiteHelper->getNotifySignals().empty();
    if (!emptyOperationModule) {
        component(ss);
    }

    // begin of architecture implementation
    ss << "\nbegin\n\n";

    if (!emptyOperationModule) {
        componentInst(ss);
    }
    monitor(ss);
    moduleOutputHandling(ss);
    printConstantOutputs(ss);
    controlProcess(ss);

    return ss.str();
}

std::string VHDLWrapper::sensitivityList() {
    std::stringstream sensitivityListStream;

    std::set<SyncSignal* > sensListSyncSignals;
    std::set<DataSignal* > sensListDataSignals;
    std::set<Variable* > sensListVars;

    const auto& operationProperties = propertySuiteHelper->getOperationProperties();
    for (auto operationProperty : operationProperties) {
        for (const auto& assumption : operationProperty->getOperation()->getAssumptionsList()) {
            auto syncSignals = ExprVisitor::getUsedSynchSignals(assumption);
            sensListSyncSignals.insert(syncSignals.begin(), syncSignals.end());

            const auto& dataSignals = ExprVisitor::getUsedDataSignals(assumption);
            sensListDataSignals.insert(dataSignals.begin(), dataSignals.end());

            const auto& vars = ExprVisitor::getUsedVariables(assumption);
            for (const auto& var : vars) {
                if (!optimizer->isConstant(var)) {
                    sensListVars.insert(var);
                }
            }
        }
    }

    sensitivityListStream << "active_state";
    for (const auto& syncSignals : sensListSyncSignals) {
        sensitivityListStream << ", " << PrintStatement::toString(syncSignals, false);
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
    for (const auto& commitment : propertySuiteHelper->getResetProperty()->getCommitmentList()) {
        auto printResetValue = PrintResetSignal(commitment->getStatement(), variable->getName());
        if (printResetValue.toString()) {
            return printResetValue.getString();
        }
    }
    return PrintStatement::toString(variable->getInitialValue(), false);
}

std::string VHDLWrapper::getResetValue(DataSignal* dataSignal)
{
    for (const auto& commitment : propertySuiteHelper->getResetProperty()->getCommitmentList()) {
        auto printResetValue = PrintResetSignal(commitment->getStatement(), dataSignal->getFullName());
        if (printResetValue.toString()) {
            return printResetValue.getString();
        }
    }
    return PrintStatement::toString(dataSignal->getInitialValue(), false);
}

void VHDLWrapper::printConstantOutputs(std::stringstream &ss)
{
    return;
    // TODO: Check all Signals
    std::vector<DataSignal *> constantOutputs;
    auto moduleOutputs = optimizer->getOutputs();
    for (const auto& port : currentModule->getPorts()) {
        if (port.second->getInterface()->isOutput()) {
            if (port.second->getDataSignal()->isCompoundType()) {
                for (const auto& subVar : port.second->getDataSignal()->getSubVarList()) {
                    if (moduleOutputs.find(subVar) == moduleOutputs.end()) {
                        constantOutputs.emplace_back(subVar);
                    }
                }
            } else {
                if (moduleOutputs.find(port.second->getDataSignal()) == moduleOutputs.end()) {
                    constantOutputs.emplace_back(port.second->getDataSignal());
                }
            }
        }
    }
    if (!constantOutputs.empty()) {
        ss << "\n\n\t-- Constant Outputs\n";
        for (const auto& constantOutput : constantOutputs) {
            ss << "\t" << Utilities::getFullName(constantOutput, ".") << " <= " << getResetValue(constantOutput) << ";\n";
        }
        ss << "\n\n";
    }
}
