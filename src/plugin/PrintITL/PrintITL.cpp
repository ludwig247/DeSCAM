//
// Created by ludwig on 27.10.16.
//
#include <fstream>
#include <ExprVisitor.h>
#include "PrintITL.h"
#include "Config.h"
#include "ConditionVisitor.h"
#include "DatapathVisitor.h"
#include "TimePointVisitor.h"

std::map<std::string, std::string> PrintITL::printModel(Model *node) {

    for (auto &module: node->getModules()) {

        this->module = module.second;

        pluginOutput.insert(std::make_pair(module.first + "_macros.vhi", macros()));
        pluginOutput.insert(std::make_pair(module.first + ".vhi", operations()));
        std::string funString = functions();
        if (funString != "")
            pluginOutput.insert(std::make_pair(module.first + "_functions.vhi", funString));
    }
    return pluginOutput;
}

std::map<std::string, std::string> PrintITL::printModule(SCAM::Module *node) {

    this->module = node;

    pluginOutput.insert(std::make_pair(node->getName() + ".vhi", propertySuite()));
    pluginOutput.insert(std::make_pair(node->getName() + "_functions.vhi", functions()));

    return pluginOutput;
}

std::string PrintITL::print() {
    return (propertySuite() + functions());
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
        for (auto tp = property->getTimePointsOrdered().begin(); tp != property->getTimePointsOrdered().end(); tp++) {
            ss << "\t" << tp->first->getName() << " = " << TimePointVisitor::toString(tp->second);
            if (std::next(tp) != property->getTimePointsOrdered().end()) {
                ss << ",\n";
            }
        }
        ss << ";\n";
    }

    //TODO: create visitor for freeze variables ... does not work as it is :)
    if (!property->getFreezeSignals().empty()) {
        ss << "freeze:\n";
        for (auto f = property->getFreezeSignals().begin(); f != property->getFreezeSignals().end(); f++) {
            ss << "\t" << f->first->getFullName("_") + "_at_" + f->second->getName();
            ss << " = ";
            ss << f->first->getFullName("_") << "@" << f->second->getName();
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

std::string PrintITL::propertySuite() {

/*    if (getOptionMap()["adjustmacros"]) {
        return adjustmacros();
    } else if (getOptionMap()["pipelined"]) {
        return pipelined();
    }*/

    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;
    std::string t_end;

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
        ss << "macro " << dp->getParentName();
        if (dp->isCompoundType()) {
            ss << "_" + dp->getSubVarName();
        }
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
        if (!vr->isArrayType()) {
            ss << "macro " << vr->getParentName();
            if (vr->isCompoundType()) {
                ss << "_" + vr->getSubVarName();
            }
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
        ss << "macro " << dp->getParentName();
        if (dp->isCompoundType()) {
            ss << "_" + dp->getSubVarName();
        }
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
        if (!vr->isArrayType()) {
            ss << "macro " << vr->getParentName();
            if (vr->isCompoundType()) {
                ss << "_" + vr->getSubVarName();
            }
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
        ss << "\tat t: " << ConditionVisitor::toString(c->getStatement()) << ";\n";
    }
    ss << "end property;\n";
    ss << std::endl << std::endl;

    for (auto p : ps->getProperties()) {
        ss << printProperty(p);
    }

    return ss.str();
}


/*std::string PrintITL::adjustmacros() {

    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;
    std::string t_end;

    ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --" << std::endl;
    for (auto sync: ps->getSyncSignals()) {
        ss << "--macro " << sync->getName() << " : " << convertDataType(sync->getDataType()->getName()) << " := end macro;" << std::endl;
    }
    for (auto notify: ps->getNotifySignals()) {
        ss << "--macro " << notify->getName() << " : " << convertDataType(notify->getDataType()->getName()) << " := end macro;" << std::endl;
    }
    ss << std::endl << std::endl;

    ss << "-- DP SIGNALS --" << std::endl;
    for (auto dp: ps->getDpSignals()) {
        if (!dp->isCompoundType()) {
            ss << "--";
        }
        ss << "macro " << dp->getName();
        if (dp->isCompoundType()) {
            ss << "_" << dp->getSubVarName();
        }
        ss << " : " << convertDataType(dp->getDataType()->getName()) << " := ";
        if (dp->isCompoundType()) {
            ss << dp->getName() << "." << dp->getSubVarName() << " ";
        }
        ss << "end macro;" << std::endl;
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
        if (!vr->isArrayType()) {
            if (!vr->isCompoundType()) {
                ss << "--";
            }
            ss << "macro " << vr->getName();
            if (vr->isCompoundType()) {
                ss << "_" << vr->getSubVarName();
            }
            ss << " : " << convertDataType(vr->getDataType()->getName()) << " := ";
            if (vr->isCompoundType()) {
                ss << vr->getName() << "." << vr->getSubVarName() << " ";
            }
            ss << "end macro;" << std::endl;
        }
    }
    ss << std::endl << std::endl;

    ss << "-- STATES --" << std::endl;
    for (auto st: ps->getStates()) {
        ss << "--macro " << st->getName() << " : " << convertDataType(st->getDataType()->getName());
        ss << " := " << ConditionVisitor::toString(st->getExpression()) << " end macro;" << std::endl;
    }
    ss << std::endl << std::endl;

    ss << "-- OPERATIONS --" << std::endl;

    // Reset property
    ss << "property " << ps->getResetProperty()->getName() << " is\n";
    ss << "assume:\n";
    ss << "\t reset_sequence;\n";
    ss << "prove:\n";
    ss << "\t at t: " << ps->getResetProperty()->getNextState()->getName() << ";\n";
    for (auto commitment : ps->getResetProperty()->getCommitmentList()) {
        ss << "\t at t: " << ConditionVisitor::toString(commitment->getLhs()) << " = " << ConditionVisitor::toString(commitment->getRhs()) << ";\n";
    }
    ss << "end property;\n";
    ss << std::endl << std::endl;

    // Operation properties
    for (auto op : ps->getOperationProperties()) {
        ss << "property " << op->getName() << " is\n";

        unsigned long constraintSize = op->getConstraints().size();
        ss << "dependencies: ";
        for (auto co : op->getConstraints()) {
            ss << co->getName();
            if (constraintSize > 1) {
                ss << ",";
            } else {
                ss << ";\n";
            }
            constraintSize--;
        }

        //TODO: Make function independent of module
        if (module->isSlave()) {
            t_end = "t+1";
        } else {
            ss << "for timepoints:\n";
            ss << "\tt_end = t+1;\n";
            t_end = "t_end";
        }

        unsigned long freezeVarSize = op->getFreezeSignals().size();
        if (freezeVarSize > 0) {
            ss << "freeze:\n";
            for (auto freeze : op->getFreezeSignals()) {

                ss << "\t";
                if (freeze.second->isArrayType()) {
                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName() << "_at_t = ";
                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName() << ")@t";
                } else {
                    ss << freeze.first << "_at_t = " << freeze.first << "@t";
                }

                if (freezeVarSize > 1) {
                    ss << ",\n";
                } else {
                    ss << ";\n";
                }
                freezeVarSize--;
            }
        }
        ss << "assume:\n";
        ss << "\tat t: " << op->getState()->getName() << ";\n";
        for (auto assumption : op->getAssumptionList()) {
            ss << "\tat t: " << ConditionVisitor::toString(assumption) << ";\n";
        }
        ss << "prove:\n";
        ss << "\tat " << t_end << ": " << op->getNextState()->getName() << ";\n";
        for (auto commitment : op->getCommitmentList()) {
            ss << "\tat " << t_end << ": " << ConditionVisitor::toString(commitment->getLhs()) << " = " << DatapathVisitor::toString(commitment->getRhs()) << ";\n";
        }
        for (auto notify : ps->getNotifySignals()) {
            switch (op->getTiming(notify->getPort())) {
                case TT_1:
                    ss << "\tat t+1: " << notify->getName() << " = true;\n";
                    break;
                case FF_1:
                    ss << "\tat t+1: " << notify->getName() << " = false;\n";
                    break;
                case FF_e:
                    ss << "\tduring[t+1, t_end]: " << notify->getName() << " = false;\n";
                    break;
                case FT_e:
                    ss << "\tduring[t+1, t_end-1]: " << notify->getName() << " = false;\n";
                    ss << "\tat t_end: " << notify->getName() << " = true;\n";
                    break;
            }
        }
        ss << "end property;\n";
        ss << "\n\n";
    }

    // Wait properties
    for (auto wp : ps->getWaitProperties()) {
        ss << "property " << wp->getName() << " is\n";

        unsigned long constraintSize = wp->getConstraints().size();
        ss << "dependencies: ";
        for (auto co : wp->getConstraints()) {
            ss << co->getName();
            if (constraintSize > 1) {
                ss << ",";
            } else {
                ss << ";\n";
            }
            constraintSize--;
        }

        unsigned long freezeVarSize = wp->getFreezeSignals().size();
        if (freezeVarSize > 0) {
            ss << "freeze:\n";
            for (auto freeze : wp->getFreezeSignals()) {
                ss << "\t";
                if (freeze.second->isArrayType()) {
                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName() << "_at_t = ";
                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName() << ")@t";
                } else {
                    ss << freeze.first << "_at_t = " << freeze.first << "@t";
                }
                if (freezeVarSize > 1) {
                    ss << ",\n";
                } else {
                    ss << ";\n";
                }
                freezeVarSize--;
            }
        }
        ss << "assume:\n";
        ss << "\tat t: " << wp->getState()->getName() << ";\n";
        for (auto assumption : wp->getAssumptionList()) {
            ss << "\tat t: " << ConditionVisitor::toString(assumption) << ";\n";
        }
        ss << "prove:\n";
        ss << "\tat t+1: " << wp->getNextState()->getName() << ";\n";
        for (auto commitment : wp->getCommitmentList()) {
            ss << "\tat t+1: " << ConditionVisitor::toString(commitment->getLhs()) << " = " << DatapathVisitor::toString(commitment->getRhs()) << ";\n";
        }
        ss << "end property;\n";
        ss << "\n\n";
    }


    return ss.str();
}

std::string PrintITL::pipelined() {

    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;
    std::string t_end;

    ss << "\n\n PIPELINED MODE IS UNTESTED AND NOT COMPLETE!\n\n";

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
        ss << "macro " << dp->getName();
        if (dp->isCompoundType()) {
            ss << "_" + dp->getSubVarName();
        }
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
        if (!vr->isArrayType()) {
            ss << "macro " << vr->getName();
            if (vr->isCompoundType()) {
                ss << "_" + vr->getSubVarName();
            }
            ss << "(location:boolean) : " << convertDataType(vr->getDataType()->getName()) << " := end macro;" << std::endl;
        }
    }
    ss << std::endl << std::endl;

    ss << "-- STATES --" << std::endl;
    for (auto st: ps->getStates()) {
        ss << "macro " << st->getName() << "(location:boolean) : " << convertDataType(st->getDataType()->getName());
        ss << " := " << ConditionVisitor::toString(st->getExpression()) << " end macro;" << std::endl;
    }
    ss << std::endl << std::endl;

    ss << "-- OPERATIONS --" << std::endl;

    // Reset property
    ss << "property " << ps->getResetProperty()->getName() << " is\n";
    ss << "assume:\n";
    ss << "\t reset_sequence;\n";
    ss << "prove:\n";
    ss << "\tat t: " << ps->getResetProperty()->getNextState()->getName() << "(true);\n";
    for (auto commitment : ps->getResetProperty()->getCommitmentList()) {
        ss << "\tat " << t_end << ": " << ConditionVisitor::toString(commitment->getLhs());
        if (ExprVisitor::isVar(commitment->getLhs())) {
            ss << "(true)";
        }
        ss << " = " << DatapathVisitor::toString(commitment->getRhs()) << ";\n";
    }
    ss << "end property;\n";
    ss << std::endl << std::endl;

    // Operation properties
    for (auto op : ps->getOperationProperties()) {
        ss << "property " << op->getName() << " is\n";

        unsigned long constraintSize = op->getConstraints().size();
        ss << "dependencies: ";
        for (auto co : op->getConstraints()) {
            ss << co->getName();
            if (constraintSize > 1) {
                ss << ",";
            } else {
                ss << ";\n";
            }
            constraintSize--;
        }

        //TODO: Make function independent of module
        if (module->isSlave()) {
            t_end = "t+1";
        } else {
            ss << "for timepoints:\n";
            ss << "\tt_end = t+1;\n";
            t_end = "t_end";
        }

        unsigned long freezeVarSize = op->getFreezeSignals().size();
        if (freezeVarSize > 0) {
            ss << "freeze:\n";
            for (auto freeze : op->getFreezeSignals()) {

                ss << "\t";
                if (freeze.second->isArrayType()) {
                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName() << "_at_t = ";
                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName() << ")@t";
                } else {
                    ss << freeze.first << "_at_t = " << freeze.first;
                    try {
                        freeze.second->getVariable();
                        ss << "(false)";
                    } catch (const std::runtime_error &e) {}
                    ss << "@t";
                }

                if (freezeVarSize > 1) {
                    ss << ",\n";
                } else {
                    ss << ";\n";
                }
                freezeVarSize--;
            }
        }
        ss << "assume:\n";
        ss << "\tat t: " << op->getState()->getName() << "(false);\n";
        for (auto assumption : op->getAssumptionList()) {
            ss << "\tat t: " << ConditionVisitor::toString(assumption) << ";\n";
        }
        ss << "prove:\n";
        ss << "\tat " << t_end << ": " << op->getNextState()->getName() << "(true);\n";
        for (auto commitment : op->getCommitmentList()) {
            ss << "\tat " << t_end << ": " << ConditionVisitor::toString(commitment->getLhs());
            if (ExprVisitor::isVar(commitment->getLhs())) {
                ss << "(true)";
            }
            ss << " = " << DatapathVisitor::toString(commitment->getRhs()) << ";\n";
        }
        for (auto notify : ps->getNotifySignals()) {
            switch (op->getTiming(notify->getPort())) {
                case TT_1:
                    ss << "\tat t+1: " << notify->getName() << " = true;\n";
                    break;
                case FF_1:
                    ss << "\tat t+1: " << notify->getName() << " = false;\n";
                    break;
                case FF_e:
                    ss << "\tduring[t+1, t_end]: " << notify->getName() << " = false;\n";
                    break;
                case FT_e:
                    ss << "\tduring[t+1, t_end-1]: " << notify->getName() << " = false;\n";
                    ss << "\tat t_end: " << notify->getName() << " = true;\n";
                    break;
            }
        }
        ss << "end property;\n";
        ss << "\n\n";
    }

    // Wait properties
    for (auto wp : ps->getWaitProperties()) {
        ss << "property " << wp->getName() << " is\n";

        unsigned long constraintSize = wp->getConstraints().size();
        ss << "dependencies: ";
        for (auto co : wp->getConstraints()) {
            ss << co->getName();
            if (constraintSize > 1) {
                ss << ",";
            } else {
                ss << ";\n";
            }
            constraintSize--;
        }

        unsigned long freezeVarSize = wp->getFreezeSignals().size();
        if (freezeVarSize > 0) {
            ss << "freeze:\n";
            for (auto freeze : wp->getFreezeSignals()) {
                ss << "\t";
                if (freeze.second->isArrayType()) {
                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName() << "_at_t = ";
                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName() << ")@t";
                } else {
                    ss << freeze.second->getFullName() << "_at_t = " << freeze.second->getFullName();
                    //TODO: remove try/catch
                    try {
                        freeze.second->getVariable();
                        ss << "(false)";
                    } catch (const std::runtime_error &e) {}
                    ss << "@t";
                }
                if (freezeVarSize > 1) {
                    ss << ",\n";
                } else {
                    ss << ";\n";
                }
                freezeVarSize--;
            }
        }
        ss << "assume:\n";
        ss << "\tat t: " << wp->getState()->getName() << "(false);\n";
        for (auto assumption : wp->getAssumptionList()) {
            ss << "\tat t: " << ConditionVisitor::toString(assumption) << ";\n";
        }
        ss << "prove:\n";
        ss << "\tat t+1: " << wp->getNextState()->getName() << "(true);\n";
        for (auto commitment : wp->getCommitmentList()) {
            ss << "\tat " << t_end << ": " << ConditionVisitor::toString(commitment->getLhs());
            if (ExprVisitor::isVar(commitment->getLhs())) {
                ss << "(true)";
            }
            ss << " = " << DatapathVisitor::toString(commitment->getRhs()) << ";\n";
        }
        ss << "end property;\n";
        ss << "\n\n";
    }


    return ss.str();
}*/
