//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include <fstream>
#include <ExprVisitor.h>
#include "PrintSVA.h"
#include "Config.h"
#include "ConditionVisitorSVA.h"
#include "DatapathVisitorSVA.h"

std::map<std::string, std::string> PrintSVA::printModel(Model *node) {
    this->model = node;
    pluginOutput.insert(std::make_pair("ipc.sva", Text_ipc()));

    for (auto &module: node->getModules()) {
        this->module = module.second;
        pluginOutput.insert(std::make_pair(module.first + ".sva", Text_body()));
        pluginOutput.insert(std::make_pair(module.first + "_functions.sva", functions()));
    }

    if(!node->getGlobalFunctionMap().empty()){
        pluginOutput.insert(std::make_pair(node->getName() + "_global_functions.sva", globalFunctions()));
    }
    return pluginOutput;
}

std::map<std::string, std::string> PrintSVA::printModule(SCAM::Module *node) {

    this->module = node;

    pluginOutput.insert(std::make_pair(node->getName() + ".sva", Text_body()));
    std::string funString = functions();
    if (funString != "")
        pluginOutput.insert(std::make_pair(node->getName() + "_functions.sva", funString));

    return pluginOutput;
}

////////////////
std::string PrintSVA::Text_ipc() {
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

std::string PrintSVA::Text_body() {
    std::stringstream result;
    result
            << dataTypes() << "\n"
            << "`define next_shift_amount 0 //IN CASE OF REQUIRED SIGNALS VALUES IN THE FUTURE, SHIFT YOUR ENTIRE TIMING BY THIS FACTOR\n\n"
            << "`include \"ipc.sva\"\n"
            << "`include \"" << this->module->getName() << "_functions.sva\"\n\n"
            << "import scam_model_types::*;\n\n"
            //<< "import " << tolower(this->module->getName()) << "_functions::*;\n\n"
            << "module " << this->module->getName() << "_verification(reset);\n\n"
            << "input reset;\n\n"
            << "//DESIGNER SHOULD PAY ATTENTION FOR USING THE MODEL CORRECT NAME TO REFER TO THE CLK SIGNAL USED IN IT\n"
            << "default clocking default_clk @(posedge " << this->module->getName() << ".clk); endclocking\n"
            << signals() << registers() << states() << "\n\n"
            << "////////////////////////////////////\n"
            << "//////////// Operations ////////////\n"
            << "////////////////////////////////////\n"
            << "\n"
            << reset_sequence() << reset_operation() << operations()
            << "endmodule\n\n"
            << "//DESIGNER SHOULD PAY ATTENTION FOR USING THE MODEL CORRECT NAME FOR BINDING AND TO REFER TO THE RESET SIGNAL USED IN IT\n"
            << "bind " << this->module->getName() << " " << this->module->getName()
            << "_verification inst (.*, .reset());\n";

    return result.str();
}


std::string PrintSVA::functions() {
    std::stringstream ss;
    if (module->getFunctionMap().empty()) return ss.str();
    ss << "\n\n// FUNCTIONS //\n";
    for (auto function: module->getFunctionMap()) {
        ss << "function " + convertDataType(function.second->getReturnType()) + " " + function.first << " (";
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isCompoundType()) {
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                     iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    ss << convertDataType(iterator->second) << " " << param->first << "_" << iterator->first;
                    if (iterator != --param->second->getDataType()->getSubVarMap().end()) ss << ", ";
                }
            } else {
                ss << convertDataType(param->second->getDataType()) << " " << param->first;
            }
            if (param != --paramMap.end()) ss << ", ";
        }
        ss << ");\n";

        if (function.second->getReturnValueConditionList().empty())
            throw std::runtime_error(" No return value for function " + function.first + "()");
        auto j = function.second->getReturnValueConditionList().size();
        for (auto returnValue: function.second->getReturnValueConditionList()) {
            ss << "\t";
            //Any conditions?
            if (!returnValue.second.empty()) {

                if (j == function.second->getReturnValueConditionList().size()) {
                    ss << "if (";
                } else ss << "else if (";

                auto i = returnValue.second.size();
                for (auto cond: returnValue.second) {
                    ss << ConditionVisitorSVA::toString(cond);
                    if (i > 1) ss << " && ";
                    --i;
                }
                ss << ") begin return ";
                //TODO: The following lines print statements like "regfile.reg_file_01", which should be changed to "regfile_reg_file_01"
                ss << ConditionVisitorSVA::toString(returnValue.first->getReturnValue()) << "; \n";
            } else {
                ss << "return " << ConditionVisitorSVA::toString(returnValue.first->getReturnValue()) << "; \n";
            }
            --j;
        }
        ss << "endfunction\n\n";
    }
    return ss.str();
}

std::string PrintSVA::dataTypes() {

    std::stringstream ss;

    ss << "// DATA TYPES //\n";
    for (auto type: DataTypes::getDataTypeMap()) {
        if (type.second->isEnumType()) {
            ss << "typedef enum {";
            for (auto it = type.second->getEnumValueMap().begin(); it != type.second->getEnumValueMap().end(); ++it) {
                ss << it->first;
                if (std::next(it) != type.second->getEnumValueMap().end())
                    ss << ", ";
            }
            ss << "} " << type.second->getName() << ";\n";
        }
    }

    return ss.str();
}

std::string PrintSVA::signals() {
    std::shared_ptr<SCAM::PropertySuite> ps = this->module->getPropertySuite();
    std::stringstream ss;

    ss << "\n// SYNC AND NOTIFY SIGNALS (1-cycle macros) //\n";
    for (auto sync: ps->getSyncSignals()){
        ss << "function " << sync->getName() << ";\n\t"  << sync->getName() << " = ;\nendfunction" << std::endl;
    }
    for (auto notify: ps->getNotifySignals()){
        ss << "function " << notify->getName() << ";\n\t"  << notify->getName() << " = ;\nendfunction" << std::endl;
    }

    ss << "\n// DP SIGNALS //\n";
    for (auto dp: ps->getDpSignals()) {

        ss << "function " << convertDataType(dp->getDataType()) << " ";
        ss << dp->getFullName("_") << ";\n";
        ss << "\t" << dp->getFullName("_") << " = ;\nendfunction\n";
    }
    return ss.str();
}

std::string PrintSVA::registers() {
    std::shared_ptr<SCAM::PropertySuite> ps = this->module->getPropertySuite();
    std::stringstream ss;
    ss << "\n// VISIBLE REGISTERS //\n";
    for (auto vr: ps->getVisibleRegisters()) {
        bool skip = vr->isSubVar() && vr->getParentDataType()->isArrayType();
        if (!skip) {
             ss << "function " << convertDataType(vr->getDataType()) << " " << vr->getFullName("_") << ";\n";
             ss << "\t" << vr->getFullName("_");
             ss << " = ;\nendfunction\n";
        }
    }
    //TODO: add array types
    return ss.str();
}

std::string PrintSVA::states() {
    std::shared_ptr<SCAM::PropertySuite> ps = this->module->getPropertySuite();
    std::stringstream ss;
    ss << "\n// STATES //\n";
    for (auto state: ps->getStates()) {
        ss << "function " << state->getName() << ";\n\t"
           << state->getName() << " = ;\n"
           << "endfunction\n";
    }
    return ss.str();
}

std::string PrintSVA::reset_sequence() {
    std::stringstream ss;
    ss << "sequence reset_sequence;\n\t//DESIGNER REFER TO MODEL RESET SIGNAL HERE\nendsequence\n\n";
    return ss.str();
}

std::string PrintSVA::temporalExpr(TemporalExpr *temporalExpr) {

    std::stringstream ss;

    ss << "\t";
    if (temporalExpr->isAt()) {
        ss << ConditionVisitorSVA::toString((temporalExpr->getTimepointList().at(0)));
        ss << " ##0 ";
    } else if (temporalExpr->isDuring()) {  //TODO: Think of a smoother way for during case
        ss << "during_o (";
        for (auto t : temporalExpr->getTimepointList()) {
            if (NodePeekVisitor::nodePeekArithmetic(t)) {
                Arithmetic *a = NodePeekVisitor::nodePeekArithmetic(t);
                ss << ConditionVisitorSVA::toString(a->getLhs()) << ", ";
                if (a->getOperation() == "-"){
                    ss << "-";
                }
                ss << ConditionVisitorSVA::toString(a->getRhs()) << ", ";
            } else {
                ss << ConditionVisitorSVA::toString(t) << ", 0, ";
            }
        }
        ss << ConditionVisitorSVA::toString(temporalExpr->getStatement()) << ")";
        return ss.str();
    }
    if (NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement())) {
        Assignment * a = NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement());
        ss << ConditionVisitorSVA::toString(a->getLhs());
        ss << " == ";
        ss << DatapathVisitorSVA::toString(a->getRhs());
    } else {
        ss << ConditionVisitorSVA::toString(temporalExpr->getStatement());
    }

    return ss.str();
}

std::string PrintSVA::reset_operation() {
    std::shared_ptr<SCAM::PropertySuite> ps = this->module->getPropertySuite();
    std::stringstream ss;
    ss << "property reset_p;\n"
       << "\treset_sequence |=>\n";
    for (auto commitment : ps->getResetProperty()->getCommitmentList()) {
        ss << temporalExpr(commitment);
        if (commitment != ps->getResetProperty()->getCommitmentList().back())
            ss << " and\n";

    }
    ss << ";\n";
    ss << "endproperty\n";
    ss << "reset_a: assert property (reset_p);\n\n";
    ss << "\n\n";
    return ss.str();
}

std::string PrintSVA::operations() {

    std::shared_ptr<SCAM::PropertySuite> ps = this->module->getPropertySuite();

    std::stringstream ss;

    // Operations
    for (auto op : ps->getProperties()) {
        ss << "property " << op->getName() << "_p(o);\n";

        if (!op->getFreezeSignals().empty()) {
            for (auto f : op->getFreezeSignals()) {
                ss << " " << convertDataType(f.second->getDataType()) << " " << f.first->getFullName("_") << "_0;\n";
            }
            for (auto f : op->getFreezeSignals()) {
                ss << "\t" << f.second->getName() << " ##0 hold(" << f.first->getFullName("_") << "_0, " << f.first->getFullName() << "()) and\n";
            }
        }

        for (auto a = op->getAssumptionList().begin(); a != op->getAssumptionList().end(); a++){
            ss << temporalExpr(*a);
            if (std::next(a) != op->getAssumptionList().end()) {
                ss << " and\n";
            }
        }
        ss << "\n";

        ss << "implies\n";

        for (auto c = op->getCommitmentList().begin(); c != op->getCommitmentList().end(); c++){
            ss << temporalExpr(*c);
            if (std::next(c) != op->getCommitmentList().end()) {
                ss << " and\n";
            }
        }
        ss << ";\n";
        ss << "endproperty;\n";
        ss << op->getName() << "_a: assert property (disable iff (reset) "<< op->getName() << "_p(1)); //ASSIGN t_end offset here\n\n";
        ss << "\n\n";
    }
    return ss.str();
}

std::string PrintSVA::convertDataType(const DataType *dataType) const {
    std::string dataTypeName = dataType->getName();
    if (dataTypeName == "bool") {
        return "bit";
    } else if (dataTypeName == "unsigned") {
        return "bit[31:0]";
    } else {
        return dataTypeName;
    }
}

std::string PrintSVA::location(bool loc) {
    if (getOptionMap()["pipelined"]) {
        if (loc) return "(true)";
        else return "(false)";
    } else return "";
}

std::string PrintSVA::tolower(std::string str) {
    std::locale loc; // for return type to be in lowercase
    std::stringstream ret;
    for (char i : str)
        ret << std::tolower(i, loc);
    return ret.str();
}

std::string PrintSVA::globalFunctions() {
    std::stringstream globss;
    globss << "\n\n// GLOBAL FUNCTIONS //\n";
    for (auto function: model->getGlobalFunctionMap()) {
        globss << "function " + convertDataType(function.second->getReturnType()) + " " + function.first << " (";
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isCompoundType()) {
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                     iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    globss << convertDataType(iterator->second) << " " << param->first << "_" << iterator->first;
                    if (iterator != --param->second->getDataType()->getSubVarMap().end()) globss << ", ";
                }
            } else {
                globss << convertDataType(param->second->getDataType()) << " " << param->first;
            }
            if (param != --paramMap.end()) globss << ", ";
        }
        globss << ");\n";

        if (function.second->getReturnValueConditionList().empty())
            throw std::runtime_error(" No return value for function " + function.first + "()");
        auto j = function.second->getReturnValueConditionList().size();
        for (auto returnValue: function.second->getReturnValueConditionList()) {
            globss << "\t";
            //Any conditions?
            if (!returnValue.second.empty()) {

                if (j == function.second->getReturnValueConditionList().size()) {
                    globss << "if (";
                } else globss << "else if (";

                auto i = returnValue.second.size();
                for (auto cond: returnValue.second) {
                    globss << ConditionVisitorSVA::toString(cond);
                    if (i > 1) globss << " && ";
                    --i;
                }
                globss << ") begin return ";
                //TODO: The following lines print statements like "regfile.reg_file_01", which should be changed to "regfile_reg_file_01"
                globss << ConditionVisitorSVA::toString(returnValue.first->getReturnValue()) << "; \n";
            } else {
                globss << "return " << ConditionVisitorSVA::toString(returnValue.first->getReturnValue()) << "; \n";
            }
            --j;
        }
        globss << "endfunction\n\n";
    }
    return globss.str();
}
