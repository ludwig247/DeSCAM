//
// Created by ludwig on 27.10.16.
//


#include <fstream>
#include <ExprVisitor.h>
#include <algorithm>

#include <list>

#include "PrintTrueOperation.h"
#include "Config.h"
#include "TrueOperation.h"


std::map<std::string, std::string> PrintTrueOperation::printModel(Model *node) {

    for (auto &module: node->getModules()) {

        this->module = module.second;

        TrueOperation trueOperation(this->module);

        pluginOutput.insert(std::make_pair(module.first + ".vhi", "nothing"));

//       pluginOutput.insert(std::make_pair(module.first + ".vhi", propertySuite()));
//        std::string funString = functions();
//        if (funString != "") pluginOutput.insert(std::make_pair(module.first + "_functions.vhi", funString));
    }
    return pluginOutput;
}

std::map<std::string, std::string> PrintTrueOperation::printModule(SCAM::Module *node) {

    this->module = node;

    pluginOutput.insert(std::make_pair(node->getName() + ".vhi", propertySuite()));
    pluginOutput.insert(std::make_pair(node->getName() + "_functions.vhi", functions()));

    return pluginOutput;
}

std::string PrintTrueOperation::print() {
    return (propertySuite() + functions());
}

std::string PrintTrueOperation::functions() {
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
                    ss << param->first << "_" << iterator->first << ": "
                       << convertDataType(iterator->second->getName());
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
                        ss << ConditionVisitor2::toString(cond_it);
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

            if (function.second->getReturnType()->getName() == "int" ||
                function.second->getReturnType()->getName() == "unsigned") {
                ss << convertDataType(function.second->getReturnType()->getName());
            }
            ss << "(" << ConditionVisitor2::toString(returnValue.first->getReturnValue()) << ")";
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

std::string PrintTrueOperation::convertDataType(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "boolean";
    } else if (dataTypeName == "int") {
        return "signed";
    } else {
        return dataTypeName;
    }
}

std::string PrintTrueOperation::location(bool loc) {
    if (getOptionMap()["pipelined"]) {
        if (loc) return "(true)";
        else return "(false)";
    } else return "";
}

std::string PrintTrueOperation::propertySuite() {

//    if (getOptionMap()["adjustmacros"]) {
//        return adjustmacros();
//    } else if (getOptionMap()["pipelined"]) {
//        return pipelined();
//    }
//
//    PropertySuite *ps = this->module->getPropertySuite();
//    auto is_flushed = ps->createConstraint("is_flushed", new BoolValue("false"));
//
//
//    std::stringstream ss;
//    std::string t_end;
//
//    ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --" << std::endl;
//    for (auto sync: ps->getSyncSignals()) {
//        ss << "macro " << sync->getName() << " : " << convertDataType(sync->getDataType()->getName())
//           << " := end macro;" << std::endl;
//    }
//    for (auto notify: ps->getNotifySignals()) {
//        ss << "macro " << notify->getName() << " : " << convertDataType(notify->getDataType()->getName())
//           << " := end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- DP SIGNALS --" << std::endl;
//    for (auto dp: ps->getDpSignals()) {
//        ss << "macro " << dp->getName();
//        if (dp->isCompoundType()) {
//            ss << "_" + dp->getSubVarName();
//        }
//        ss << " : " << convertDataType(dp->getDataType()->getName()) << " := end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- CONSTRAINTS --" << std::endl;
//    // Reset constraint is print out extra because of the quotation marks ('0')
//    ss << "constraint no_reset := rst = '0'; end constraint;" << std::endl;
//    for (auto co: ps->getConstraints()) {
//        if (co->getName() != "no_reset") {
//            ss << "constraint " << co->getName() << " : " << ConditionVisitor2::toString(co->getExpression())
//               << "; end constraint;" << std::endl;
//        }
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- VISIBLE REGISTERS --" << std::endl;
//    for (auto vr: ps->getVisibleRegisters()) {
//        if (!vr->isArrayType()) {
//            ss << "macro " << vr->getName();
//            if (vr->isCompoundType()) {
//                ss << "_" + vr->getSubVarName();
//            }
//            ss << " : " << convertDataType(vr->getDataType()->getName()) << " := end macro;" << std::endl;
//        }
//    }
//    ss << std::endl << std::endl;
//
//
//    ss << "-- STATES --" << std::endl;
//    for (auto st: ps->getStates()) {
//        ss << "macro " << st->getName() << " : " << convertDataType(st->getDataType()->getName());
//        ss << " := " << ConditionVisitor2::toString(st->getExpression()) << " end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//
//    ss << "-- OPERATIONS --" << std::endl;
//
//    // Reset property
//    ss << "property " << ps->getResetProperty()->getName() << " is\n";
//    ss << "assume:\n";
//    ss << "\t reset_sequence;\n";
//    ss << "prove:\n";
////    ss << "\t at t: " << ps->getResetProperty()->getNextState()->getName() << ";\n";
////    for (auto commitment : ps->getResetProperty()->getCommitmentList()) {
////        ss << "\t at t: " << ConditionVisitor2::toString(commitment->getLhs()) << " = "
////           << ConditionVisitor2::toString(commitment->getRhs()) << ";\n";
//    }
//    ss << "end property;\n";
//    ss << std::endl << std::endl;
//    /*
//    // Operation properties
//    for (auto op : ps->getOperationProperties()) {
//        ss << "property " << op->getName() << " is\n";
//
//        unsigned long constraintSize = op->getConstraints().size();
//        ss << "dependencies: ";
//        for (auto co : op->getConstraints()) {
//            std::cout << "..." << co->getName() << std::endl;
//            ss << co->getName();
//            if (constraintSize > 1) {
//                ss << ",";
//            } else {
//                ss << ";\n";
//            }
//            constraintSize--;
//        }
//
//        //TODO: Make function independent of module
//        if (module->isSlave()) {
//            t_end = "t+1";
//        } else {
//            ss << "for timepoints:\n";
//            ss << "\tt_end = t+1;\n";
//            t_end = "t_end";
//        }
//
//        unsigned long freezeVarSize = op->getFreezeSignals().size();
//        if (freezeVarSize > 0) {
//            ss << "freeze:\n";
//            for (auto freeze : op->getFreezeSignals()) {
//
//                ss << "\t";
//                if (freeze.second->isArrayType()) {
//                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
//                       << "_at_t = ";
//                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
//                       << ")@t";
//                } else {
//                    ss << freeze.first << "_at_t = " << freeze.first << "@t";
//                }
//
//                if (freezeVarSize > 1) {
//                    ss << ",\n";
//                } else {
//                    ss << ";\n";
//                }
//                freezeVarSize--;
//            }
//        }
//        ss << "assume:\n";
//        ss << "\tat t: " << op->getState()->getName() << ";\n";
//        for (auto assumption : op->getAssumptionList()) {
//            ss << "\tat t: " << ConditionVisitor2::toString(assumption) << ";\n";
//        }
//        ss << "prove:\n";
//        ss << "\tat " << t_end << ": " << op->getNextState()->getName() << ";\n";
//        for (auto commitment : op->getCommitmentList()) {
//            ss << "\tat " << t_end << ": " << ConditionVisitor2::toString(commitment->getLhs()) << " = "
//               << DatapathVisitor2::toString(commitment->getRhs()) << ";\n";
//        }
//        for (auto notify : ps->getNotifySignals()) {
//            switch (op->getTiming(notify->getPort())) {
//                case TT_1:
//                    ss << "\tat t+1: " << notify->getName() << " = true;\n";
//                    break;
//                case FF_1:
//                    ss << "\tat t+1: " << notify->getName() << " = false;\n";
//                    break;
//                case FF_e:
//                    ss << "\tduring[t+1, t_end]: " << notify->getName() << " = false;\n";
//                    break;
//                case FT_e:
//                    ss << "\tduring[t+1, t_end-1]: " << notify->getName() << " = false;\n";
//                    ss << "\tat t_end: " << notify->getName() << " = true;\n";
//                    break;
//            }
//        }
//        ss << "end property;\n";
//        ss << "\n\n";
//    }
//    */
////
////    State2 *initState = this->module->getFSM()->getStateMap().at(0);
////    assert(initState->getName() == "init" && "Wrong state");
////
////    auto startState = initState->getOutgoingOperationsList().back()->getNextState();
////    findCylces(startState, startState, {});
////
////    for (auto &&cycle : cycleMap) {
////        ss << generatTrueOp(cycle) << std::endl;
////    }
//
//    // Wait properties
////    for (auto wp : ps->getWaitProperties()) {
////        ss << "property " << wp->getName() << " is\n";
////
////        unsigned long constraintSize = wp->getConstraints().size();
////        ss << "dependencies: ";
////        for (auto co : wp->getConstraints()) {
////            ss << co->getName();
////            if (constraintSize > 1) {
////                ss << ",";
////            } else {
////                ss << ";\n";
////            }
////            constraintSize--;
////        }
////
////        unsigned long freezeVarSize = wp->getFreezeSignals().size();
////        if (freezeVarSize > 0) {
////            ss << "freeze:\n";
////            for (auto freeze : wp->getFreezeSignals()) {
////                ss << "\t";
////                if (freeze.second->isArrayType()) {
////                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
////                       << "_at_t = ";
////                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
////                       << ")@t";
////                } else {
////                    ss << freeze.first << "_at_t = " << freeze.first << "@t";
////                }
////                if (freezeVarSize > 1) {
////                    ss << ",\n";
////                } else {
////                    ss << ";\n";
////                }
////                freezeVarSize--;
////            }
////        }
////        ss << "assume:\n";
////        ss << "\tat t: " << wp->getState()->getName() << ";\n";
////        for (auto assumption : wp->getAssumptionList()) {
////            ss << "\tat t: " << ConditionVisitor2::toString(assumption) << ";\n";
////        }
////        ss << "prove:\n";
////        ss << "\tat t+1: " << wp->getNextState()->getName() << ";\n";
////        for (auto commitment : wp->getCommitmentList()) {
////            ss << "\tat t+1: " << ConditionVisitor2::toString(commitment->getLhs()) << " = "
////               << DatapathVisitor2::toString(commitment->getRhs()) << ";\n";
////        }
////        ss << "end property;\n";
////        ss << "\n\n";
////    }
////
////
    return ss.str();
}

std::string PrintTrueOperation::adjustmacros() {

    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;
    std::string t_end;

//    ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --" << std::endl;
//    for (auto sync: ps->getSyncSignals()) {
//        ss << "--macro " << sync->getName() << " : " << convertDataType(sync->getDataType()->getName())
//           << " := end macro;" << std::endl;
//    }
//    for (auto notify: ps->getNotifySignals()) {
//        ss << "--macro " << notify->getName() << " : " << convertDataType(notify->getDataType()->getName())
//           << " := end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- DP SIGNALS --" << std::endl;
//    for (auto dp: ps->getDpSignals()) {
//        if (!dp->isCompoundType()) {
//            ss << "--";
//        }
//        ss << "macro " << dp->getName();
//        if (dp->isCompoundType()) {
//            ss << "_" << dp->getSubVarName();
//        }
//        ss << " : " << convertDataType(dp->getDataType()->getName()) << " := ";
//        if (dp->isCompoundType()) {
//            ss << dp->getName() << "." << dp->getSubVarName() << " ";
//        }
//        ss << "end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- CONSTRAINTS --" << std::endl;
//    // Reset constraint is print out extra because of the quotation marks ('0')
//    ss << "constraint no_reset := rst = '0'; end constraint;" << std::endl;
//    for (auto co: ps->getConstraints()) {
//        if (co->getName() != "no_reset") {
//            ss << "constraint " << co->getName() << " : " << ConditionVisitor2::toString(co->getExpression())
//               << "; end constraint;" << std::endl;
//        }
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- VISIBLE REGISTERS --" << std::endl;
//    for (auto vr: ps->getVisibleRegisters()) {
//        if (!vr->isArrayType()) {
//            if (!vr->isCompoundType()) {
//                ss << "--";
//            }
//            ss << "macro " << vr->getName();
//            if (vr->isCompoundType()) {
//                ss << "_" << vr->getSubVarName();
//            }
//            ss << " : " << convertDataType(vr->getDataType()->getName()) << " := ";
//            if (vr->isCompoundType()) {
//                ss << vr->getName() << "." << vr->getSubVarName() << " ";
//            }
//            ss << "end macro;" << std::endl;
//        }
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- STATES --" << std::endl;
//    for (auto st: ps->getStates()) {
//        ss << "--macro " << st->getName() << " : " << convertDataType(st->getDataType()->getName());
//        ss << " := " << ConditionVisitor2::toString(st->getExpression()) << " end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- OPERATIONS --" << std::endl;
//
//    // Reset property
//    ss << "property " << ps->getResetProperty()->getName() << " is\n";
//    ss << "assume:\n";
//    ss << "\t reset_sequence;\n";
//    ss << "prove:\n";
//    ss << "\t at t: " << ps->getResetProperty()->getNextState()->getName() << ";\n";
//    for (auto commitment : ps->getResetProperty()->getCommitmentList()) {
//        ss << "\t at t: " << ConditionVisitor2::toString(commitment->getLhs()) << " = "
//           << ConditionVisitor2::toString(commitment->getRhs()) << ";\n";
//    }
//    ss << "end property;\n";
//    ss << std::endl << std::endl;
//
//    // Operation properties
//    for (auto op : ps->getOperationProperties()) {
//        ss << "property " << op->getName() << " is\n";
//
//        unsigned long constraintSize = op->getConstraints().size();
//        ss << "dependencies: ";
//        for (auto co : op->getConstraints()) {
//            ss << co->getName();
//            if (constraintSize > 1) {
//                ss << ",";
//            } else {
//                ss << ";\n";
//            }
//            constraintSize--;
//        }
//
//        //TODO: Make function independent of module
//        if (module->isSlave()) {
//            t_end = "t+1";
//        } else {
//            ss << "for timepoints:\n";
//            ss << "\tt_end = t+1;\n";
//            t_end = "t_end";
//        }
//
//        unsigned long freezeVarSize = op->getFreezeSignals().size();
//        if (freezeVarSize > 0) {
//            ss << "freeze:\n";
//            for (auto freeze : op->getFreezeSignals()) {
//
//                ss << "\t";
//                if (freeze.second->isArrayType()) {
//                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
//                       << "_at_t = ";
//                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
//                       << ")@t";
//                } else {
//                    ss << freeze.first << "_at_t = " << freeze.first << "@t";
//                }
//
//                if (freezeVarSize > 1) {
//                    ss << ",\n";
//                } else {
//                    ss << ";\n";
//                }
//                freezeVarSize--;
//            }
//        }
//        ss << "assume:\n";
//        ss << "\tat t: " << op->getState()->getName() << ";\n";
//        for (auto assumption : op->getAssumptionList()) {
//            ss << "\tat t: " << ConditionVisitor2::toString(assumption) << ";\n";
//        }
//        ss << "prove:\n";
//        ss << "\tat " << t_end << ": " << op->getNextState()->getName() << ";\n";
//        for (auto commitment : op->getCommitmentList()) {
//            ss << "\tat " << t_end << ": " << ConditionVisitor2::toString(commitment->getLhs()) << " = "
//               << DatapathVisitor2::toString(commitment->getRhs()) << ";\n";
//        }
//        for (auto notify : ps->getNotifySignals()) {
//            switch (op->getTiming(notify->getPort())) {
//                case TT_1:
//                    ss << "\tat t+1: " << notify->getName() << " = true;\n";
//                    break;
//                case FF_1:
//                    ss << "\tat t+1: " << notify->getName() << " = false;\n";
//                    break;
//                case FF_e:
//                    ss << "\tduring[t+1, t_end]: " << notify->getName() << " = false;\n";
//                    break;
//                case FT_e:
//                    ss << "\tduring[t+1, t_end-1]: " << notify->getName() << " = false;\n";
//                    ss << "\tat t_end: " << notify->getName() << " = true;\n";
//                    break;
//            }
//        }
//        ss << "end property;\n";
//        ss << "\n\n";
//    }
//
//    // Wait properties
//    for (auto wp : ps->getWaitProperties()) {
//        ss << "property " << wp->getName() << " is\n";
//
//        unsigned long constraintSize = wp->getConstraints().size();
//        ss << "dependencies: ";
//        for (auto co : wp->getConstraints()) {
//            ss << co->getName();
//            if (constraintSize > 1) {
//                ss << ",";
//            } else {
//                ss << ";\n";
//            }
//            constraintSize--;
//        }
//
//        unsigned long freezeVarSize = wp->getFreezeSignals().size();
//        if (freezeVarSize > 0) {
//            ss << "freeze:\n";
//            for (auto freeze : wp->getFreezeSignals()) {
//                ss << "\t";
//                if (freeze.second->isArrayType()) {
//                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
//                       << "_at_t = ";
//                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
//                       << ")@t";
//                } else {
//                    ss << freeze.first << "_at_t = " << freeze.first << "@t";
//                }
//                if (freezeVarSize > 1) {
//                    ss << ",\n";
//                } else {
//                    ss << ";\n";
//                }
//                freezeVarSize--;
//            }
//        }
//        ss << "assume:\n";
//        ss << "\tat t: " << wp->getState()->getName() << ";\n";
//        for (auto assumption : wp->getAssumptionList()) {
//            ss << "\tat t: " << ConditionVisitor2::toString(assumption) << ";\n";
//        }
//        ss << "prove:\n";
//        ss << "\tat t+1: " << wp->getNextState()->getName() << ";\n";
//        for (auto commitment : wp->getCommitmentList()) {
//            ss << "\tat t+1: " << ConditionVisitor2::toString(commitment->getLhs()) << " = "
//               << DatapathVisitor2::toString(commitment->getRhs()) << ";\n";
//        }
//        ss << "end property;\n";
//        ss << "\n\n";
//    }


    return ss.str();
}

std::string PrintTrueOperation::pipelined() {

    PropertySuite *ps = this->module->getPropertySuite();

    std::stringstream ss;
    std::string t_end;
//
//    ss << "\n\n PIPELINED MODE IS UNTESTED AND NOT COMPLETE!\n\n";
//
//    ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) --" << std::endl;
//    for (auto sync: ps->getSyncSignals()) {
//        ss << "macro " << sync->getName() << " : " << convertDataType(sync->getDataType()->getName())
//           << " := end macro;" << std::endl;
//    }
//    for (auto notify: ps->getNotifySignals()) {
//        ss << "macro " << notify->getName() << " : " << convertDataType(notify->getDataType()->getName())
//           << " := end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- DP SIGNALS --" << std::endl;
//    for (auto dp: ps->getDpSignals()) {
//        ss << "macro " << dp->getName();
//        if (dp->isCompoundType()) {
//            ss << "_" + dp->getSubVarName();
//        }
//        ss << " : " << convertDataType(dp->getDataType()->getName()) << " := end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- CONSTRAINTS --" << std::endl;
//    // Reset constraint is print out extra because of the quotation marks ('0')
//    ss << "constraint no_reset := rst = '0'; end constraint;" << std::endl;
//    for (auto co: ps->getConstraints()) {
//        if (co->getName() != "no_reset") {
//            ss << "constraint " << co->getName() << " : " << ConditionVisitor2::toString(co->getExpression())
//               << "; end constraint;" << std::endl;
//        }
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- VISIBLE REGISTERS --" << std::endl;
//    for (auto vr: ps->getVisibleRegisters()) {
//        if (!vr->isArrayType()) {
//            ss << "macro " << vr->getName();
//            if (vr->isCompoundType()) {
//                ss << "_" + vr->getSubVarName();
//            }
//            ss << "(location:boolean) : " << convertDataType(vr->getDataType()->getName()) << " := end macro;"
//               << std::endl;
//        }
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- STATES --" << std::endl;
//    for (auto st: ps->getStates()) {
//        ss << "macro " << st->getName() << "(location:boolean) : " << convertDataType(st->getDataType()->getName());
//        ss << " := " << ConditionVisitor2::toString(st->getExpression()) << " end macro;" << std::endl;
//    }
//    ss << std::endl << std::endl;
//
//    ss << "-- OPERATIONS --" << std::endl;
//
//    // Reset property
//    ss << "property " << ps->getResetProperty()->getName() << " is\n";
//    ss << "assume:\n";
//    ss << "\t reset_sequence;\n";
//    ss << "prove:\n";
//    ss << "\tat t: " << ps->getResetProperty()->getNextState()->getName() << "(true);\n";
//    for (auto commitment : ps->getResetProperty()->getCommitmentList()) {
//        ss << "\tat " << t_end << ": " << ConditionVisitor2::toString(commitment->getLhs());
//        if (ExprVisitor::isVar(commitment->getLhs())) {
//            ss << "(true)";
//        }
//        ss << " = " << DatapathVisitor2::toString(commitment->getRhs()) << ";\n";
//    }
//    ss << "end property;\n";
//    ss << std::endl << std::endl;
//
//    // Operation properties
//    for (auto op : ps->getOperationProperties()) {
//        ss << "property " << op->getName() << " is\n";
//
//        unsigned long constraintSize = op->getConstraints().size();
//        ss << "dependencies: ";
//        for (auto co : op->getConstraints()) {
//            ss << co->getName();
//            if (constraintSize > 1) {
//                ss << ",";
//            } else {
//                ss << ";\n";
//            }
//            constraintSize--;
//        }
//
//        //TODO: Make function independent of module
//        if (module->isSlave()) {
//            t_end = "t+1";
//        } else {
//            ss << "for timepoints:\n";
//            ss << "\tt_end = t+1;\n";
//            t_end = "t_end";
//        }
//
//        unsigned long freezeVarSize = op->getFreezeSignals().size();
//        if (freezeVarSize > 0) {
//            ss << "freeze:\n";
//            for (auto freeze : op->getFreezeSignals()) {
//
//                ss << "\t";
//                if (freeze.second->isArrayType()) {
//                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
//                       << "_at_t = ";
//                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
//                       << ")@t";
//                } else {
//                    ss << freeze.first << "_at_t = " << freeze.first;
//                    try {
//                        freeze.second->getVariable();
//                        ss << "(false)";
//                    } catch (const std::runtime_error &e) {}
//                    ss << "@t";
//                }
//
//                if (freezeVarSize > 1) {
//                    ss << ",\n";
//                } else {
//                    ss << ";\n";
//                }
//                freezeVarSize--;
//            }
//        }
//        ss << "assume:\n";
//        ss << "\tat t: " << op->getState()->getName() << "(false);\n";
//        for (auto assumption : op->getAssumptionList()) {
//            ss << "\tat t: " << ConditionVisitor2::toString(assumption) << ";\n";
//        }
//        ss << "prove:\n";
//        ss << "\tat " << t_end << ": " << op->getNextState()->getName() << "(true);\n";
//        for (auto commitment : op->getCommitmentList()) {
//            ss << "\tat " << t_end << ": " << ConditionVisitor2::toString(commitment->getLhs());
//            if (ExprVisitor::isVar(commitment->getLhs())) {
//                ss << "(true)";
//            }
//            ss << " = " << DatapathVisitor2::toString(commitment->getRhs()) << ";\n";
//        }
//        for (auto notify : ps->getNotifySignals()) {
//            switch (op->getTiming(notify->getPort())) {
//                case TT_1:
//                    ss << "\tat t+1: " << notify->getName() << " = true;\n";
//                    break;
//                case FF_1:
//                    ss << "\tat t+1: " << notify->getName() << " = false;\n";
//                    break;
//                case FF_e:
//                    ss << "\tduring[t+1, t_end]: " << notify->getName() << " = false;\n";
//                    break;
//                case FT_e:
//                    ss << "\tduring[t+1, t_end-1]: " << notify->getName() << " = false;\n";
//                    ss << "\tat t_end: " << notify->getName() << " = true;\n";
//                    break;
//            }
//        }
//        ss << "end property;\n";
//        ss << "\n\n";
//    }
//
//    // Wait properties
//    for (auto wp : ps->getWaitProperties()) {
//        ss << "property " << wp->getName() << " is\n";
//
//        unsigned long constraintSize = wp->getConstraints().size();
//        ss << "dependencies: ";
//        for (auto co : wp->getConstraints()) {
//            ss << co->getName();
//            if (constraintSize > 1) {
//                ss << ",";
//            } else {
//                ss << ";\n";
//            }
//            constraintSize--;
//        }
//
//        unsigned long freezeVarSize = wp->getFreezeSignals().size();
//        if (freezeVarSize > 0) {
//            ss << "freeze:\n";
//            for (auto freeze : wp->getFreezeSignals()) {
//                ss << "\t";
//                if (freeze.second->isArrayType()) {
//                    ss << freeze.second->getParent()->getName() << "_" << freeze.second->getVariable()->getName()
//                       << "_at_t = ";
//                    ss << freeze.second->getParent()->getName() << "(" << freeze.second->getVariable()->getName()
//                       << ")@t";
//                } else {
//                    ss << freeze.first << "_at_t = " << freeze.first;
//                    try {
//                        freeze.second->getVariable();
//                        ss << "(false)";
//                    } catch (const std::runtime_error &e) {}
//                    ss << "@t";
//                }
//                if (freezeVarSize > 1) {
//                    ss << ",\n";
//                } else {
//                    ss << ";\n";
//                }
//                freezeVarSize--;
//            }
//        }
//        ss << "assume:\n";
//        ss << "\tat t: " << wp->getState()->getName() << "(false);\n";
//        for (auto assumption : wp->getAssumptionList()) {
//            ss << "\tat t: " << ConditionVisitor2::toString(assumption) << ";\n";
//        }
//        ss << "prove:\n";
//        ss << "\tat t+1: " << wp->getNextState()->getName() << "(true);\n";
//        for (auto commitment : wp->getCommitmentList()) {
//            ss << "\tat " << t_end << ": " << ConditionVisitor2::toString(commitment->getLhs());
//            if (ExprVisitor::isVar(commitment->getLhs())) {
//                ss << "(true)";
//            }
//            ss << " = " << DatapathVisitor2::toString(commitment->getRhs()) << ";\n";
//        }
//        ss << "end property;\n";
//        ss << "\n\n";
//    }
//

    return ss.str();
}


void PrintTrueOperation::findCylces(State2 *current, State2 *start, const std::vector<Operation2 *> &opList) {
    save++;
    if(save == 0xFFFF-1) throw std::runtime_error(" loop ");
    for (auto operation: current->getOutgoingOperationsList()) {
        if(operation->IsWait()) continue;
        auto newOpList = opList;
        newOpList.push_back(operation);
        if (operation->getNextState() == start) {
            this->cycleMap.push_back(newOpList);
        } else findCylces(operation->getNextState(), start, newOpList);
    }
    return;
}

std::string PrintTrueOperation::generatTrueOp(std::vector<Operation2 *> &cycle) {
    this->cycle_cnt++;
    std::stringstream ss;
    ss << "property " << "cycle" << this->cycle_cnt << " is\n";
    ss << "dependencies: no_reset;\n";
    ss << "for timepoints:\n";
    ss << "\tt_" << cycle.front()->getState()->getName() << " = t,\n";
    for (int i = 1; i < cycle.size(); ++i) {
        auto prev_op = cycle.at(i - 1);
        auto op = cycle.at(i);
        ss << "\tt_" << op->getState()->getName() << " = t_" << prev_op->getState()->getName() << "+1";
        if (i == cycle.size() - 1) ss << ";\n";
        else ss << ",\n";
    }
    ss << "freeze:\n";
    std::vector<std::string> freezeSignals;
    for (auto &&op : cycle) {
        //Find all objects that need to be freezed
        std::set<SCAM::SyncSignal *> syncSignals;
        std::set<SCAM::Variable *> variables;
        std::set<SCAM::DataSignal *> dataSignals;
        for (auto &&assignment : op->getCommitmentsList()) {
            auto newSyncSignals = ExprVisitor::getUsedSynchSignals(assignment->getRhs());
            syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());

            auto newDataSignals = ExprVisitor::getUsedDataSignals(assignment->getRhs());
            dataSignals.insert(newDataSignals.begin(), newDataSignals.end());

            auto lhsExpr = *ExprVisitor::getUsedVariables(assignment->getLhs()).begin();
            if (lhsExpr == nullptr || isRequired(lhsExpr, op, cycle)){
                if( lhsExpr == nullptr || isRequired2(lhsExpr, op, cycle)) {
                    auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                    for (auto var: newVariables) {
                        variables.insert(var);
                    }
                }
            }
        }
        //Stream freeze variables to stringstream

        //throw std::runtime_error("done");

        auto state_name = op->getState()->getName();
        std::string tp = "_at_t_" + state_name;

        for (auto sync: syncSignals) {
            std::stringstream localSS;
            localSS << "\t" << sync->getPort()->getName() + "_sync" << tp << " = " << sync->getPort()->getName() + "_sync@t_"
               << state_name;
            freezeSignals.push_back(localSS.str());
        }
        for (auto var: variables) {
            std::stringstream localSS;
            if (var->isSubVar()) {
                auto varName = var->getParent()->getName();
                auto subName = var->getName();
                if(var->isArrayType()){
                    localSS << "\t" << var->getParent()->getName() << "_" << var->getName() << tp << " = " << varName << "("
                            << subName << ")" << "@t_" << state_name ;
                }else{
                    localSS << "\t" << var->getParent()->getName() << "_" << var->getName() << tp << " = " << varName << "_"
                            << subName <<  "@t_" << state_name ;
                }
            } else   localSS << "\t" << var->getFullName() << tp << " = " << var->getFullName() << "@t_" << state_name ;
            freezeSignals.push_back(localSS.str());
        }
        for (auto dataSig: dataSignals) {
            std::stringstream localSS;
            if (dataSig->isSubVar()) {
                auto varName = dataSig->getParent()->getName();
                auto subName = dataSig->getName();
                localSS << "\t" << dataSig->getParent()->getName() << "_" << dataSig->getName() << tp << " = " << varName
                   << "(" << subName << ")" << "@t_" << state_name;
            } else
                localSS << "\t" << dataSig->getFullName() << tp << " = " << dataSig->getFullName() << "@t_" << state_name;
            freezeSignals.push_back(localSS.str());

        }

    }

    for (auto iterator = freezeSignals.begin(); iterator != freezeSignals.end(); ++iterator) {
        if(iterator == freezeSignals.end()-1){
            ss << *iterator << ";" << std::endl;
        }else ss << *iterator << "," << std::endl;
    }

    ss << "assume:\n";
    ss << "\tat t: state_constraint;\n";
    // constant registers
    ss << "\tduring[t_" << cycle.at(1)->getState()->getName() <<",t_" << cycle.at(cycle.size()-1)->getState()->getName()<<"]: regfile = prev(regfile);\n";
    for (auto &&op : cycle) {
        auto timpeoint = "at t_" + op->getState()->getName() + ": ";
        for (auto &&assumption : op->getAssumptionsList()) {
            ss << "\t" << timpeoint << ConditionVisitor2::toString(assumption) << ";\n";
        }
    }


    ss << "prove:\n";
    //Last operation goes back to beginning no need to prove:
    ss << "\tat t_"<<cycle.at(1)->getState()->getName() <<": state_constraint;\n";
    for (int i = 0; i < cycle.size() - 1; ++i) {
        auto op = cycle.at(i);
        std::string tp = "_at_t_" + op->getState()->getName();
        auto timpeoint = "at t_" + op->getNextState()->getName() + ": ";

        for (auto &&commitment : op->getCommitmentsList()) {
            //Only one variable in set
            auto vars = ExprVisitor::getUsedVariables(commitment->getLhs());
            assert(vars.size() < 2 && "Too many variables for LHS");


            if (vars.empty() || isRequired(*vars.begin(), op, cycle)) {
                if (vars.empty() || isRequired2(*vars.begin(), op, cycle)) {
                    ss << "\t" << timpeoint << ConditionVisitor2::toString(commitment->getLhs()) << " = "
                       << DatapathVisitor2::toString(commitment->getRhs(), 2, 0, tp) << ";\n";
                }
            }
        }
    }

    ss << "right_hook: t_"<<cycle.at(1)->getState()->getName() <<";\n";
    ss << "end property;\n";
    ss << "\n\n";
    /*
    ss << "\tat " << t_end << ": " << op->getNextState()->getName() << ";\n";
    for (auto commitment : op->getCommitmentList()) {
        ss << "\tat " << t_end << ": " << ConditionVisitor2::toString(commitment->getLhs()) << " = "
           << DatapathVisitor::toString(commitment->getRhs()) << ";\n";
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

}
*/
    return ss.str();

}

/***
 * \brief Algorithm checks whether a visible register is needed for completness or not
 *
 * Algorithm starts at the current operation. If the variable is used in the current or any subsequent operatin, then
 * it is needed for completion, otherwise not.
 *
 * @param var
 * @param currentOperation
 * @param cycle
 * @return
 */
bool PrintTrueOperation::isRequired(Variable *var, Operation2 *&currentOperation, std::vector<Operation2 *> &cycle) {

    //Start iterating from currentOperation
    auto it = std::find(begin(cycle), end(cycle), currentOperation);

    //Iterate through set and search for usages of the variable
    for (auto iterator = it; iterator != cycle.end(); ++iterator) {
        for (auto assignment: (*iterator)->getCommitmentsList()) {
            if (PrintStmt::toString(assignment->getLhs()) == var->getFullName()) {
                auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                const bool isInSet = newVariables.find(var) != newVariables.end();
                const bool isEqual = *assignment->getRhs() == *assignment->getLhs();
                if (!isInSet or !isEqual) return true;
            }
        }
    }
    return false;
}

bool PrintTrueOperation::isRequired2(Variable *const &var, Operation2 *op, std::vector<Operation2 *> &cycle) {
    //Start iterating from currentOperation

    //Check operation: Is there already an assignment?
    for (auto assignment: op->getCommitmentsList()) {
        if (PrintStmt::toString(assignment->getLhs()) == var->getFullName()) {
            auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
            //const bool isInSet = newVariables.find(var) != newVariables.end();
            const bool isEqual = *assignment->getRhs() == *assignment->getLhs();
            if (!isEqual) {
                return true;
            }
        }
    }
    auto it = std::find(begin(cycle), end(cycle), op)++;

    //Iterate through set and search for usages of the variable
    for (auto iterator = it; iterator != cycle.end(); ++iterator) {
        for (auto assignment: (*iterator)->getCommitmentsList()) {
            if (PrintStmt::toString(assignment->getLhs()) == var->getFullName()) {
                auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                const bool isInSet = newVariables.find(var) != newVariables.end();
                const bool isEqual = *assignment->getRhs() == *assignment->getLhs();

                if (!isEqual) {
                    if (!isInSet) return false;
                    else return true;
                }
            }
        }
    }
    return false;
}






