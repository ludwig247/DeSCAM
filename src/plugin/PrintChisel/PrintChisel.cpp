//
// Created by Lukas Krupp on 05.02.19.
//
#include <fstream>
#include <ExprVisitor.h>
#include <cstring>

#include "PrintChisel.h"
#include "Config.h"
#include "ChiselConditionVisitor.h"
#include "ChiselDatapathVisitor.h"
#include "ChiselSVAConditionVisitor.h"
#include "ChiselSVADatapathVisitor.h"

std::map<std::string, std::string> PrintChisel::printModel(Model *node) {

    for (auto &module: node->getModules()) {
        //pluginOutput.insert(std::make_pair("ipc.sva", Text_ipc()));
        this->module = module.second;
        pluginOutput.insert(std::make_pair(module.first + ".scala", constructScala()));
        pluginOutput.insert(std::make_pair(module.first + "_functions.scala", functions()));
        pluginOutput.insert(std::make_pair(module.first + ".sva", autorefine()));
        pluginOutput.insert(std::make_pair(module.first + "_functions.sva", sva_functions()));
        pluginOutput.insert(std::make_pair("types.sva", types()));
        //pluginOutput.insert(std::make_pair(module.first + "_functions.sva", SVAfunctions()));
    }
    return pluginOutput;
}

std::map<std::string, std::string> PrintChisel::printModule(DESCAM::Module *node) {

    this->module = node;

    pluginOutput.insert(std::make_pair(node->getName() + ".scala", constructScala()));
    //pluginOutput.insert(std::make_pair(node->getName() + "_functions.vhi",functions()));

    return pluginOutput;
}


/*===============================================================================*/
/*                                  Chisel                                       */
/*===============================================================================*/
std::string PrintChisel::functions() {
    std::stringstream ss;
    if (module->getFunctionMap().empty()) return ss.str();
    PropertySuite *ps = this->module->getPropertySuite();
    ss << printIncludes(module->getPropertySuite());
    ss << std::endl;

    //ss << "object " << ps->getName() << "_functions {" << std::endl;

    std::map<std::string, int> EnumTypeMap;
    int i = 0;
    int cnt = 0;

    for (auto function: module->getFunctionMap()) {
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isEnumType()) {
                if (EnumTypeMap.find(param->second->getDataType()->getName()) == EnumTypeMap.end()) {
                    EnumTypeMap.insert(std::pair<std::string, int>(param->second->getDataType()->getName(), i));
                    i++;
                    //ss << "\tval ";
                    ss << "\tobject {\n";

                    std::map<std::string, int> enum_map = param->second->getDataType()->getEnumValueMap();

                    typedef std::function<bool(std::pair<std::string, int>, std::pair<std::string, int>)> Comparator;

                    // Defining a lambda function to compare two pairs. It will compare two pairs using second field
                    Comparator compFunctor =
                            [](std::pair<std::string, int> elem1, std::pair<std::string, int> elem2) {
                                return elem1.second < elem2.second;
                            };

                    // Declaring a set that will store the pairs using above comparision logic
                    std::set<std::pair<std::string, int>, Comparator> setOfEnumVals(enum_map.begin(), enum_map.end(),
                                                                                    compFunctor);
                    int enum_val = 0;
                    for (std::pair<std::string, int> element : setOfEnumVals) {
                        //ss << convertEnumType(element.first) << " :: ";
                        ss << "val " << convertEnumType(element.first) << " = " << enum_val << ".U(32.W)\n";
                        enum_val++;
                    }

                    ss << "}\n\n";
                    //ss << " Nil = Enum(" << enum_map.size() << ")" << std::endl;

                }
            }
            if (function.second->getReturnType()->isEnumType()) {
                if (EnumTypeMap.find(function.second->getReturnType()->getName()) == EnumTypeMap.end()) {
                    EnumTypeMap.insert(std::pair<std::string, int>(function.second->getReturnType()->getName(), i));
                    i++;
                    //ss << "\tval ";
                    ss << "\tobject {\n";

                    std::map<std::string, int> enum_map = function.second->getReturnType()->getEnumValueMap();

                    typedef std::function<bool(std::pair<std::string, int>, std::pair<std::string, int>)> Comparator;

                    // Defining a lambda function to compare two pairs. It will compare two pairs using second field
                    Comparator compFunctor =
                            [](std::pair<std::string, int> elem1, std::pair<std::string, int> elem2) {
                                return elem1.second < elem2.second;
                            };

                    // Declaring a set that will store the pairs using above comparision logic
                    std::set<std::pair<std::string, int>, Comparator> setOfEnumVals(enum_map.begin(), enum_map.end(),
                                                                                    compFunctor);
                    int enum_val = 0;
                    for (std::pair<std::string, int> element : setOfEnumVals) {
                        //ss << convertEnumType(element.first) << " :: ";
                        ss << "val " << convertEnumType(element.first) << " = " << enum_val << ".U(32.W)\n";
                        enum_val++;
                    }

                    ss << "}\n\n";
                    //ss << " Nil = Enum(" << enum_map.size() << ")" << std::endl;

                }
            }
        }
    }
    ss << "\n\n";

    ss << "object " << ps->getName() << "_functions {" << std::endl;

    for (auto function: module->getFunctionMap()) {
        auto paramMap = function.second->getParamMap();

        ss << "\tdef " + function.first << "(";
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isCompoundType()) {
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                     iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    ss << param->first << "_" << iterator->first << ": "
                       << convertDataTypeFunction(iterator->second->getName());
                    if (iterator != --param->second->getDataType()->getSubVarMap().end()) ss << ", ";
                }
            } else if (param->second->getDataType()->isEnumType()) {
                ss << param->first << ": UInt";
            } else {
                ss << param->first << ": " << convertDataTypeFunction(param->second->getDataType()->getName());
            }
            if (param != --paramMap.end()) ss << ", ";
        }
        ss << "): ";
        if (function.second->getReturnType()->isEnumType()) {
            ss << "UInt = {\n";
            ss << "val tmp = Wire(UInt())\n";
        } else {
            ss << convertDataTypeFunction(function.second->getReturnType()->getName()) << " = {\n";
            ss << "val tmp = Wire(" << convertDataTypeFunction(function.second->getReturnType()->getName()) << "())\n";
        }

        if (function.second->getReturnValueConditionList().empty())
            TERMINATE(" No return value for function " + function.first + "()");
        auto branchNum = function.second->getReturnValueConditionList().size();
        for (auto returnValue: function.second->getReturnValueConditionList()) {
            ss << "\t\t";
            //Any conditions?
            if (!returnValue.second.empty()) {
                if (branchNum > 1) {
                    if (branchNum == function.second->getReturnValueConditionList().size())
                        ss << "when (";
                    else
                        ss << ".elsewhen (";

                    auto condNum = returnValue.second.size();
                    for (auto cond_it: returnValue.second) {
                        ss << ChiselConditionVisitor::toString(cond_it);
                        if (condNum > 1) ss << " && ";
                        condNum--;
                    }
                    ss << ") { " << std::endl;
                } else {
                    ss << ".otherwise {\n";
                }
            }

            ss << "\t\t\t";
            //if (function.second->getReturnType()->getName() == "int" || function.second->getReturnType()->getName() == "unsigned") {
            //    ss << convertDataType(function.second->getReturnType()->getName());
            //}
            ss << "tmp := (" << ChiselConditionVisitor::toString(returnValue.first->getReturnValue()) << ")";
            if (!returnValue.second.empty()) {
                ss << "\n";
            } else {
                ss << ";\n";
            }
            ss << "\t\t}" << std::endl;
            --branchNum;
        }
        if (function.second->getReturnValueConditionList().size() > 1) ss << "\t\ttmp\n" << "\t}\n\n";
    }
    ss << "}\n\n";
    return ss.str();
}

std::string PrintChisel::convertDataType(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "Bool";
    } else if (dataTypeName == "int") {
        return "SInt(32.W)";
    } else if (dataTypeName == "unsigned") {
        return "UInt(32.W)";
    } else {
        return dataTypeName;
    }
}

std::string PrintChisel::convertDataTypeFunction(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "Bool";
    } else if (dataTypeName == "int") {
        return "SInt";
    } else if (dataTypeName == "unsigned") {
        return "UInt";
    } else {
        return dataTypeName;
    }
}

std::string PrintChisel::convertDataTypeFunctionSVA(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "Bool";
    } else if (dataTypeName == "int") {
        return "int";
    } else if (dataTypeName == "unsigned") {
        return "int unsigned";
    } else {
        return dataTypeName;
    }
}

std::string PrintChisel::convertCompoundType(std::string compoundTypeName) {
    std::string::size_type i = compoundTypeName.find("_");

    while (i != std::string::npos) {
        compoundTypeName.erase(i, 1);
        i = compoundTypeName.find("_");
    }
    std::transform(compoundTypeName.begin(), compoundTypeName.end(), compoundTypeName.begin(), ::tolower);
    std::transform(compoundTypeName.begin(), compoundTypeName.begin() + 1, compoundTypeName.begin(), ::toupper);
    return compoundTypeName;
}

std::string PrintChisel::convertEnumType(std::string enumTypeName) {
    std::string::size_type i = enumTypeName.find("_");

    /*while (i != std::string::npos)
    {
        enumTypeName.erase(i, 1);
        i = enumTypeName.find("_");
    }*/
    std::transform(enumTypeName.begin(), enumTypeName.end(), enumTypeName.begin(), ::tolower);
    return enumTypeName;
}

std::string PrintChisel::convertPortDirection(std::string direction) {
    if (direction == "in") {
        return "Input";
    } else {
        return "Output";
    }
}

std::string PrintChisel::printIncludes(PropertySuite *ps) {
    std::stringstream ss;
    std::string package_name = ps->getName();

    std::transform(package_name.begin(), package_name.end(), package_name.begin(), ::tolower);
    ss << "package " << package_name << std::endl;
    ss << "import chisel3._" << std::endl;
    ss << "import chisel3.util._" << std::endl;

    return ss.str();
}

std::string PrintChisel::printCompoundTypes(PropertySuite *ps) {
    std::stringstream ss;
    std::string dpNamePre = "";
    std::multimap<std::string, std::string> CompoundTypeMap;
    typedef std::multimap<std::string, std::string>::iterator CompoundTypeMapIterator;
    int included = 0;

    for (auto dp: ps->getDpSignals()) {
        if (dp->isCompoundType()) {
            if (dp->getName() != dpNamePre) {
                if (CompoundTypeMap.find(dp->getPort()->getDataType()->getName()) == CompoundTypeMap.end()) {
                    if (!CompoundTypeMap.empty()) {
                        ss << "}" << std::endl << std::endl;
                    }
                    ss << "class " << convertCompoundType(dp->getPort()->getDataType()->getName()) << " extends Bundle {" << std::endl;
                    ss << "\tval " << dp->getSubVarName() << " = ";
                    if (dp->getDataType()->isEnumType()) {
                        ss << "UInt(32.W)" << std::endl;
                    } else {
                        ss << convertDataType(dp->getDataType()->getName()) << std::endl;
                    }
                    CompoundTypeMap.insert(
                            std::pair<std::string, std::string>(dp->getPort()->getDataType()->getName(), dp->getSubVarName()));
                }
            } else {
                std::pair<CompoundTypeMapIterator, CompoundTypeMapIterator> result = CompoundTypeMap.equal_range(
                        dp->getPort()->getDataType()->getName());
                for (CompoundTypeMapIterator it = result.first; it != result.second; it++) {
                    if (it->second == dp->getSubVarName()) {
                        included = 1;
                    }
                }
                if (!included) {
                    CompoundTypeMap.insert(
                            std::pair<std::string, std::string>(dp->getPort()->getDataType()->getName(), dp->getSubVarName()));
                    ss << "\tval " << dp->getSubVarName() << " = ";
                    if (dp->getDataType()->isEnumType()) {
                        ss << "UInt(32.W)" << std::endl;
                    } else {
                        ss << convertDataType(dp->getDataType()->getName()) << std::endl;
                    }
                }
            }
        }
        included = 0;
        dpNamePre = dp->getName();
    }
    if (!CompoundTypeMap.empty()) {
        ss << "}" << std::endl;
    }

    return ss.str();
}

std::string PrintChisel::printIoPorts(PropertySuite *ps) {
    std::string dpNamePre = "";
    std::stringstream ss;

    ss << "\tval io = IO(new Bundle {" << std::endl;
    for (auto sync: ps->getSyncSignals()) {
        ss << "\t\tval " << sync->getName() << " = " << "Input(" << convertDataType(sync->getDataType()->getName()) << "())" << std::endl;
    }
    for (auto notify: ps->getNotifySignals()) {
        ss << "\t\tval " << notify->getName() << " = " << "Output(" << convertDataType(notify->getDataType()->getName()) << "())"
           << std::endl;
    }

    for (auto dp: ps->getDpSignals()) {
        if (dp->getName() != dpNamePre) {
            if (dp->isCompoundType()) {
                ss << "\t\tval " << dp->getPort()->getName() << " = "
                   << convertPortDirection(dp->getPort()->getInterface()->getDirection())
                   << "(" << "new " << convertCompoundType(dp->getPort()->getDataType()->getName()) << "())" << std::endl;
            } else {
                ss << "\t\tval " << dp->getPort()->getName() << " = "
                   << convertPortDirection(dp->getPort()->getInterface()->getDirection())
                   << "(" << dp->getPort()->getDataType()->getName() << "())" << std::endl;
            }
            dpNamePre = dp->getName();
        }
    }
    ss << "\t})" << std::endl;
    return ss.str();
}

std::string PrintChisel::printRegisters(PropertySuite *ps) {
    std::string dpNamePre = "";
    std::string vrNamePre = "";
    std::stringstream ss;

    for (auto notify: ps->getNotifySignals()) {
        ss << '\t' << "val " << notify->getName() << "_r" << " = " << "Reg(" << convertDataType(notify->getDataType()->getName()) << "())"
           << std::endl;
    }

    for (auto dp: ps->getDpSignals()) {
        if (dp->getName() != dpNamePre) {
            if (dp->getPort()->getInterface()->getDirection() == "out") {
                if (dp->isCompoundType()) {
                    ss << '\t' << "val " << dp->getPort()->getName() << "_r" " = "
                       << "Reg(" << "new " << convertCompoundType(dp->getPort()->getDataType()->getName()) << "())" << std::endl;
                } else {
                    ss << '\t' << "val " << dp->getPort()->getName() << " = "
                       << "Reg(" << dp->getPort()->getDataType()->getName() << "())" << std::endl;
                }
                dpNamePre = dp->getName();
            }
        }
    }

    for (auto vr: ps->getVisibleRegisters()) {
        if (vr->getName() != vrNamePre) {
            ss << '\t' << "val " << vr->getName() << "_signal_r = Reg(";
            if (vr->isCompoundType()) {
                ss << "new ";
                //if (vr->getVariable()->isSubVar()){
                ss << convertCompoundType(vr->getVariable()->getParent()->getDataType()->getName()) << "()";
                //}
            } else {
                ss << convertDataType(vr->getDataType()->getName());
            }
            ss << ")" << std::endl;
            vrNamePre = vr->getName();
        }
    }

    ss << "\tval state_r = Reg(UInt())" << std::endl;
    return ss.str();
}

std::string PrintChisel::printEnums(PropertySuite *ps) {
    std::map<std::string, int> EnumTypeMap;
    int i = 0;
    int cnt = 0;
    std::stringstream ss;

    for (auto dp: ps->getDpSignals()) {
        if (dp->isCompoundType()) {
            if (dp->getDataType()->isEnumType()) {
                if (EnumTypeMap.find(dp->getDataType()->getName()) == EnumTypeMap.end()) {
                    EnumTypeMap.insert(std::pair<std::string, int>(dp->getDataType()->getName(), i));
                    i++;

                    ss << "\tval ";

                    std::map<std::string, int> enum_map = dp->getDataType()->getEnumValueMap();

                    typedef std::function<bool(std::pair<std::string, int>, std::pair<std::string, int>)> Comparator;

                    // Defining a lambda function to compare two pairs. It will compare two pairs using second field
                    Comparator compFunctor =
                            [](std::pair<std::string, int> elem1, std::pair<std::string, int> elem2) {
                                return elem1.second < elem2.second;
                            };

                    // Declaring a set that will store the pairs using above comparision logic
                    std::set<std::pair<std::string, int>, Comparator> setOfEnumVals(enum_map.begin(), enum_map.end(), compFunctor);

                    for (std::pair<std::string, int> element : setOfEnumVals) {
                        ss << convertEnumType(element.first) << " :: ";
                    }

                    ss << " Nil = Enum(" << enum_map.size() << ")" << std::endl;
                }
            }
        }
    }

    ss << "\tval ";
    for (auto st: ps->getStates()) {
        ss << st->getName() << " :: ";
        cnt++;
    }
    ss << " Nil = Enum(" << cnt << ")" << std::endl;
    return ss.str();
}

std::string PrintChisel::printBehaviour(PropertySuite *ps) {
    ss << "\twhen(reset.toBool) {" << std::endl;
    ss << "\t\tstate_r := " << ps->getResetProperty()->getNextState()->getName() << std::endl;
    for (auto commitment : ps->getResetProperty()->getCommitmentList()) {
        ss << "\t\t" << ChiselConditionVisitor::toString(commitment->getLhs()) << " := "
           << ChiselConditionVisitor::toString(commitment->getRhs()) << std::endl;
    }
    ss << "\t}" << std::endl;

    ss << "\t.otherwise {" << std::endl;
    for (auto op : ps->getOperationProperties()) {
        ss << "\t\twhen(state_r === " << op->getState()->getName() << ") {" << std::endl;

        int tab_count = 3;
        for (auto assumption : op->getAssumptionList()) {
            for (int i = 0; i < tab_count; i++) {
                ss << '\t';
            }
            ss << "when(" << ChiselConditionVisitor::toString(assumption) << ") {" << std::endl;
            tab_count++;
        }

        for (int i = 0; i < tab_count; i++) {
            ss << '\t';
        }
        ss << "state_r := " << op->getNextState()->getName() << std::endl;

        for (auto commitment : op->getCommitmentList()) {
            for (int i = 0; i < tab_count; i++) {
                ss << '\t';
            }
            ss << ChiselConditionVisitor::toString(commitment->getLhs()) << " := " << ChiselDatapathVisitor::toString(commitment->getRhs())
               << std::endl;
        }

        for (auto notify : ps->getNotifySignals()) {
            for (int i = 0; i < tab_count; i++) {
                ss << '\t';
            }
            switch (op->getTiming(notify->getPort())) {
                case TT_1:
                    ss << notify->getName() << "_r := true.B\n";
                    break;
                case FF_1:
                    ss << notify->getName() << "_r := false.B\n";
                    break;
                case FF_e:
                    ss << notify->getName() << "_r := false.B\n";
                    break;
                case FT_e:
                    ss << notify->getName() << "_r := true.B\n";
                    break;
            }
        }

        for (auto assumption : op->getAssumptionList()) {
            for (int i = 0; i < tab_count - 1; i++) {
                ss << '\t';
            }
            ss << "}" << std::endl;
            tab_count--;
        }
        ss << "\t\t}" << std::endl;
    }
    return ss.str();
}

std::string PrintChisel::printDontTouch(PropertySuite *ps) {
    std::string vrNamePre = "";
    std::stringstream ss;

    for (auto vr: ps->getVisibleRegisters()) {
        if (vr->getName() != vrNamePre) {
            ss << "\tcore.dontTouch(" << vr->getName() << "_signal_r)" << std::endl;
            vrNamePre = vr->getName();
        }
    }
    return ss.str();
}

std::string PrintChisel::printOutputAssignments(PropertySuite *ps) {
    std::string dpNamePre = "";
    std::stringstream ss;

    for (auto notify: ps->getNotifySignals()) {
        ss << "\tio." << notify->getName() << " := " << notify->getName() << "_r" << std::endl;
    }

    for (auto dp: ps->getDpSignals()) {
        if (dp->getName() != dpNamePre) {
            if (dp->getPort()->getInterface()->isOutput()) {
                ss << "\tio." << dp->getPort()->getName() << " := " << dp->getPort()->getName() << "_r" << std::endl;
            }
            dpNamePre = dp->getName();
        }
    }
    return ss.str();
}


// Magic happens here
std::string PrintChisel::constructScala() {
    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;
    std::string t_end;

    ss << printIncludes(ps);
    //ss << "import ISA_functions._\n";
    ss << std::endl;

    ss << printCompoundTypes(ps);
    ss << std::endl;

    ss << "class " << ps->getName() << " extends Module {" << std::endl;

    ss << printIoPorts(ps);
    ss << std::endl;

    ss << printRegisters(ps);
    ss << std::endl;

    ss << printEnums(ps);
    ss << std::endl;

    ss << printBehaviour(ps);

    ss << "\t}" << std::endl << std::endl;

    ss << printDontTouch(ps);
    ss << std::endl;

    ss << printOutputAssignments(ps);

    ss << "}" << std::endl << std::endl;

    ss << "object " << ps->getName() << " extends App {" << std::endl;
    ss << "\tchisel3.Driver.execute(args, () => new " << ps->getName() << ")" << std::endl;
    ss << "}";
    ss << std::endl << std::endl;

    return ss.str();
}


/*===============================================================================*/
/*                SVA refined for Verilog generated from Chisel                  */
/*===============================================================================*/

std::string PrintChisel::Text_ipc() {
    std::stringstream result;
    result << "// required terminology \n"
              "sequence hold(l, e);\n"
              "\t(l===e, l=e);\n"
              "endsequence\n"
              "\n"
              "sequence t;\n"
              "\t##`next_shift_amount 1'b1;\n"
              "endsequence\n"
              "\n"
              "sequence t_end(offset);\n"
              "\tt ##offset 1'b1;\n"
              "endsequence\n"
              "\n"
              "sequence next(timepoint, offset);\n"
              "\ttimepoint ##offset 1'b1;\n"
              "endsequence\n"
              "\n"
              "property during(t1, t2, se);\n"
              "\t(t1 ##0 se[*0:$] intersect t2) or\n"
              "\t(t1 intersect t2 ##[1:$] 1'b1);\n"
              "endproperty\n"
              "\n"
              "property during_limited(t1, t2, off, se);\n"
              "\t(t1 ##0 se[*0:$] ##off 1'b1 intersect t2) or\n"
              "\t(next(t1, off) intersect t2 ##[1:$] 1'b1);\n"
              "endproperty\n"
              "\n"
              "property during_o(t1, o1, t2, o2, se);\n"
              "\tif (o2 >= 0)\n"
              "\t\tduring(next(t1, o1), next(t2, (o2<0) ? 0 : o2), se)\n"
              "\telse\n"
              "\t\tduring_limited(next(t1, o1), t2, (o2>0) ? 0 : -o2, se);\n"
              "endproperty\n"
              "// end of ipc_sva\n\n";
    return result.str();
}

std::string PrintChisel::types() {
    PropertySuite *ps = this->module->getPropertySuite();
    std::stringstream ss;
    std::map<std::string, int> EnumTypeMap;
    int i = 0;
    int cnt = 0;

    ss << "package scam_model_types;\n";

    for (auto function: module->getFunctionMap()) {
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isEnumType()) {
                if (EnumTypeMap.find(param->second->getDataType()->getName()) == EnumTypeMap.end()) {
                    EnumTypeMap.insert(std::pair<std::string, int>(param->second->getDataType()->getName(), i));
                    i++;
                    //ss << "\tval ";
                    ss << "\ttypedef enum {";

                    std::map<std::string, int> enum_map = param->second->getDataType()->getEnumValueMap();

                    typedef std::function<bool(std::pair<std::string, int>, std::pair<std::string, int>)> Comparator;

                    // Defining a lambda function to compare two pairs. It will compare two pairs using second field
                    Comparator compFunctor =
                            [](std::pair<std::string, int> elem1, std::pair<std::string, int> elem2) {
                                return elem1.second < elem2.second;
                            };

                    // Declaring a set that will store the pairs using above comparision logic
                    std::set<std::pair<std::string, int>, Comparator> setOfEnumVals(enum_map.begin(), enum_map.end(),
                                                                                    compFunctor);

                    int size_enum_vals = setOfEnumVals.size();
                    int j = 0;
                    for (std::pair<std::string, int> element : setOfEnumVals) {
                        if (j < size_enum_vals - 1) {
                            ss << convertEnumType(element.first) << ", ";
                        } else {
                            ss << convertEnumType(element.first) << "} ";
                        }
                        j++;
                    }

                    ss << param->second->getDataType()->getName() << ";" << std::endl;
                    //ss << " Nil = Enum(" << enum_map.size() << ")" << std::endl;

                }
            }
            if (function.second->getReturnType()->isEnumType()) {
                if (EnumTypeMap.find(function.second->getReturnType()->getName()) == EnumTypeMap.end()) {
                    EnumTypeMap.insert(std::pair<std::string, int>(function.second->getReturnType()->getName(), i));
                    i++;
                    //ss << "\tval ";
                    ss << "\ttypedef enum {";

                    std::map<std::string, int> enum_map = function.second->getReturnType()->getEnumValueMap();

                    typedef std::function<bool(std::pair<std::string, int>, std::pair<std::string, int>)> Comparator;

                    // Defining a lambda function to compare two pairs. It will compare two pairs using second field
                    Comparator compFunctor =
                            [](std::pair<std::string, int> elem1, std::pair<std::string, int> elem2) {
                                return elem1.second < elem2.second;
                            };

                    // Declaring a set that will store the pairs using above comparision logic
                    std::set<std::pair<std::string, int>, Comparator> setOfEnumVals(enum_map.begin(), enum_map.end(),
                                                                                    compFunctor);
                    int size_enum_vals = setOfEnumVals.size();
                    int j = 0;
                    for (std::pair<std::string, int> element : setOfEnumVals) {
                        if (j < size_enum_vals - 1) {
                            ss << convertEnumType(element.first) << ", ";
                        } else {
                            ss << convertEnumType(element.first) << "} ";
                        }
                        j++;
                    }

                    ss << function.second->getReturnType()->getName() << ";" << std::endl;
                    //ss << " Nil = Enum(" << enum_map.size() << ")" << std::endl;

                }
            }
        }
    }

    //FIXME: what about local types? worry about them? I guess ports always have to be global
    for (auto dp: ps->getDpSignals()) {

        if (dp->isCompoundType()) {

            if (dp->getDataType()->isEnumType()) {
                if (EnumTypeMap.find(dp->getDataType()->getName()) == EnumTypeMap.end()) {
                    EnumTypeMap.insert(std::pair<std::string, int>(dp->getDataType()->getName(), i));
                    i++;

                    ss << "\ttypedef enum {";

                    std::map<std::string, int> enum_map = dp->getDataType()->getEnumValueMap();

                    typedef std::function<bool(std::pair<std::string, int>, std::pair<std::string, int>)> Comparator;

                    // Defining a lambda function to compare two pairs. It will compare two pairs using second field
                    Comparator compFunctor =
                            [](std::pair<std::string, int> elem1, std::pair<std::string, int> elem2) {
                                return elem1.second < elem2.second;
                            };

                    // Declaring a set that will store the pairs using above comparision logic
                    std::set<std::pair<std::string, int>, Comparator> setOfEnumVals(enum_map.begin(), enum_map.end(), compFunctor);

                    int size_enum_vals = setOfEnumVals.size();
                    int j = 0;
                    for (std::pair<std::string, int> element : setOfEnumVals) {
                        if (j < size_enum_vals - 1) {
                            ss << convertEnumType(element.first) << ", ";
                        } else {
                            ss << convertEnumType(element.first) << "} ";
                        }
                        j++;
                    }

                    ss << dp->getDataType()->getName() << ";" << std::endl;
                }
            }
        }
    }
    ss << "endpackage";

    return ss.str();
}


std::string PrintChisel::sva_functions() {
    std::stringstream ss;
    if (module->getFunctionMap().empty()) return ss.str();
    ss << "\n\n// FUNCTIONS //\n";
    for (auto function: module->getFunctionMap()) {
        ss << "function " + convertDataTypeFunctionSVA(function.second->getReturnType()->getName()) + " " + function.first << " (";
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isCompoundType()) {
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                     iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    ss << convertDataTypeFunctionSVA(iterator->second->getName()) + " " + param->first << "_" << iterator->first;
                    if (iterator != --param->second->getDataType()->getSubVarMap().end()) ss << ";";
                }
            } else {
                ss << convertDataTypeFunctionSVA(param->second->getDataType()->getName()) + " " + param->first;
            }
            if (param != --paramMap.end()) ss << ", ";
        }
        ss << ");\n";

        if (function.second->getReturnValueConditionList().empty())
            TERMINATE(" No return value for function " + function.first + "()");
        auto branchNum = function.second->getReturnValueConditionList().size();
        for (auto returnValue: function.second->getReturnValueConditionList()) {
            ss << "\t";
            //Any conditions?
            if (!returnValue.second.empty()) {
                if (branchNum > 0) {
                    if (branchNum == function.second->getReturnValueConditionList().size())
                        ss << "if (";
                    else
                        ss << "else if (";

                    auto condNum = returnValue.second.size();
                    for (auto cond_it: returnValue.second) {
                        ss << ChiselSVAConditionVisitor::toString(cond_it);
                        if (condNum > 1) ss << " && ";
                        condNum--;
                    }
                    ss << ") begin return ";
                } else {
                    ss << "else ";
                }
            }

            //if (function.second->getReturnType()->getName() == "int" || function.second->getReturnType()->getName() == "unsigned") {
            //    ss << convertDataTypeFunctionSVA(function.second->getReturnType()->getName());
            //}
            ss << "(" << ChiselSVAConditionVisitor::toString(returnValue.first->getReturnValue()) << "); end";
            if (!returnValue.second.empty()) {
                ss << "\n";
            } else {
                ss << ";\n";
            }
            --branchNum;
        }
        //if (function.second->getReturnValueConditionList().size() > 1) ss << "end if;\n";
        ss << "endfunction\n\n";
    }
    return ss.str();
}


std::string PrintChisel::autorefine() {

    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;
    std::string t_end;

    ss << "`define next_shift_amount 0 //IN CASE OF REQUIRED SIGNALS VALUES IN THE FUTURE, SHIFT YOUR ENTIRE TIMING BY THIS FACTOR\n\n"
       << "`include \"ipc.sva\"\n"
       << "//`include \"" << this->module->getName() << "_functions.sva//\"\n"
       << "`include \"types.sva\"\n"
       << "import scam_model_types::*;\n\n"
       //            << "import " << tolower(this->module->getName()) << "_functions::*;\n\n"
       << "module " << this->module->getName() << "_verification(reset);\n\n"
       << "input reset;\n\n"
       << "//DESIGNER SHOULD PAY ATTENTION FOR USING THE MODEL CORRECT NAME TO REFER TO THE CLK SIGNAL USED IN IT\n"
       << "default clocking default_clk @(posedge " << this->module->getName() << ".clk); endclocking\n\n";


    ss << "// SYNC AND NOTIFY SIGNALS (1-cycle macros) //" << std::endl;
    for (auto sync: ps->getSyncSignals()) {
        ss << "function " << sync->getName() << ";\n";
        ss << "\t" << sync->getName() << " = " << this->module->getName() << ".io_" << sync->getName() << ";\n";
        ss << "endfunction" << std::endl;
    }
    for (auto notify: ps->getNotifySignals()) {
        ss << "function " << notify->getName() << ";\n";
        ss << "\t" << notify->getName() << " = " << this->module->getName() << ".io_" << notify->getName() << ";\n";
        ss << "endfunction" << std::endl;
    }
    ss << std::endl;

    ss << "// DP SIGNALS //" << std::endl;
    for (auto dp: ps->getDpSignals()) {
        //if (!dp->isCompoundType()){
        //    ss << "--";
        //}
        ss << "function " << dp->getDataType()->getName() << " " << dp->getName();
        if (dp->isCompoundType()) {
            ss << "_" << dp->getSubVarName();
        }
        ss << ";" << std::endl;
        ss << "\t" << dp->getName();
        if (dp->isCompoundType()) {
            ss << "_" << dp->getSubVarName();
        }
        ss << " = " << this->module->getName() << ".io_" << dp->getPort()->getName();
        if (dp->isCompoundType()) {
            ss << "_" << dp->getSubVarName();
        }
        ss << ";" << std::endl;
        ss << "endfunction" << std::endl;
    }
    ss << std::endl << std::endl;

    /*ss << "-- CONSTRAINTS --" << std::endl;
    // Reset constraint is print out extra because of the quotation marks ('0')
    ss << "constraint no_reset := rst = '0'; end constraint;" << std::endl;
    for (auto co: ps->getConstraints()){
        if (co->getName() != "no_reset") {
            ss << "constraint " << co->getName() << " : " << ChiselSVAConditionVisitor::toString(co->getExpression()) << "; end constraint;" << std::endl;
        }
    }
    ss << std::endl << std::endl;*/

    ss << "// VISIBLE REGISTERS //" << std::endl;
    for (auto vr: ps->getVisibleRegisters()) {
        if (!vr->isArrayType()) {
            //if (!vr->isCompoundType()){
            //    ss << "--";
            //}
            ss << "function " << vr->getDataType()->getName() << " " << vr->getName();
            if (vr->isCompoundType()) {
                ss << "_" << vr->getSubVarName();
            }
            ss << ";" << std::endl;
            ss << "\t" << vr->getName();
            if (vr->isCompoundType()) {
                ss << "_" << vr->getSubVarName();
            }
            ss << " = " << this->module->getName() << "." << vr->getName() << "_signal_r";
            if (vr->isCompoundType()) {
                ss << "_" << vr->getSubVarName();
            }
            ss << ";" << std::endl;
            ss << "endfunction" << std::endl;
        }
    }
    ss << std::endl << std::endl;

    //TODO: Add automatic refinement of states
    ss << "// STATES //" << std::endl;
    for (auto st: ps->getStates()) {
        ss << "--macro " << st->getName() << " : " << convertDataType(st->getDataType()->getName());
        ss << " := " << ChiselSVAConditionVisitor::toString(st->getExpression()) << " end macro;" << std::endl;
    }
    ss << std::endl << std::endl;


    ss << "// OPERATIONS //" << std::endl;
    ss << "sequence reset_sequence;\n//DISGNER REFER TO MODEL RESET SIGNAL HERE\n";
    ss << "\t(" << this->module->getName() << ".reset == 1'b1);\n" << "endsequence\n";

    // Reset property
    ss << "property " << ps->getResetProperty()->getName() << "_p;\n";
    ss << "\treset_sequence |=>\n";
    ss << "\tt ##0 " << ps->getResetProperty()->getNextState()->getName() << "() and\n";
    int comm_size = ps->getResetProperty()->getCommitmentList().size();
    int i = 0;
    for (auto commitment : ps->getResetProperty()->getCommitmentList()) {
        if (i < comm_size - 1) {
            ss << "\tt ##0 " << ChiselSVAConditionVisitor::toString(commitment->getLhs()) << " == "
               << ChiselSVAConditionVisitor::toString(commitment->getRhs()) << " and\n";
        } else {
            ss << "\tt ##0 " << ChiselSVAConditionVisitor::toString(commitment->getLhs()) << " == "
               << ChiselSVAConditionVisitor::toString(commitment->getRhs()) << ";\n";
        }
        i++;
    }
    ss << "endproperty\n";
    ss << ps->getResetProperty()->getName() << "_a: assert property (" << ps->getResetProperty()->getName() << "_p);\n";
    ss << std::endl << std::endl;

    // Operation properties
    for (auto op : ps->getOperationProperties()) {
        ss << "property " << op->getName() << "_p(o);\n";

        /*unsigned long constraintSize = op->getConstraints().size();
        ss << "dependencies: ";
        for (auto co : op->getConstraints()) {
            ss << co->getName();
            if (constraintSize > 1) {
                ss << ",";
            } else {
                ss << ";\n";
            }
            constraintSize--;
        }*/

        //TODO: Make function independent of module
        /*if (module->isSlave()) {
            t_end = "t+1";
        } else {
            ss << "for timepoints:\n";
            ss << "\tt_end = t+1;\n";
            t_end = "t_end";
        }*/
        unsigned long freezeVarSize = op->getFreezeSignals().size();
        if (freezeVarSize > 0) {
            for (auto freeze : op->getFreezeSignals()) {
                if (freeze.second->isArrayType()) {
                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
                       << "_at_t = ";
                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
                       << ")@t";
                } else {
                    ss << freeze.second->getDataType()->getName() << " " << freeze.first << "_0;\n";
                }
            }
        }

        if (freezeVarSize > 0) {
            ss << "// hold //\n";
            for (auto freeze : op->getFreezeSignals()) {
                ss << "\tt ##0 hold(";
                if (freeze.second->isArrayType()) {
                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
                       << "_at_t = ";
                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
                       << ")@t";
                } else {
                    ss << freeze.first << "_0, " << freeze.first << "()) and\n";
                }
            }
        }
        ss << "// Conceptual State //\n";
        ss << "\tt ##0 " << op->getState()->getName() << "() and\n";
        ss << "// trigger //\n";
        int assumption_size = op->getAssumptionList().size();
        int i = 0;
        for (auto assumption : op->getAssumptionList()) {
            if (i < assumption_size - 1) {
                ss << "\tt ##0 " << ChiselSVAConditionVisitor::toString(assumption) << " and\n";
            } else {
                ss << "\tt ##0 " << ChiselSVAConditionVisitor::toString(assumption) << "\n";
            }
            i++;
        }
        ss << "implies\n";
        ss << "\tt_end(o) ##0 " << op->getNextState()->getName() << "() and\n";
        for (auto commitment : op->getCommitmentList()) {
            ss << "\tt_end(o) ##0 " << ChiselSVAConditionVisitor::toString(commitment->getLhs())
               << " == " << ChiselSVADatapathVisitor::toString(commitment->getRhs()) << " and\n";
        }
        int notify_size = ps->getNotifySignals().size();
        i = 0;
        for (auto notify : ps->getNotifySignals()) {
            switch (op->getTiming(notify->getPort())) {
                case TT_1:
                    ss << "\tt ##1 " << notify->getName() << "() == 1";
                    break;
                case FF_1:
                    ss << "\tt ##1 " << notify->getName() << "() == 0";
                    break;
                case FF_e:
                    ss << "\tduring (next(t,1), t_end(o), " << notify->getName() << "() == 0)";
                    break;
                case FT_e:
                    ss << "\tduring_o (t, 1, t_end(o), -1, " << notify->getName() << "() == 0) and\n";
                    ss << "\tt_end(o) ##0 " << notify->getName() << "() == 1";
                    break;
            }
            if (i < notify_size - 1) {
                ss << " and\n";
            } else {
                ss << ";\n";
            }
            i++;
        }
        ss << "endproperty;\n";
        ss << op->getName() << "_a: assert property (disable iff (reset) " << op->getName()
           << "_p(1)); //ASSIGN t_end offset here\n";
        ss << "\n\n";
    }

    // Wait properties
    for (auto wp : ps->getWaitProperties()) {
        ss << "property " << wp->getName() << "_p;\n";

        /*unsigned long constraintSize = wp->getConstraints().size();
        ss << "dependencies: ";
        for (auto co : wp->getConstraints()) {
            ss << co->getName();
            if (constraintSize > 1) {
                ss << ",";
            } else {
                ss << ";\n";
            }
            constraintSize--;
        }*/

        unsigned long freezeVarSize = wp->getFreezeSignals().size();
        if (freezeVarSize > 0) {
            for (auto freeze : wp->getFreezeSignals()) {
                if (freeze.second->isArrayType()) {
                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
                       << "_at_t = ";
                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
                       << ")@t";
                } else {
                    ss << freeze.second->getDataType()->getName() << " " << freeze.first << "_0;\n";
                }
            }
        }

        if (freezeVarSize > 0) {
            ss << "// hold //\n";
            for (auto freeze : wp->getFreezeSignals()) {
                ss << "\tt ##0 hold(";
                if (freeze.second->isArrayType()) {
                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
                       << "_at_t = ";
                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
                       << ")@t";
                } else {
                    ss << freeze.first << "_0, " << freeze.first << "()) and\n";
                }
            }
        }

        ss << "// Conceptual State //\n";
        ss << "\tt ##0 " << wp->getState()->getName() << "() and\n";
        ss << "// trigger //\n";

        int assumption_size = wp->getAssumptionList().size();
        int i = 0;
        for (auto assumption : wp->getAssumptionList()) {
            if (i < assumption_size - 1) {
                ss << "\tt ##0 " << ChiselSVAConditionVisitor::toString(assumption) << " and\n";
            } else {
                ss << "\tt ##0 " << ChiselSVAConditionVisitor::toString(assumption) << "\n";
            }
        }
        ss << "implies\n";
        ss << "\tt ##1 " << wp->getNextState()->getName() << "() and\n";
        int commitment_size = wp->getCommitmentList().size();
        i = 0;
        for (auto commitment : wp->getCommitmentList()) {
            ss << "\tt ##1 " << ChiselSVAConditionVisitor::toString(commitment->getLhs()) << " == "
               << ChiselSVADatapathVisitor::toString(commitment->getRhs());
            if (i < commitment_size - 1) {
                ss << " and\n";
            } else {
                ss << ";\n";
            }
            i++;
        }
        ss << "endproperty;\n";
        ss << wp->getName() << "_a: assert property (disable iff (reset) " << wp->getName()
           << "_p); //ASSIGN t_end offset here\n";
        ss << "\n\n";
    }

    ss << "endmodule\n\n"
       << "//DESIGNER SHOULD PAY ATTENTION FOR USING THE MODEL CORRECT NAME FOR BINDING AND TO REFER TO THE RESET SIGNAL USED IN IT\n"
       << "bind " << this->module->getName() << " " << this->module->getName()
       << "_verification inst (.*, .reset(" << this->module->getName() << ".reset));\n";

    return ss.str();
}