//
// Created by Paulius Morkunas on 01.12.17.
//

#include <fstream>
#include <assert.h>
#include <StmtNodeAlloc.h>


#include "PrintVHDL.h"
#include "VHDLPrintVisitor.h"
#include "ExprVisitor.h"
#include "NodePeekVisitor.h"


using namespace SCAM;

std::map<std::string, std::string> PrintVHDL::printModel(Model *model) {

    // Print types that have to be seen from outside of the provided modules
    pluginOutput.insert(std::make_pair(model->getName() + "_types.vhd", printTypes(model)));
    std::stringstream ss;
    for (auto &module : model->getModules()) {
        this->propertySuite = module.second->getPropertySuite();
        this->module = module.second;

        // Resolve signals that combinational logic is sensitive to
        resolveSensitivityList();

        // Print module
        ss << includes(model);
        ss << entities();
        ss << architecture();

        pluginOutput.insert(std::make_pair(propertySuite->getName() + ".vhd", ss.str()));

        // Clean up for the next module
        ss.str(""); // remove previous contents of the stringstream
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

    typeStream << "package " + model->getName() << "_types is\n";

    for (auto &module : model->getModules()) {
        for (auto &port : module.second->getPorts()) {
            typeStream << printDataTypes(port.second->getDataType());
        }
    }

    typeStream << "end package " + model->getName() << "_types;\n\n";
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
    entityStream << "entity " + convertIfReserved(propertySuite->getName()) + " is\n";
    entityStream << "port(\t\n";

    //FIXME use propertySuite for ports
//    for (auto &it : propertySuite->getDpSignals()) {
//        auto port = it->getPort();
//        entityStream << "\t" << port->getName() << "_sig: " << port->getInterface()->getDirection() << " "
//                     << convertDataTypeConstrained(port->getDataType()->getName()) << ";\n";
//    }

    for (auto &it : module->getPorts()) {
        auto port = it.second;
        entityStream << "\t" << port->getName() << "_sig: " << port->getInterface()->getDirection() << " "
                     << convertDataTypeConstrained(port->getDataType()->getName()) << ";\n";
    }

    for (auto syncSignal : propertySuite->getSyncSignals()) {
        entityStream << "\t" << syncSignal->getName() << ": in boolean;\n";
    }

    for (auto notifySignal : propertySuite->getNotifySignals()) {
        entityStream << "\t" << notifySignal->getName() << ": out boolean;\n";
    }

    entityStream << "\tclk: in std_logic;\n";
    entityStream << "\trst: in std_logic\n";
    entityStream << ");\n";
    entityStream << "end " + convertIfReserved(propertySuite->getName()) << ";\n\n";
    return entityStream.str();
}


std::string PrintVHDL::architecture() {
    std::stringstream archStream;

    //<editor-fold desc="Signal declarations">
    archStream << "architecture " << propertySuite->getName() << "_arch of " << convertIfReserved(
            propertySuite->getName()) << " is\n";

    archStream << "\t-- Define internal data types\n";

    // Operation enumeration
    archStream << "\ttype " << propertySuite->getName() << "_operation_t is (";
    for (auto op_it = propertySuite->getOperationProperties().begin(); op_it != propertySuite->getOperationProperties().end(); op_it++) {
        archStream << "op_" << (*op_it)->getName();
        if (std::next(op_it) != propertySuite->getOperationProperties().end())
            archStream << ", ";
    }
    if (propertySuite->getWaitProperties().size() > 0)
        archStream << ", ";
    for (auto op_it = propertySuite->getWaitProperties().begin(); op_it != propertySuite->getWaitProperties().end(); op_it++) {
        archStream << "op_" << (*op_it)->getName();
        if (std::next(op_it) != propertySuite->getWaitProperties().end())
            archStream << ", ";
    }
    archStream << ");\n";

    // State enumeration
    archStream << "\ttype " + propertySuite->getName() << "_state_t is (";
    for (auto st_it = propertySuite->getStates().begin(); st_it != propertySuite->getStates().end(); st_it++) {
        archStream << "st_" << (*st_it)->getName();
        if (std::next(st_it) != propertySuite->getStates().end())
            archStream << ", ";
    }
    archStream << ");\n";

    for (auto &reg : propertySuite->getVisibleRegisters()) {
        archStream << printDataTypes(reg->getDataType());
    }

    for (auto &func : propertySuite->getFunctions()) {
        archStream << printDataTypes(func->getReturnType());
    }

    archStream << "\n";

    archStream << "\t-- Declare signals\n";
    archStream << "\tsignal active_state: " << propertySuite->getName() << "_state_t;\n";
    archStream << "\tsignal active_operation: " << propertySuite->getName() << "_operation_t;\n";

    // add variables
    //FIXME prints wrong data types (records do not appear)
//    for (auto &reg : propertySuite->getVisibleRegisters()) {
//        archStream << "\tsignal " << reg->getName() << ": " << convertDataTypeConstrained(reg->getDataType()->getName()) << ";\n";
//    }

    for (auto &reg : this->module->getVariableMap()) {
        archStream << "\tsignal " << reg.second->getName() << ": " << convertDataTypeConstrained(reg.second->getDataType()->getName()) << ";\n";
    }

    archStream << "\n";

    // description can be found one line below in the code
    archStream << "\t-- Declare state signals that are used by ITL properties for OneSpin\n";
    for (auto state : propertySuite->getStates()) {
        archStream << "\tsignal " << state->getName() << ": boolean;\n";
    }

    //</editor-fold>

    archStream << functions();

    // begin of architecture implementation
    archStream << "\nbegin\n";

    //<editor-fold desc="Combinational logic that selects current operation">
    archStream << "\t-- Combinational logic that selects current operation\n";
    archStream << "\tprocess (";
    archStream << printSensitivityList();
    archStream << ")\n";
    archStream << "\tbegin\n";
    archStream << "\t\tcase active_state is\n";

    for (auto state_it: propertySuite->getStates()) {
        bool commentOutEndIf = false;
        //if (state_it.second->isInit()) continue;
        archStream << "\t\twhen st_" << state_it->getName() << " =>\n";


        auto op_list = propertySuite->getSuccessorProperties(state_it);
        for (auto op_it = op_list.begin(); op_it != op_list.end(); ++op_it) {
            if (op_it == op_list.begin()) {
                if (op_list.size() == 1) {
                    archStream << "\t\t\t--if (";
                    commentOutEndIf = true;
                } else {
                    archStream << "\t\t\tif (";
                }
            } else if (std::next(op_it) == op_list.end()) {
                // make last operation as default, saves some logic
                archStream << "\t\t\telse--if(";
            } else {
                archStream << "\t\t\telsif (";
            }
            archStream << printAssumptions((*op_it)->getAssumptionList());
            archStream << ") then \n";
            archStream << "\t\t\t\tactive_operation <= op_" << (*op_it)->getName() << ";\n";
        }
        if (commentOutEndIf) archStream << "\t\t\t--end if;\n";
        else archStream << "\t\t\tend if;\n";

    }
    archStream << "\t\tend case;\n";
    archStream << "\tend process;\n\n";

    //</editor-fold>
    
    //<editor-fold desc="Main process">
    archStream << "\t-- Main process\n";
    archStream << "\tprocess (clk, rst)\n";
    archStream << "\tbegin\n";
    archStream << "\t\tif (rst = '1') then\n";
    archStream << "\t\t\t\tactive_state <= st_" << propertySuite->getResetProperty()->getNextState()->getName() << ";\n";
    for (auto assign_it : propertySuite->getResetProperty()->getCommitmentList()) {
        archStream << "\t\t\t" << VHDLPrintVisitor::toString(assign_it);
    }
    archStream << "\t\telsif (clk = '1' and clk'event) then\n";

    archStream << "\t\t\tcase active_operation is\n";
    for (auto op_it : propertySuite->getOperationProperties()) {
        archStream << "\t\t\twhen op_" << op_it->getName() << " =>\n";
        archStream << "\t\t\t\tactive_state <= st_" << op_it->getNextState()->getName() << ";\n";
        for (auto assign_it : op_it->getCommitmentList()) {
            archStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
        }
        for (auto notify : propertySuite->getNotifySignals()){
            switch(op_it->getTiming(notify->getPort())){
                case TT_1:
                case FT_e: archStream << "\t\t\t\t" << notify->getName() << " <= true;\n"; break;
                case FF_1:
                case FF_e: archStream << "\t\t\t\t" << notify->getName() << " <= false;\n"; break;

            }
        }
    }
    for (auto op_it : propertySuite->getWaitProperties()) {
        archStream << "\t\t\twhen op_" << op_it->getName() << " =>\n";
        archStream << "\t\t\t\t--active_state <= st_" << op_it->getNextState()->getName() << ";\n";
        // TODO: "blocking_notify <= true" can be removed since it does not change
        for (auto assign_it : op_it->getCommitmentList()) {
            archStream << "\t\t\t\t" << VHDLPrintVisitor::toString(assign_it);
        }
    }

    archStream << "\t\t\tend case;\n";
    archStream << "\t\tend if;\n";
    archStream << "\tend process;\n\n";
    //</editor-fold>
    
    // description can be found one line below in the code
    archStream << "\t-- Assigning state signals that are used by ITL properties for OneSpin\n";
    for (auto &state_it : propertySuite->getStates()) {
        archStream << "\t" << state_it->getName() << " <= active_state = st_" << state_it->getName()
                   << ";\n";
    }

    archStream << "\nend " + propertySuite->getName() << "_arch;\n\n";
    return archStream.str();
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

void PrintVHDL::resolveSensitivityList() {
    auto op_list = propertySuite->getOperationProperties();
    for (auto op_it = op_list.begin(); op_it != op_list.end(); ++op_it) {

        for (auto assumption_it : (*op_it)->getAssumptionList()) {
            auto tempSet1 = ExprVisitor::getUsedSynchSignals(assumption_it);
            sensListSyncSignals.insert(tempSet1.begin(), tempSet1.end());

            auto tempSet2 = ExprVisitor::getUsedDataSignals(assumption_it);
            sensListDataSignals.insert(tempSet2.begin(), tempSet2.end());

            auto tempSet3 = ExprVisitor::getUsedVariables(assumption_it);
            sensListVars.insert(tempSet3.begin(), tempSet3.end());
        }
    }

    auto waitop_list = propertySuite->getWaitProperties();
    for (auto op_it = waitop_list.begin(); op_it != waitop_list.end(); ++op_it) {

        for (auto assumption_it : (*op_it)->getAssumptionList()) {
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

std::string PrintVHDL::convertIfReserved(std::string name) {
    std::vector<std::string> keywords;
    // Enlist all of the keywords that can not be used as module name (might be more, added only most common ones)
    keywords.push_back("abs");
    keywords.push_back("access");
    keywords.push_back("after");
    keywords.push_back("alias");
    keywords.push_back("all");
    keywords.push_back("and");
    keywords.push_back("architecture");
    keywords.push_back("array");
    keywords.push_back("assert");
    keywords.push_back("attribute");
    keywords.push_back("begin");
    keywords.push_back("block");
    keywords.push_back("body");
    keywords.push_back("buffer");
    keywords.push_back("bus");
    keywords.push_back("case");
    keywords.push_back("component");
    keywords.push_back("configuration");
    keywords.push_back("constant");
    keywords.push_back("disconnect");
    keywords.push_back("downto");
    keywords.push_back("else");
    keywords.push_back("elsif");
    keywords.push_back("end");
    keywords.push_back("entity");
    keywords.push_back("exit");
    keywords.push_back("file");
    keywords.push_back("for");
    keywords.push_back("function");
    keywords.push_back("generate");
    keywords.push_back("generic");
    keywords.push_back("group");
    keywords.push_back("guarded");
    keywords.push_back("if");
    keywords.push_back("impure");
    keywords.push_back("in");
    keywords.push_back("inertial");
    keywords.push_back("inout");
    keywords.push_back("is");
    keywords.push_back("label");
    keywords.push_back("library");
    keywords.push_back("linkage");
    keywords.push_back("literal");
    keywords.push_back("loop");
    keywords.push_back("map");
    keywords.push_back("mod");
    keywords.push_back("nand");
    keywords.push_back("new");
    keywords.push_back("next");
    keywords.push_back("nor");
    keywords.push_back("not");
    keywords.push_back("nul");
    keywords.push_back("of");
    keywords.push_back("on");
    keywords.push_back("open");
    keywords.push_back("or");
    keywords.push_back("others");
    keywords.push_back("out");
    keywords.push_back("package");
    keywords.push_back("port");
    keywords.push_back("postponed");
    keywords.push_back("procedure");
    keywords.push_back("process");
    keywords.push_back("pure");
    keywords.push_back("range");
    keywords.push_back("record");
    keywords.push_back("register");
    keywords.push_back("reject");
    keywords.push_back("rem");
    keywords.push_back("report");
    keywords.push_back("return");
    keywords.push_back("rol");
    keywords.push_back("ror");
    keywords.push_back("select");
    keywords.push_back("severity");
    keywords.push_back("shared");
    keywords.push_back("signal");
    keywords.push_back("sla");
    keywords.push_back("sll");
    keywords.push_back("sra");
    keywords.push_back("srl");
    keywords.push_back("subtype");
    keywords.push_back("then");
    keywords.push_back("to");
    keywords.push_back("transport");
    keywords.push_back("type");
    keywords.push_back("unaffected");
    keywords.push_back("units");
    keywords.push_back("until");
    keywords.push_back("use");
    keywords.push_back("variable");
    keywords.push_back("wait");
    keywords.push_back("when");
    keywords.push_back("while");
    keywords.push_back("with");
    keywords.push_back("xnor");
    keywords.push_back("xor");

    for (auto word_it : keywords) {
        if (stringCompare(word_it, name)) {
            return name + "_1";
        }
    }
    return name;
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
//                for (auto it = param_it->second->getDataType()->getSubVarMap().begin(); it != param_it->second->getDataType()->getSubVarMap().end(); ++it) {
//                    functionStream << param_it->first << "_" << it->first << ": " << convertDataType(
//                            it->second->getName());
//                    if (it != --param_it->second->getDataType()->getSubVarMap().end())
//                        functionStream << "; ";
//                }
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
//                for (auto iterator = param_it->second->getDataType()->getSubVarMap().begin(); iterator != param_it->second->getDataType()->getSubVarMap().end(); ++iterator) {
//                    functionStream << param_it->first << "_" << iterator->first << ": " << convertDataType(
//                            iterator->second->getName());
//                    if (iterator != --param_it->second->getDataType()->getSubVarMap().end())
//                        functionStream << "; ";
//                }
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

std::string PrintVHDL::printDataTypes(const DataType *dataType) {
    std::stringstream dataTypeStream;

    // this function does not print duplicate data types (it remembers printed data types)
    static std::map<std::string, const DataType *> printedTypes;

    if (dataType->isEnumType()) {
        if (printedTypes.find(dataType->getName()) == printedTypes.end()) {
            printedTypes.insert(std::make_pair(dataType->getName(), dataType));

            dataTypeStream << "\ttype " << convertDataTypeConstrained(dataType->getName()) << " is (";
            for (auto enumVal = dataType->getEnumValueMap().begin(); enumVal != dataType->getEnumValueMap().end(); enumVal++) {
                dataTypeStream << enumVal->first;
                if (enumVal != --dataType->getEnumValueMap().end()) dataTypeStream << ", ";
            }
            dataTypeStream << ");\n";
        }
    } else if (dataType->isCompoundType()) {
        if (printedTypes.find(dataType->getName()) == printedTypes.end()) {
            printedTypes.insert(std::make_pair(dataType->getName(), dataType));

            for (auto subVar: dataType->getSubVarMap()) {
                dataTypeStream << printDataTypes(subVar.second);
            }

            dataTypeStream << "\ttype " + convertDataTypeConstrained(dataType->getName()) << " is record\n";
            for (auto subVar: dataType->getSubVarMap()) {
                dataTypeStream << "\t\t" + subVar.first << ": " << convertDataTypeConstrained(subVar.second->getName()) << ";\n";
            }
            dataTypeStream << "\tend record;\n";
        }
    }
    return dataTypeStream.str();
}

/*
 * Case Insensitive String Comparision
 */
bool PrintVHDL::stringCompare(std::string &str1, std::string &str2) {
    return ((str1.size() == str2.size()) && std::equal(str1.begin(), str1.end(), str2.begin(), [](char & c1, char & c2){
        return (c1 == c2 || std::toupper(c1) == std::toupper(c2));
    }));
}