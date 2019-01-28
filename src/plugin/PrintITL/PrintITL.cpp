//
// Created by ludwig on 27.10.16.
//

#include "PropertyFactory.h"
#include <fstream>
#include <ExprVisitor.h>
#include <optimizePPA/OptimizeMaster.h>
#include <optimizePPA/OptimizeSlave.h>
#include <optimizePPA/OptimizeOperations.h>

#include "PrintITL.h"
#include "Config.h"
#include "ConditionVisitor.h"
#include "DatapathVisitor.h"


std::map<std::string, std::string> PrintITL::printModel(Model *node) {
    for (auto &module: node->getModules()) {
        this->module = module.second;

        optimizeCommunicationFSM();
        std::stringstream result;

        result << signals() << constraints()  << registers() << states() << reset_operation()
               << operations() << wait_operations();
        pluginOutput.insert(std::make_pair(module.first + ".vhi", result.str()));
        pluginOutput.insert(std::make_pair(module.first + "_functions.vhi",functions()));
    }
    return pluginOutput;
}

std::map<std::string, std::string> PrintITL::printModule(SCAM::Module *node) {

    this->module = node;

    optimizeCommunicationFSM();
    std::stringstream result;
    result << signals() << constraints() << functions() << registers() << states() << reset_operation()
           << operations() << wait_operations();
    pluginOutput.insert(std::make_pair(node->getName() + ".vhi", result.str()));
    return pluginOutput;
}

std::string PrintITL::print() {
    std::stringstream result;
    result << signals() << constraints() << functions() << registers() << states() << reset_operation()
           << operations() << wait_operations();
    return result.str();
}

////////////////

std::string PrintITL::signals() {
    std::stringstream ss;
    ss << "-- SYNC AND NOTIFY SIGNALS (1-cycle macros) -- \n";
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared()) continue;
        if (interface->isMasterOut() || interface->isBlocking()) {
            ss << "macro " + port.first << "_notify :  boolean " << " := end macro; \n";
        }
        if (!interface->isMaster() && !interface->isSlaveOut()) {
            ss << "macro " + port.first << "_sync   :  boolean " << " := end macro; \n";
        }
    }
    ss << "\n\n-- DP SIGNALS -- \n";
    for (auto port: module->getPorts()) {
        if (port.second->getDataType()->isVoid()) continue;
        if (!port.second->getDataType()->isCompoundType()) {
            ss << "macro " << port.first << "_sig" << " : " << convertDataType(port.second->getDataType()->getName())
               << " := end macro; \n";
        } else {
            for (auto subVar: port.second->getDataType()->getSubVarMap()) {
                ss << "macro " << port.first << "_sig_" << subVar.first << " : " << convertDataType(subVar.second->getName()) << " := ";
                ss << "end macro; \n";
            }
        }
    }
    return ss.str();
}

std::string PrintITL::constraints() {
    std::stringstream ss;
    ss << "\n\n--CONSTRAINTS-- \n";
    ss << "constraint no_reset := rst = '0'; end constraint; \n";
    return ss.str();
}

std::string PrintITL::registers() {
    std::stringstream ss;
    ss << "\n\n-- VISIBLE REGISTERS --\n";
    if (getOptionMap()["pipelined"]) {
        for (auto stateVar: this->stateVarMap) {
            if (!stateVar.second->isSubVar()) {
                ss << "macro " << stateVar.first << " (location:boolean) : " << convertDataType(stateVar.second->getDataType()->getName())
                   << " := end macro; \n";
            } else {
                VariableOperand varOp(stateVar.second);
                ss << "macro " << ConditionVisitor::toString(&varOp) << " (location:boolean) : "
                   << convertDataType(stateVar.second->getDataType()->getName())
                   << " := end macro; \n";
            }
        }
    } else {
        for (auto stateVar: this->stateVarMap) {
            if (!stateVar.second->isSubVar()) {
                ss << "macro " << stateVar.first << " : " << convertDataType(stateVar.second->getDataType()->getName())
                   << " := end macro; \n";
            } else {
                VariableOperand varOp(stateVar.second);
                ss << "macro " << ConditionVisitor::toString(&varOp) << " : " << convertDataType(stateVar.second->getDataType()->getName())
                   << " := end macro; \n";
            }
        }
    }
    return ss.str();
}

std::string PrintITL::states() {
    std::stringstream ss;
    ss << "\n\n-- STATES -- \n";
    if (getOptionMap()["pipelined"]) {
        for (auto state: this->stateMap) {
            if (state.second->isInit()) continue;
            ss << "macro " + state.second->getName();
            ss << "(location:boolean) : boolean := true end macro;\n";
        }
    } else {
        for (auto state: this->stateMap) {
            if (state.second->isInit()) continue;
            ss << "macro " + state.second->getName();
            ss << " : boolean := true end macro;\n";
        }
    }
    return ss.str();

}

std::string PrintITL::operations() {
    std::stringstream ss;

    int opCnt = 0;
    int ChunkOpCnt = 0;
    std::string t_end;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {
            ChunkOpCnt++;
            if (ChunkOpCnt > 1000) {
                pluginOutput.insert(std::make_pair(this->module->getName() + "_OPs_" + std::to_string(opCnt) + ".vhi", ss.str()));
                ss.str("");
                ChunkOpCnt = 0;
            }
            if (operation->isWait()) continue;
            ss << "\n\n";
            ss << "property ";
            ss << operation->getState()->getName();

            if (operation->getState()->isRead()) ss << "_read_";
            else if (operation->getState()->isWrite()) ss << "_write_";
            ss << opCnt;
            opCnt++;


            ss << " is\n";
            ss << "dependencies: no_reset;\n";
            if (module->isSlave()) {
                t_end = "t+1";
            } else {
                ss << "for timepoints:\n";
                ss << "\t t_end = ";
                if (operation->isWait()) ss << "t+1;\n";
                else ss << "t+1;\n";
                t_end = "t_end";
            }

            //FREEZE VARS
            std::set<SCAM::SyncSignal *> syncSignals;
            std::set<SCAM::Variable *> variables;
            std::set<SCAM::DataSignal *> dataSignals;
            std::set<std::string> freezeVars;
            std::map<std::string, std::string> freezeVarMap;
            std::vector<SCAM::Assignment *, std::allocator<SCAM::Assignment *>>::const_iterator assignment;
            for (assignment = operation->getCommitmentList().begin();
                 assignment != operation->getCommitmentList().end(); ++assignment) {
                //Find all objects that need to be freezed
                auto newSyncSignals = ExprVisitor::getUsedSynchSignals((*assignment)->getRhs());
                syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
                auto newVariables = ExprVisitor::getUsedVariables((*assignment)->getRhs());
                variables.insert(newVariables.begin(), newVariables.end());
                auto newDataSignals = ExprVisitor::getUsedDataSignals((*assignment)->getRhs());
                dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
            }
            int freezeVarCnt = 0;
            freezeVarCnt += syncSignals.size();
            freezeVarCnt += variables.size();
            freezeVarCnt += dataSignals.size();

            for (auto sync: syncSignals) {
                freezeVarMap[DatapathVisitor::toString(sync)] = ConditionVisitor::toString(sync);
            }
            for (auto var: variables) {
                auto varOp = VariableOperand(var);
                if (getOptionMap()["pipelined"]) {
                    freezeVarMap[DatapathVisitor::toString(&varOp)] = ConditionVisitor::toString(&varOp)+"(false)";
                }else freezeVarMap[DatapathVisitor::toString(&varOp)] = ConditionVisitor::toString(&varOp);

            }
            for (auto dataSig: dataSignals) {
                auto dataOp = DataSignalOperand(dataSig);
                freezeVarMap[DatapathVisitor::toString(&dataOp)] = ConditionVisitor::toString(&dataOp);
            }

            if (freezeVarCnt != 0) ss << "freeze:\n";
            for (auto freezeVar: freezeVarMap) {
                ss << "\t" + freezeVar.first << " = " << freezeVar.second;
                freezeVarCnt--;
                if (freezeVarCnt == 0) ss << "@t;\n";
                else ss << "@t,\n";
            }

            ss << "assume: \n";
            if (getOptionMap()["pipelined"]) {
                ss << "\t at t: " + operation->getState()->getName()+"(false)"<< ";\n";
            }else{
                ss << "\t at t: " + operation->getState()->getName() << ";\n";
            }

            for (auto assumption: operation->getAssumptionList()) {
                ss << "\t at t: " + ConditionVisitor::toString(assumption) << ";\n";
            }



            //Reset used ports:
            this->usedPortsList.clear();
            ss << "prove:\n";
            //Nextstate
            if (getOptionMap()["pipelined"] ){
                ss << "\t at " << t_end << ": " << operation->getNextState()->getName() << "(true);\n";
            }else{
                ss << "\t at " << t_end << ": " << operation->getNextState()->getName() << ";\n";
            }

            //Translate all dataPath assignments into strings,
            // for the datapath all variable and signals are replaced with their value@t
            for (auto commitment: operation->getCommitmentList()) {
                ss << "\t at " << t_end << ": " << ConditionVisitor::toString(commitment->getLhs());
                if (getOptionMap()["pipelined"] && ExprVisitor::isVar(commitment->getLhs())) ss << "(true)";
                ss << " = ";
                ss << DatapathVisitor::toString(commitment->getRhs()) << ";\n";
                //Add all output port that are used within this operation
                for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                    if (port->getInterface()->isOutput()) {
                        this->usedPortsList.insert(port);
                    }
                }
            }
            //Hold outputs for shareds until t_end-1
            if (!module->isSlave()) {
                //Is holding values for shareds necessary?
//                for (auto port: module->getPorts()) {
//                    if (port.second->getInterface()->isShared()  && port.second->getInterface()->isOutput()) {
//                        if (port.second->getDataType()->isCompoundType()) {
//                            for (auto subSig: port.second->getDataSignal()->getSubSigList()) {
//                                ss << "\tduring[t+1, t_end-1]: " << ConditionVisitor::toString(new DataSignalOperand(subSig)) << "=";
//                                ss << DatapathVisitor::toString(new DataSignalOperand(subSig)) << ";\n";
//                            }
//                        } else {
//                            ss << "\tduring[t+1, t_end-1]: "
//                               << ConditionVisitor::toString(new DataSignalOperand(port.second->getDataSignal())) << "=";
//                            ss << DatapathVisitor::toString(new DataSignalOperand(port.second->getDataSignal())) << ";\n";
//                        }
//                    }
//                }
            }


            //Add all possible inputs for the next state to usedPortsList, necessary because of merge of operations
            for (auto nextOp: operation->getNextState()->getOutgoingOperationList()) {
                for (auto commitment: nextOp->getCommitmentList()) {
                    //Add all input port that are used within this operation

                    for (auto port: ExprVisitor::getUsedPorts(commitment->getRhs())) {
                        if (port->getInterface()->isInput()) {
                            usedPortsList.insert(port);
                        }
                    }
                }
            }


            //Notify&Sync Signals, no notification for shareds, alwaysReady in ...
            for (auto port: module->getPorts()) {
                auto interface = port.second->getInterface();
                if (interface->isShared()) continue;
                if (interface->isSlaveIn()) continue;
                if (interface->isSlaveOut()) continue;
                if (interface->isMasterIn()) continue;

                if (module->isSlave()) {
                    if (this->usedPortsList.find(port.second) != this->usedPortsList.end()) {
                        ss << "\t at t+1: " + port.first << "_notify = true;\n";
                    } else ss << "\t at t+1: " + port.first << "_notify = false;\n";
                } else {
                    if (port.second == operation->getNextState()->getCommPort()) {
                        ss << "\t during[t+1, t_end-1]: " + port.first << "_notify = false;\n";
                        ss << "\t at t_end: " + port.first << "_notify = true;\n";
                    } else if (this->usedPortsList.find(port.second) != this->usedPortsList.end()) {
                        ss << "\t during[t+1, t_end-1]: " + port.first << "_notify = false;\n";
                        ss << "\t at t_end: " + port.first << "_notify = true;\n";
                    } else ss << "\t during[t+1, t_end]: " + port.first << "_notify = false;\n";
                }
            }

            ss << "end property;";
        }
    }
    return ss.str();

}

std::string PrintITL::reset_operation() {
    std::stringstream ss;
    ss << "\n\n--Operations -- \n";

    for (auto state: this->stateMap) {
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (operation->getState()->isInit()) {

                ss << "property reset is\n";
                ss << "assume:\n";
                ss << "\t reset_sequence;\n";
                ss << "prove:\n";
                //Nextstate
                if (getOptionMap()["pipelined"]) {
                    ss << "\t at t: " + operation->getNextState()->getName() << "(true);\n";
                } else ss << "\t at t: " + operation->getNextState()->getName() << ";\n";
                //Translate all dataPath assignments into strings,

                // for the datapath all variable and signals are replaced with their value@t
                for (auto commitment: operation->getCommitmentList()) {
                    if (getOptionMap()["pipelined"] && ExprVisitor::isVar(commitment->getLhs()) ) {
                        ss << "\t at t: " + ConditionVisitor::toString(commitment->getLhs())+"(true)";
                    } else ss << "\t at t: " + ConditionVisitor::toString(commitment->getLhs());
                    ss << " = ";
                    ss << ConditionVisitor::toString(commitment->getRhs()) << ";\n";
                }

                //Notify&Sync Signals, no notification for shareds
                std::set<Port *> usedPortsList;
                for (auto commitment: operation->getCommitmentList()) {
                    //Add all output port that are used within this operation
                    for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                        if (port->getInterface()->isOutput()) {
                            usedPortsList.insert(port);
                        }
                    }
                }
                for (auto nextOp: operation->getNextState()->getOutgoingOperationList()) {
                    for (auto commitment: nextOp->getCommitmentList()) {
                        //Add all input port that are used within this operation
                        for (auto port: ExprVisitor::getUsedPorts(commitment->getRhs())) {
                            if (port->getInterface()->isInput()) {
                                usedPortsList.insert(port);
                            }
                        }
                    }
                }

                usedPortsList.insert(operation->getNextState()->getCommPort());

                for (auto port: module->getPorts()) {
                    if (port.second->getInterface()->isShared()) continue;
                    if (port.second->getInterface()->isSlaveIn()) continue;
                    if (port.second->getInterface()->isSlaveOut()) continue;
                    if (port.second->getInterface()->isMasterIn()) continue;

                    else if (usedPortsList.find(port.second) != usedPortsList.end()) {
                        ss << "\t at t: " + port.first << "_notify = true;\n";
                    } else ss << "\t at t: " + port.first << "_notify = false;\n";

                }
                ss << "end property;\n";
                break;
            }
        }
    }
    return ss.str();
}

std::string PrintITL::wait_operations() {
    std::stringstream ss;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (!operation->isWait()) continue;
            ss << "\n\n";
            ss << "property ";
            ss << "wait_";
            ss << operation->getState()->getName();
            ss << " is\n";
            ss << "dependencies: no_reset;\n";

            //FREEZE VARS
            std::set<SCAM::SyncSignal *> syncSignals;
            std::set<SCAM::Variable *> variables;
            std::set<SCAM::DataSignal *> dataSignals;
            std::set<std::string> freezeVars;
            std::map<std::string, std::string> freezeVarMap;
            std::vector<SCAM::Assignment *, std::allocator<SCAM::Assignment *>>::const_iterator assignment;
            for (assignment = operation->getCommitmentList().begin();
                 assignment != operation->getCommitmentList().end(); ++assignment) {
                //Find all objects that need to be freezed
                auto newSyncSignals = ExprVisitor::getUsedSynchSignals((*assignment)->getRhs());
                syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
                auto newVariables = ExprVisitor::getUsedVariables((*assignment)->getRhs());
                variables.insert(newVariables.begin(), newVariables.end());
                auto newDataSignals = ExprVisitor::getUsedDataSignals((*assignment)->getRhs());
                dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
            }
            int freezeVarCnt = 0;
            freezeVarCnt += syncSignals.size();
            freezeVarCnt += variables.size();
            freezeVarCnt += dataSignals.size();

            for (auto sync: syncSignals) {
                freezeVarMap[DatapathVisitor::toString(sync)] = ConditionVisitor::toString(sync);
            }
            for (auto var: variables) {
                auto varOp = VariableOperand(var);
                if (getOptionMap()["pipelined"]) {
                    freezeVarMap[DatapathVisitor::toString(&varOp)] = ConditionVisitor::toString(&varOp)+"(false)";
                }else freezeVarMap[DatapathVisitor::toString(&varOp)] = ConditionVisitor::toString(&varOp);
            }
            for (auto dataSig: dataSignals) {
                auto dataOp = DataSignalOperand(dataSig);
                freezeVarMap[DatapathVisitor::toString(&dataOp)] = ConditionVisitor::toString(&dataOp);
            }

            if (freezeVarCnt != 0) ss << "freeze:\n";
            for (auto freezeVar: freezeVarMap) {
                ss << "\t" + freezeVar.first << " = " << freezeVar.second;
                freezeVarCnt--;
                if (freezeVarCnt == 0) ss << "@t;\n";
                else ss << "@t,\n";
            }


            ss << "assume: \n";

            if (getOptionMap()["pipelined"]) {
                ss << "\t at t: " + operation->getState()->getName() << "(false);\n";
            }else ss << "\t at t: " + operation->getState()->getName() << ";\n";

            for (auto assumption: operation->getAssumptionList()) {
                ss << "\t at t: " + ConditionVisitor::toString(assumption) << ";\n";
            }
            ss << "prove:\n";
            //Nextstate
            if (getOptionMap()["pipelined"] ){
                ss << "\t at t+1: " + operation->getNextState()->getName() << "(true);\n";
            }else{
                ss << "\t at t+1: " + operation->getNextState()->getName() << ";\n";
            }
            //Translate all dataPath assignments into strings,
            // for the datapath all variable and signals are replaced with their value@t
            for (auto commitment: operation->getCommitmentList()) {
                if (getOptionMap()["pipelined"] && ExprVisitor::isVar(commitment->getLhs())) {
                    ss << "\t at t+1: " + ConditionVisitor::toString(commitment->getLhs())+"(true)";
                }else  ss << "\t at t+1: " + ConditionVisitor::toString(commitment->getLhs());
                ss << " = ";
                ss << DatapathVisitor::toString(commitment->getRhs()) << ";\n";

            }
            //Notify&Sync Signals, no notification for shareds
            for (auto port: module->getPorts()) {
                Interface *pI = port.second->getInterface();
                if (pI->isMasterIn()) continue;
                if (pI->isShared()) continue;
                if ((pI->isBlocking() || pI->isMasterOut()) &&
                    port.second != operation->getNextState()->getCommPort()) {
                    ss << "\t at t+1: " + port.first << "_notify = false;\n";
                } else {
                    ss << "\t at t+1: " + operation->getNextState()->getCommPort()->getName() << "_notify = true;\n";
                }
            }
            ss << "end property;";
        }
    }
    return ss.str();
}


void PrintITL::optimizeCommunicationFSM() {
//        std::cout << "State-map(unoptimized):" << this->getOpCnt(this->module->getFSM()->getStateMap())
//                  << " operations created" << std::endl;

    std::map<SCAM::Operation *, SCAM::Path *> operation_path_map = this->module->getFSM()->getOperationPathMap();
    OptimizeMaster optimizeMaster(this->module->getFSM()->getStateMap(), this->module, operation_path_map);

    OptimizeSlave optzimizeSlave(optimizeMaster.getNewStateMap(), this->module, optimizeMaster.getOperationPathMap());


    OptimizeOperations optimizeOperations(optzimizeSlave.getNewStateMap(), this->module);

    this->stateMap = optimizeOperations.getNewStateMap();
    this->stateVarMap = optimizeOperations.getStateVarMap();
//        std::cout << "State-map(optimized):" << this->getOpCnt(this->stateMap) << " operations created" << std::endl;
//        std::cout << "----------------------" << std::endl;

    int opCnt = 0;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        opCnt += state.second->getOutgoingOperationList().size();
    }
    std::cout << "Operations created: " << opCnt << std::endl;
    if (opCnt > 1000)
        std::cout << "Warning: Due to a large operation cnt streaming output to files!" << std::endl;
}

int PrintITL::getOpCnt(std::map<int, State *> stateMap) {
    int op_cnt = 0;
    for (auto state: stateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            op_cnt++;
        }
    }
    return op_cnt;
}

std::string PrintITL::functions() {
    std::stringstream ss;
    if (module->getFunctionMap().empty()) return ss.str();
    ss << "\n\n-- FUNCTIONS --\n";
    for (auto function: module->getFunctionMap()) {
        ss << "macro " + function.first << "(";
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isCompoundType()) {
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                     iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    ss << param->first << "_" << iterator->first << ": " << iterator->second->getName();
                    if (iterator != --param->second->getDataType()->getSubVarMap().end()) ss << ";";
                }
            } else {
                ss << param->first << ": " << param->second->getDataType()->getName();
            }
            if (param != --paramMap.end()) ss << ";";
        }
        ss << ") : " << convertDataType(function.second->getReturnType()->getName()) << " := \n";

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
                } else {
                    ss << "else ";
                }
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
        ss << "end macro; \n\n";
    }
    return ss.str();
}

std::string PrintITL::convertDataType(std::string dataTypeName) {
    if (dataTypeName == "bool") {
        return "bool";
    } else if (dataTypeName == "int") {
        return "int";
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
