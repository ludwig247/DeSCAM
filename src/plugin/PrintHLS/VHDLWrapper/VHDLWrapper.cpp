//
// Created by johannes on 13.02.20.
//

#include "ExprVisitor.h"
#include "Utilities.h"
#include "VHDLWrapper.h"
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

    typeStream << "\t -- States\n"
               << "\ttype " + propertySuite->getName() << "_state_t is (";
    const auto &states = propertySuite->getStates();
    for (auto state = states.begin(); state != states.end(); ++state) {
        typeStream << "st_" << (*state)->getName();
        if (std::next(state) != states.end()) {
            typeStream << ", ";
        }
    }
    typeStream << ");\n\n";

    operationEnum(typeStream);

    if (!optimizer->getEnumTypes().empty()) {
        typeStream << "\t-- Enum Types\n";
    }
    for (const auto &type : optimizer->getEnumTypes()) {
        typeStream << printDataTypes(type);
    }

    if (!optimizer->getCompoundTypes().empty()) {
        typeStream << "\n\t-- Compound Types\n";
    }
    for (const auto &type : optimizer->getCompoundTypes()) {
        typeStream << printDataTypes(type);
    }

    if (!optimizer->getArrayTypes().empty()) {
        typeStream << "\n\t-- Array Types\n";
    }
    for (const auto &type : optimizer->getArrayTypes()) {
        typeStream << printDataTypes(type);
    }

    if (!optimizer->getConstantVariables().empty()) {
        typeStream << "\n\t-- Constants\n";
    }
    for (const auto &var : Utilities::getParents(optimizer->getConstantVariables())) {
        typeStream << "\tconstant " << var->getName() << ": " << SignalFactory::convertDataTypeName(var->getDataType())
                   << " := " << getResetValue(var) << ";\n";
    }

    typeStream << "\nend package " + moduleName << "_types;";

    return typeStream.str();
}

/*
 * Prints operation subtype for types package
 */
void VHDLWrapper::operationEnum(std::stringstream &ss) {

    const auto waitPropertiesUsed = !propertySuite->getWaitProperties().empty();

    auto numberOfProperties = propertySuite->getOperationProperties().size();
    numberOfProperties += (waitPropertiesUsed ? 1 : 0);
    int vectorSize = ceil(log2(numberOfProperties));
    vectorSize += ((vectorSize == 0) ? 1 : 0);

    std::string opTypeName = propertySuite->getName() + "_operation_t";

    ss << "\t-- Operations\n"
       << "\tsubtype " << opTypeName << " is std_logic_vector("
       << std::to_string(vectorSize - 1) << " downto 0);\n";
    int i = 0;
    for (const auto &op : propertySuite->getOperationProperties()) {
        ss << "\tconstant op_" << op->getName() << " : " << opTypeName << " := \""
           << Utilities::intToBinary(i, vectorSize) << "\";\n";
        i++;
    }
    if (waitPropertiesUsed) {
        ss << "\tconstant op_state_wait : " << opTypeName << " := \"" << Utilities::intToBinary(i, vectorSize) << "\";\n";
    }
    ss << "\n";
}

/*
 * Prints the given data type in VHDL formatting
 */
std::string VHDLWrapper::printDataTypes(const DataType *dataType) {
    std::stringstream dataTypeStream;

    if (dataType->isEnumType()) {
        const auto typeName = SignalFactory::convertDataTypeName(dataType);
        int i = 0;
        int vectorSize = ceil(log2(dataType->getEnumValueMap().size()));
        if (vectorSize == 0) {
            vectorSize++;
        }
        dataTypeStream << "\tsubtype " << typeName << " is std_logic_vector(" << std::to_string(vectorSize - 1)
                       << " downto 0);\n";
        for (const auto &enumVal : dataType->getEnumValueMap()) {
            dataTypeStream << "\tconstant " << enumVal.first << " : " << typeName << " := \""
                           << Utilities::intToBinary(i, vectorSize) << "\";\n";
            i++;
        }
    } else if (dataType->isCompoundType()) {
        dataTypeStream << "\ttype " + SignalFactory::convertDataTypeName(dataType) << " is record\n";
        for (const auto &subVar: dataType->getSubVarMap()) {
            dataTypeStream << "\t\t" + subVar.first << ": " << SignalFactory::convertDataTypeName(subVar.second)
                           << ";\n";
        }
        dataTypeStream << "\tend record;\n";
    } else if (dataType->isArrayType()) {
        dataTypeStream << "\ttype " << dataType->getName() << " is array (" << (dataType->getSubVarMap().size() - 1)
                       << " downto 0) of "
                       << SignalFactory::convertDataTypeName(dataType->getSubVarMap().begin()->second)
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

    auto printPortSignals = [&ss](std::set<DataSignal *> const &dataSignals, bool lastSet) {
        for (auto dataSignal = dataSignals.begin(); dataSignal != dataSignals.end(); dataSignal++) {
            ss << "\t" << (*dataSignal)->getFullName() << ": "
               << (*dataSignal)->getPort()->getInterface()->getDirection()
               << " " << SignalFactory::convertDataTypeName((*dataSignal)->getDataType(), false);
            if (std::next(dataSignal) != dataSignals.end() || !lastSet) {
                ss << ";\n";
            }
        }
    };
    printPortSignals(signalFactory->getInputs(), false);
    printPortSignals(signalFactory->getOutputs(), false);
    for (const auto &notifySignal : propertySuite->getNotifySignals()) {
        ss << "\t" << notifySignal->getName() << ": out std_logic;\n";
    }
    for (const auto &syncSignal : propertySuite->getSyncSignals()) {
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
    for (const auto &property : propertySuite->getOperationProperties()) {
        for (const auto &assumption : property->getOperation()->getAssumptionsList()) {
            const auto &funcSet = ExprVisitor::getUsedFunction(assumption);
            usedFunctions.insert(funcSet.begin(), funcSet.end());
        }
    }

    ss << "\n\t-- Functions\n";

    // Print function prototype
    ss << "\tfunction bool_to_sl(x : boolean) return std_logic;\n";
    for (const auto &func : usedFunctions) {
        ss << "\tfunction " + func->getName() << "(";

        const auto &parameterMap = func->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); parameter++) {
            if (parameter->second->isCompoundType()) {
                const auto &subVarList = parameter->second->getSubVarList();
                for (auto subVar = subVarList.begin(); subVar != subVarList.end(); subVar++) {
                    ss << (*subVar)->getFullName("_") << ": "
                       << SignalFactory::convertDataTypeName((*subVar)->getDataType());
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
        ss << ") return " << SignalFactory::convertReturnType(*(func->getReturnType())) << ";\n";
    }
    ss << "\n";

    // Print function definition
    ss << "\tfunction bool_to_sl(x : boolean) return std_logic is\n"
          "\tbegin\n"
          "  \tif x then\n"
          "    \treturn '1';\n"
          "  \telse\n"
          "    \treturn '0';\n"
          "  \tend if;\n"
          "  end bool_to_sl;\n\n";
    for (const auto &func : usedFunctions) {
        ss << "\tfunction " + func->getName() << "(";

        const auto &parameterMap = func->getParamMap();
        for (auto parameter = parameterMap.begin(); parameter != parameterMap.end(); parameter++) {
            if (parameter->second->isCompoundType()) {
                const auto &subVarList = parameter->second->getSubVarList();
                for (auto subVar = subVarList.begin(); subVar != subVarList.end(); subVar++) {
                    ss << (*subVar)->getFullName("_") << ": "
                       << SignalFactory::convertDataTypeName((*subVar)->getDataType());
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
        ss << ") return " << SignalFactory::convertReturnType(*(func->getReturnType())) << " is\n";
        ss << "\tbegin\n";

        if (func->getReturnValueConditionList().empty()) TERMINATE(
                "No return value for function " + func->getName() + "()")

        const auto &returnValueConditionList = func->getReturnValueConditionList();
        for (auto retValData = returnValueConditionList.begin();
             retValData != returnValueConditionList.end(); retValData++) {
            ss << "\t\t";
            if (retValData == (returnValueConditionList.end() - 1)) {
                if (returnValueConditionList.size() != 1)
                    ss << "else ";
            } else {
                if (retValData == returnValueConditionList.begin()) {
                    ss << "if ";
                } else {
                    ss << "elsif ";
                }
                ss << "(";
                for (auto cond = retValData->second.begin(); cond != retValData->second.end(); cond++) {
                    ss << PrintStmtVHDL::toString(*cond);
                    if (std::next(cond) != retValData->second.end()) {
                        ss << " and ";
                    }
                }
                ss << ") = '1'";
                ss << " then ";
            }
            ss << PrintStmtVHDL::toString(retValData->first) << ";\n";
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

    for (const auto &state : currentModule->getFSM()->getStateMap()) {
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
                    ss << "\t\t\tif ";
                }
            } else if (std::next(operation) == operations.end()) {
                ss << "\t\t\telse\n";
                skipAssumptions = true;
            } else {
                ss << "\t\t\telsif ";
            }
            if (!skipAssumptions) {
                ss << printAssumptionList((*operation)->getAssumptionsList());
                ss << " then \n";
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
void VHDLWrapper::printConstantOutputs(std::stringstream &ss) {
    auto constantOutputs = optimizer->getConstantOutputs();
    if (constantOutputs.empty()) {
        return;
    }
    ss << "\t-- Constant outputs\n";
    for (const auto &out : constantOutputs) {
        ss << "\t" << out->getFullName() << " <= " << getResetValue(out) << ";\n";
    }
    ss << "\n";
}

/*
 * Prints given list of expressions as a single condition
 */
std::string VHDLWrapper::printAssumptionList(const std::vector<Expr *> &exprList) {
    if (exprList.empty()) {
        return "true";
    }
    std::stringstream ss;
    ss << "(";
    for (auto expr = exprList.begin(); expr != exprList.end(); expr++) {
        ss << PrintStmtVHDL::toString(*expr);
        if (std::next(expr) != exprList.end()) {
            ss << " and ";
        }
    }
    ss << ") = '1'";
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

    const auto &operationProperties = propertySuite->getOperationProperties();
    for (const auto &operationProperty : operationProperties) {
        for (const auto &assumption : operationProperty->getOperation()->getAssumptionsList()) {
            const auto &syncSignals = ExprVisitor::getUsedSynchSignals(assumption);
            sensListSyncSignals.insert(syncSignals.begin(), syncSignals.end());

            const auto &dataSignals = ExprVisitor::getUsedDataSignals(assumption);
            sensListDataSignals.insert(dataSignals.begin(), dataSignals.end());

            const auto &vars = ExprVisitor::getUsedVariables(assumption);
            for (const auto &var : vars) {
                if (!optimizer->isConstant(var)) {
                    sensListVars.insert(var);
                }
            }
        }
    }

    sensitivityListStream << "active_state";
    for (const auto &sync : sensListSyncSignals) {
        sensitivityListStream << ", " << sync->getPort()->getName() << "_sync";
    }

    for (const auto &dataSignals : sensListDataSignals) {
        sensitivityListStream << ", " << dataSignals->getFullName();
    }

    for (const auto &vars : sensListVars) {
        sensitivityListStream << ", " << vars->getFullName();
    }
    return sensitivityListStream.str();
}

/*
 * Finds and returns the reset value of the given signal
 * Intended inputs types are Variable and DataSignal
 */
template<typename T>
std::string VHDLWrapper::getResetValue(const T &signal) {
    for (const auto &assignment : optimizer->getResetStatements()) {
        if (PrintStmtVHDL::toString(assignment->getLhs()) == signal->getFullName()) {
            return PrintStmtVHDL::toString(assignment->getRhs());
        }
    }
    return PrintStmtVHDL::toString(signal->getInitialValue());
}
