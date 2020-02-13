//
// Created by Paulius Morkunas on 01.12.17.
//

#include <memory>

#include "PrintVHDL.h"
#include "VHDLPrintVisitor.h"
#include "ExprVisitor.h"

using namespace SCAM;

std::map<std::string, std::string> PrintVHDL::printModel(Model *model) {
    // Print types that have to be seen from outside of the provided modules
    for (auto &module : model->getModules()) {
        this->propertySuite = module.second->getPropertySuite();
        this->currentModule = module.second;

        pluginOutput.insert(std::make_pair(model->getName() + "_types.vhd", printTypes(model)));

        // Resolve signals that combinational logic is sensitive to
        resolveSensitivityList();

        // Print module
        std::stringstream ss;
        ss << includes(model);
        ss << entities();
        ss << architecture();

        pluginOutput.insert(std::make_pair(propertySuite->getName() + ".vhd", ss.str()));

        // Clean up for the next module
        ss.str("");
        sensListSyncSignals.clear();
        sensListDataSignals.clear();
        sensListVars.clear();
    }
    return pluginOutput;
}

std::string PrintVHDL::printTypes(Model *model) {
    std::stringstream typeStream;
    typeStream << "-- External data type definition package\n";
    typeStream << "library ieee;\n";
    typeStream << "use ieee.std_logic_1164.all;\n";
    typeStream << "use ieee.numeric_std.all;\n";
    typeStream << "\n";

    typeStream << "package " + model->getName() << "_types is\n\n";

    // Operation enumeration
    typeStream << "-- Operations\n"
               << "\ttype " << propertySuite->getName() << "_operation_t is (";
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
    typeStream << "-- States"
               << "\ttype " + propertySuite->getName() << "_state_t is (";
    for (auto st_it = propertySuite->getStates().begin(); st_it != propertySuite->getStates().end(); st_it++) {
        typeStream << "st_" << (*st_it)->getName();
        if (std::next(st_it) != propertySuite->getStates().end())
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


std::string PrintVHDL::includes(Model *model) {
    std::stringstream includeStream;
    includeStream << "library ieee;\n";
    includeStream << "use ieee.std_logic_1164.all;\n";
    includeStream << "use ieee.numeric_std.all;\n";
    includeStream << "use work." + model->getName() + "_types.all;\n\n";

    return includeStream.str();
}


std::string PrintVHDL::entities() {
    std::stringstream entityStream;
    entityStream << "entity " + propertySuite->getName() + "_module is\n";
    entityStream << "port(\t\n";

    for (auto &it : currentModule->getPorts()) {
        auto port = it.second;
        entityStream << "\t" << port->getName() << "_sig: " << port->getInterface()->getDirection() << " "
                     << convertDataTypeConstrained(port->getDataType()->getName()) << ";\n";
    }

    for (auto syncSignal : propertySuite->getSyncSignals()) {
        entityStream << "\t" << syncSignal->getName() << ": in " << convertDataTypeConstrained("bool") << ";\n";
    }

    for (auto notifySignal : propertySuite->getNotifySignals()) {
        entityStream << "\t" << notifySignal->getName() << ": out " << convertDataTypeConstrained("bool") << ";\n";
    }

    entityStream << "\tclk: in std_logic;\n";
    entityStream << "\trst: in std_logic\n";
    entityStream << ");\n";
    entityStream << "end " + propertySuite->getName() << "_module;\n\n";
    return entityStream.str();
}


std::string PrintVHDL::architecture() {
    std::stringstream archStream;

    archStream << "architecture " << propertySuite->getName() << "_arch of " << propertySuite->getName() << "_module is\n";

    archStream << printInternalSignals();
    archStream << functions();

    // begin of architecture implementation
    archStream << "\nbegin\n";

    archStream << printCombinatorialLogic();
    archStream << "\n";

    archStream << mainProcess();

    return archStream.str();
}

std::string PrintVHDL::printInternalSignals() {
    std::stringstream signalStream;

    signalStream << "\t-- Declare signals\n";
    signalStream << "\tsignal active_state: " << propertySuite->getName() << "_state_t;\n";
    signalStream << "\tsignal active_operation: " << propertySuite->getName() << "_operation_t;\n";

    for (auto &reg : this->currentModule->getVariableMap()) {
        signalStream << "\tsignal " << reg.second->getName() << ": "
            << convertDataTypeConstrained(reg.second->getDataType()->getName()) << ";\n";
    }

    signalStream << "\n";

    // description can be found one line below in the code
    signalStream << "\t-- Declare state signals that are used by ITL properties for OneSpin\n";
    for (auto state : propertySuite->getStates()) {
        signalStream << "\tsignal " << state->getName() << ": boolean;\n";
    }

    return signalStream.str();
}

std::string PrintVHDL::functions() {
    std::stringstream functionStream;

    if (propertySuite->getFunctions().empty()) return functionStream.str();

    functionStream << "\n\t-- Functions\n";
    // Print function declarations
    for (auto func_it: propertySuite->getFunctions()) {
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

std::string PrintVHDL::printCombinatorialLogic() {
    std::stringstream logicStream;

    logicStream << "\t-- Combinatorial logic that selects current operation\n";
    logicStream << "\tprocess (";
    logicStream << printSensitivityList();
    logicStream << ")\n";
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
            logicStream << "\t\t\t\tactive_operation <= op_" << (*op_it)->getName() << ";\n";
        }
        if (commentOutEndIf) logicStream << "\t\t\t--end if;\n";
        else logicStream << "\t\t\tend if;\n";

    }
    logicStream << "\t\tend case;\n";
    logicStream << "\tend process;\n\n";

    return logicStream.str();
}

std::string PrintVHDL::printAssumptions(const std::vector<Expr *> &exprList) {
    std::stringstream assumptionsStream;
    if (exprList.empty()) return "true";
    for (auto it = exprList.begin(); it != exprList.end(); ++it) {
        assumptionsStream << VHDLPrintVisitor::toString(*it);
        if (it != --exprList.end()) {
            assumptionsStream << " and ";
        }
    }
    return assumptionsStream.str();
}

std::string PrintVHDL::mainProcess() {
    std::stringstream mainProcessStream;

    mainProcessStream << "\t-- Main process\n";
    mainProcessStream << "\tprocess (clk, rst)\n";
    mainProcessStream << "\tbegin\n";
    mainProcessStream << "\t\tif (rst = '1') then\n";
    mainProcessStream << "\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getNextState()->getName() << ";\n";
    for (auto assign_it : propertySuite->getResetProperty()->getCommitmentList()) {
        mainProcessStream << "\t\t\t" << VHDLPrintVisitor::toString(assign_it);
    }
    mainProcessStream << "\t\telsif (clk = '1' and clk'event) then\n";

    mainProcessStream << "\t\t\tcase active_operation is\n";
    for (auto op_it : propertySuite->getOperationProperties()) {
        mainProcessStream << "\t\t\twhen op_" << op_it->getName() << " =>\n";
        mainProcessStream << "\t\t\t\tactive_state <= st_" << op_it->getNextState()->getName() << ";\n";
        for (auto assign_it : op_it->getCommitmentList()) {
            mainProcessStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
        }
        for (auto notify : propertySuite->getNotifySignals()){
            switch(op_it->getTiming(notify->getPort())){
                case TT_1:
                case FT_e: mainProcessStream << "\t\t\t\t" << notify->getName() << " <= true;\n"; break;
                case FF_1:
                case FF_e: mainProcessStream << "\t\t\t\t" << notify->getName() << " <= false;\n"; break;

            }
        }
    }
    for (auto op_it : propertySuite->getWaitProperties()) {
        mainProcessStream << "\t\t\twhen op_" << op_it->getName() << " =>\n";
        mainProcessStream << "\t\t\t\t--active_state <= st_" << op_it->getNextState()->getName() << ";\n";
        // TODO: "blocking_notify <= true" can be removed since it does not change
        for (auto assign_it : op_it->getCommitmentList()) {
            mainProcessStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
        }
    }

    mainProcessStream << "\t\t\tend case;\n";
    mainProcessStream << "\t\tend if;\n";
    mainProcessStream << "\tend process;\n\n";

    mainProcessStream << "\t-- Assigning state signals that are used by ITL properties for OneSpin\n";
    for (auto &state_it : propertySuite->getStates()) {
        mainProcessStream << "\t" << state_it->getName() << " <= active_state = st_" << state_it->getName()
                          << ";\n";
    }

    mainProcessStream << "\nend " + propertySuite->getName() << "_arch;\n\n";
    return mainProcessStream.str();
}

void PrintVHDL::resolveSensitivityList() {
    auto operationProperties = propertySuite->getOperationProperties();
    for (auto operationProperty : operationProperties) {

        for (auto assumption_it : operationProperty->getAssumptionList()) {
            auto tempSet1 = ExprVisitor::getUsedSynchSignals(assumption_it);
            sensListSyncSignals.insert(tempSet1.begin(), tempSet1.end());

            auto tempSet2 = ExprVisitor::getUsedDataSignals(assumption_it);
            sensListDataSignals.insert(tempSet2.begin(), tempSet2.end());

            auto tempSet3 = ExprVisitor::getUsedVariables(assumption_it);
            sensListVars.insert(tempSet3.begin(), tempSet3.end());
        }
    }

    auto waitProperties = propertySuite->getWaitProperties();
    for (auto waitProperty : waitProperties) {

        for (auto assumption_it : waitProperty->getAssumptionList()) {
            auto tempSet1 = ExprVisitor::getUsedSynchSignals(assumption_it);
            sensListSyncSignals.insert(tempSet1.begin(), tempSet1.end());

            auto tempSet2 = ExprVisitor::getUsedDataSignals(assumption_it);
            sensListDataSignals.insert(tempSet2.begin(), tempSet2.end());

            auto tempSet3 = ExprVisitor::getUsedVariables(assumption_it);
            sensListVars.insert(tempSet3.begin(), tempSet3.end());
        }
    }
}

std::string PrintVHDL::printSensitivityList() {
    std::stringstream sensitivityListStream;

    sensitivityListStream << "active_state";

    for (auto it : sensListSyncSignals) {
        sensitivityListStream << ", ";
        sensitivityListStream << VHDLPrintVisitor::toString(it);
    }

    for (auto it : sensListDataSignals) {
        sensitivityListStream << ", ";
        sensitivityListStream << it->getFullName();
    }

    for (auto it : sensListVars) {
        sensitivityListStream << ", ";
        sensitivityListStream << it->getFullName();
    }

    return sensitivityListStream.str();
}

std::string PrintVHDL::convertDataTypeConstrained(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "boolean";
    } else if (dataTypeName == "int") {
        return "signed(31 downto 0)";
    } else if (dataTypeName == "unsigned") {
        return "unsigned(31 downto 0)";
    } else if (nullptr != propertySuite && dataTypeName == propertySuite->getName() + "_SECTIONS") {
        return propertySuite->getName() + "_sections_t";
    } else {
        return dataTypeName;
    }
}

std::string PrintVHDL::convertDataType(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "boolean";
    } else if (dataTypeName == "int") {
        return "signed";
    } else if (nullptr != propertySuite && dataTypeName == propertySuite->getName() + "_SECTIONS") {
        return propertySuite->getName() + "_sections_t";
    } else {
        return dataTypeName;
    }
}

std::string PrintVHDL::printDataTypes(const DataType *dataType) {
    std::stringstream dataTypeStream;

    if (dataType->isEnumType()) {
        dataTypeStream << "\ttype " << convertDataTypeConstrained(dataType->getName()) << " is (";
        for (auto enumVal = dataType->getEnumValueMap().begin(); enumVal != dataType->getEnumValueMap().end(); enumVal++) {
            dataTypeStream << enumVal->first;
            if (enumVal != --dataType->getEnumValueMap().end()) dataTypeStream << ", ";
        }
        dataTypeStream << ");\n";
    } else if (dataType->isCompoundType()) {
        dataTypeStream << "\ttype " + convertDataTypeConstrained(dataType->getName()) << " is record\n";
        for (auto &subVar: dataType->getSubVarMap()) {
            dataTypeStream << "\t\t" + subVar.first << ": " << convertDataTypeConstrained(subVar.second->getName()) << ";\n";
        }
        dataTypeStream << "\tend record;\n";
    } else if (dataType->isArrayType()) {
        dataTypeStream << "\ttype " << dataType->getName() << " is array (" << (dataType->getSubVarMap().size() - 1)
            << " downto 0) of " << convertDataTypeConstrained(dataType->getSubVarMap().begin()->second->getName())
            << ";\n";
    }
    return dataTypeStream.str();
}
