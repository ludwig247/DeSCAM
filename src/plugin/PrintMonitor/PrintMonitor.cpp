//
// Created by tobias on 15.03.18.
//

#include "../../optimizePPA/OptimizeSlave.h"
#include "../../optimizePPA/OptimizeMaster.h"
#include "../../optimizePPA/OptimizeOperations.h"
#include "PrintMonitor.h"
#include "Synthesize/VHDLPrintVisitor.h"

SCAM::PrintMonitor::PrintMonitor(SCAM::Module * module):
        module(module) {
    opcnt = 0;
    //Use the optimized version of the statemap
    optimize();
    for(auto state: stateMap){
        csm_states.push_back(state.second->getName());
        auto ops = state.second->getOutgoingOperationList();
        opcnt+= ops.size();
        operations.insert(operations.end(),ops.begin(),ops.end());
    }
}

SCAM::PrintMonitor::~PrintMonitor() {

}

std::string SCAM::PrintMonitor::print() {
    this->ss << monitor_pkg(module) << std::endl;
    this->ss << monitor() << std::endl;;
    return ss.str();
}

std::string SCAM::PrintMonitor::monitor() {
    std::stringstream monitor;
    monitor << "library ieee ;\n";
    monitor << "use ieee.std_logic_1164.all;\n";
    monitor << "use ieee.numeric_std.ALL;\n";
    monitor << "use work.monitor_pkg.ALL;\n";
    monitor << "use work.SCAM_Model_types.all;\n\n";

    monitor << "entity monitor is\n";
    monitor << "\tport(\n";
    monitor << "\t\tclk,rst: IN std_ulogic;\n";
    for (auto port:  module->getPorts()) {
        monitor << "\t\t" <<  port.second->getName() <<"_sync" << ": " << " in bool;\n";
        monitor << "\t\t" <<  port.second->getName() << "_sig "<< ": " << " in " <<  port.second->getDataType()->getName() << ";\n";
    }
    std::set<Variable*> var_set;
    for (auto var: stateVarMap) {
        bool is_new = false;
        Variable * new_var;
        if(var.second->isSubVar()){
            is_new = var_set.insert(var.second->getParent()).second;
            new_var = var.second->getParent();
        } else{
            is_new = var_set.insert(var.second).second;
            new_var = var.second;
        }
        if(is_new)  monitor << "\t\t" <<  new_var->getName()  << ": in " <<  new_var->getDataType()->getName() << ";\n";
    }
    monitor << "\t\top_property   : out PROPERTY_T\n";
    monitor << ");\n";
    monitor << "end entity;\n\n";
    monitor << "architecture FSM of monitor is\n\n";
    monitor << "signal pre_op_property : PROPERTY_T;\n";
    monitor << "signal op_property_s: property_t;\n";
    monitor << "begin\n";
    monitor << "\top_property <= op_property_s;\n";
    monitor << "\n\tprocess(clk,rst)\n";
    monitor << "\tbegin\n";
    monitor << "\t\tif(rst='1') then\n";
    monitor << "\t\t\tpre_op_property<= op_"<< (*stateMap.at(-1)->getOutgoingOperationList().begin())->getOp_id() << ";\n";

    monitor << "\t\telsif (clk='1' and clk'event) then\n";
    monitor << "\t\t\tpre_op_property <= op_property_s;\n";
    monitor << "\t\tend if;\n";
    monitor << "\tend process;\n";

    monitor << "\n\tprocess(rst,pre_op_property,";
    for (auto it = stateVarMap.begin(); it != stateVarMap.end(); ++it) {
        auto var = (*it).second;
        monitor << var->getFullName();
        if(it != --stateVarMap.end()) monitor << ",";
    }
    monitor << ")\n";
    monitor << "\tbegin\n";
    monitor << "\t\tif (rst = '1') then\n";
    monitor << "\t\t\top_property_s <= op_" << (*stateMap.at(-1)->getOutgoingOperationList().begin())->getOp_id() << ";\n";
    monitor << "\t\telse\n";
    monitor << "\t\t\tcase ending_state(pre_op_property) is\n";
    for(auto state: stateMap){
        if(state.second->isInit()) continue;
        monitor << "\t\t\twhen "<< state.second->getName()  <<"=>\n";
        auto op_list = state.second->getOutgoingOperationList();
        for (auto op_it = op_list.begin();
             op_it != op_list.end(); ++op_it) {
            if(op_it == op_list.begin()){
                monitor << "\t\t\t\tif(" << printAssumptions((*op_it)->getAssumptionList()) << ") then \n";
            }
            else{
                monitor << "\t\t\t\telsif(" << printAssumptions((*op_it)->getAssumptionList()) << ") then \n";
            }
            monitor  << "\t\t\t\t\top_property_s <=op_" << (*op_it)->getOp_id() << ";\n";

        }
        monitor  << "\t\t\t\tend if;\n";
    }
    monitor << "\t\t\twhen others=> op_property_s <= op_" << (*stateMap.at(-1)->getOutgoingOperationList().begin())->getOp_id() << ";\n";
    monitor << "\t\tend case;\n";
    monitor << "\t\tend if;\n";
    monitor << "\tend process;\n";
    monitor << "end architecture;\n";

    return monitor.str();
}


std::string SCAM::PrintMonitor::monitor_pkg(SCAM::Module *module) {

    std::stringstream package_head;
    package_head << "library ieee ;\n";
    package_head << "use ieee.std_logic_1164.all;\n";


    package_head << "package monitor_pkg is\n";
    package_head << "\ttype PROPERTY_T is (";
    for (auto iterator = operations.begin(); iterator != operations.end(); ++iterator) {
        package_head << "op_"<<(*iterator)->getOp_id();
        if(iterator != operations.end()-1) package_head << ",";
        else package_head << ");\n";
    }
    package_head << "\ttype CSM_STATE is (";
    for (auto iterator = csm_states.begin(); iterator != csm_states.end(); ++iterator) {
        package_head << (*iterator);
        if(iterator != csm_states.end()-1) package_head << ",";
        else package_head << ");\n";
    }
    package_head << "\tfunction ending_state (op : PROPERTY_T) return CSM_STATE;\n";

    package_head << "end monitor_pkg;\n\n";

    std::stringstream package_body;

    package_body << "package body monitor_pkg is\n";
    package_body << "\tfunction ending_state (op : PROPERTY_T) return CSM_STATE is\n";
    package_body << "\tbegin\n";
    package_body << "\t\tcase op is \n";
    for(auto op: operations){
        package_body << "\t\t\twhen " << "op_" << op->getOp_id() << "=> return " << op->getNextState()->getName() << ";\n";
    }
    package_body << "\t\tend case;\n";
    package_body << "\tend ending_state;\n";
    package_body << "end monitor_pkg;\n\n";

    return package_head.str()+package_body.str();

}

void SCAM::PrintMonitor::optimize() {
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

}

std::string SCAM::PrintMonitor::printAssumptions(const std::vector<Expr *> &exprList) {
    std::stringstream assumptions;
    if(exprList.empty()) return "true";
    for (auto expr = exprList.begin(); expr != exprList.end(); ++expr) {
        assumptions << VHDLPrintVisitor::toString(*expr);
        if(expr != --exprList.end()) assumptions << " and ";
    }
    return assumptions.str();
}

