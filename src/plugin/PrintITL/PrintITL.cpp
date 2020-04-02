//
// Created by ludwig on 27.10.16.
//

#include "ConditionVisitor.h"
#include "DatapathVisitor.h"
#include "PrintITL.h"


using namespace SCAM;

PrintITL::PrintITL()
{
    if (getOptionMap().at("hls-sco") || getOptionMap().at("hls-mco")) {
        macroFunction = std::bind(&PrintITL::macrosForHLS, this);
    }
    else {
        macroFunction = std::bind(&PrintITL::macros, this);
    }
}

std::map<std::string, std::string> PrintITL::printModel(Model *node) {
    this->model = node;
    for (auto &module: node->getModules()) {

        this->module = module.second;

        pluginOutput.insert(std::make_pair(module.first + "_macros.vhi", macroFunction()));
        pluginOutput.insert(std::make_pair(module.first + ".vhi", operations()));
        std::string funString = functions();
        if (!funString.empty())
            pluginOutput.insert(std::make_pair(module.first + "_functions.vhi", funString));

    }

    if(!node->getGlobalFunctionMap().empty()){
        pluginOutput.insert(std::make_pair(node->getName() + "_global_functions.vhi", globalFunctions()));
    }

    return pluginOutput;
}

std::map<std::string, std::string> PrintITL::printModule(SCAM::Module *node) {

    this->module = node;

    pluginOutput.insert(std::make_pair(node->getName() + ".vhi", macroFunction() + operations()));
    pluginOutput.insert(std::make_pair(node->getName() + "_functions.vhi", functions()));

    return pluginOutput;
}

std::string PrintITL::print() {
    return (macros() + operations()  + functions());
}

std::string PrintITL::functions() {
    std::stringstream ss;
    if (module->getFunctionMap().empty()) return ss.str();
    ss << "-- FUNCTIONS --\n";
    for (auto function: module->getFunctionMap()) {
        ss << "macro " + function.first << "(";
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isCompoundType()) {
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                     iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    ss << param->first << "_" << iterator->first << ": " << convertDataType(iterator->second->getName());
                    if (iterator != --param->second->getDataType()->getSubVarMap().end()) ss << ";";
                }
            } else {
                ss << param->first << ": " << convertDataType(param->second->getDataType()->getName());
            }
            if (param != --paramMap.end()) ss << ";";
        }
        ss << ") : " << convertDataType(function.second->getReturnType()->getName()) << " :=\n";

        if (function.second->getReturnValueConditionList().empty())
            throw std::runtime_error(" No return value for function " + function.first + "()");
        auto branchNum = function.second->getReturnValueConditionList().size();
        for (auto returnValue: function.second->getReturnValueConditionList()) {
            ss << "\t";
            //Any conditions?
            if (!returnValue.second.empty()) {
                if (branchNum > 1) {
                    if (branchNum == function.second->getReturnValueConditionList().size())
                        ss << "if (";
                    else
                        ss << "elsif (";

                    auto condNum = returnValue.second.size();
                    for (auto cond_it: returnValue.second) {
                        ss << ConditionVisitor::toString(cond_it);
                        if (condNum > 1) ss << " and ";
                        condNum--;
                    }
                    ss << ") then ";
                }
            }

            // Handle optimized functions (last branch does not have any conditions)
            if (1 != function.second->getReturnValueConditionList().size()) {
                if (branchNum == 1) ss << "else ";
            }

            if (function.second->getReturnType()->getName() == "int" || function.second->getReturnType()->getName() == "unsigned") {
                ss << convertDataType(function.second->getReturnType()->getName());
            }
            ss << "(" << ConditionVisitor::toString(returnValue.first->getReturnValue()) << ")";
            if (!returnValue.second.empty()) {
                ss << "\n";
            } else {
                ss << ";\n";
            }
            --branchNum;
        }
        if (function.second->getReturnValueConditionList().size() > 1) ss << "end if;\n";
        ss << "end macro;\n\n";
    }
    return ss.str();
}

std::string PrintITL::convertDataType(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "boolean";
    } else if (dataTypeName == "int") {
        return "signed";
    } else {
        return dataTypeName;
    }
}

std::string PrintITL::convertDataTypeForHLS(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "boolean";
    } else if (dataTypeName == "int" || dataTypeName == "unsigned") {
        return "std_logic_vector";
    } else {
        return dataTypeName;
    }
}

std::string PrintITL::location(bool loc) {
    if (getOptionMap()["pipelined"]) {
        if (loc) return "(true)";
        else return "(false)";
    } else return "";
}


std::string PrintITL::printTemporalExpr(TemporalExpr* temporalExpr) {

    std::stringstream ss;

    ss << "\t";
    if (temporalExpr->isAt()) {
        ss << "at ";
        ss << TimePointVisitor::toString(temporalExpr->getTimepointList().front());
        ss << ": ";
    } else if (temporalExpr->isDuring()) {
        ss << "during[";
        ss << TimePointVisitor::toString(temporalExpr->getTimepointList().front());
        ss << ", ";
        ss << TimePointVisitor::toString(temporalExpr->getTimepointList().back());
        ss << "]: ";
    }

    if (NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement())) {
        Assignment * a = NodePeekVisitor::nodePeekAssignment(temporalExpr->getStatement());
        ss << ConditionVisitor::toString(a->getLhs());
        ss << " = ";
        ss << DatapathVisitor::toString(a->getRhs(),2,0,temporalExpr->getFreezeAt());
    } else {
        ss << ConditionVisitor::toString(temporalExpr->getStatement());
    }
    ss << ";\n";

    return ss.str();
}

std::string PrintITL::printProperty(Property *property) {

    std::stringstream ss;

    ss << "property " << property->getName() << " is\n";

    if (!property->getConstraints().empty()) {
        ss << "dependencies: ";
        for (auto c : property->getConstraints()) {
            ss << c->getName();
            if (c != *(property->getConstraints().end()-1)){
                ss << ", ";
            }
        }
        ss << ";\n";
    }

    if (!property->getTimePoints().empty()) {
        ss << "for timepoints:\n";
        if (getOptionMap().at("hls-mco")) {
            ss << "\tt_end = t+t_min..t_max waits_for done_sig = '1';\n";
        } else {
            for (auto tp = property->getTimePointsOrdered().begin(); tp!=property->getTimePointsOrdered().end(); tp++) {
                ss << "\t" << tp->first->getName() << " = " << TimePointVisitor::toString(tp->second);
                if (std::next(tp)!=property->getTimePointsOrdered().end()) {
                    ss << ",\n";
                }
            }
            ss << ";\n";
        }
    }

    if (!property->getFreezeSignals().empty()) {
        ss << "freeze:\n";
        for (auto f = property->getFreezeSignals().begin(); f != property->getFreezeSignals().end(); f++) {
            ss <<  "\t" <<  f->first->getFullName("_");
            ss << "_at_" + f->second->getName();
            ss << " = ";
            if(f->first->isSubVar() && f->first->getParentDataType()->isArrayType()){
                ss << f->first->getFullName();
            }else ss << f->first->getFullName("_");
            ss << "@" << f->second->getName();
            if (std::next(f) != property->getFreezeSignals().end()) {
                ss << ",\n";
            }
        }
        ss << ";\n";
    }

    if (!property->getAssumptionList().empty()){
        ss << "assume:\n";
        for (auto a : property->getAssumptionList()) {
            ss << printTemporalExpr(a);
        }
    }

    if (!property->getCommitmentList().empty()) {
        ss << "prove:\n";
        for (auto c : property->getCommitmentList()) {
            ss << printTemporalExpr(c);
        }
    }
    
    ss << "end property;\n\n\n";

    return ss.str();
}

std::string PrintITL::macros() {
    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;


    ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --" << std::endl;
    for (auto sync: ps->getSyncSignals()) {
        ss << "macro " << sync->getName() << " : " << convertDataType(sync->getDataType()->getName()) << " := end macro;" << std::endl;
    }
    for (auto notify: ps->getNotifySignals()) {
        ss << "macro " << notify->getName() << " : " << convertDataType(notify->getDataType()->getName()) << " := end macro;" << std::endl;
    }
    ss << std::endl << std::endl;

    ss << "-- DP SIGNALS --" << std::endl;
    for (auto dp: ps->getDpSignals()) {
        ss << "macro " ;
        ss << dp->getFullName("_");
        ss << " : " << convertDataType(dp->getDataType()->getName()) << " := end macro;" << std::endl;
    }
    ss << std::endl << std::endl;

    ss << "-- CONSTRAINTS --" << std::endl;
    // Reset constraint is print out extra because of the quotation marks ('0')
    ss << "constraint no_reset := rst = '0'; end constraint;" << std::endl;
    for (auto co: ps->getConstraints()) {
        if (co->getName() != "no_reset") {
            ss << "constraint " << co->getName() << " : " << ConditionVisitor::toString(co->getExpression()) << "; end constraint;" << std::endl;
        }
    }
    ss << std::endl << std::endl;

    ss << "-- VISIBLE REGISTERS --" << std::endl;
    for (auto vr: ps->getVisibleRegisters()) {
        bool skip = vr->isSubVar() && vr->getParentDataType()->isArrayType();
        if (!skip) {  //Dont print all the sub vars for an array
            ss << "macro " << vr->getFullName("_");
           ss << " : " << convertDataType(vr->getDataType()->getName()) << " := end macro;" << std::endl;
        }
    }
    ss << std::endl << std::endl;

    ss << "-- STATES --" << std::endl;
    for (auto st: ps->getStates()) {
        ss << "macro " << st->getName() << " : " << convertDataType(st->getDataType()->getName());
        ss << " := " << ConditionVisitor::toString(st->getExpression()) << " end macro;" << std::endl;
    }
    ss << std::endl << std::endl;
    return ss.str();
}

std::string PrintITL::operations() {

    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;

    ss << "-- OPERATIONS --" << std::endl;

    // Reset property
    ss << "property " << ps->getResetProperty()->getName() << " is\n";
    ss << "assume:\n";
    ss << "\t reset_sequence;\n";
    ss << "prove:\n";
    for (auto c : ps->getResetProperty()->getCommitmentList()) {
        ss << "\t at t: " << ConditionVisitor::toString(c->getStatement()) << ";\n";
    }
    ss << "end property;\n";
    ss << std::endl << std::endl;

    for (auto p : ps->getProperties()) {
        ss << printProperty(p);
    }

    return ss.str();
}

std::string PrintITL::macrosForHLS()
{
    PropertySuite* ps = this->module->getPropertySuite();
    std::stringstream ss;

    ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --" << std::endl;
    for (auto sync: ps->getSyncSignals()) {
        ss << "-- macro " << sync->getName() << " : " << convertDataTypeForHLS(sync->getDataType()->getName())
           << " := end macro;" << std::endl;
    }
    for (auto notify: ps->getNotifySignals()) {
        ss << "-- macro " << notify->getName() << " : " << convertDataTypeForHLS(notify->getDataType()->getName())
           << " := end macro;" << std::endl;
    }
    ss << std::endl << std::endl;

    ss << "-- DP SIGNALS --" << std::endl;
    for (auto dp: ps->getDpSignals()) {
        if (dp->isCompoundType() || (dp->isSubVar() && dp->getParentDataType()->isArrayType())
                || (!dp->isSubVar()) && !dp->isArrayType()) {
            ss << "-- ";
        }
        ss << "macro ";
        ss << dp->getFullName("_");
        ss << " : " << convertDataTypeForHLS(dp->getDataType()->getName()) << " := ";
        ss << dp->getFullName(".");
        ss << " end macro;" << std::endl;
    }
    ss << std::endl << std::endl;

    ss << "-- CONSTRAINTS --" << std::endl;
    // Reset constraint is print out extra because of the quotation marks ('0')
    ss << "constraint no_reset := rst = '0'; end constraint;" << std::endl;
    for (auto co: ps->getConstraints()) {
        if (co->getName()!="no_reset") {
            ss << "constraint " << co->getName() << " : " << ConditionVisitor::toString(co->getExpression())
               << "; end constraint;" << std::endl;
        }
    }
    ss << std::endl << std::endl;

    ss << "-- VISIBLE REGISTERS --" << std::endl;
    for (auto vr: ps->getVisibleRegisters()) {
        if (vr->isCompoundType() || (vr->isSubVar() && vr->getParentDataType()->isArrayType())
                || ((!vr->isSubVar()) && !vr->isArrayType())) {
            ss << "-- ";
        }
        ss << "macro " << vr->getFullName("_");
        ss << " : " << convertDataTypeForHLS(vr->getDataType()->getName()) << " := ";
        ss << vr->getFullName(".");
        ss << " end macro;" << std::endl;
    }
    ss << std::endl << std::endl;

    ss << "-- STATES --" << std::endl;
    for (auto st: ps->getStates()) {
        ss << "macro " << st->getName() << " : " << convertDataTypeForHLS(st->getDataType()->getName())
           << " := " << "active_state = st_" << st->getName();
        if (getOptionMap().at("hls-mco")) {
            ss << " and (ready_sig = '1' or idle_sig = '1')";
        }
        ss << " end macro;\n";
    }
    ss << std::endl << std::endl;
    return ss.str();
}


std::string PrintITL::globalFunctions() {
    std::stringstream ss;
    if (model->getGlobalFunctionMap().empty()) return ss.str();
    ss << "-- GLOBAL FUNCTIONS --\n";
    for (auto function: model->getGlobalFunctionMap()) {
        ss << "macro " + function.first << "(";
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isCompoundType()) {
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                     iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    ss << param->first << "_" << iterator->first << ": " << convertDataType(iterator->second->getName());
                    if (iterator != --param->second->getDataType()->getSubVarMap().end()) ss << ";";
                }
            } else {
                ss << param->first << ": " << convertDataType(param->second->getDataType()->getName());
            }
            if (param != --paramMap.end()) ss << ";";
        }
        ss << ") : " << convertDataType(function.second->getReturnType()->getName()) << " :=\n";

        if (function.second->getReturnValueConditionList().empty())
            throw std::runtime_error(" No return value for function " + function.first + "()");
        auto branchNum = function.second->getReturnValueConditionList().size();
        for (auto returnValue: function.second->getReturnValueConditionList()) {
            ss << "\t";
            //Any conditions?
            if (!returnValue.second.empty()) {
                if (branchNum > 1) {
                    if (branchNum == function.second->getReturnValueConditionList().size())
                        ss << "if (";
                    else
                        ss << "elsif (";

                    auto condNum = returnValue.second.size();
                    for (auto cond_it: returnValue.second) {
                        ss << ConditionVisitor::toString(cond_it);
                        if (condNum > 1) ss << " and ";
                        condNum--;
                    }
                    ss << ") then ";
                }
            }

            // Handle optimized functions (last branch does not have any conditions)
            if (1 != function.second->getReturnValueConditionList().size()) {
                if (branchNum == 1) ss << "else ";
            }

            if (function.second->getReturnType()->getName() == "int" || function.second->getReturnType()->getName() == "unsigned") {
                ss << convertDataType(function.second->getReturnType()->getName());
            }
            ss << "(" << ConditionVisitor::toString(returnValue.first->getReturnValue()) << ")";
            if (!returnValue.second.empty()) {
                ss << "\n";
            } else {
                ss << ";\n";
            }
            --branchNum;
        }
        if (function.second->getReturnValueConditionList().size() > 1) ss << "end if;\n";
        ss << "end macro;\n\n";
    }
    return ss.str();
}
