//
// Created by johannes on 13.02.20.
//

#include "ExprVisitor.h"
#include "PrintReset.h"
#include "Utilities.h"
#include "VHDLWrapper.h"
#include "PrintFunction.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "PrintStmtVHDL.h"


using namespace DESCAM::HLSPlugin::VHDLWrapper;

/*
 * Plugin output generation
 */
std::map<std::string, std::string> VHDLWrapper::printModule() {
    std::map<std::string, std::string> pluginOutput;

    pluginOutput.insert(std::make_pair(moduleName + "_types.vhd", printTypes()));
    pluginOutput.insert(std::make_pair(moduleName + ".vhd", printArchitecture()));

    return pluginOutput;
}

/*
 * Print function for module_types.vhd package
 */
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
               << "\ttype " + propertySuite->getName() << "_state_t is (";
    const auto& states = propertySuite->getStates();
    for (auto state = states.begin(); state != states.end(); ++state) {
        typeStream << "st_" << (*state)->getName();
        if (std::next(state) != states.end()) {
            typeStream << ", ";
        }
    }
    typeStream << ");\n\n";

    operationEnum(typeStream);

    // Find all used data types and sort them
    std::set<const DataType *> enumTypes;
    std::set<const DataType *> compoundTypes;
    std::set<const DataType *> arrayTypes;

    auto fillTypeSets = [&enumTypes, &compoundTypes, &arrayTypes](const DataType* dataType) {
        if (dataType->isEnumType()) {
            enumTypes.insert(dataType);
        } else if (dataType->isCompoundType()) {
            compoundTypes.insert(dataType);
        } else if (dataType->isArrayType()) {
            arrayTypes.insert(dataType);
        }
    };

    for (const auto& reg : propertySuite->getVisibleRegisters()) {
        fillTypeSets(reg->getDataType());
    }
    for (const auto& func : propertySuite->getFunctions()) {
        fillTypeSets(func->getReturnType());
    }
    for (const auto &port : currentModule->getPorts()) {
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

    // Print data types
    typeStream << "\t-- Enum Types\n";
    for (const auto& type : enumTypes) {
        typeStream << printDataTypes(type);
    }

    typeStream << "\n\t-- Compound Types\n";
    for (const auto& type : compoundTypes) {
        typeStream << printDataTypes(type);
    }

    typeStream << "\n\t-- Array Types\n";
    for (const auto& type : arrayTypes) {
        typeStream << printDataTypes(type);
    }

    typeStream << "\n\t-- Constants\n";
    for (const auto& var : Utilities::getParents(optimizer->getConstantVariables())) {
        typeStream << "\tconstant " << var->getName() << ": " << SignalFactory::convertDataTypeName(var->getDataType())
                   << " := " << getResetValue(var) << ";\n";
    }

    typeStream << "\nend package " + moduleName << "_types;";

    return typeStream.str();
}

/*
 * Prints operation subtype for types package
 */
void VHDLWrapper::operationEnum(std::stringstream &ss)
{
    // Calculate bit vector size for operation enum
    int vectorSize = ceil(log2(propertySuite->getOperationProperties().size()));
    if (vectorSize == 0) {
        vectorSize++;
    }
    std::string opTypeName = propertySuite->getName() + "_operation_t";

    ss << "\t-- Operations\n"
       << "\tsubtype " << opTypeName << " is std_logic_vector("
       << std::to_string(vectorSize - 1) << " downto 0);\n";
    const auto& operations = propertySuite->getOperationProperties();
    int i = 0;
    for (const auto& op : operations) {
        ss << "\tconstant op_" << op->getName() << " : " << opTypeName << " := \"" << Utilities::intToBinary(i, vectorSize) << "\";\n";
        i++;
    }
    ss << "\tconstant op_state_wait : " << opTypeName << " := \"" << Utilities::intToBinary(i, vectorSize) << "\";\n\n";
}

/*
 * Prints the given data type in VHDL formatting
 */
std::string VHDLWrapper::printDataTypes(const DataType *dataType) {
    std::stringstream dataTypeStream;

    if (dataType->isEnumType()) {
        dataTypeStream << "\ttype " << SignalFactory::convertDataTypeName(dataType) << " is (";
        for (auto enumVal = dataType->getEnumValueMap().begin(); enumVal != dataType->getEnumValueMap().end(); enumVal++) {
            dataTypeStream << enumVal->first;
            if (std::next(enumVal) != dataType->getEnumValueMap().end()) dataTypeStream << ", ";
        }
        dataTypeStream << ");\n";
    } else if (dataType->isCompoundType()) {
        dataTypeStream << "\ttype " + SignalFactory::convertDataTypeName(dataType) << " is record\n";
        for (auto &subVar: dataType->getSubVarMap()) {
            dataTypeStream << "\t\t" + subVar.first << ": " << SignalFactory::convertDataTypeName(subVar.second) << ";\n";
        }
        dataTypeStream << "\tend record;\n";
    } else if (dataType->isArrayType()) {
        dataTypeStream << "\ttype " << dataType->getName() << " is array (" << (dataType->getSubVarMap().size() - 1)
                       << " downto 0) of " << SignalFactory::convertDataTypeName(dataType->getSubVarMap().begin()->second)
                       << ";\n";
    }

    return dataTypeStream.str();
}

/*
 * Main print function for VHDL wrapper
 */
std::string VHDLWrapper::printArchitecture() {

    std::stringstream ss;

    // Print Include
    ss << "library ieee;\n";
    ss << "use ieee.std_logic_1164.all;\n";
    ss << "use ieee.numeric_std.all;\n";
    ss << "use work." + moduleName + "_operations;\n";
    ss << "use work." + moduleName + "_types.all;\n\n";

    entity(ss);

    ss << "architecture " << propertySuite->getName() << "_arch of " << propertySuite->getName() << "_module is\n";

    signals(ss);
    functions(ss);
    component(ss);

    ss << "\nbegin\n\n";

    componentInst(ss);
    monitor(ss);
    moduleOutputHandling(ss);
    printConstantOutputs(ss);
    controlProcess(ss);

    ss << "end " << propertySuite->getName() << "_arch;\n";

    return ss.str();
}

/*
 * Prints VHDL entity declaration
 */
void VHDLWrapper::entity(std::stringstream &ss) {

    ss << "entity " << propertySuite->getName() << "_module is\n";
    ss << "port(\n";

    auto printPortSignals = [&ss](std::set<DataSignal* > const& dataSignals, bool lastSet) {
        for (auto dataSignal = dataSignals.begin(); dataSignal != dataSignals.end(); dataSignal++) {
            ss << "\t" << (*dataSignal)->getFullName() << ": " << (*dataSignal)->getPort()->getInterface()->getDirection()
               << " " << SignalFactory::convertDataTypeName((*dataSignal)->getDataType(), false);
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
    for (const auto& syncSignal : propertySuite->getSyncSignals()) {
        ss << "\t" << syncSignal->getName() << ": in std_logic;\n";
    }
    printPortSignals(signalFactory->getControlSignals(), true);

    ss << "\n);\n";
    ss << "end " + propertySuite->getName() << "_module;\n\n";
}

/*
 * Prints VHDL functions
 */
void VHDLWrapper::functions(std::stringstream &ss) {

    // Find used functions
    std::set<Function *> usedFunctions;
    for (const auto& property : propertySuite->getOperationProperties()) {
        for (const auto& assumption : property->getOperation()->getAssumptionsList()) {
            const auto& funcSet = ExprVisitor::getUsedFunction(assumption);
            usedFunctions.insert(funcSet.begin(), funcSet.end());
        }
    }

    if (usedFunctions.empty()) {
        return;
    }

    ss << "\n\t-- Functions\n";

    // Print function prototype
    for (const auto& func : usedFunctions) {
        ss << "\tfunction " + func->getName() << "(";

        const auto& parameterMap = func->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); parameter++) {
            if (parameter->second->isCompoundType()) {
                const auto& subVarList = parameter->second->getSubVarList();
                for (auto subVar = subVarList.begin(); subVar!=subVarList.end(); subVar++) {
                    ss << (*subVar)->getFullName("_") << ": " << SignalFactory::convertDataTypeName((*subVar)->getDataType());
                    if (std::next(subVar) != subVarList.end()) {
                        ss << "; ";
                    }
                }
            } else {
                ss << parameter->first << ": " << SignalFactory::convertDataTypeName(parameter->second->getDataType());
            }
            if (std::next(parameter) != parameterMap.end()) {
                ss << "; ";
            }
        }
        ss << ") return " << SignalFactory::convertReturnTypeFunction(func->getReturnType()->getName()) << ";\n";
    }
    ss << "\n";

    // Print function definition
    for (const auto& func : usedFunctions) {
        ss << "\tfunction " + func->getName() << "(";

        const auto& parameterMap = func->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); parameter++) {
            if (parameter->second->isCompoundType()) {
                const auto& subVarList = parameter->second->getSubVarList();
                for (auto subVar = subVarList.begin(); subVar!=subVarList.end(); subVar++) {
                    ss << (*subVar)->getFullName("_") << ": " << SignalFactory::convertDataTypeName((*subVar)->getDataType());
                    if (std::next(subVar) != subVarList.end()) {
                        ss << "; ";
                    }
                }
            } else {
                ss << parameter->first << ": " << SignalFactory::convertDataTypeName(parameter->second->getDataType());
            }
            if (std::next(parameter) != parameterMap.end()) {
                ss << "; ";
            }
        }
        ss << ") return " << SignalFactory::convertReturnTypeFunction(func->getReturnType()->getName()) << " is\n";
        ss << "\tbegin\n";

        if (func->getReturnValueConditionList().empty())
            TERMINATE("No return value for function " + func->getName() + "()")

        const auto& returnValueConditionList = func->getReturnValueConditionList();
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
                    ss << PrintFunction::toString(*cond);
                    if (std::next(cond) != retValData->second.end()) {
                        ss << " and ";
                    }
                }
                ss << " then ";
            }
            ss << PrintFunction::toString(retValData->first) << ";\n";
        }
        if (returnValueConditionList.size() != 1) ss << "\t\tend if;\n";
        ss << "\tend " + func->getName() + ";\n\n";
    }
}

/*
 * Print operation monitor
 */
void VHDLWrapper::monitor(std::stringstream &ss) {
    ss << "\t-- Monitor\n";
    ss << "\tprocess (" << sensitivityList() << ")\n";
    ss << "\tbegin\n";
    ss << "\t\tcase active_state is\n";

    for (const auto& state : currentModule->getFSM()->getStateMap()) {
        if (state.second->isInit()) {
            continue;
        }
        bool noEndIf = false;
        bool skipAssumptions = false;
        ss << "\t\twhen st_" << state.second->getName() << " =>\n";
        auto operations = state.second->getOutgoingOperationsList();
        for (auto operation = operations.begin(); operation != operations.end(); operation++) {
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
                ss << printAssumptionList((*operation)->getAssumptionsList());
                ss << ") then \n";
            }
            ss << printMonitorOperation(*(*operation));
        }
        if (!noEndIf) {
            ss << "\t\t\tend if;\n";
        }
    }
    ss << "\t\tend case;\n";
    ss << "\tend process;\n\n";
}

/*
 * Prints constant outputs based on optimization
 */
void VHDLWrapper::printConstantOutputs(std::stringstream &ss)
{
    auto constantOutputs = optimizer->getConstantOutputs();
    if (constantOutputs.empty()) {
        return;
    }
    ss << "\t-- Constant outputs\n";
    for (const auto& out : constantOutputs) {
        ss << "\t" << out->getFullName() << " <= " << getResetValue(out) << ";\n";
    }
    ss << "\n";
}

/*
 * Prints given list of expressions as a single condition
 */
std::string VHDLWrapper::printAssumptionList(const std::vector<Expr*>& exprList) {
    if (exprList.empty()) {
        return "true";
    }
    std::stringstream ss;
    for (auto expr = exprList.begin(); expr != exprList.end(); expr++) {
        ss << PrintStmtVHDL::toString(*expr);
        if (std::next(expr) != exprList.end()) {
            ss << " and ";
        }
    }
    return ss.str();
}

/*
 * Prints out sensitivity list for the monitor process
 */
std::string VHDLWrapper::sensitivityList() {
    std::stringstream sensitivityListStream;

    std::set<SyncSignal *> sensListSyncSignals;
    std::set<DataSignal *> sensListDataSignals;
    std::set<Variable *> sensListVars;

    const auto& operationProperties = propertySuite->getOperationProperties();
    for (const auto& operationProperty : operationProperties) {
        for (const auto& assumption : operationProperty->getOperation()->getAssumptionsList()) {
            const auto& syncSignals = ExprVisitor::getUsedSynchSignals(assumption);
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
        sensitivityListStream << ", " << PrintFunction::toString(syncSignals);
    }

    for (const auto& dataSignals : sensListDataSignals) {
        sensitivityListStream << ", " << dataSignals->getFullName();
    }

    for (const auto& vars : sensListVars) {
        sensitivityListStream << ", " << vars->getFullName();
    }
    return sensitivityListStream.str();
}

/*
 * Returns reset value for given Variable
 * Used for reset process
 */
std::string VHDLWrapper::getResetValue(Variable* variable)
{
    for (const auto& statement : optimizer->getResetStatements()) {
        auto printResetValue = PrintResetSignal(statement, variable->getName());
        if (printResetValue.toString()) {
            return PrintFunction::toString(statement->getRhs());
        }
    }
    return PrintFunction::toString(variable->getInitialValue());
}

/*
 * Returns reset value for given DataSignal
 * Used for reset process
 */
std::string VHDLWrapper::getResetValue(DataSignal* dataSignal)
{
    for (const auto& statement : optimizer->getResetStatements()) {
        auto printResetValue = PrintResetSignal(statement, dataSignal->getFullName());
        if (printResetValue.toString()) {
            return PrintFunction::toString(statement->getRhs());
        }
    }
    return PrintFunction::toString(dataSignal->getInitialValue());
}