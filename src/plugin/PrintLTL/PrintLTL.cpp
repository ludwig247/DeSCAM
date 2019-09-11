//
// Created by anna on 27.06.18.
//

#include <sstream>
#include "PrintLTL.h"
#include "../../optimizePPA/OptimizeMaster.h"
#include "../../optimizePPA/OptimizeSlave.h"
#include "../../optimizePPA/OptimizeOperations.h"
#include "PrintStmt.h"
#include "PrintStmtLTL.h"

SCAM::PrintLTL::PrintLTL(SCAM::Model *model) :
        model(model),
        topInstance(model->getTopInstance()) {
    assert(model->getTopInstance() != nullptr);
    this->model->accept(*this);
}

std::string SCAM::PrintLTL::print() {
    return this->ss.str();
}

std::string SCAM::PrintLTL::createCommStmt(SCAM::State *state){
    std::stringstream ss;
    auto comm = state->getCommStmt();

    if ((comm->isBlocking() && !comm->isNonBlockingAccess()) || comm->isMaster()) {
        for(auto channel: model->getTopInstance()->getChannelMap()) {
            //Blocking_Write
            if (channel.second->getFromPort() == comm->getPort()) {
                //if(channel.second->getName().back() == currentInstance->getName().back()) { //TODO:Zugriff auf entsprechenden Kanal möglich, falls unterschiedliche Ports
                        ss << "\t\t\tatomic{\n";
                        ss << "\t\t\t" << channel.second->getName() << "!(" << PrintStmtLTL::toString(state->getWriteValue()) << ",true);" << state->getCommPort()->getName() << "_sync = true;\n";
                        ss << "\t\t\t" << channel.second->getName() << "!(" << PrintStmtLTL::toString(state->getWriteValue()) << ",false);" << state->getCommPort()->getName() << "_sync = true;\n";
                        ss << "\t\t\t};";
                //}
            }
            //Blocking_Read
            if (channel.second->getToPort() == comm->getPort()) {
                //if(channel.second->getName().back() == currentInstance->getName().back()) {
                    ss << "\t\t\tatomic{\n";
                    ss << "\t\t\t" << channel.second->getName() << "?(" << state->getCommPort()->getDataSignal()->getName() << ",dummy);\n";
                    ss << "\t\t\tif\n\t\t\t\t:: dummy == true ->\n";
                    ss << "\t\t\t\t\t" << channel.second->getName() << "?(" << state->getCommPort()->getDataSignal()->getName() << ",dummy);\n";
                    ss << "\t\t\t\t:: else -> skip\n\t\t\tfi;\n";
                    ss << "\t\t\t};";
                //}
            }
        }
    }

    if((comm->isBlocking() && comm->isNonBlockingAccess()) || comm->isSlave()){
        for(auto channel: model->getTopInstance()->getChannelMap()) {
            //NB_Write
            if (channel.second->getFromPort() == comm->getPort()) {
                //if(channel.second->getName().back() == currentInstance->getName().back()) {
                //overwriting old values
                    if(comm->isSlave()){
                        ss << "\t\t\td_step{\n\t\t\tdo\n\t\t\t\t:: " << channel.second->getName() << "?_\n";
                        ss << "\t\t\t\t:: empty( " << channel.second->getName() << ") -> break\n\t\t\tod;\n\t\t\tskip\n\t\t\t};";
                        ss << "\t\t\t" << channel.second->getName() << "!(" << PrintStmtLTL::toString(state->getWriteValue()) << ",false);\n";
                    }
                    else {
                        ss << "\t\t\t" << channel.second->getName() << "!(" << PrintStmtLTL::toString(state->getWriteValue()) << ",false);\n";
                        ss << "\t\t\t};\n\t\t\td_step{\n\t\t\tdo\n\t\t\t\t:: " << channel.second->getName() << "?_; " << state->getCommPort()->getName() << "_sync = true;\n";
                        ss << "\t\t\t\t:: empty( " << channel.second->getName() << ") -> " << state->getCommPort()->getName() << "_sync = false; break\n\t\t\tod;\n\t\t\tskip\n\t\t\t};";
                    }
                //}
            }
            //NB_Read
            if (channel.second->getToPort() == comm->getPort()) {
                //if(channel.second->getName().back() == currentInstance->getName().back()) {
                    ss << "\t\t\tatomic{\n";
                    ss << "\t\t\t\td_step{\n\t\t\t\tdo\n\t\t\t\t\t:: " << channel.second->getName() << "?(" << state->getCommPort()->getDataSignal()->getName() << ",dummy);\n";
                    ss << "\t\t\t\t\t:: empty(" << channel.second->getName() << ") -> " << state->getCommPort()->getName() << "_sync = false; " << "break\n\t\t\t\tod;\n\t\t\t\tskip\n\t\t\t\t};\n";
                    ss << "\t\t\tif\n\t\t\t\t:: dummy == true ->\n";
                    ss << "\t\t\t\t\t" << channel.second->getName() << "?(" << state->getCommPort()->getDataSignal()->getName() << ",dummy);\n";
                    ss << "\t\t\t\t:: else -> skip\n\t\t\tfi;\n";
                    ss << "\t\t\t};";
                //}
            }
        }
    }

    return ss.str();
}

void SCAM::PrintLTL::visit(SCAM::Model &node) {

    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "//// Datatype definitions\n";
    this->ss << "///////////////////////////////////////////////\n";
    //ENUMS
    for (auto type: DataTypes::getDataTypeMap()) {
        if (type.second->isEnumType()) {
            //IF section enum -> not needed
            if (type.first.find("_SECTIONS") < type.first.size()) continue;
            this->ss << "//Enum Type: " << type.first << "\n";
            this->ss << "mtype:" << type.first << " {";
            bool first = true;
            for (auto enumVal: type.second->getEnumValueMap()) {
                if (first){
                    this->ss << enumVal.first;
                    first = false;
                }
                else this->ss << ", " << enumVal.first;
            }
            this->ss << "};\n";
        }
    }
    //COMPOUNDS
    for (auto type: DataTypes::getDataTypeMap()) {
        if (type.second->isCompoundType()) {
            this->ss << "//Compound Type: " << type.first << "\n";
            this->ss << "typedef " << type.first << "{\n";
            for (auto subtype: type.second->getSubVarMap()) {
                if(subtype.second->isEnumType()) {
                    this->ss << "\tmtype:" << subtype.second->getName() << " " << subtype.first << ";\n";
                }
                else {
                    this->ss << "\t" << subtype.second->getName() << " " << subtype.first << ";\n";
                }
            }
            this->ss << "};\n";
        }
    }

    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "//// Communication channels & global variables\n";
    this->ss << "///////////////////////////////////////////////\n";
    for (auto channel: node.getTopInstance()->getChannelMap()) {
        channel.second->accept(*this);
    }
    for (auto &&item : topInstance->getModuleInstances()) {
        item.second->accept(*this);
    }
}

void SCAM::PrintLTL::visit(SCAM::Module &node) {
    this->ss << "\n";
    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "//// Module:" << node.getName() << "\n";
    this->ss << "///////////////////////////////////////////////\n";

    for (auto state: node.getFSM()->getStateMap()) {
        if(state.second->isInit()) continue;
        this->ss << "#define " << node.getName() << "_" << state.second->getName() << " " << state.first << "\n";
    }
}

void SCAM::PrintLTL::visit(SCAM::ModuleInstance &node) {
    //Create everything that is globally used for each module
    node.getStructure()->accept(*this);
    currentInstance = &node;

    //Create specific instance
    Module *current_module = node.getStructure();
    //
    this->currentModule = node.getStructure();
    optimizeCommunicationFSM();
    //
    this->ss << "\n";
    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "//// Instance:" << node.getName() << " Module:" << current_module->getName() << "\n";
    this->ss << "///////////////////////////////////////////////\n";
    this->ss << "\nactive proctype " << node.getName() << "_" << current_module->getName() << "(){\n";

    this->ss << "int state = " << current_module->getName() << "_run_0;\n";

    this->ss << "bool dummy = false;\n";

    for (auto var: stateVarMap) {
    //for (auto var: current_module->getVariableMap()) {
        this->ss << var.second->getDataType()->getName() << " " << var.first << ";\n";
    }

    for (auto port: current_module->getPorts()) {
        if(!port.second->getInterface()->isShared()) {
            this->ss << port.second->getDataType()->getName() << " " << port.first << "_sig;\n";
        }
    }

    //sync only in case of nb_write needed
    //for(auto state : current_module->getFSM()->getStateMap()) {
    for(auto state : stateMap) {
        if(state.second->isInit()) continue;
        if (state.second->getCommStmt()->isBlocking() && state.second->getCommStmt()->isWrite() && state.second->getCommStmt()->isNonBlockingAccess()) {
            this->ss << state.second->getCommStmt()->getPort()->getDataType()->getName() << " " << state.second->getCommStmt()->getPort()->getName() << "_sync = true;\n";
        }
    }

    this->ss << " \tend: do\n";
    current_module->getFSM()->accept(*this);
    //currentModule->getFSM()->accept(*this);
    this->ss << "\tod;\n}\n ";
}

void SCAM::PrintLTL::visit(SCAM::Port &node) {

}

void SCAM::PrintLTL::visit(SCAM::Channel &node) {
    if (node.getFromPort()->getInterface()->isShared()) {
        this->ss << node.getFromPort()->getDataType()->getName() << " " << node.getName() << ";\n";
    } else {
        this->ss << "chan " << node.getName() << " = [1] of {" << node.getFromPort()->getDataType()->getName() << ", bool};\n";
    }
}

void SCAM::PrintLTL::visit(SCAM::Interface &node) {

}

void SCAM::PrintLTL::visit(SCAM::Variable &node) {
    this->ss << node.getDataType()->getName() << " " << node.getName() << "=";
    if (!node.isCompoundType()) {
        //FIXME: not sure why this is done but const_cast is BAD
        this->ss << PrintStmtLTL::toString(node.getInitialValue());
    }
    this->ss << ";\n";
}

void SCAM::PrintLTL::visit(SCAM::FSM &node) {
    //for (auto &&state : node.getStateMap()) {
    for (auto state : stateMap) {
        if(state.second->isInit()) continue;
        this->ss << "\t\t:: state ==  " << node.getModule()->getName() << "_" << state.second->getName() << " ->\n";
        this->ss << "\t\t\t//Communication \n";
        this->ss << createCommStmt(state.second) << "\n";
        this->ss << "\t\t\t//Dpath operations \n";
        this->ss << "\t\t\td_step{\n";
        this->ss << "\t\t\tif \n  ";
        for (auto operation: state.second->getOutgoingOperationList()) {
            if (operation->isWait()) continue;
            this->ss << "\t\t\t:: ";
            bool first  = true;
            for (auto assumption: operation->getAssumptionList()) {
                if(first){
                    this->ss << PrintStmtLTL::toString(assumption);
                    //assumption->accept(*this);
                    first = false;
                }
                else{
                    this->ss << " && " << PrintStmtLTL::toString(assumption);
                    //this->ss << " && ";
                    //assumption->accept(*this);
                }
            }
            this->ss << " -> \n";
            if (operation->getAssumptionList().empty()) this->ss << "true ->  \n";
            for (auto commitment: operation->getCommitmentList()) {
                if(PrintStmtLTL::toString(commitment->getLhs()) != PrintStmtLTL::toString(commitment->getRhs())) {
                    this->ss << "\t\t\t\t" << PrintStmtLTL::toString(commitment) << ";" << std::endl;
                    //this->ss << "\t\t\t\t";
                    //commitment->accept(*this);
                    //this->ss << ";" << std::endl;
                }
            }
            this->ss << "\t\t\t\tstate = " << node.getModule()->getName() << "_" << operation->getNextState()->getSection() << "_" << operation->getNextState()->getStateId() << ";\n";
        }
        this->ss << "\t\t\tfi;\n";
        this->ss << "\t\t\t};\n";
    }
}

void SCAM::PrintLTL::visit(SCAM::DataType &node) {

}

void SCAM::PrintLTL::visit(SCAM::DataSignal &node) {

}

void SCAM::PrintLTL::optimizeCommunicationFSM() {
    std::cout << "State-map(unoptimized):" << this->getOpCnt(this->currentModule->getFSM()->getStateMap()) << " operations created" << std::endl;

    std::map<SCAM::Operation *, SCAM::Path *> operation_path_map = this->currentModule->getFSM()->getOperationPathMap();
    OptimizeMaster optimizeMaster(this->currentModule->getFSM()->getStateMap(), this->currentModule, operation_path_map);

//    std::cout << "----------------------- MASTER -------------------" << std::endl;
//    for(auto state: optimizeMaster.getNewStateMap()){
//        std::cout << state.second->printOutgoingOperations() << std::endl;
//    }
//    std::cout << "----------------------- MASTER END -------------------" << std::endl;

    OptimizeSlave optzimizeSlave(optimizeMaster.getNewStateMap(), this->currentModule, optimizeMaster.getOperationPathMap());
//    std::cout << "----------------------- SLAVE -------------------" << std::endl;
//    for(auto state: optzimizeSlave.getNewStateMap()){
//        std::cout <<  state.second->printOutgoingOperations() << std::endl;
//    }
//    std::cout << "----------------------- SLAVE END -------------------" << std::endl;

    OptimizeOperations optimizeOperations(optzimizeSlave.getNewStateMap(), this->currentModule);

    this->stateMap = optimizeOperations.getNewStateMap();
    this->stateVarMap = optimizeOperations.getStateVarMap();
    std::cout << "State-map(optimized):" << this->getOpCnt(this->stateMap) << " operations created" << std::endl;
    std::cout << "----------------------" << std::endl;
}

int SCAM::PrintLTL::getOpCnt(std::map<int, State *> stateMap) {
    int op_cnt = 0;
    for (auto state: stateMap) {
        for (auto op: state.second->getOutgoingOperationList()) {
            op_cnt++;
        }
    }
    return op_cnt;
}

void SCAM::PrintLTL::visit(SCAM::Function &node) {
    throw std::runtime_error("Not implemented");
}

void SCAM::PrintLTL::visit(SCAM::Parameter &node) {
    throw std::runtime_error("Not implemented");
}
