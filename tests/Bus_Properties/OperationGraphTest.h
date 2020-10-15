//
// Created by wezel on 23.04.20.
//

#ifndef DESCAM_OPERATION_GRAPH_H
#define DESCAM_OPERATION_GRAPH_H


#include <gtest/gtest.h>
#include <Stmts_all.h>
#include <PrintStmt.h>
#include <ModelGlobal.h>
#include <PrintITL/PrintITL.h>
#include <ReconstructOperations.h>
#include <ExprVisitor.h>
#include <PropertyFactory.h>
#include <ValidOperations.h>
#include <z3++.h>
#include <ExprTranslator.h>
#include <chrono>
#include <OperationOptimizations/ConditionOptimizer2.h>


#include "gmock/gmock.h"
#include "Model.h"

using namespace SCAM;

class OperationGraphTest: public ::testing::Test{
public:
    OperationGraphTest():module(new SCAM::Module("Bus")){
    }

    struct pathIDStmt{
        std::vector<int> idList;
        std::vector<SCAM::Stmt*> stmtList;
    };

    struct eventID{
        int id;
        std::string eventname;
    };

    SCAM::Module *module;

    std::map<int, CfgNode *> controlFlowMapAccessBus0;
    std::map<int, CfgNode *> controlFlowMapAccessBus1;
    std::map<int, CfgNode *> controlFlowMapSlaveRead0;
    std::map<int, CfgNode *> controlFlowMapSlaveRead1;
    std::map<int, CfgNode *> controlFlowMapSlaveWrite0;
    std::map<int, CfgNode *> controlFlowMapSlaveWrite1;
    std::map<int, CfgNode *> controlFlowMapDummy;
    std::map<int, CfgNode *> controlFlowMap;

    std::vector<std::vector<SCAM::Stmt*>> pathsAccessBus0;
    std::vector<std::vector<int>> pathsAccessBus0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsAccessBus1;
    std::vector<std::vector<int>> pathsAccessBus1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveRead0;
    std::vector<std::vector<int>> pathsSlaveRead0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveRead1;
    std::vector<std::vector<int>> pathsSlaveRead1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveWrite0;
    std::vector<std::vector<int>> pathsSlaveWrite0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveWrite1;
    std::vector<std::vector<int>> pathsSlaveWrite1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsDummy;
    std::vector<std::vector<int>> pathsDummyIDs;

    std::vector<eventID> startnodes;
    std::vector<eventID> endnodes;

    Operation *reset_op;
    std::vector<pathIDStmt> allPaths;
    std::vector<pathIDStmt> finalPaths;
    std::vector<pathIDStmt> finalPathsOpt;
    std::vector<Operation*> operationsFinalOpt;
    State* start_state;
    State* init;
    std::vector<std::vector<eventID>>permutations;
    std::vector<std::string> portnames;


    int merge_count;
    int unreachable_count;


    std::string printCFG(std::map<int,CfgNode*> controlFlowMap) {
        //Print CFG for debugging
        std::stringstream ss;
        for (auto node: controlFlowMap) {
            CfgNode *sus = node.second;

            ss << "[ID" << node.first << "] [Node" << sus->getName() << "]" << "\n";
            ss << "\tStmnt: " << "\n";


            auto stmt = sus->getStmt();
            ss << "\t\t" << PrintStmt::toString(stmt) << "\n";

            ss << "\tPred: ";
            for (auto pred: sus->getPredecessorList()) {
                ss << "[ID" << pred->getId() << "], ";
            }
            ss << "\n";;
            ss << "\tSucc: ";
            for (auto succ: sus->getSuccessorList()) {
                ss << "[ID" << succ->getId() << "], ";
            }
            ss << "\n";
        }
        return ss.str();
    }
    void findImportantStates(std::map<int,CfgNode*> controlFlowMap, std::map<int,CfgNode*>* importantStateMap) {
        //Iterate over all CfgNodes and find wait and return statements
        for (auto node : controlFlowMap) {
            //Nodes with a wait statement
            if (NodePeekVisitor::nodePeekWait(node.second->getStmt())) {
                importantStateMap->insert(node);
            }
            //Nodes with a return statement
            if (NodePeekVisitor::nodePeekReturn(node.second->getStmt())) {
                importantStateMap->insert(node);
            }
        }
        return;
    }
    void findPathsfromNode(CfgNode* startnode, std::vector<std::vector<SCAM::Stmt*>> *pathsFromStart, std::vector<std::vector<int>> *pathsAsIDs){
        //Recursively compute all successors starting from startnode
        //Push _back id of CfgNode to currentPath with each function call
        static std::vector<SCAM::Stmt*> currentPath;
        static std::vector<int> nodeIDPath;
        currentPath.push_back(startnode->getStmt());
        nodeIDPath.push_back(startnode->getId());
        //check if node has at least one successor and node is no wait or return
        if (startnode->getSuccessorList().size() >= 1 && (!NodePeekVisitor::nodePeekWait(startnode->getStmt()) && !NodePeekVisitor::nodePeekReturn(startnode->getStmt()) || currentPath.size() == 1)){
            //true successor
            findPathsfromNode(startnode->getSuccessorList().at(0),pathsFromStart,pathsAsIDs);
            //Node is an If statement
            if(startnode->getSuccessorList().size() > 1) {
                //false successor
                auto if_cond = (If *)currentPath.back();
                currentPath.back() = new If(new UnaryExpr("not", if_cond->getConditionStmt()));
                findPathsfromNode(startnode->getSuccessorList().at(1), pathsFromStart, pathsAsIDs);
            }
            //Pop_back id of CfgNode if you return from node
            currentPath.pop_back();
            nodeIDPath.pop_back();
            return;
        }
            //terminal node => creates a new path and adds it to pathsFromStart
        else{
            //only add paths with more than one node
            if(currentPath.size() > 1) {
                pathsFromStart->push_back(currentPath);
                pathsAsIDs->push_back(nodeIDPath);
            }
            //Pop_back id of CfgNode if you return from node
            currentPath.pop_back();
            nodeIDPath.pop_back();
            return;
        }
    }
    void combinePaths(std::vector<eventID> readyQueue, std::vector<eventID> blockedFunctions) {
        static pathIDStmt currentPath;
        bool equal_commits;

        //Try out all paths
        for(auto path: allPaths){
            //Check if there are still functions to run
            if(readyQueue.size() > 0) {
                int start = readyQueue.front().id;
                //if path starts with id start
                if(path.idList.front()==start){
                    //store context to restore it later for other possible paths
                    pathIDStmt savedPath = currentPath;
                    std::vector<eventID> savedReady = readyQueue;
                    std::vector<eventID> savedBlocked = blockedFunctions;

                    //add IDs and statements to current path
                    currentPath.idList.insert(currentPath.idList.end(),path.idList.begin(),path.idList.end());
                    currentPath.stmtList.insert(currentPath.stmtList.end(),path.stmtList.begin(),path.stmtList.end());

                    //check if resulting path is reachabble
                    auto test_op = new Operation();
                    test_op->setStatementsList(currentPath.stmtList);
                    auto rOperations = new ReconstructOperations(module);
                    rOperations->sortOperation(test_op);
                    if(!ValidOperations::isOperationReachable(test_op)){
                        unreachable_count++;
                        currentPath = savedPath;
                        readyQueue = savedReady;
                        blockedFunctions = savedBlocked;
                        continue;
                    }


                    //check if path stmts contain a notify
                    for(auto p:path.idList){
                        //if node is a notify statement
                        Notify* notify = NodePeekVisitor::nodePeekNotify(controlFlowMap.at(p)->getStmt());
                        if(notify){
                            int size = blockedFunctions.size();
                            for(int i=0; i < size;i++){
                                //check if function is existent in blockedFunctions
                                for(auto iter=blockedFunctions.begin(); iter!=blockedFunctions.end(); ++iter)
                                {
                                    std::string eventname = notify->getEventname();
                                    if(iter->eventname == eventname) {
                                        //add function to readyQueue
                                        readyQueue.push_back(*iter);
                                        //remove function from blockedFunctions
                                        blockedFunctions.erase(iter);
                                        break;
                                    }
                                }
                            }
                        }
                    }

                    //check if path ends with a wait
                    Wait* wait = NodePeekVisitor::nodePeekWait(controlFlowMap.at(path.idList.back())->getStmt());
                    if(wait)
                    {
                        std::string eventname = wait->getStateName();
                        //add function to blockedFunctions
                        eventID blocked = {path.idList.back(),eventname};
                        blockedFunctions.push_back(blocked);
                        //remove function from readyQueue
                        readyQueue.erase(readyQueue.begin());
                    }
                    //check if path ends with return
                    if(NodePeekVisitor::nodePeekReturn(controlFlowMap.at(path.idList.back())->getStmt()))
                    {
                        //remove function from readyQueue
                        readyQueue.erase(readyQueue.begin());
                    }

                    //Start Recursion
                    combinePaths(readyQueue,blockedFunctions);

                    //After reaching the end of a path:
                    //Restore Context to old value to be able to try next path
                    currentPath = savedPath;
                    readyQueue = savedReady;
                    blockedFunctions = savedBlocked;
                }
            }
            else {
                //End of path reached
                //Create Operation and compare commitments with all other commitments
                auto op = new Operation();
                if (currentPath.idList.size() > 0){
                    //Create new Operation
                    op->setState(start_state);
                    op->setNextState(start_state);
                    std::vector<SCAM::Stmt*> statementList;
                    for(auto stmt :currentPath.stmtList){
                        statementList.push_back(stmt);
                    }
                    op->setStatementsList(statementList);
                    auto rOperations = new ReconstructOperations(module);
                    rOperations->sortOperation(op);

                    //Add sync and notify
                    //Arrays that state if sync or notify needs to be added
                    bool addsync[startnodes.size()];
                    bool addnoti[startnodes.size()];

                    //Sync and Notify are unset by default
                    for(int j=0;j<startnodes.size();j++){
                        addsync[j] = false;
                        addnoti[j] = false;
                    }

                    for(auto id: currentPath.idList){
                        for(int j=0; j<startnodes.size();j++){
                            //If the startnode of a function is contained in the path, add the sync of that function
                            if(id==startnodes.at(j).id){
                                addsync[j]=true;
                            }
                            //If the endnode of a function is contained in the path, add the notify of that function
                            if(id==endnodes.at(j).id){
                                addnoti[j]=true;
                            }
                        }
                    }

                    for(int j=0; j<startnodes.size();j++){
                        //Add Sync and Notify to Assumptions/Commitments
                        auto sync = new SyncSignal(module->getPort(portnames.at(j)));
                        auto noti = new Notify(module->getPort(portnames.at(j)));
                        if(addsync[j]){
                            op->addAssumption(sync);
                        }
                        else{
                            op->addAssumption(new UnaryExpr("not",sync));
                        }
                        if(addnoti[j]){
                            auto assign = new Assignment(noti,new BoolValue(true));
                            op->addCommitment(assign);
                        }
                        else{
                            auto assign = new Assignment(noti,new BoolValue(false));
                            op->addCommitment(assign);
                        }
                    }

                    //Compare commitments
                    bool was_merged = false;
                    for(auto comp_op: operationsFinalOpt){
                        if(comp_op->getCommitmentsList().size()==op->getCommitmentsList().size()){
                            equal_commits = true;
                            for(int i=0; i< op->getCommitmentsList().size();i++){
                                if(!(*comp_op->getCommitmentsList().at(i)==*op->getCommitmentsList().at(i))){
                                    //if one pair of commitments is not equal: stop
                                    equal_commits = false;
                                    break;
                                }
                            }
                            //if all commitments are equal, merge the AssumptionLists of both operations
                            if(equal_commits){
                                //Merge
                                SCAM::Expr* combined_assump_list = new BoolValue(true);
                                auto assump_list = op->getAssumptionsList();
                                for(auto assump: assump_list){
                                    combined_assump_list = new Logical(combined_assump_list,"and",assump);
                                }
                                SCAM::Expr* combined_assump_list2 = new BoolValue(true);
                                auto comp_assump_list = comp_op->getAssumptionsList();
                                for(auto assump: comp_assump_list){
                                    combined_assump_list2 = new Logical(combined_assump_list2,"and",assump);
                                }
                                auto merged_assump_list = new Logical(combined_assump_list,"or",combined_assump_list2);
                                std::vector<SCAM::Expr *> merged_assump_vector;
                                merged_assump_vector.push_back(merged_assump_list);
                                ModelGlobal::setModel(new Model("test"));
                                ModelGlobal::getModel()->addModule(this->module);
                                auto opti = new ConditionOptimizer2(merged_assump_vector,this->module);
                                comp_op->setAssumptionsList(opti->getNewConditionList());
                                was_merged = true;
                                merge_count++;
                                break;
                            }
                        }
                    }
                    //If the operation wasn't merged it is a relevant new one, so store it
                    if(!was_merged){
                        //if operation is reachable add it to operationsFinalOpt
                        operationsFinalOpt.push_back(op);
                    }

                }
                return;
            }
        }
    }
    bool isUnreachable(const std::vector<SCAM::Expr *> &assumptionList) {
        z3::context context;
        z3::solver solver(context);
        ExprTranslator translator(&context);
        //Idea: check for satisfiability of assumptions_of_operation & assumption_of_ternary
        //If unsat -> always false
        //Translate each expression with the ExprtTranslator and add to solver
        for (auto condition: assumptionList) {
            solver.add(translator.translate(condition));
        }
        // Check for SAT if unsat -> erase path
        if ((solver.check() == z3::unsat)) {
            //expr->setTrivialFalse();
            return true;
        }
        return false;
    }
    void computePermutations(std::vector<eventID> functionVec){
        static std::vector<eventID> currentPerm;
        if(functionVec.size()>0){
            for(eventID func: functionVec){
                auto reduced_functions = functionVec;
                //only allow ordered permutations
                int compare_id = currentPerm.size()>0 ? currentPerm.back().id : -1;
                if(func.id> compare_id){
                    //if a new function can be added, push currentPerm to permutations
                    currentPerm.push_back(func);
                    permutations.push_back(currentPerm);
                    reduced_functions.erase(reduced_functions.begin());
                    computePermutations(reduced_functions);
                    currentPerm.pop_back();
                }
            }
        }
        return;
    }
    virtual void SetUp() {
        //create variables and datatypes
        auto states = new DataType("states");
        DataTypes::addDataType(states);
        states->addEnumValue("MASTER_REQ");
        states->addEnumValue("SLAVE_REQ");
        states->addEnumValue("SLAVE_RESP");
        states->addEnumValue("MASTER_RESP");
        auto state = new Variable("state", states);

        auto master_id = new Variable("master_id",DataTypes::getDataType("unsigned"));
        auto slave_id = new Variable("slave_id",DataTypes::getDataType("unsigned"));

        auto bus_req_t = new DataType("bus_req_t");
        DataTypes::addDataType(bus_req_t);
        bus_req_t->addSubVar("haddr",DataTypes::getDataType("unsigned"));
        bus_req_t->addSubVar("hwdata",DataTypes::getDataType("unsigned"));
        auto req = new Variable("req",bus_req_t);

        auto bus_resp_t = new DataType("bus_resp_t");
        DataTypes::addDataType(bus_resp_t);
        bus_resp_t->addSubVar("hrdata",DataTypes::getDataType("unsigned"));
        bus_resp_t->addSubVar("hresp",DataTypes::getDataType("unsigned"));
        auto resp = new Variable("resp", bus_resp_t);

        auto fromReset = new Variable("fromReset",DataTypes::getDataType("bool"));

        //Master write
        auto bus_req_master_0 = new Port("val_master_0",new Interface("blocking","in"), bus_req_t);
        auto bus_req_master_1 = new Port("val_master_1",new Interface("blocking","in"), bus_req_t);

        //Slave read
        auto bus_req_slave_0 = new Port("out_slave_0",new Interface("blocking","out"),bus_req_t);
        auto bus_req_slave_1 = new Port("out_slave_1",new Interface("blocking","out"),bus_req_t);

        //Slave write
        auto bus_resp_slave_0 = new Port("val_slave_0",new Interface("blocking","in"),bus_resp_t);
        auto bus_resp_slave_1 = new Port("val_slave_1",new Interface("blocking","in"),bus_resp_t);

        //Master read
        auto bus_resp_master_0 = new Port("out_master_0",new Interface("blocking","out"),bus_resp_t);
        auto bus_resp_master_1 = new Port("out_master_1",new Interface("blocking","out"),bus_resp_t);

        //add Variables to Module
        module->addVariable(state);
        module->addVariable(master_id);
        module->addVariable(slave_id);
        module->addVariable(req);
        module->addVariable(resp);
        module->addVariable(fromReset);
        module->addPort(bus_req_master_0);
        module->addPort(bus_req_master_1);
        module->addPort(bus_req_slave_0);
        module->addPort(bus_req_slave_1);
        module->addPort(bus_resp_master_0);
        module->addPort(bus_resp_master_1);
        module->addPort(bus_resp_slave_0);
        module->addPort(bus_resp_slave_1);

        for(auto subVar: req->getSubVarList()){
            module->addVariable(subVar);
        }
        for(auto subVar: resp->getSubVarList()){
            module->addVariable(subVar);
        }

        //Master Access_Bus Statements
        //if(fromReset)
        auto if_fromReset = new If(new VariableOperand(fromReset));
        //wait(dummy_master)
        auto wait_dummy_master = new Wait("dummy_master");
        //if(state != MASTER_REQ)
        auto state_neq_MASTER_REQ = new Relational(new VariableOperand(state),"!=",new EnumValue("MASTER_REQ",states));
        auto if_state_neq_MASTER_REQ = new If(state_neq_MASTER_REQ);
        //wait(master_read_notify)
        auto wait_master_read_notify = new Wait("master_read_notify");
        //if(master_id > id)
        auto master_id_gt_0 = new Relational(new VariableOperand(master_id),">",new UnsignedValue(0));
        auto master_id_gt_1 = new Relational(new VariableOperand(master_id),">",new UnsignedValue(1));
        auto if_master_id_gt_0 = new If(master_id_gt_0);
        auto if_master_id_gt_1 = new If(master_id_gt_1);
        //master_id=id
        auto master_id_assign_0 = new Assignment(new VariableOperand(master_id),new UnsignedValue(0));
        auto master_id_assign_1 = new Assignment(new VariableOperand(master_id),new UnsignedValue(1));
        //if(val.haddr >= SLAVE0_START && val.haddr <SLAVE0_END)
        auto SLAVE0_START = new UnsignedValue(0x00000000);
        auto SLAVE0_END = new UnsignedValue(0x00010000);
        //Slave 0
        auto val_0_haddr_geq_slave0_start = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),">=",SLAVE0_START);
        auto val_1_haddr_geq_slave0_start = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),">=",SLAVE0_START);

        auto val_0_haddr_lt_slave0_end = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),"<",SLAVE0_END);
        auto val_1_haddr_lt_slave0_end = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),"<",SLAVE0_END);

        auto val_0_slave0 = new Logical(val_0_haddr_geq_slave0_start,"and",val_0_haddr_lt_slave0_end);
        auto val_1_slave0 = new Logical(val_1_haddr_geq_slave0_start,"and",val_1_haddr_lt_slave0_end);

        auto if_val_0_slave_0 = new If(val_0_slave0);
        auto if_val_1_slave_0 = new If(val_1_slave0);

        auto slave_id_assign_0 = new Assignment(new VariableOperand(slave_id),new UnsignedValue(0));

        auto slave_id_assign_1 = new Assignment(new VariableOperand(slave_id),new UnsignedValue(1));

        //req.hwdata=val.hwdata
        auto req_assign_val0_hwdata = new Assignment(new VariableOperand(req->getSubVar("hwdata")),new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("hwdata")));
        auto req_assign_val1_hwdata = new Assignment(new VariableOperand(req->getSubVar("hwdata")),new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("hwdata")));

        //req.haddr=val.haddr
        auto req_assign_val0_haddr = new Assignment(new VariableOperand(req->getSubVar("haddr")),new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")));
        auto req_assign_val1_haddr = new Assignment(new VariableOperand(req->getSubVar("haddr")),new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")));

        auto noti = new Notify("Debug");

        //master_dummy.notify()
        auto master_dummy_notify = new Notify("master_dummy");
        //wait(dummy_master)
        //already implemented as wait_dummy_master

        //if(master_id != id)
        auto master_id_neq_0 = new Relational(new VariableOperand(master_id),"!=",new UnsignedValue(0));
        auto master_id_neq_1 = new Relational(new VariableOperand(master_id),"!=",new UnsignedValue(1));

        auto if_master_id_neq_0 = new If(master_id_neq_0);
        auto if_master_id_neq_1 = new If(master_id_neq_1);

        //state = SLAVE_REQ
        auto state_assign_SLAVE_REQ = new Assignment(new VariableOperand(state),new EnumValue("SLAVE_REQ",states));

        //master_write_notify.notify()
        auto master_write_notify = new Notify("master_write_notify");

        //wait(slave_write_notify)
        auto wait_slave_write_notify = new Wait("slave_write_notify");

        //out.hrdata = resp.hrdata
        auto out_0_assign_resp_hrdata = new Assignment(new DataSignalOperand(bus_resp_master_0->getDataSignal()->getSubVar("hrdata")),new VariableOperand(resp->getSubVar("hrdata")));
        auto out_1_assign_resp_hrdata = new Assignment(new DataSignalOperand(bus_resp_master_1->getDataSignal()->getSubVar("hrdata")),new VariableOperand(resp->getSubVar("hrdata")));

        //out.hresp = resp.hresp
        auto out_0_assign_resp_hresp = new Assignment(new DataSignalOperand(bus_resp_master_0->getDataSignal()->getSubVar("hresp")),new VariableOperand(resp->getSubVar("hresp")));
        auto out_1_assign_resp_hresp = new Assignment(new DataSignalOperand(bus_resp_master_1->getDataSignal()->getSubVar("hresp")),new VariableOperand(resp->getSubVar("hresp")));

        //state = MASTER_REQ
        auto state_assign_MASTER_REQ = new Assignment(new VariableOperand(state),new EnumValue("MASTER_REQ",states));
        //master_id = 10
        auto master_id_assign_10 = new Assignment(new VariableOperand(master_id),new UnsignedValue(10));
        //slave_id = 10
        auto slave_id_assign_10 = new Assignment(new VariableOperand(slave_id),new UnsignedValue(10));

        auto noti4 = new Notify("Debug2");
        auto noti4cfg = new CfgNode(noti4);
        auto retx = new Return("Debug");

        //master_read_notify.notify()
        auto master_read_notify = new Notify("master_read_notify");
        //return
        auto ret_access_bus = new Return("access_bus");

        //wait(master_read_notify)
        //already implemented as wait_master_read_notify




        //Slave Read
        //if(state != SLAVE_REQ)
        auto state_neq_SLAVE_REQ = new Relational(new VariableOperand(state),"!=",new EnumValue("SLAVE_REQ",states));
        auto if_state_neq_SLAVE_REQ = new If(state_neq_SLAVE_REQ);
        //wait(master_write_notify)
        auto wait_master_write_notify = new Wait("master_write_notify");
        //if(slave_id==id)
        auto slave_id_eq_0 = new Relational(new VariableOperand(slave_id),"==",new UnsignedValue(0));
        auto slave_id_eq_1 = new Relational(new VariableOperand(slave_id),"==",new UnsignedValue(1));
        auto slave_id_eq_2 = new Relational(new VariableOperand(slave_id),"==",new UnsignedValue(2));
        auto slave_id_eq_3 = new Relational(new VariableOperand(slave_id),"==",new UnsignedValue(3));

        auto if_slave_id_eq_0 = new If(slave_id_eq_0);
        auto if_slave_id_eq_1 = new If(slave_id_eq_1);
        auto if_slave_id_eq_2 = new If(slave_id_eq_2);
        auto if_slave_id_eq_3 = new If(slave_id_eq_3);

        //out.hwdata = req.hwdata
        auto out_0_assign_req_hwdata = new Assignment(new DataSignalOperand(bus_req_slave_0->getDataSignal()->getSubVar("hwdata")),new VariableOperand(req->getSubVar("hwdata")));
        auto out_1_assign_req_hwdata = new Assignment(new DataSignalOperand(bus_req_slave_1->getDataSignal()->getSubVar("hwdata")),new VariableOperand(req->getSubVar("hwdata")));
        //out.haddr = req.haddr
        auto out_0_assign_req_haddr = new Assignment(new DataSignalOperand(bus_req_slave_0->getDataSignal()->getSubVar("haddr")),new VariableOperand(req->getSubVar("haddr")));
        auto out_1_assign_req_haddr = new Assignment(new DataSignalOperand(bus_req_slave_1->getDataSignal()->getSubVar("haddr")),new VariableOperand(req->getSubVar("haddr")));

        //state = SLAVE_RESP
        auto state_assign_SLAVE_RESP = new Assignment(new VariableOperand(state),new EnumValue("SLAVE_RESP",states));

        //debug
        auto noti2 = new Notify("Test");
        auto noti_cfg2 = new CfgNode(noti2);
        auto ret2 = new Return("Return");

        //slave_read_notify.notify()
        auto slave_read_notify = new Notify("slave_read_notify");
        //return
        auto ret_read_slave = new Return("read_slave");
        //wait(master_write_notify)
        //already implemented as wait_master_write_notify


        //Slave Write
        //if(state != SLAVE_RESP)
        auto state_neq_SLAVE_RESP = new Relational(new VariableOperand(state),"!=",new EnumValue("SLAVE_RESP",states));
        auto if_state_neq_SLAVE_RESP = new If(state_neq_SLAVE_RESP);
        //wait(slave_read_notify)
        auto wait_slave_read_notify = new Wait("slave_read_notify");
        //if(slave_id == id)
        //already implemtented as slave_id_eq_0/1/2/3 and if_slave_id_eq_0/1/2/3
        //resp.hrdata = val.hrdata
        auto resp_assign_val_0_hrdata = new Assignment(new VariableOperand(resp->getSubVar("hrdata")),new DataSignalOperand(bus_resp_slave_0->getDataSignal()->getSubVar("hrdata")));
        auto resp_assign_val_1_hrdata = new Assignment(new VariableOperand(resp->getSubVar("hrdata")),new DataSignalOperand(bus_resp_slave_1->getDataSignal()->getSubVar("hrdata")));
        //resp.hresp = val.hresp
        auto resp_assign_val_0_hresp = new Assignment( new VariableOperand(resp->getSubVar("hresp")),new DataSignalOperand(bus_resp_slave_0->getDataSignal()->getSubVar("hresp")));
        auto resp_assign_val_1_hresp = new Assignment( new VariableOperand(resp->getSubVar("hresp")),new DataSignalOperand(bus_resp_slave_1->getDataSignal()->getSubVar("hresp")));
        //state = MASTER_RESP
        auto state_assign_MASTER_RESP = new Assignment(new VariableOperand(state),new EnumValue("MASTER_RESP",states));

        //debug
        auto notix = new Notify("Test");
        auto noti_cfgx = new CfgNode(noti2);
        auto returnx = new Return("Return");

        //slave_write_notify.notify()
        auto slave_write_notify = new Notify("slave_write_notify");
        //return
        auto ret_write_slave = new Return("write_slave");
        //wait(slave_read_notify)
        //already implemented as wait_slave_read_notify

        //dummyFunc()
        //fromReset = false
        auto fromReset_assign_false = new Assignment(new VariableOperand(fromReset),new BoolValue(false));
        //dummy_master.notify()
        auto dummy_master_notify = new Notify("dummy_master");
        //wait(master_dummy)
        auto wait_master_dummy = new Wait("master_dummy");

        //CFG Access Bus Master0
        auto check_fromReset_master0 = new CfgNode(if_fromReset);
        auto wait_for_dummy_master0 = new CfgNode(wait_dummy_master);
        auto check_state_MASTER_REQ_master0 = new CfgNode(if_state_neq_MASTER_REQ);
        auto wait_for_read_master0 = new CfgNode(wait_master_read_notify);
        auto check_master_id_master0 = new CfgNode(if_master_id_gt_0);
        auto set_master_id_master0 = new CfgNode(master_id_assign_0);
        auto check_addr_slave0_master0 = new CfgNode(if_val_0_slave_0);
        auto set_slave_id_0_master0 = new CfgNode(slave_id_assign_0);
        auto set_slave_id_1_master0 = new CfgNode(slave_id_assign_1);
        auto set_req_hwdata_master0 = new CfgNode(req_assign_val0_hwdata);
        auto set_req_haddr_master0 = new CfgNode(req_assign_val0_haddr);
        auto notify_dummy_master0 = new CfgNode(master_dummy_notify);
        auto wait_dummy_master0 = new CfgNode(wait_dummy_master);
        auto check_master_id_neq_id_master0 = new CfgNode(if_master_id_neq_0);
        auto set_state_SLAVE_REQ_master0 = new CfgNode(state_assign_SLAVE_REQ);
        auto notify_master_write_master0 = new CfgNode(master_write_notify);
        auto wait_slave_write_master0 = new CfgNode(wait_slave_write_notify);
        auto set_out_hrdata_master0 = new CfgNode(out_0_assign_resp_hrdata);
        auto set_out_hresp_master0 = new CfgNode(out_0_assign_resp_hresp);
        auto set_state_MASTER_REQ_master0 = new CfgNode(state_assign_MASTER_REQ);
        auto set_master_id_10_master0 = new CfgNode(master_id_assign_10);
        auto set_slave_id_10_master0 = new CfgNode(slave_id_assign_10);
        auto notify_master_read_master0 = new CfgNode(master_read_notify);
        auto return_access_bus_master0 = new CfgNode(ret_access_bus);
        auto wait_master_read_master0 = new CfgNode(wait_master_read_notify);


        //Add Nodes to ControlFlowMap
        controlFlowMapAccessBus0.insert(std::make_pair(check_fromReset_master0->getId(),check_fromReset_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(wait_for_dummy_master0->getId(),wait_for_dummy_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(check_state_MASTER_REQ_master0->getId(),check_state_MASTER_REQ_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(wait_for_read_master0->getId(),wait_for_read_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(check_master_id_master0->getId(),check_master_id_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_master_id_master0->getId(),set_master_id_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(check_addr_slave0_master0->getId(),check_addr_slave0_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_slave_id_0_master0->getId(),set_slave_id_0_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_slave_id_1_master0->getId(),set_slave_id_1_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_req_hwdata_master0->getId(),set_req_hwdata_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_req_haddr_master0->getId(),set_req_haddr_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(notify_dummy_master0->getId(),notify_dummy_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(wait_dummy_master0->getId(),wait_dummy_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(check_master_id_neq_id_master0->getId(),check_master_id_neq_id_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_state_SLAVE_REQ_master0->getId(),set_state_SLAVE_REQ_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(notify_master_write_master0->getId(),notify_master_write_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(wait_slave_write_master0->getId(),wait_slave_write_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_out_hrdata_master0->getId(),set_out_hrdata_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_out_hresp_master0->getId(),set_out_hresp_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_state_MASTER_REQ_master0->getId(),set_state_MASTER_REQ_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_master_id_10_master0->getId(),set_master_id_10_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(set_slave_id_10_master0->getId(),set_slave_id_10_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(notify_master_read_master0->getId(),notify_master_read_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(return_access_bus_master0->getId(),return_access_bus_master0));
        controlFlowMapAccessBus0.insert(std::make_pair(wait_master_read_master0->getId(),wait_master_read_master0));

        //Link Nodes
        check_fromReset_master0->addSuccessor(wait_for_dummy_master0);
        check_fromReset_master0->addSuccessor(check_state_MASTER_REQ_master0);
        wait_for_dummy_master0->addSuccessor(check_state_MASTER_REQ_master0);
        check_state_MASTER_REQ_master0->addSuccessor(wait_for_read_master0);
        check_state_MASTER_REQ_master0->addSuccessor(check_master_id_master0);
        wait_for_read_master0->addSuccessor(check_master_id_master0);
        check_master_id_master0->addSuccessor(set_master_id_master0);
        check_master_id_master0->addSuccessor(wait_master_read_master0);
        set_master_id_master0->addSuccessor(check_addr_slave0_master0);
        check_addr_slave0_master0->addSuccessor(set_slave_id_0_master0);
        check_addr_slave0_master0->addSuccessor(set_slave_id_1_master0);
        set_slave_id_0_master0->addSuccessor(set_req_hwdata_master0);
        set_slave_id_1_master0->addSuccessor(set_req_hwdata_master0);
        set_req_hwdata_master0->addSuccessor(set_req_haddr_master0);
        set_req_haddr_master0->addSuccessor(notify_dummy_master0);
        notify_dummy_master0->addSuccessor(wait_dummy_master0);
        wait_dummy_master0->addSuccessor(check_master_id_neq_id_master0);
        check_master_id_neq_id_master0->addSuccessor(check_master_id_master0);
        check_master_id_neq_id_master0->addSuccessor(set_state_SLAVE_REQ_master0);
        set_state_SLAVE_REQ_master0->addSuccessor(notify_master_write_master0);
        notify_master_write_master0->addSuccessor(wait_slave_write_master0);
        wait_slave_write_master0->addSuccessor(set_out_hrdata_master0);
        set_out_hrdata_master0->addSuccessor(set_out_hresp_master0);
        set_out_hresp_master0->addSuccessor(set_state_MASTER_REQ_master0);
        set_state_MASTER_REQ_master0->addSuccessor(set_master_id_10_master0);
        set_master_id_10_master0->addSuccessor(set_slave_id_10_master0);
        set_slave_id_10_master0->addSuccessor(notify_master_read_master0);
        notify_master_read_master0->addSuccessor(return_access_bus_master0);
        wait_master_read_master0->addSuccessor(check_master_id_master0);

        //CFG Access Bus Master1
        auto check_fromReset_master1 = new CfgNode(if_fromReset);
        auto wait_for_dummy_master1 = new CfgNode(wait_dummy_master);
        auto check_state_MASTER_REQ_master1 = new CfgNode(if_state_neq_MASTER_REQ);
        auto wait_for_read_master1 = new CfgNode(wait_master_read_notify);
        auto check_master_id_master1 = new CfgNode(if_master_id_gt_1);
        auto set_master_id_master1 = new CfgNode(master_id_assign_1);
        auto check_addr_slave0_master1 = new CfgNode(if_val_1_slave_0);
        auto set_slave_id_0_master1 = new CfgNode(slave_id_assign_0);
        auto set_slave_id_1_master1 = new CfgNode(slave_id_assign_1);
        auto set_req_hwdata_master1 = new CfgNode(req_assign_val1_hwdata);
        auto set_req_haddr_master1 = new CfgNode(req_assign_val1_haddr);
        auto notify_dummy_master1 = new CfgNode(master_dummy_notify);
        auto wait_dummy_master1 = new CfgNode(wait_dummy_master);
        auto check_master_id_neq_id_master1 = new CfgNode(if_master_id_neq_1);
        auto set_state_SLAVE_REQ_master1 = new CfgNode(state_assign_SLAVE_REQ);
        auto notify_master_write_master1 = new CfgNode(master_write_notify);
        auto wait_slave_write_master1 = new CfgNode(wait_slave_write_notify);
        auto set_out_hrdata_master1 = new CfgNode(out_1_assign_resp_hrdata);
        auto set_out_hresp_master1 = new CfgNode(out_1_assign_resp_hresp);
        auto set_state_MASTER_REQ_master1 = new CfgNode(state_assign_MASTER_REQ);
        auto set_master_id_10_master1 = new CfgNode(master_id_assign_10);
        auto set_slave_id_10_master1 = new CfgNode(slave_id_assign_10);
        auto notify_master_read_master1 = new CfgNode(master_read_notify);
        auto return_access_bus_master1 = new CfgNode(ret_access_bus);
        auto wait_master_read_master1 = new CfgNode(wait_master_read_notify);


        //Add Nodes to ControlFlowMap
        controlFlowMapAccessBus1.insert(std::make_pair(check_fromReset_master1->getId(),check_fromReset_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(wait_for_dummy_master1->getId(),wait_for_dummy_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(check_state_MASTER_REQ_master1->getId(),check_state_MASTER_REQ_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(wait_for_read_master1->getId(),wait_for_read_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(check_master_id_master1->getId(),check_master_id_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_master_id_master1->getId(),set_master_id_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(check_addr_slave0_master1->getId(),check_addr_slave0_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_slave_id_0_master1->getId(),set_slave_id_0_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_slave_id_1_master1->getId(),set_slave_id_1_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_req_hwdata_master1->getId(),set_req_hwdata_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_req_haddr_master1->getId(),set_req_haddr_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(notify_dummy_master1->getId(),notify_dummy_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(wait_dummy_master1->getId(),wait_dummy_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(check_master_id_neq_id_master1->getId(),check_master_id_neq_id_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_state_SLAVE_REQ_master1->getId(),set_state_SLAVE_REQ_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(notify_master_write_master1->getId(),notify_master_write_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(wait_slave_write_master1->getId(),wait_slave_write_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_out_hrdata_master1->getId(),set_out_hrdata_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_out_hresp_master1->getId(),set_out_hresp_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_state_MASTER_REQ_master1->getId(),set_state_MASTER_REQ_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_master_id_10_master1->getId(),set_master_id_10_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(set_slave_id_10_master1->getId(),set_slave_id_10_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(notify_master_read_master1->getId(),notify_master_read_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(return_access_bus_master1->getId(),return_access_bus_master1));
        controlFlowMapAccessBus1.insert(std::make_pair(wait_master_read_master1->getId(),wait_master_read_master1));


        //Link Nodes
        check_fromReset_master1->addSuccessor(wait_for_dummy_master1);
        check_fromReset_master1->addSuccessor(check_state_MASTER_REQ_master1);
        wait_for_dummy_master1->addSuccessor(check_state_MASTER_REQ_master1);
        check_state_MASTER_REQ_master1->addSuccessor(wait_for_read_master1);
        check_state_MASTER_REQ_master1->addSuccessor(check_master_id_master1);
        wait_for_read_master1->addSuccessor(check_master_id_master1);
        check_master_id_master1->addSuccessor(set_master_id_master1);
        check_master_id_master1->addSuccessor(wait_master_read_master1);
        set_master_id_master1->addSuccessor(check_addr_slave0_master1);
        check_addr_slave0_master1->addSuccessor(set_slave_id_0_master1);
        check_addr_slave0_master1->addSuccessor(set_slave_id_1_master1);
        set_slave_id_0_master1->addSuccessor(set_req_hwdata_master1);
        set_slave_id_1_master1->addSuccessor(set_req_hwdata_master1);
        set_req_hwdata_master1->addSuccessor(set_req_haddr_master1);
        set_req_haddr_master1->addSuccessor(notify_dummy_master1);
        notify_dummy_master1->addSuccessor(wait_dummy_master1);
        wait_dummy_master1->addSuccessor(check_master_id_neq_id_master1);
        check_master_id_neq_id_master1->addSuccessor(check_master_id_master1);
        check_master_id_neq_id_master1->addSuccessor(set_state_SLAVE_REQ_master1);
        set_state_SLAVE_REQ_master1->addSuccessor(notify_master_write_master1);
        notify_master_write_master1->addSuccessor(wait_slave_write_master1);
        wait_slave_write_master1->addSuccessor(set_out_hrdata_master1);
        set_out_hrdata_master1->addSuccessor(set_out_hresp_master1);
        set_out_hresp_master1->addSuccessor(set_state_MASTER_REQ_master1);
        set_state_MASTER_REQ_master1->addSuccessor(set_master_id_10_master1);
        set_master_id_10_master1->addSuccessor(set_slave_id_10_master1);
        set_slave_id_10_master1->addSuccessor(notify_master_read_master1);
        notify_master_read_master1->addSuccessor(return_access_bus_master1);
        wait_master_read_master1->addSuccessor(check_master_id_master1);


        //CFG Slave Read 0
        auto check_state_SLAVE_REQ_slave0 = new CfgNode(if_state_neq_SLAVE_REQ);
        auto wait_for_write_slave0 = new CfgNode(wait_master_write_notify);
        auto check_slave_id_slave0 = new CfgNode(if_slave_id_eq_0);
        auto set_out_hwdata_slave0 = new CfgNode(out_0_assign_req_hwdata);
        auto set_out_haddr_slave0 = new CfgNode(out_0_assign_req_haddr);
        auto set_state_SLAVE_RESP_slave0 = new CfgNode(state_assign_SLAVE_RESP);
        auto notify_slave_read_slave0 = new CfgNode(slave_read_notify);
        auto return_read_slave_slave0 = new CfgNode(ret_read_slave);
        auto wait_master_write_slave0 = new CfgNode(wait_master_write_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapSlaveRead0.insert(std::make_pair(check_state_SLAVE_REQ_slave0->getId(),check_state_SLAVE_REQ_slave0));
        controlFlowMapSlaveRead0.insert(std::make_pair(wait_for_write_slave0->getId(),wait_for_write_slave0));
        controlFlowMapSlaveRead0.insert(std::make_pair(check_slave_id_slave0->getId(),check_slave_id_slave0));
        controlFlowMapSlaveRead0.insert(std::make_pair(set_out_hwdata_slave0->getId(),set_out_hwdata_slave0));
        controlFlowMapSlaveRead0.insert(std::make_pair(set_out_haddr_slave0->getId(),set_out_haddr_slave0));
        controlFlowMapSlaveRead0.insert(std::make_pair(set_state_SLAVE_RESP_slave0->getId(),set_state_SLAVE_RESP_slave0));
        controlFlowMapSlaveRead0.insert(std::make_pair(notify_slave_read_slave0->getId(),notify_slave_read_slave0));
        controlFlowMapSlaveRead0.insert(std::make_pair(return_read_slave_slave0->getId(),return_read_slave_slave0));
        controlFlowMapSlaveRead0.insert(std::make_pair(wait_master_write_slave0->getId(),wait_master_write_slave0));

        //Link Nodes
        check_state_SLAVE_REQ_slave0->addSuccessor(wait_for_write_slave0);
        check_state_SLAVE_REQ_slave0->addSuccessor(check_slave_id_slave0);
        wait_for_write_slave0->addSuccessor(check_slave_id_slave0);
        check_slave_id_slave0->addSuccessor(set_out_hwdata_slave0);
        check_slave_id_slave0->addSuccessor(wait_master_write_slave0);
        set_out_hwdata_slave0->addSuccessor(set_out_haddr_slave0);
        set_out_haddr_slave0->addSuccessor(set_state_SLAVE_RESP_slave0);
        set_state_SLAVE_RESP_slave0->addSuccessor(notify_slave_read_slave0);
        notify_slave_read_slave0->addSuccessor(return_read_slave_slave0);
        wait_master_write_slave0->addSuccessor(check_slave_id_slave0);

        //CFG Slave Read 1
        auto check_state_SLAVE_REQ_slave1 = new CfgNode(if_state_neq_SLAVE_REQ);
        auto wait_for_write_slave1 = new CfgNode(wait_master_write_notify);
        auto check_slave_id_slave1 = new CfgNode(if_slave_id_eq_1);
        auto set_out_hwdata_slave1 = new CfgNode(out_1_assign_req_hwdata);
        auto set_out_haddr_slave1 = new CfgNode(out_1_assign_req_haddr);
        auto set_state_SLAVE_RESP_slave1 = new CfgNode(state_assign_SLAVE_RESP);
        auto notify_slave_read_slave1 = new CfgNode(slave_read_notify);
        auto return_read_slave_slave1 = new CfgNode(ret_read_slave);
        auto wait_master_write_slave1 = new CfgNode(wait_master_write_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapSlaveRead1.insert(std::make_pair(check_state_SLAVE_REQ_slave1->getId(),check_state_SLAVE_REQ_slave1));
        controlFlowMapSlaveRead1.insert(std::make_pair(wait_for_write_slave1->getId(),wait_for_write_slave1));
        controlFlowMapSlaveRead1.insert(std::make_pair(check_slave_id_slave1->getId(),check_slave_id_slave1));
        controlFlowMapSlaveRead1.insert(std::make_pair(set_out_hwdata_slave1->getId(),set_out_hwdata_slave1));
        controlFlowMapSlaveRead1.insert(std::make_pair(set_out_haddr_slave1->getId(),set_out_haddr_slave1));
        controlFlowMapSlaveRead1.insert(std::make_pair(set_state_SLAVE_RESP_slave1->getId(),set_state_SLAVE_RESP_slave1));
        controlFlowMapSlaveRead1.insert(std::make_pair(notify_slave_read_slave1->getId(),notify_slave_read_slave1));
        controlFlowMapSlaveRead1.insert(std::make_pair(return_read_slave_slave1->getId(),return_read_slave_slave1));
        controlFlowMapSlaveRead1.insert(std::make_pair(wait_master_write_slave1->getId(),wait_master_write_slave1));

        //Link Nodes
        check_state_SLAVE_REQ_slave1->addSuccessor(wait_for_write_slave1);
        check_state_SLAVE_REQ_slave1->addSuccessor(check_slave_id_slave1);
        wait_for_write_slave1->addSuccessor(check_slave_id_slave1);
        check_slave_id_slave1->addSuccessor(set_out_hwdata_slave1);
        check_slave_id_slave1->addSuccessor(wait_master_write_slave1);
        set_out_hwdata_slave1->addSuccessor(set_out_haddr_slave1);
        set_out_haddr_slave1->addSuccessor(set_state_SLAVE_RESP_slave1);
        set_state_SLAVE_RESP_slave1->addSuccessor(notify_slave_read_slave1);
        notify_slave_read_slave1->addSuccessor(return_read_slave_slave1);
        wait_master_write_slave1->addSuccessor(check_slave_id_slave1);

        //CFG Slave Write 0
        auto check_state_SLAVE_RESP_slave0 = new CfgNode(if_state_neq_SLAVE_RESP);
        auto wait_for_read_slave0 = new CfgNode(wait_slave_read_notify);
        auto check_slave_id_write_slave0 = new CfgNode(if_slave_id_eq_0);
        auto set_resp_hrdata_slave0 = new CfgNode(resp_assign_val_0_hrdata);
        auto set_resp_hresp_slave0 = new CfgNode(resp_assign_val_0_hresp);
        auto set_state_MASTER_RESP_slave0 = new CfgNode(state_assign_MASTER_RESP);
        auto notify_slave_write_slave0 = new CfgNode(slave_write_notify);
        auto return_write_slave_slave0 = new CfgNode(ret_write_slave);
        auto wait_slave_read_slave0 = new CfgNode(wait_slave_read_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapSlaveWrite0.insert(std::make_pair(check_state_SLAVE_RESP_slave0->getId(),check_state_SLAVE_RESP_slave0));
        controlFlowMapSlaveWrite0.insert(std::make_pair(wait_for_read_slave0->getId(),wait_for_read_slave0));
        controlFlowMapSlaveWrite0.insert(std::make_pair(check_slave_id_write_slave0->getId(),check_slave_id_write_slave0));
        controlFlowMapSlaveWrite0.insert(std::make_pair(set_resp_hrdata_slave0->getId(),set_resp_hrdata_slave0));
        controlFlowMapSlaveWrite0.insert(std::make_pair(set_resp_hresp_slave0->getId(),set_resp_hresp_slave0));
        controlFlowMapSlaveWrite0.insert(std::make_pair(set_state_MASTER_RESP_slave0->getId(),set_state_MASTER_RESP_slave0));
        controlFlowMapSlaveWrite0.insert(std::make_pair(notify_slave_write_slave0->getId(),notify_slave_write_slave0));
        controlFlowMapSlaveWrite0.insert(std::make_pair(return_write_slave_slave0->getId(),return_write_slave_slave0));
        controlFlowMapSlaveWrite0.insert(std::make_pair(wait_slave_read_slave0->getId(),wait_slave_read_slave0));

        //Link Nodes
        check_state_SLAVE_RESP_slave0->addSuccessor(wait_for_read_slave0);
        check_state_SLAVE_RESP_slave0->addSuccessor(check_slave_id_write_slave0);
        wait_for_read_slave0->addSuccessor(check_slave_id_write_slave0);
        check_slave_id_write_slave0->addSuccessor(set_resp_hrdata_slave0);
        check_slave_id_write_slave0->addSuccessor(wait_slave_read_slave0);
        set_resp_hrdata_slave0->addSuccessor(set_resp_hresp_slave0);
        set_resp_hresp_slave0->addSuccessor(set_state_MASTER_RESP_slave0);
        set_state_MASTER_RESP_slave0->addSuccessor(notify_slave_write_slave0);
        notify_slave_write_slave0->addSuccessor(return_write_slave_slave0);
        wait_slave_read_slave0->addSuccessor(check_slave_id_write_slave0);

        //CFG Slave Write 1
        auto check_state_SLAVE_RESP_slave1 = new CfgNode(if_state_neq_SLAVE_RESP);
        auto wait_for_read_slave1 = new CfgNode(wait_slave_read_notify);
        auto check_slave_id_write_slave1 = new CfgNode(if_slave_id_eq_1);
        auto set_resp_hrdata_slave1 = new CfgNode(resp_assign_val_1_hrdata);
        auto set_resp_hresp_slave1 = new CfgNode(resp_assign_val_1_hresp);
        auto set_state_MASTER_RESP_slave1 = new CfgNode(state_assign_MASTER_RESP);
        auto notify_slave_write_slave1 = new CfgNode(slave_write_notify);
        auto return_write_slave_slave1 = new CfgNode(ret_write_slave);
        auto wait_slave_read_slave1 = new CfgNode(wait_slave_read_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapSlaveWrite1.insert(std::make_pair(check_state_SLAVE_RESP_slave1->getId(),check_state_SLAVE_RESP_slave1));
        controlFlowMapSlaveWrite1.insert(std::make_pair(wait_for_read_slave1->getId(),wait_for_read_slave1));
        controlFlowMapSlaveWrite1.insert(std::make_pair(check_slave_id_write_slave1->getId(),check_slave_id_write_slave1));
        controlFlowMapSlaveWrite1.insert(std::make_pair(set_resp_hrdata_slave1->getId(),set_resp_hrdata_slave1));
        controlFlowMapSlaveWrite1.insert(std::make_pair(set_resp_hresp_slave1->getId(),set_resp_hresp_slave1));
        controlFlowMapSlaveWrite1.insert(std::make_pair(set_state_MASTER_RESP_slave1->getId(),set_state_MASTER_RESP_slave1));
        controlFlowMapSlaveWrite1.insert(std::make_pair(notify_slave_write_slave1->getId(),notify_slave_write_slave1));
        controlFlowMapSlaveWrite1.insert(std::make_pair(return_write_slave_slave1->getId(),return_write_slave_slave1));
        controlFlowMapSlaveWrite1.insert(std::make_pair(wait_slave_read_slave1->getId(),wait_slave_read_slave1));

        //Link Nodes
        check_state_SLAVE_RESP_slave1->addSuccessor(wait_for_read_slave1);
        check_state_SLAVE_RESP_slave1->addSuccessor(check_slave_id_write_slave1);
        wait_for_read_slave1->addSuccessor(check_slave_id_write_slave1);
        check_slave_id_write_slave1->addSuccessor(set_resp_hrdata_slave1);
        check_slave_id_write_slave1->addSuccessor(wait_slave_read_slave1);
        set_resp_hrdata_slave1->addSuccessor(set_resp_hresp_slave1);
        set_resp_hresp_slave1->addSuccessor(set_state_MASTER_RESP_slave1);
        set_state_MASTER_RESP_slave1->addSuccessor(notify_slave_write_slave1);
        notify_slave_write_slave1->addSuccessor(return_write_slave_slave1);
        wait_slave_read_slave1->addSuccessor(check_slave_id_write_slave1);

        //CFG DummyFunc
        auto set_fromReset = new CfgNode(fromReset_assign_false);
        auto notify_dummy_master = new CfgNode(dummy_master_notify);
        auto wait_for_master_dummy = new CfgNode(wait_master_dummy);

        //Add Nodes to ControlFlowMap
        controlFlowMapDummy.insert(std::make_pair(set_fromReset->getId(),set_fromReset));
        controlFlowMapDummy.insert(std::make_pair(notify_dummy_master->getId(),notify_dummy_master));
        controlFlowMapDummy.insert(std::make_pair(wait_for_master_dummy->getId(),wait_for_master_dummy));

        //Link Nodes
        set_fromReset->addSuccessor(notify_dummy_master);
        notify_dummy_master->addSuccessor(wait_for_master_dummy);
        wait_for_master_dummy->addSuccessor(notify_dummy_master);

        //Add all Nodes to controlFlowMap
        for(auto node: controlFlowMapAccessBus0){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapAccessBus1){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveRead0){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveRead1){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveWrite0){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveWrite1){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapDummy){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        //Print CFG AccessBus
        std::cout << printCFG(controlFlowMapAccessBus0) << std::endl;
        std::cout << printCFG(controlFlowMapAccessBus1) << std::endl;
        //Print CFG for SlaveRead
        std::cout << printCFG(controlFlowMapSlaveRead0) << std::endl;
        std::cout << printCFG(controlFlowMapSlaveRead1) << std::endl;

        //Print CFG for SlaveWrite
        std::cout << printCFG(controlFlowMapSlaveWrite0) << std::endl;
        std::cout << printCFG(controlFlowMapSlaveWrite1) << std::endl;

        //Print CFG Dummy
        std::cout << printCFG(controlFlowMapDummy) << std::endl;

        init = new State("reset");
        init->setInit();

        //Generate Reset Operation
        reset_op = new Operation();
        reset_op->addStatement(state_assign_MASTER_REQ);
        reset_op->addStatement(master_id_assign_10);
        reset_op->addStatement(slave_id_assign_10);
        auto fromReset_assign_true = new Assignment(new VariableOperand(fromReset),new BoolValue(true));
        reset_op->addStatement(fromReset_assign_true);
        reset_op->setState(init);
        start_state = new State("start_state");
        reset_op->setNextState(start_state);
        reset_op->setReset(true);

        //set start and end nodes for sync and notify
        eventID temp;
        temp = {3,"master0_access_bus_sync"};
        startnodes.push_back(temp);
        temp = {28,"master1_access_bus_sync"};
        startnodes.push_back(temp);
        temp = {53,"slave0_read_sync"};
        startnodes.push_back(temp);
        temp = {62,"slave1_read_sync"};
        startnodes.push_back(temp);
        temp = {71,"slave0_write_sync"};
        startnodes.push_back(temp);
        temp = {80,"slave1_write_sync"};
        startnodes.push_back(temp);

        temp = {26,"master0_access_bus_notify"};
        endnodes.push_back(temp);
        temp = {51,"master1_access_bus_notify"};
        endnodes.push_back(temp);
        temp = {60,"slave0_read_notify"};
        endnodes.push_back(temp);
        temp = {69,"slave1_read_notify"};
        endnodes.push_back(temp);
        temp = {78,"slave0_write_notify"};
        endnodes.push_back(temp);
        temp = {87,"slave1_write_notify"};
        endnodes.push_back(temp);

        //Define portnames for notify and sync signals
        portnames.push_back("val_master_0");
        portnames.push_back("val_master_1");
        portnames.push_back("out_slave_0");
        portnames.push_back("out_slave_1");
        portnames.push_back("val_slave_0");
        portnames.push_back("val_slave_1");
    }

    virtual void TearDown() {}

};

TEST_F(OperationGraphTest, ExtractPaths){
    //Find important states AccessBus0
    std::map<int, CfgNode *> importantStatesAccessBus0;
    findImportantStates(controlFlowMapAccessBus0,&importantStatesAccessBus0);

    //Find paths AccessBus0
    auto start_AccessBus0 = controlFlowMapAccessBus0.begin()->second;
    findPathsfromNode(start_AccessBus0,&pathsAccessBus0,&pathsAccessBus0IDs);
    for(auto const& node : importantStatesAccessBus0) {
        findPathsfromNode(node.second,&pathsAccessBus0,&pathsAccessBus0IDs);
    }

    //Find important states AccessBus1
    std::map<int, CfgNode *> importantStatesAccessBus1;
    findImportantStates(controlFlowMapAccessBus1,&importantStatesAccessBus1);

    //Find paths AccessBus1
    auto start_AccessBus1 = controlFlowMapAccessBus1.begin()->second;
    findPathsfromNode(start_AccessBus1,&pathsAccessBus1,&pathsAccessBus1IDs);
    for(auto const& node : importantStatesAccessBus1) {
        findPathsfromNode(node.second,&pathsAccessBus1,&pathsAccessBus1IDs);
    }

    //Find important states SlaveRead0
    std::map<int, CfgNode *> importantStatesSlaveRead0;
    findImportantStates(controlFlowMapSlaveRead0,&importantStatesSlaveRead0);

    //Find paths SlaveRead0
    auto start_SlaveRead0 = controlFlowMapSlaveRead0.begin()->second;
    findPathsfromNode(start_SlaveRead0,&pathsSlaveRead0,&pathsSlaveRead0IDs);
    for(auto const& node : importantStatesSlaveRead0) {
        findPathsfromNode(node.second,&pathsSlaveRead0,&pathsSlaveRead0IDs);
    }

    //Find important states SlaveRead1
    std::map<int, CfgNode *> importantStatesSlaveRead1;
    findImportantStates(controlFlowMapSlaveRead1,&importantStatesSlaveRead1);

    //Find paths SlaveRead1
    auto start_SlaveRead1 = controlFlowMapSlaveRead1.begin()->second;
    findPathsfromNode(start_SlaveRead1,&pathsSlaveRead1,&pathsSlaveRead1IDs);
    for(auto const& node : importantStatesSlaveRead1) {
        findPathsfromNode(node.second,&pathsSlaveRead1,&pathsSlaveRead1IDs);
    }

    //Find important states SlaveWrite0
    std::map<int, CfgNode *> importantStatesSlaveWrite0;
    findImportantStates(controlFlowMapSlaveWrite0,&importantStatesSlaveWrite0);

    //Find paths SlaveWrite0
    auto start_SlaveWrite0 = controlFlowMapSlaveWrite0.begin()->second;
    findPathsfromNode(start_SlaveWrite0,&pathsSlaveWrite0,&pathsSlaveWrite0IDs);
    for(auto const& node : importantStatesSlaveWrite0) {
        findPathsfromNode(node.second,&pathsSlaveWrite0,&pathsSlaveWrite0IDs);
    }

    //Find important states SlaveWrite1
    std::map<int, CfgNode *> importantStatesSlaveWrite1;
    findImportantStates(controlFlowMapSlaveWrite1,&importantStatesSlaveWrite1);

    //Find paths SlaveWrite1
    auto start_SlaveWrite1 = controlFlowMapSlaveWrite1.begin()->second;
    findPathsfromNode(start_SlaveWrite1,&pathsSlaveWrite1,&pathsSlaveWrite1IDs);
    for(auto const& node : importantStatesSlaveWrite1) {
        findPathsfromNode(node.second,&pathsSlaveWrite1,&pathsSlaveWrite1IDs);
    }

    //Find important states Dummy
    std::map<int, CfgNode *> importantStatesDummy;
    findImportantStates(controlFlowMapDummy,&importantStatesDummy);

    //Find paths Dummy
    auto start_dummy = controlFlowMapDummy.begin()->second;
    findPathsfromNode(start_dummy,&pathsDummy,&pathsDummyIDs);
    for(auto const& node : importantStatesDummy) {
        findPathsfromNode(node.second,&pathsDummy,&pathsDummyIDs);
    }

    //Generate final FSM
    std::vector<eventID> blockedFunctions;
    std::vector<eventID> readyQueue;
    std::vector<eventID> hv;

    //Define all possible functions and their starting nodes
    eventID AccessBus0 = {3,"AccessBus0"};
    eventID AccessBus1 = {28,"AccessBus1"};
    eventID SlaveRead0 = {53,"SlaveRead0"};
    eventID SlaveRead1 = {62,"SlaveRead1"};
    eventID SlaveWrite0 = {71,"SlaveWrite0"};
    eventID SlaveWrite1 = {80,"SlaveWrite1"};
    eventID dummy = {89,"dummy"};

    //vector of all functions that are always ready to execute
    std::vector<eventID> always_ready;
    always_ready.push_back(dummy);

    //Vector of all functions that can be called from modules
    std::vector<eventID> functions;
    functions.push_back(AccessBus0);
    functions.push_back(AccessBus1);
    functions.push_back(SlaveRead0);
    functions.push_back(SlaveRead1);
    functions.push_back(SlaveWrite0);
    functions.push_back(SlaveWrite1);

    //compute all possible permutations and store them in variable permutations
    computePermutations(functions);

    //add all functions from always_ready to all permuations
    for(auto readyFunc : always_ready){
        for(auto perm = permutations.begin(); perm != permutations.end(); ++perm){
            perm->push_back(readyFunc);
        }
    }
    //construct a vector of all paths by pushing all paths to allPaths
    for(int i=0; i<pathsAccessBus0IDs.size();i++){
        pathIDStmt p = {pathsAccessBus0IDs.at(i),pathsAccessBus0.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsAccessBus1IDs.size();i++){
        pathIDStmt p = {pathsAccessBus1IDs.at(i),pathsAccessBus1.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsSlaveRead0IDs.size();i++){
        pathIDStmt p = {pathsSlaveRead0IDs.at(i),pathsSlaveRead0.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsSlaveRead1IDs.size();i++){
        pathIDStmt p = {pathsSlaveRead1IDs.at(i),pathsSlaveRead1.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsSlaveWrite0IDs.size();i++){
        pathIDStmt p = {pathsSlaveWrite0IDs.at(i),pathsSlaveWrite0.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsSlaveWrite1IDs.size();i++){
        pathIDStmt p = {pathsSlaveWrite1IDs.at(i),pathsSlaveWrite1.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsDummyIDs.size();i++){
        pathIDStmt p = {pathsDummyIDs.at(i),pathsDummy.at(i)};
        allPaths.push_back(p);
    }
    int i = 0;
    merge_count=0;
    unreachable_count=0;
    std::chrono::steady_clock::time_point begin;
    std::chrono::steady_clock::time_point end;

// generate all Paths combining all CFGs and store them in variable finalPaths
    std::chrono::steady_clock::time_point begin_all = std::chrono::steady_clock::now();
    for(auto perm: permutations){
        //set ready queue to current permutation and clear blocked queue
        readyQueue = perm;
        blockedFunctions.clear();
        begin = std::chrono::steady_clock::now();
        combinePaths(readyQueue,blockedFunctions);
        end = std::chrono::steady_clock::now();
        std::cout << "Time needed for permutation " << ++i << ": " << std::chrono::duration_cast<std::chrono::milliseconds>(end-begin).count() <<" [ms]" << std::endl;
        std::cout << "Number of operations: " << operationsFinalOpt.size() << std::endl;
    }
    std::chrono::steady_clock::time_point end_all = std::chrono::steady_clock::now();
    std::cout << "Time needed for all permutations: " << std::chrono::duration_cast<std::chrono::milliseconds>(end_all-begin_all).count() <<" [ms]" << std::endl;

    int cnt = 0;
    std::vector<SCAM::Stmt*> statementList;

    auto rOperations = new ReconstructOperations(module);

    //Set Incoming and Outgoing Operations
    for(auto op:operationsFinalOpt){
        op->getState()->addOutgoingOperation(op);
        op->getNextState()->addIncomingOperation(op);
    }

    //add reset operation
    rOperations->sortOperation(reset_op);
    for(int i=0; i<startnodes.size();i++){
        auto noti = new Notify(module->getPort(portnames.at(i)));
        auto assign = new Assignment(noti,new BoolValue(false));
        reset_op->addCommitment(assign);
    }
    operationsFinalOpt.push_back(reset_op);
    //Create empty path for reset operation
    std::vector<int> int_vec;
    std::vector<SCAM::Stmt*> stmt_vec;
    pathIDStmt temp = {int_vec,stmt_vec};
    reset_op->getState()->addOutgoingOperation(reset_op);
    reset_op->getNextState()->addIncomingOperation(reset_op);

    //wait operation
    auto wait_op = new Operation();
    rOperations->sortOperation(wait_op);
    for(int i=0; i<startnodes.size();i++){
        auto sync = new SyncSignal(module->getPort(portnames.at(i)));
        auto noti = new Notify(module->getPort(portnames.at(i)));
        wait_op->addAssumption(new UnaryExpr("not",sync));
        auto assign = new Assignment(noti,new BoolValue(false));
        wait_op->addCommitment(assign);
    }

    operationsFinalOpt.push_back(wait_op);
    wait_op->setState(start_state);
    wait_op->setNextState(start_state);
    wait_op->getState()->addOutgoingOperation(wait_op);
    wait_op->getNextState()->addIncomingOperation(wait_op);

//    //Debug: Print Assumptions and Commitments for operationsFinalOpt
//    for(auto op: operationsFinalOpt){
//        std::cout << "Assumptions Operation " << op->getId() <<std::endl;
//        for(auto assump: op->getAssumptionsList()){
//            std::cout << *assump << std::endl;
//        }
//        std::cout << std::endl;
//        std::cout << "Commitments Operation" << op->getId() <<std::endl;
//        for(auto commit: op->getCommitmentsList()){
//            std::cout << *commit << std::endl;
//        }
//        std::cout << std::endl;
//    }

    //Statemap consists of a initial state Init and one state start_state
    std::map<int,State*> stateMap;
    stateMap.insert(std::make_pair(init->getStateId(),init ));
    stateMap.insert(std::make_pair(start_state->getStateId(),start_state));
    module->getFSM()->setStateMap(stateMap);

    //Create PropertySuite
    PropertyFactory propertyFactory(module);
    module->setPropertySuite(propertyFactory.getPropertySuite());
    //Print ITL Properties to file
    PrintITL printITL;
    auto map = printITL.printModule(module);
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Bus_Properties/" + module->getName() + "_generated.vhi");
    myfile << map.at(module->getName() + ".vhi") << std::endl;
    myfile.close();
}



#endif //DESCAM_OPERATION_GRAPH_H
