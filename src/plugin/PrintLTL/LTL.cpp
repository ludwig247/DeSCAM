//
// Created by anna on 06.07.18.
//

#include <sstream>
#include "LTL.h"
#include "../../optimizePPA/OptimizeMaster.h"
#include "../../optimizePPA/OptimizeSlave.h"
#include "../../optimizePPA/OptimizeOperations.h"
#include "PrintStmt.h"
#include "PrintStmtLTL.h"
#include "RHS_LTL.h"

SCAM::LTL::LTL(SCAM::Module *module) :
        module(module) {
    optimizeCommunicationFSM();
}

std::string SCAM::LTL::print() {
    std::stringstream result;
    result << reset_ltl() << wait_ltl() << run_ltl() << helper_ltl();
    return result.str();
}

std::string SCAM::LTL::reset_ltl() {
    std::stringstream ss;

    ss << "ltl reset_sequence {reset && [](reset → ((reset && !notify) U (!reset && notify && ";
    ss << this->stateMap.find(-1)->second->getOutgoingOperationList()[0]->getNextState()->getName();
    for(auto& commitments: this->stateMap.find(-1)->second->getOutgoingOperationList()[0]->getCommitmentList()){
        ss << " && (" << PrintStmtLTL::toString(commitments->getLhs()) << " == " << PrintStmtLTL::toString(commitments->getRhs()) << ")";
    }
    ss << ")))}" << "\n";

    return ss.str();
}

std::string SCAM::LTL::wait_ltl(){
    std::stringstream ss;

    for(auto& state: this->stateMap) {
        std::string state_name = state.second->getName();
        if (state.second->isInit()) continue;
        ss << "ltl wait_" << state_name;
        ss << " {[]((" << state_name << " && notify) -> ((" << state_name << " && notify";

        //visible_registers are not changed
        for(auto stateVar: this->stateVarMap ){
            VariableOperand varOp(stateVar.second);
            ss << " && (" << PrintStmtLTL::toString(&varOp) << " == " << PrintStmtLTL::toString(&varOp) << "_at_notify)";
        }

        //shared_values are not changed
        for (auto port: module->getPorts()) {
            if(port.second->getInterface()->isShared() && port.second->getInterface()->isOutput()) {
                if (port.second->getDataType()->isVoid()) continue;
                if (!port.second->getDataType()->isCompoundType()) {
                    ss << " && (" + port.first << "_sig" << " == " << port.first << "_sig_at_sync)";
                } else if (port.second->getDataType()->isCompoundType()) {
                    for (auto subVar: port.second->getDataType()->getSubVarMap()) {
                        ss << " && (" + port.first << "_sig_" << subVar.first << " == " << port.first << "_sig_" << subVar.first << "_at_sync)";
                    }
                }
            }
        }

        ss << ") U (" << state_name << " && !notify)))}\n";
    }

    return  ss.str();
}

std::string SCAM::LTL::run_ltl(){
    std::stringstream ss;
    int opCnt = 0;

    for(auto& state: this->stateMap) {
        std::string state_name = state.second->getName();
        if (state.second->isInit()) continue;
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (operation->isWait()) continue;

            ss << "ltl " << state_name;
            if (operation->getState()->isRead()) ss << "_read_";
            else if (operation->getState()->isWrite()) ss << "_write_";
            ss << opCnt;
            opCnt++;
            ss << " {[]((" << state_name << " && !notify";

            for (auto assumption: operation->getAssumptionList()) {
                ss << " && " << PrintStmtLTL::toString(assumption);
            }

            ss << ") -> ((" << state_name << " && !notify) || !notify) U (";
            ss << operation->getNextState()->getName() << " && notify";

            for (auto commitment: operation->getCommitmentList()) {
                ss << " && (" << PrintStmtLTL::toString(commitment->getLhs());
                ss << " == ";
                ss << RHS_LTL::toString(commitment->getRhs()) << ")"; //TODO: falls state auch zu sich zurückführt-> nehme Werte zu sync
            }

            ss << "))}\n";
        }
        opCnt = 0;
    }

    return  ss.str();
}

std::string SCAM::LTL::helper_ltl(){
    std::stringstream ss;

    for(auto& state: this->stateMap) {
        std::string state_name = state.second->getName();
        if (state.second->isInit()) continue;

        ss << "ltl helper_" << state_name;
        ss << " {[]((!notify && " << state_name << ") -> ((!notify && " << state_name << ") U (notify && (";

        bool first = true;
        for(auto& nextstate: this->module->getFSM()->getStateMap()) {
            if (nextstate.second->isInit()) continue;
            if(first) {
                ss << nextstate.second->getName();
                first = false;
            }
            else ss << " || " << nextstate.second->getName();
        }

        ss << "))))}\n";

    }

    return  ss.str();
}

void SCAM::LTL::optimizeCommunicationFSM() {
    std::cout << "State-map(unoptimized):" << this->getOpCnt(this->module->getFSM()->getStateMap()) << " operations created" << std::endl;

    std::map<SCAM::Operation *, SCAM::Path *> operation_path_map = this->module->getFSM()->getOperationPathMap();
    OptimizeMaster optimizeMaster(this->module->getFSM()->getStateMap(), this->module, operation_path_map);

//    std::cout << "----------------------- MASTER -------------------" << std::endl;
//    for(auto state: optimizeMaster.getNewStateMap()){
//        std::cout << state.second->printOutgoingOperations() << std::endl;
//    }
//    std::cout << "----------------------- MASTER END -------------------" << std::endl;

    OptimizeSlave optzimizeSlave(optimizeMaster.getNewStateMap(), this->module, optimizeMaster.getOperationPathMap());
//    std::cout << "----------------------- SLAVE -------------------" << std::endl;
//    for(auto state: optzimizeSlave.getNewStateMap()){
//        std::cout <<  state.second->printOutgoingOperations() << std::endl;
//    }
//    std::cout << "----------------------- SLAVE END -------------------" << std::endl;

    OptimizeOperations optimizeOperations(optzimizeSlave.getNewStateMap(), this->module);

    this->stateMap = optimizeOperations.getNewStateMap();
    this->stateVarMap = optimizeOperations.getStateVarMap();
    std::cout << "State-map(optimized):" << this->getOpCnt(this->stateMap) << " operations created" << std::endl;
    std::cout << "----------------------" << std::endl;
}

int SCAM::LTL::getOpCnt(std::map<int, State *> stateMap) {
    int op_cnt = 0;
    for (auto state: stateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            op_cnt++;
        }
    }
    return op_cnt;
}