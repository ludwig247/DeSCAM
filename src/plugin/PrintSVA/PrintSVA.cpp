//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include "PropertyFactory.h"
#include <fstream>
#include <optimizePPA/OptimizeMaster.h>
#include <optimizePPA/OptimizeSlave.h>
#include <optimizePPA/OptimizeOperations.h>
#include "PrintSVA.h"
#include "Config.h"
#include "ConditionVisitorSVA.h"
#include "DatapathVisitorSVA.h"

std::map<std::string, std::string> PrintSVA::printModel(Model *node) {
    pluginOutput.insert(std::make_pair("ipc.sva", Text_ipc()));

    for (auto &module: node->getModules()) {
        this->module = module.second;
        optimizeCommunicationFSM();
        pluginOutput.insert(std::make_pair(module.first + ".sva", Text_body()));
    }
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
            << "`define next_shift_amount 0 //IN CASE OF REQUIRED SIGNALS VALUES IN THE FUTURE, SHIFT YOUR ENTIRE TIMING BY THIS FACTOR\n"
            << "`include \"ipc.sva\"\n\n"
            << "import scam_model_types::*;\n\n"
            << "module " << this->module->getName() << "_verification(reset);\n\n"
            << "input reset;\n\n"
            << "//DESIGNER SHOULD PAY ATTENTION FOR USING THE MODEL CORRECT NAME TO REFER TO THE CLK SIGNAL USED IN IT\n"
            << "default clocking default_clk @(posedge " << this->module->getName() << ".clk); endclocking\n"
            << functions() << signals() << registers() << states() << "\n\n"
            << "////////////////////////////////////\n"
            << "//////////// Operations ////////////\n"
            << "////////////////////////////////////\n"
            << reset_sequence() << reset_operation() << operations() << wait_operations()
            << "endmodule\n\n"
            << "//DESIGNER SHOULD PAY ATTENTION FOR USING THE MODEL CORRECT NAME FOR BINDING AND TO REFER TO THE RESET SIGNAL USED IN IT\n"
            << "bind " << this->module->getName() << " " << this->module->getName()
            << "_verification inst (.*, .reset());\n";

    return result.str();
}

void PrintSVA::optimizeCommunicationFSM() {
//        std::cout << "State-map(unoptimized):" << getOpCnt(this->module->getFSM()->getStateMap())
//                  << " operations created" << std::endl;

    std::map<SCAM::Operation *, SCAM::Path *> operation_path_map = this->module->getFSM()->getOperationPathMap();
    SCAM::OptimizeMaster optimizeMaster(this->module->getFSM()->getStateMap(), this->module, operation_path_map);

    SCAM::OptimizeSlave optzimizeSlave(optimizeMaster.getNewStateMap(), this->module,
                                 optimizeMaster.getOperationPathMap());

    OptimizeOperations optimizeOperations(optzimizeSlave.getNewStateMap(), this->module);

    this->stateMap = optimizeOperations.getNewStateMap();
    this->stateVarMap = optimizeOperations.getStateVarMap();
//        std::cout << "State-map(optimized):" << getOpCnt(this->stateMap) << " operations created" << std::endl;
//        std::cout << "----------------------" << std::endl;.

    int opCnt = 0;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        opCnt += state.second->getOutgoingOperationList().size();
    }
    if (opCnt > 1000)
        std::cout << "WARNING: Large operation cnt: Streaming output to files!" << std::endl;
}

inline int PrintSVA::getOpCnt(std::map<int, State *> stateMap) {
    int op_cnt = 0;
    for (auto state: stateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            op_cnt++;
        }
    }
    return op_cnt;
}


std::string PrintSVA::functions() {
    std::stringstream ss;
    if (module->getFunctionMap().empty()) return ss.str();
    ss << "\n\n// FUNCTIONS //\n";
    for (auto function: module->getFunctionMap()) {
        ss << "function " + function.second->getReturnType()->getName() + " " + function.first << " (";
        auto paramMap = function.second->getParamMap();
        for (auto param = paramMap.begin(); param != paramMap.end(); ++param) {
            if (param->second->getDataType()->isCompoundType()) {
                for (auto iterator = param->second->getDataType()->getSubVarMap().begin();
                     iterator != param->second->getDataType()->getSubVarMap().end(); ++iterator) {
                    ss << iterator->second->getName() << " " << param->first << "_" << iterator->first;
                    if (iterator != --param->second->getDataType()->getSubVarMap().end()) ss << ", ";
                }
            } else {
                ss << param->second->getDataType()->getName() << " " << param->first;
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
                ss << ConditionVisitorSVA::toString(returnValue.first->getReturnValue()) << "; end\n";
            } else
                ss << "return " << ConditionVisitorSVA::toString(returnValue.first->getReturnValue()) << "; end\n";
            --j;
        }
        ss << "endfunction\n\n";
    }
    return ss.str();
}

std::string PrintSVA::signals() {
    std::stringstream ss;
    ss << "\n// SYNC AND NOTIFY SIGNALS (1-cycle macros) //\n";
    for (auto port: module->getPorts()) {
        auto interface = port.second->getInterface();
        if (interface->isShared()) continue;
        if (interface->isMasterOut() || interface->isBlocking()) {
            ss << "function " << port.first << "_notify;\n\t"
               << port.first << "_notify = ;\n"
               << "endfunction\n";
        }
        if (!interface->isMaster()) {
            ss << "function " << port.first << "_sync;\n\t"
               << port.first << "_sync = ;\n"
               << "endfunction\n";
        }
    }
    ss << "\n// DP SIGNALS //\n";
    for (auto port: module->getPorts()) {
        if (port.second->getDataType()->isVoid()) continue;
        if (!port.second->getDataType()->isCompoundType()) {
            ss << "function " << port.second->getDataType()->getName() << " " << port.first << "_sig;\n\t"
               << port.first << "_sig = ;\n"
               << "endfunction\n";
        } else if (port.second->getDataType()->isCompoundType()) {
            for (auto subVar: port.second->getDataType()->getSubVarMap()) {
                ss << "function " << subVar.second->getName() << " " << port.first << "_sig_" << subVar.first
                   << ";\n\t"
                   << port.first << "_sig_" << subVar.first << " = ;\n"
                   << "endfunction\n";
            }
        }
    }
    return ss.str();
}

std::string PrintSVA::registers() {
    std::stringstream ss;
    ss << "\n// VISIBLE REGISTERS //\n";
    for (auto stateVar: this->stateVarMap) {
        VariableOperand varOp(stateVar.second);
        ss << "function " << stateVar.second->getDataType()->getName() << " ";
        if (varOp.getVariable()->isSubVar()) {
            ss << varOp.getVariable()->getParent()->getName() << "_" << varOp.getVariable()->getName() << ";\n\t"
               << varOp.getVariable()->getParent()->getName() << "_" << varOp.getVariable()->getName() << " = ;\n";
        } else {
            ss << varOp.getVariable()->getName() << ";\n\t"
               << varOp.getVariable()->getName() << " = ;\n";
        }
        ss << "endfunction\n";
    }
    return ss.str();
}

std::string PrintSVA::states() {
    std::stringstream ss;
    ss << "\n// STATES //\n";
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        ss << "function " << state.second->getName() << ";\n\t"
           << state.second->getName() << " = ;\n"
           << "endfunction\n";
    }
    return ss.str();
}

std::string PrintSVA::reset_sequence() {
    std::stringstream ss;
    ss << "sequence reset_sequence;\n//DISGNER REFER TO MODEL RESET SIGNAL HERE\nendsequence\n";
    return ss.str();
}

std::string PrintSVA::reset_operation() {
    std::stringstream ss;

    for (auto state: this->stateMap) {
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (operation->getState()->isInit()) {

                ss << "property reset_p;\n"
                   << "\treset_sequence |=>\n";
                //Nextstate
                ss << "\tt ##0 " + operation->getNextState()->getName() << "() and\n";
                //Translate all dataPath assignments into strings,
                for (auto commitment: operation->getCommitmentList()) {
                    ss << "\tt ##0 " + ConditionVisitorSVA::toString(commitment) + " and\n";
                }

                //Notify&Sync Signals, no notification for shareds
                std::set<Port*> usedPortsList;
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
                        ss << "\tt ##0 " + port.first << "_notify() == 1 and\n";
                    } else ss << "\tt ##0 " + port.first << "_notify() == 0 and\n";
                }

                ss.seekp(-5, std::ios_base::end);//remove last " and\n"
                ss << ";\n";//and replace it with ";"
                ss << "endproperty\n";
                ss << "reset_a: assert property (reset_p);\n\n";
                break;
            }
        }
    }
    return ss.str();
}

std::string PrintSVA::operations() {
    std::stringstream ss;
    int opCnt = 0;
    int ChunkOpCnt = 0;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {
            ChunkOpCnt++;
            if (ChunkOpCnt > 1000) {
                pluginOutput.insert(std::make_pair(this->module->getName() + "_OPs_" + std::to_string(opCnt) + ".sva", ss.str()));
                ss.str("");
                ChunkOpCnt = 0;
            }
            if (operation->isWait()) continue;
            ss << "property ";
            ss << operation->getState()->getName();
            if (operation->getState()->isRead()) ss << "_read_";
            else if (operation->getState()->isWrite()) ss << "_write_";
            ss << opCnt << "_p(o);\n";

            //FREEZE VARS
            std::set<SCAM::SyncSignal *> syncSignals;
            std::set<SCAM::Variable *> variables;
            std::set<SCAM::DataSignal *> dataSignals;
            std::vector<std::string> freezeVars;
            std::vector<std::string> freezeVarsTypes;
            for (auto assignment : operation->getCommitmentList()) {
                //Find all objects that need to be freezed
                auto newSyncSignals = ExprVisitor::getUsedSynchSignals(assignment->getRhs());
                syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
                auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                variables.insert(newVariables.begin(), newVariables.end());
                auto newDataSignals = ExprVisitor::getUsedDataSignals(assignment->getRhs());
                dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
            }
            for (auto sync :syncSignals) {
                freezeVarsTypes.emplace_back("");//this type is boolean and not necessery to show
                freezeVars.push_back(sync->getPort()->getName() + "_sync");
            }
            for (auto var : variables) {
                auto varOp = VariableOperand(var);
                freezeVarsTypes.push_back(var->getDataType()->getName());
                if (varOp.getVariable()->isSubVar()) {
                    freezeVars.push_back(
                            varOp.getVariable()->getParent()->getName() + "_" + varOp.getVariable()->getName());
                } else {
                    freezeVars.push_back(varOp.getVariable()->getName());
                }
            }
            for (auto dataSig : dataSignals) {
                auto dataOp = DataSignalOperand(dataSig);
                freezeVarsTypes.push_back(dataSig->getDataType()->getName());
                if (dataOp.getDataSignal()->isSubSig()) {
                    freezeVars.push_back(
                            dataOp.getDataSignal()->getParent()->getName() + "_" +
                            dataOp.getDataSignal()->getName());
                } else {
                    freezeVars.push_back(dataOp.getDataSignal()->getName());
                }
            }
            for (int i = 0; i < freezeVars.size(); i++) {
                ss << freezeVarsTypes.at(i) << " " << freezeVars.at(i) << "_0;\n";
            }
            if (!freezeVars.empty()) ss << "// hold\n";
            ///// t ##0 hold(var_0, var()) and
            for (const auto &freezeVar : freezeVars) {
                ss << "\tt ##0 hold(" + freezeVar << "_0, " << freezeVar << "()) and\n";
            }

            //CONCEPTUAL STATE & TRIGGERS
            ss << "// Conceptual State\n";
            ss << "\tt ##0 " + operation->getState()->getName() << "() and\n";
            ss << "// trigger\n";
            for (auto assumption: operation->getAssumptionList()) {
                ss << "\tt ##0 " + ConditionVisitorSVA::toString(assumption) << " and\n";
            }
            ss.seekp(-5, std::ios_base::end);//remove last " and\n"
            ss << "\n";

            //IMPLICATIONS
            std::set<Port*> usedPortsList;
            ss << "implies\n";
            //Nextstate
            ss << "\tt_end(o) ##0 " << operation->getNextState()->getName() << "() and\n";
            //Translate all dataPath assignments into strings,
            // for the datapath all variable and signals are replaced with their value@t
            for (auto commitment: operation->getCommitmentList()) {
                ss << "\tt_end(o) ##0 " << ConditionVisitorSVA::toString(commitment->getLhs());
                ss << " == ";
                ss << DatapathVisitorSVA::toString(commitment->getRhs()) << " and\n";
                //Add all output port that are used within this operation
                auto usedPorts = ExprVisitor::getUsedPorts(commitment->getLhs());
                for (auto port: ExprVisitor::getUsedPorts(commitment->getLhs())) {
                    if (port->getInterface()->isOutput()) {
                        usedPortsList.insert(port);
                    }
                }
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

            //Notify&Sync Signals, no notification for shared, alwaysReady in ...
            for (auto port: module->getPorts()) {
                auto interface = port.second->getInterface();
                if (interface->isShared()) continue;
                if (interface->isSlaveIn()) continue;
                if (interface->isSlaveOut()) continue;
                if (interface->isMasterIn()) continue;

                if (module->isSlave()) {
                    if (usedPortsList.find(port.second) != usedPortsList.end()) {
                        ss << "\tt ##1 " + port.first + "_notify() == 1 and\n";
                    } else ss << "\tt ##1 " + port.first + "_notify() == 0 and\n";
                } else {
                    if (port.second == operation->getNextState()->getCommPort()) {
                        ss << "\tduring_o (t, 1, t_end(o) , -1, " + port.first + "_notify() == 0) and\n";
                        ss << "\tt_end(o) ##0 " + port.first + "_notify() == 1 and\n";
                    } else if (usedPortsList.find(port.second) != usedPortsList.end()) {
                        ss << "\tduring_o (t, 1, t_end(o), -1, " + port.first + "_notify() == 0) and\n";
                        ss << "\tt_end(o) ##0 " + port.first + "_notify() == 1 and\n";
                    } else ss << "\tduring (next(t,1), t_end(o), " + port.first + "_notify() == 0) and\n";
                }
            }

            ss.seekp(-5, std::ios_base::end);//remove last " and\n"
            ss << ";\n";//and replace it with ";"
            ss << "endproperty;\n";

            //PROPERTY ASSERTION
            ///// S_read_#_a: assert property (disable iff (reset) S_read_#_p(1));
            ss << operation->getState()->getName();
            if (operation->getState()->isRead()) ss << "_read_";
            else if (operation->getState()->isWrite()) ss << "_write_";
            ss << opCnt << "_a: assert property (disable iff (reset) "
               << operation->getState()->getName();
            if (operation->getState()->isRead()) ss << "_read_";
            else if (operation->getState()->isWrite()) ss << "_write_";
            ss << opCnt << "_p(1));// ASSIGN t_end offset here\n\n";

            opCnt++;
        }
    }
    return ss.str();
}

std::string PrintSVA::wait_operations() {
    std::stringstream ss;
    for (auto state: this->stateMap) {
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (!operation->isWait()) continue;
            ss << "\n";
            ss << "property ";
            ss << "wait_";
            ss << operation->getState()->getName();
            ss << "_p;\n";

            //FREEZE VARS
            std::set<SCAM::SyncSignal *> syncSignals;
            std::set<SCAM::Variable *> variables;
            std::set<SCAM::DataSignal *> dataSignals;
            std::vector<std::string> freezeVars;
            std::vector<std::string> freezeVarsTypes;
            for (auto assignment : operation->getCommitmentList()) {
                //Find all objects that need to be freezed
                auto newSyncSignals = ExprVisitor::getUsedSynchSignals(assignment->getRhs());
                syncSignals.insert(newSyncSignals.begin(), newSyncSignals.end());
                auto newVariables = ExprVisitor::getUsedVariables(assignment->getRhs());
                variables.insert(newVariables.begin(), newVariables.end());
                auto newDataSignals = ExprVisitor::getUsedDataSignals(assignment->getRhs());
                dataSignals.insert(newDataSignals.begin(), newDataSignals.end());
            }
            for (auto sync :syncSignals) {
                freezeVarsTypes.emplace_back("");//this type is boolean and not necessery to show
                freezeVars.push_back(sync->getPort()->getName() + "_sync");
            }
            for (auto var : variables) {
                auto varOp = VariableOperand(var);
                freezeVarsTypes.push_back(var->getDataType()->getName());
                if (varOp.getVariable()->isSubVar()) {
                    freezeVars.push_back(
                            varOp.getVariable()->getParent()->getName() + "_" + varOp.getVariable()->getName());
                } else {
                    freezeVars.push_back(varOp.getVariable()->getName());
                }
            }
            for (auto dataSig : dataSignals) {
                auto dataOp = DataSignalOperand(dataSig);
                freezeVarsTypes.push_back(dataSig->getDataType()->getName());
                if (dataOp.getDataSignal()->isSubSig()) {
                    freezeVars.push_back(dataOp.getDataSignal()->getParent()->getName() + "_" +
                                         dataOp.getDataSignal()->getName());
                } else {
                    freezeVars.push_back(dataOp.getDataSignal()->getName());
                }
            }

            for (int i = 0; i < freezeVars.size(); i++) {
                ss << freezeVarsTypes.at(i) << " " << freezeVars.at(i) << "_0;\n";
            }
            if (!freezeVars.empty()) ss << "// hold\n";
            ///// t ##0 hold(var_0, var()) and
            for (const auto &freezeVar : freezeVars) {
                ss << "\tt ##0 hold(" + freezeVar << "_0, " << freezeVar << "()) and\n";
            }

            //CONCEPTUAL STATE & TRIGGERS
            ss << "// Conceptual State\n";
            ss << "\tt ##0 " + operation->getState()->getName() << "() and\n";
            ss << "// trigger\n";
            for (auto assumption: operation->getAssumptionList()) {
                ss << "\tt ##0 " + ConditionVisitorSVA::toString(assumption) << " and\n";
            }
            ss.seekp(-5, std::ios_base::end);//remove last " and\n"
            ss << "\n";

            //IMPLICATIONS
            ss << "implies\n";
            //Nextstate
            ss << "\tt ##1 " << operation->getNextState()->getName() << "() and\n";
            //Translate all dataPath assignments into strings,
            // for the datapath all variable and signals are replaced with their value@t
            for (auto commitment: operation->getCommitmentList()) {
                ss << "\tt ##1 " << ConditionVisitorSVA::toString(commitment->getLhs());
                ss << " == ";
                ss << DatapathVisitorSVA::toString(commitment->getRhs()) << " and\n";
            }

            //Notify&Sync Signals, no notification for shareds
            for (auto port: module->getPorts()) {
                Interface *pI = port.second->getInterface();
                if (pI->isMasterIn()) continue;
                if (pI->isShared()) continue;
                if ((pI->isBlocking() || pI->isMasterOut()) &&
                    port.second != operation->getNextState()->getCommPort())
                    ss << "\tt ##1 " + port.first << "_notify() == 0 and\n";
                else
                    ss << "\tt ##1 " + operation->getNextState()->getCommPort()->getName()
                       << "_notify() == 1 and\n";
            }

            ss.seekp(-5, std::ios_base::end);//remove last " and\n"
            ss << ";\n";//and replace it with ";"
            ss << "endproperty;\n";

            //PROPERTY ASSERTION
            ///// wait_state_a: assert property (disable iff (reset) wait_state_p);
            ss << "wait_" << operation->getState()->getName()
               << "_a: assert property (disable iff (reset) wait_"
               << operation->getState()->getName()
               << "_p);\n\n";
        }
    }
    return ss.str();
}
