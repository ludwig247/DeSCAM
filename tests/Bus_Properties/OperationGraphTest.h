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

    std::map<int, CfgNode *> controlFlowMapMasterWrite0;
    std::map<int, CfgNode *> controlFlowMapSlaveRead0;
    std::map<int, CfgNode *> controlFlowMapSlaveWrite0;
    std::map<int, CfgNode *> controlFlowMapMasterRead0;
    std::map<int, CfgNode *> controlFlowMapMasterWrite1;
    std::map<int, CfgNode *> controlFlowMapSlaveRead1;
    std::map<int, CfgNode *> controlFlowMapSlaveWrite1;
    std::map<int, CfgNode *> controlFlowMapMasterRead1;
    std::map<int, CfgNode *> controlFlowMapMasterWrite2;
    std::map<int, CfgNode *> controlFlowMapSlaveRead2;
    std::map<int, CfgNode *> controlFlowMapSlaveWrite2;
    std::map<int, CfgNode *> controlFlowMapMasterRead2;
    std::map<int, CfgNode *> controlFlowMapMasterWrite3;
    std::map<int, CfgNode *> controlFlowMapSlaveRead3;
    std::map<int, CfgNode *> controlFlowMapSlaveWrite3;
    std::map<int, CfgNode *> controlFlowMapMasterRead3;
    std::map<int, CfgNode *> controlFlowMapDummy;
    std::map<int, CfgNode *> controlFlowMap;


    std::vector<std::vector<SCAM::Stmt*>> pathsMasterWrite0;
    std::vector<std::vector<int>> pathsMasterWrite0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsMasterWrite1;
    std::vector<std::vector<int>> pathsMasterWrite1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsMasterWrite2;
    std::vector<std::vector<int>> pathsMasterWrite2IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsMasterWrite3;
    std::vector<std::vector<int>> pathsMasterWrite3IDs;

    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveRead0;
    std::vector<std::vector<int>> pathsSlaveRead0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveRead1;
    std::vector<std::vector<int>> pathsSlaveRead1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveRead2;
    std::vector<std::vector<int>> pathsSlaveRead2IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveRead3;
    std::vector<std::vector<int>> pathsSlaveRead3IDs;

    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveWrite0;
    std::vector<std::vector<int>> pathsSlaveWrite0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveWrite1;
    std::vector<std::vector<int>> pathsSlaveWrite1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveWrite2;
    std::vector<std::vector<int>> pathsSlaveWrite2IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsSlaveWrite3;
    std::vector<std::vector<int>> pathsSlaveWrite3IDs;

    std::vector<std::vector<SCAM::Stmt*>> pathsMasterRead0;
    std::vector<std::vector<int>> pathsMasterRead0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsMasterRead1;
    std::vector<std::vector<int>> pathsMasterRead1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsMasterRead2;
    std::vector<std::vector<int>> pathsMasterRead2IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsMasterRead3;
    std::vector<std::vector<int>> pathsMasterRead3IDs;

    std::vector<std::vector<SCAM::Stmt*>> pathsDummy;
    std::vector<std::vector<int>> pathsDummyIDs;

    std::vector<eventID> startnodes;
    std::vector<eventID> endnodes;

    Operation *reset_op;
    std::vector<pathIDStmt> allPaths;
    std::vector<pathIDStmt> finalPaths;
    std::vector<Operation*> operationsFinal;
    std::vector<pathIDStmt> finalPathsOpt;
    std::vector<Operation*> operationsFinalOpt;
    State* start_state;
    State* init;
    std::vector<std::vector<eventID>>permutations;



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

                    //add IDs and statements to global path
                    currentPath.idList.insert(currentPath.idList.end(),path.idList.begin(),path.idList.end());
                    currentPath.stmtList.insert(currentPath.stmtList.end(),path.stmtList.begin(),path.stmtList.end());

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
                    if(ValidOperations::isOperationReachable(op)){
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
                                   auto assump_list = op->getAssumptionsList();
                                   for(auto assump:assump_list){
                                       comp_op->addAssumption(assump);
                                   }
                                   was_merged = true;
                                   break;
                                }
                            }
                        }
                        //If the operation wasn't merged it is a relevant new one, so store it
                        if(!was_merged){
                            //if operation is reachable add it to operationsFinalOpt
                            if(ValidOperations::isOperationReachable(op)){
                                operationsFinalOpt.push_back(op);
                            }
                        }
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
        states->addEnumValue("MASTER_REQ");
        states->addEnumValue("SLAVE_REQ");
        states->addEnumValue("SLAVE_RESP");
        states->addEnumValue("MASTER_RESP");
        auto state = new Variable("state", states);

        auto master_id = new Variable("master_id",DataTypes::getDataType("unsigned"));
        auto slave_id = new Variable("slave_id",DataTypes::getDataType("unsigned"));

        auto bus_req_t = new DataType("bus_req_t");
        bus_req_t->addSubVar("haddr",DataTypes::getDataType("unsigned"));
        bus_req_t->addSubVar("hwdata",DataTypes::getDataType("unsigned"));
        auto req = new Variable("req",bus_req_t);

        auto bus_resp_t = new DataType("bus_resp_t");
        bus_resp_t->addSubVar("hrdata",DataTypes::getDataType("unsigned"));
        bus_resp_t->addSubVar("hresp",DataTypes::getDataType("unsigned"));
        auto resp = new Variable("resp", bus_resp_t);

        auto fromReset = new Variable("fromReset",DataTypes::getDataType("bool"));

        //Master write
        auto bus_req_master_0 = new Port("val_master_0",new Interface("blocking","in"), bus_req_t);
        auto bus_req_master_1 = new Port("val_master_1",new Interface("blocking","in"), bus_req_t);
        auto bus_req_master_2 = new Port("val_master_2",new Interface("blocking","in"), bus_req_t);
        auto bus_req_master_3 = new Port("val_master_3",new Interface("blocking","in"), bus_req_t);

        //Slave read
        auto bus_req_slave_0 = new Port("out_slave_0",new Interface("blocking","out"),bus_req_t);
        auto bus_req_slave_1 = new Port("out_slave_1",new Interface("blocking","out"),bus_req_t);
        auto bus_req_slave_2 = new Port("out_slave_2",new Interface("blocking","out"),bus_req_t);
        auto bus_req_slave_3 = new Port("out_slave_3",new Interface("blocking","out"),bus_req_t);

        //Slave write
        auto bus_resp_slave_0 = new Port("val_slave_0",new Interface("blocking","in"),bus_resp_t);
        auto bus_resp_slave_1 = new Port("val_slave_1",new Interface("blocking","in"),bus_resp_t);
        auto bus_resp_slave_2 = new Port("val_slave_2",new Interface("blocking","in"),bus_resp_t);
        auto bus_resp_slave_3 = new Port("val_slave_3",new Interface("blocking","in"),bus_resp_t);

        //Master read
        auto bus_resp_master_0 = new Port("out_master_0",new Interface("blocking","out"),bus_resp_t);
        auto bus_resp_master_1 = new Port("out_master_1",new Interface("blocking","out"),bus_resp_t);
        auto bus_resp_master_2 = new Port("out_master_2",new Interface("blocking","out"),bus_resp_t);
        auto bus_resp_master_3 = new Port("out_master_3",new Interface("blocking","out"),bus_resp_t);

        //add Variables to Module
        module->addVariable(state);
        module->addVariable(master_id);
        module->addVariable(slave_id);
        module->addVariable(req);
        module->addVariable(resp);
        module->addVariable(fromReset);
        module->addPort(bus_req_master_0);
        module->addPort(bus_req_master_1);
        module->addPort(bus_req_master_2);
        module->addPort(bus_req_master_3);
        module->addPort(bus_req_slave_0);
        module->addPort(bus_req_slave_1);
        module->addPort(bus_req_slave_2);
        module->addPort(bus_req_slave_3);
        module->addPort(bus_resp_master_0);
        module->addPort(bus_resp_master_1);
        module->addPort(bus_resp_master_2);
        module->addPort(bus_resp_master_3);
        module->addPort(bus_resp_slave_0);
        module->addPort(bus_resp_slave_1);
        module->addPort(bus_resp_slave_2);
        module->addPort(bus_resp_slave_3);

        for(auto subVar: req->getSubVarList()){
            module->addVariable(subVar);
        }
        for(auto subVar: resp->getSubVarList()){
            module->addVariable(subVar);
        }

        //Master Write Statements
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
        auto master_id_gt_2 = new Relational(new VariableOperand(master_id),">",new UnsignedValue(2));
        auto master_id_gt_3 = new Relational(new VariableOperand(master_id),">",new UnsignedValue(3));
        auto if_master_id_gt_0 = new If(master_id_gt_0);
        auto if_master_id_gt_1 = new If(master_id_gt_1);
        auto if_master_id_gt_2 = new If(master_id_gt_2);
        auto if_master_id_gt_3 = new If(master_id_gt_3);
        //master_id=id
        auto master_id_assign_0 = new Assignment(new VariableOperand(master_id),new UnsignedValue(0));
        auto master_id_assign_1 = new Assignment(new VariableOperand(master_id),new UnsignedValue(1));
        auto master_id_assign_2 = new Assignment(new VariableOperand(master_id),new UnsignedValue(2));
        auto master_id_assign_3 = new Assignment(new VariableOperand(master_id),new UnsignedValue(3));
        //if(val.haddr >= SLAVE0_START && val.haddr <SLAVE0_END)
        auto SLAVE0_START = new UnsignedValue(0x00000000);
        auto SLAVE0_END = new UnsignedValue(0x00010000);
        auto SLAVE1_START = new UnsignedValue(0x00010000);
        auto SLAVE1_END = new UnsignedValue(0x00020000);
        auto SLAVE2_START = new UnsignedValue(0x00020000);
        auto SLAVE2_END = new UnsignedValue(0x00030000);
        auto SLAVE3_START = new UnsignedValue(0x00030000);
        auto SLAVE3_END = new UnsignedValue(0x00040000);

        //Slave 0
        auto val_0_haddr_geq_slave0_start = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),">=",SLAVE0_START);
        assert(bus_req_master_0->getDataSignal()->getPort());
        assert(bus_req_master_0->getDataSignal()->getSubVar("haddr")->getPort());
        auto val_1_haddr_geq_slave0_start = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),">=",SLAVE0_START);
        auto val_2_haddr_geq_slave0_start = new Relational(new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")),">=",SLAVE0_START);
        auto val_3_haddr_geq_slave0_start = new Relational(new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")),">=",SLAVE0_START);

        auto val_0_haddr_lt_slave0_end = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),"<",SLAVE0_END);
        auto val_1_haddr_lt_slave0_end = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),"<",SLAVE0_END);
        auto val_2_haddr_lt_slave0_end = new Relational(new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")),"<",SLAVE0_END);
        auto val_3_haddr_lt_slave0_end = new Relational(new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")),"<",SLAVE0_END);

        auto val_0_slave0 = new Logical(val_0_haddr_geq_slave0_start,"and",val_0_haddr_lt_slave0_end);
        auto val_1_slave0 = new Logical(val_1_haddr_geq_slave0_start,"and",val_1_haddr_lt_slave0_end);
        auto val_2_slave0 = new Logical(val_2_haddr_geq_slave0_start,"and",val_2_haddr_lt_slave0_end);
        auto val_3_slave0 = new Logical(val_3_haddr_geq_slave0_start,"and",val_3_haddr_lt_slave0_end);

        auto if_val_0_slave_0 = new If(val_0_slave0);
        auto if_val_1_slave_0 = new If(val_1_slave0);
        auto if_val_2_slave_0 = new If(val_2_slave0);
        auto if_val_3_slave_0 = new If(val_3_slave0);

        auto slave_id_assign_0 = new Assignment(new VariableOperand(slave_id),new UnsignedValue(0));

        //Slave 1
        auto val_0_haddr_geq_slave1_start = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),">=",SLAVE1_START);
        auto val_1_haddr_geq_slave1_start = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),">=",SLAVE1_START);
        auto val_2_haddr_geq_slave1_start = new Relational(new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")),">=",SLAVE1_START);
        auto val_3_haddr_geq_slave1_start = new Relational(new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")),">=",SLAVE1_START);

        auto val_0_haddr_lt_slave1_end = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),"<",SLAVE1_END);
        auto val_1_haddr_lt_slave1_end = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),"<",SLAVE1_END);
        auto val_2_haddr_lt_slave1_end = new Relational(new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")),"<",SLAVE1_END);
        auto val_3_haddr_lt_slave1_end = new Relational(new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")),"<",SLAVE1_END);

        auto val_0_slave1 = new Logical(val_0_haddr_geq_slave1_start,"and",val_0_haddr_lt_slave1_end);
        auto val_1_slave1 = new Logical(val_1_haddr_geq_slave1_start,"and",val_1_haddr_lt_slave1_end);
        auto val_2_slave1 = new Logical(val_2_haddr_geq_slave1_start,"and",val_2_haddr_lt_slave1_end);
        auto val_3_slave1 = new Logical(val_3_haddr_geq_slave1_start,"and",val_3_haddr_lt_slave1_end);

        auto if_val_0_slave_1 = new If(val_0_slave1);
        auto if_val_1_slave_1 = new If(val_1_slave1);
        auto if_val_2_slave_1 = new If(val_2_slave1);
        auto if_val_3_slave_1 = new If(val_3_slave1);

        auto slave_id_assign_1 = new Assignment(new VariableOperand(slave_id),new UnsignedValue(1));

        //Slave 2
        auto val_0_haddr_geq_slave2_start = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),">=",SLAVE2_START);
        auto val_1_haddr_geq_slave2_start = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),">=",SLAVE2_START);
        auto val_2_haddr_geq_slave2_start = new Relational(new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")),">=",SLAVE2_START);
        auto val_3_haddr_geq_slave2_start = new Relational(new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")),">=",SLAVE2_START);

        auto val_0_haddr_lt_slave2_end = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),"<",SLAVE2_END);
        auto val_1_haddr_lt_slave2_end = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),"<",SLAVE2_END);
        auto val_2_haddr_lt_slave2_end = new Relational(new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")),"<",SLAVE2_END);
        auto val_3_haddr_lt_slave2_end = new Relational(new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")),"<",SLAVE2_END);

        auto val_0_slave2 = new Logical(val_0_haddr_geq_slave2_start,"and",val_0_haddr_lt_slave2_end);
        auto val_1_slave2 = new Logical(val_1_haddr_geq_slave2_start,"and",val_1_haddr_lt_slave2_end);
        auto val_2_slave2 = new Logical(val_2_haddr_geq_slave2_start,"and",val_2_haddr_lt_slave2_end);
        auto val_3_slave2 = new Logical(val_3_haddr_geq_slave2_start,"and",val_3_haddr_lt_slave2_end);

        auto if_val_0_slave_2 = new If(val_0_slave2);
        auto if_val_1_slave_2 = new If(val_1_slave2);
        auto if_val_2_slave_2 = new If(val_2_slave2);
        auto if_val_3_slave_2 = new If(val_3_slave2);

        auto slave_id_assign_2 = new Assignment(new VariableOperand(slave_id),new UnsignedValue(2));

        //Slave 3
        auto val_0_haddr_geq_slave3_start = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),">=",SLAVE3_START);
        auto val_1_haddr_geq_slave3_start = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),">=",SLAVE3_START);
        auto val_2_haddr_geq_slave3_start = new Relational(new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")),">=",SLAVE3_START);
        auto val_3_haddr_geq_slave3_start = new Relational(new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")),">=",SLAVE3_START);

        auto val_0_haddr_lt_slave3_end = new Relational(new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")),"<",SLAVE3_END);
        auto val_1_haddr_lt_slave3_end = new Relational(new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")),"<",SLAVE3_END);
        auto val_2_haddr_lt_slave3_end = new Relational(new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")),"<",SLAVE3_END);
        auto val_3_haddr_lt_slave3_end = new Relational(new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")),"<",SLAVE3_END);

        auto val_0_slave3 = new Logical(val_0_haddr_geq_slave3_start,"and",val_0_haddr_lt_slave3_end);
        auto val_1_slave3 = new Logical(val_1_haddr_geq_slave3_start,"and",val_1_haddr_lt_slave3_end);
        auto val_2_slave3 = new Logical(val_2_haddr_geq_slave3_start,"and",val_2_haddr_lt_slave3_end);
        auto val_3_slave3 = new Logical(val_3_haddr_geq_slave3_start,"and",val_3_haddr_lt_slave3_end);

        auto if_val_0_slave_3 = new If(val_0_slave3);
        auto if_val_1_slave_3 = new If(val_1_slave3);
        auto if_val_2_slave_3 = new If(val_2_slave3);
        auto if_val_3_slave_3 = new If(val_3_slave3);

        auto slave_id_assign_3 = new Assignment(new VariableOperand(slave_id),new UnsignedValue(3));

        //req.hwdata=val.hwdata
        auto req_assign_val0_hwdata = new Assignment(new VariableOperand(req->getSubVar("hwdata")),new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("hwdata")));
        auto req_assign_val1_hwdata = new Assignment(new VariableOperand(req->getSubVar("hwdata")),new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("hwdata")));
        auto req_assign_val2_hwdata = new Assignment(new VariableOperand(req->getSubVar("hwdata")),new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("hwdata")));
        auto req_assign_val3_hwdata = new Assignment(new VariableOperand(req->getSubVar("hwdata")),new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("hwdata")));
        //req.haddr=val.haddr
        auto req_assign_val0_haddr = new Assignment(new VariableOperand(req->getSubVar("haddr")),new DataSignalOperand(bus_req_master_0->getDataSignal()->getSubVar("haddr")));
        auto req_assign_val1_haddr = new Assignment(new VariableOperand(req->getSubVar("haddr")),new DataSignalOperand(bus_req_master_1->getDataSignal()->getSubVar("haddr")));
        auto req_assign_val2_haddr = new Assignment(new VariableOperand(req->getSubVar("haddr")),new DataSignalOperand(bus_req_master_2->getDataSignal()->getSubVar("haddr")));
        auto req_assign_val3_haddr = new Assignment(new VariableOperand(req->getSubVar("haddr")),new DataSignalOperand(bus_req_master_3->getDataSignal()->getSubVar("haddr")));

        //debug
        auto noti = new Notify("Test");
        auto noti_cfg = new CfgNode(noti);
        auto ret = new Return("Return");

        //master_dummy.notify()
        auto master_dummy_notify = new Notify("master_dummy");
        //wait(dummy_master)
        //already implemented as wait_dummy_master

        //if(master_id != id)
        auto master_id_neq_0 = new Relational(new VariableOperand(master_id),"!=",new UnsignedValue(0));
        auto master_id_neq_1 = new Relational(new VariableOperand(master_id),"!=",new UnsignedValue(1));
        auto master_id_neq_2 = new Relational(new VariableOperand(master_id),"!=",new UnsignedValue(2));
        auto master_id_neq_3 = new Relational(new VariableOperand(master_id),"!=",new UnsignedValue(3));

        auto if_master_id_neq_0 = new If(master_id_neq_0);
        auto if_master_id_neq_1 = new If(master_id_neq_1);
        auto if_master_id_neq_2 = new If(master_id_neq_2);
        auto if_master_id_neq_3 = new If(master_id_neq_3);

        //state = SLAVE_REQ
        auto state_assign_SLAVE_REQ = new Assignment(new VariableOperand(state),new EnumValue("SLAVE_REQ",states));

        //master_write_notify.notify()
        auto master_write_notify = new Notify("master_write_notify");

        //return
        auto ret_write_master = new Return("write_master");

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
        auto out_2_assign_req_hwdata = new Assignment(new DataSignalOperand(bus_req_slave_2->getDataSignal()->getSubVar("hwdata")),new VariableOperand(req->getSubVar("hwdata")));
        auto out_3_assign_req_hwdata = new Assignment(new DataSignalOperand(bus_req_slave_3->getDataSignal()->getSubVar("hwdata")),new VariableOperand(req->getSubVar("hwdata")));
        //out.haddr = req.haddr
        auto out_0_assign_req_haddr = new Assignment(new DataSignalOperand(bus_req_slave_0->getDataSignal()->getSubVar("haddr")),new VariableOperand(req->getSubVar("haddr")));
        auto out_1_assign_req_haddr = new Assignment(new DataSignalOperand(bus_req_slave_1->getDataSignal()->getSubVar("haddr")),new VariableOperand(req->getSubVar("haddr")));
        auto out_2_assign_req_haddr = new Assignment(new DataSignalOperand(bus_req_slave_2->getDataSignal()->getSubVar("haddr")),new VariableOperand(req->getSubVar("haddr")));
        auto out_3_assign_req_haddr = new Assignment(new DataSignalOperand(bus_req_slave_3->getDataSignal()->getSubVar("haddr")),new VariableOperand(req->getSubVar("haddr")));

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
        auto resp_assign_val_2_hrdata = new Assignment(new VariableOperand(resp->getSubVar("hrdata")),new DataSignalOperand(bus_resp_slave_2->getDataSignal()->getSubVar("hrdata")));
        auto resp_assign_val_3_hrdata = new Assignment(new VariableOperand(resp->getSubVar("hrdata")),new DataSignalOperand(bus_resp_slave_3->getDataSignal()->getSubVar("hrdata")));
        //resp.hresp = val.hresp
        auto resp_assign_val_0_hresp = new Assignment( new VariableOperand(resp->getSubVar("hresp")),new DataSignalOperand(bus_resp_slave_0->getDataSignal()->getSubVar("hresp")));
        auto resp_assign_val_1_hresp = new Assignment( new VariableOperand(resp->getSubVar("hresp")),new DataSignalOperand(bus_resp_slave_1->getDataSignal()->getSubVar("hresp")));
        auto resp_assign_val_2_hresp = new Assignment( new VariableOperand(resp->getSubVar("hresp")),new DataSignalOperand(bus_resp_slave_2->getDataSignal()->getSubVar("hresp")));
        auto resp_assign_val_3_hresp = new Assignment( new VariableOperand(resp->getSubVar("hresp")),new DataSignalOperand(bus_resp_slave_3->getDataSignal()->getSubVar("hresp")));
        //state = MASTER_RESP
        auto state_assign_MASTER_RESP = new Assignment(new VariableOperand(state),new EnumValue("MASTER_RESP",states));

        //debug
        auto noti3 = new Notify("Test");
        auto noti_cfg3 = new CfgNode(noti);
        auto ret3 = new Return("Return");

        //slave_write_notify.notify()
        auto slave_write_notify = new Notify("slave_write_notify");
        //return
        auto ret_write_slave = new Return("write_slave");
        //wait(slave_read_notify)
        //already implemented as wait_slave_read_notify


        //Master Read
        //if(state != MASTER_RESP)
        auto state_neq_MASTER_RESP = new Relational(new VariableOperand(state),"!=",new EnumValue("MASTER_RESP",states));
        auto if_state_neq_MASTER_RESP = new If(state_neq_MASTER_RESP);
        //wait(slave_write_notify)
        auto wait_slave_write_notify = new Wait("slave_write_notify");
        //if(master_id == id)
        auto master_id_eq_0 = new Relational(new VariableOperand(master_id),"==",new UnsignedValue(0));
        auto master_id_eq_1 = new Relational(new VariableOperand(master_id),"==",new UnsignedValue(1));
        auto master_id_eq_2 = new Relational(new VariableOperand(master_id),"==",new UnsignedValue(2));
        auto master_id_eq_3 = new Relational(new VariableOperand(master_id),"==",new UnsignedValue(3));

        auto if_master_id_eq_0 = new If(master_id_eq_0);
        auto if_master_id_eq_1 = new If(master_id_eq_1);
        auto if_master_id_eq_2 = new If(master_id_eq_2);
        auto if_master_id_eq_3 = new If(master_id_eq_3);

        //out.hrdata = resp.hrdata
        auto out_0_assign_resp_hrdata = new Assignment(new DataSignalOperand(bus_resp_master_0->getDataSignal()->getSubVar("hrdata")),new VariableOperand(resp->getSubVar("hrdata")));
        auto out_1_assign_resp_hrdata = new Assignment(new DataSignalOperand(bus_resp_master_1->getDataSignal()->getSubVar("hrdata")),new VariableOperand(resp->getSubVar("hrdata")));
        auto out_2_assign_resp_hrdata = new Assignment(new DataSignalOperand(bus_resp_master_2->getDataSignal()->getSubVar("hrdata")),new VariableOperand(resp->getSubVar("hrdata")));
        auto out_3_assign_resp_hrdata = new Assignment(new DataSignalOperand(bus_resp_master_3->getDataSignal()->getSubVar("hrdata")),new VariableOperand(resp->getSubVar("hrdata")));
        //out.hresp = resp.hresp
        auto out_0_assign_resp_hresp = new Assignment(new DataSignalOperand(bus_resp_master_0->getDataSignal()->getSubVar("hresp")),new VariableOperand(resp->getSubVar("hresp")));
        auto out_1_assign_resp_hresp = new Assignment(new DataSignalOperand(bus_resp_master_1->getDataSignal()->getSubVar("hresp")),new VariableOperand(resp->getSubVar("hresp")));
        auto out_2_assign_resp_hresp = new Assignment(new DataSignalOperand(bus_resp_master_2->getDataSignal()->getSubVar("hresp")),new VariableOperand(resp->getSubVar("hresp")));
        auto out_3_assign_resp_hresp = new Assignment(new DataSignalOperand(bus_resp_master_3->getDataSignal()->getSubVar("hresp")),new VariableOperand(resp->getSubVar("hresp")));
        //state = MASTER_REQ
        auto state_assign_MASTER_REQ = new Assignment(new VariableOperand(state),new EnumValue("MASTER_REQ",states));
        //master_id = 10
        auto master_id_assign_10 = new Assignment(new VariableOperand(master_id),new UnsignedValue(10));
        //slave_id = 10
        auto slave_id_assign_10 = new Assignment(new VariableOperand(slave_id),new UnsignedValue(10));
        //master_read_notify.notify()

        //debug
        auto noti4 = new Notify("Test");
        auto noti_cfg4 = new CfgNode(noti);
        auto ret4 = new Return("Return");

        auto master_read_notify = new Notify("master_read_notify");
        //return
        auto ret_read_master = new Return("read_master");
        //wait(slave_write_notify)
        //already implemented as wait_slave_write_notify


        //dummyFunc()
        //fromReset = false
        auto fromReset_assign_false = new Assignment(new VariableOperand(fromReset),new BoolValue(false));
        //dummy_master.notify()
        auto dummy_master_notify = new Notify("dummy_master");
        //wait(master_dummy)
        auto wait_master_dummy = new Wait("master_dummy");

        //CFG Master Write 0
        auto check_fromReset_master0 = new CfgNode(if_fromReset);
        auto wait_for_dummy_master0 = new CfgNode(wait_dummy_master);
        auto check_state_MASTER_REQ_master0 = new CfgNode(if_state_neq_MASTER_REQ);
        auto wait_for_read_master0 = new CfgNode(wait_master_read_notify);
        auto check_master_id_master0 = new CfgNode(if_master_id_gt_0);
        auto set_master_id_master0 = new CfgNode(master_id_assign_0);
        auto check_addr_slave0_master0 = new CfgNode(if_val_0_slave_0);
        auto set_slave_id_0_master0 = new CfgNode(slave_id_assign_0);
        auto check_addr_slave1_master0 = new CfgNode(if_val_0_slave_1);
        auto set_slave_id_1_master0 = new CfgNode(slave_id_assign_1);
        auto check_addr_slave2_master0 = new CfgNode(if_val_0_slave_2);
        auto set_slave_id_2_master0 = new CfgNode(slave_id_assign_2);
        auto check_addr_slave3_master0 = new CfgNode(if_val_0_slave_3);
        auto set_slave_id_3_master0 = new CfgNode(slave_id_assign_3);
        auto set_req_hwdata_master0 = new CfgNode(req_assign_val0_hwdata);
        auto set_req_haddr_master0 = new CfgNode(req_assign_val0_haddr);
        auto notify_dummy_master0 = new CfgNode(master_dummy_notify);
        auto wait_dummy_master0 = new CfgNode(wait_dummy_master);
        auto check_master_id_neq_id_master0 = new CfgNode(if_master_id_neq_0);
        auto set_state_SLAVE_REQ_master0 = new CfgNode(state_assign_SLAVE_REQ);
        auto notify_master_write_master0 = new CfgNode(master_write_notify);
        auto return_write_master_master0 = new CfgNode(ret_write_master);
        auto wait_master_read_master0 = new CfgNode(wait_master_read_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapMasterWrite0.insert(std::make_pair(check_fromReset_master0->getId(),check_fromReset_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(wait_for_dummy_master0->getId(),wait_for_dummy_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(check_state_MASTER_REQ_master0->getId(),check_state_MASTER_REQ_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(wait_for_read_master0->getId(),wait_for_read_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(check_master_id_master0->getId(),check_master_id_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(set_master_id_master0->getId(),set_master_id_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(check_addr_slave0_master0->getId(),check_addr_slave0_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(set_slave_id_0_master0->getId(),set_slave_id_0_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(check_addr_slave1_master0->getId(),check_addr_slave1_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(set_slave_id_1_master0->getId(),set_slave_id_1_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(check_addr_slave2_master0->getId(),check_addr_slave2_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(set_slave_id_2_master0->getId(),set_slave_id_2_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(check_addr_slave3_master0->getId(),check_addr_slave3_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(set_slave_id_3_master0->getId(),set_slave_id_3_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(set_req_hwdata_master0->getId(),set_req_hwdata_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(set_req_haddr_master0->getId(),set_req_haddr_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(notify_dummy_master0->getId(),notify_dummy_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(wait_dummy_master0->getId(),wait_dummy_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(check_master_id_neq_id_master0->getId(),check_master_id_neq_id_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(set_state_SLAVE_REQ_master0->getId(),set_state_SLAVE_REQ_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(notify_master_write_master0->getId(),notify_master_write_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(return_write_master_master0->getId(),return_write_master_master0));
        controlFlowMapMasterWrite0.insert(std::make_pair(wait_master_read_master0->getId(),wait_master_read_master0));


        //Link nodes
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
        check_addr_slave0_master0->addSuccessor(check_addr_slave1_master0);
        set_slave_id_0_master0->addSuccessor(set_req_hwdata_master0);
        check_addr_slave1_master0->addSuccessor(set_slave_id_1_master0);
        check_addr_slave1_master0->addSuccessor(check_addr_slave2_master0);
        set_slave_id_1_master0->addSuccessor(set_req_hwdata_master0);
        check_addr_slave2_master0->addSuccessor(set_slave_id_2_master0);
        check_addr_slave2_master0->addSuccessor(check_addr_slave3_master0);
        set_slave_id_2_master0->addSuccessor(set_req_hwdata_master0);
        check_addr_slave3_master0->addSuccessor(set_slave_id_3_master0);
        check_addr_slave3_master0->addSuccessor(set_req_hwdata_master0);
        set_slave_id_3_master0->addSuccessor(set_req_hwdata_master0);
        set_req_hwdata_master0->addSuccessor(set_req_haddr_master0);
        set_req_haddr_master0->addSuccessor(notify_dummy_master0);
        notify_dummy_master0->addSuccessor(wait_dummy_master0);
        wait_dummy_master0->addSuccessor(check_master_id_neq_id_master0);
        check_master_id_neq_id_master0->addSuccessor(check_master_id_master0);
        check_master_id_neq_id_master0->addSuccessor(set_state_SLAVE_REQ_master0);
        set_state_SLAVE_REQ_master0->addSuccessor(notify_master_write_master0);
        notify_master_write_master0->addSuccessor(return_write_master_master0);
        wait_master_read_master0->addSuccessor(check_master_id_master0);

        //CFG Master Write 1
        auto check_fromReset_master1 = new CfgNode(if_fromReset);
        auto wait_for_dummy_master1 = new CfgNode(wait_dummy_master);
        auto check_state_MASTER_REQ_master1 = new CfgNode(if_state_neq_MASTER_REQ);
        auto wait_for_read_master1 = new CfgNode(wait_master_read_notify);
        auto check_master_id_master1 = new CfgNode(if_master_id_gt_1);
        auto set_master_id_master1 = new CfgNode(master_id_assign_1);
        auto check_addr_slave0_master1 = new CfgNode(if_val_1_slave_0);
        auto set_slave_id_0_master1 = new CfgNode(slave_id_assign_0);
        auto check_addr_slave1_master1 = new CfgNode(if_val_1_slave_1);
        auto set_slave_id_1_master1 = new CfgNode(slave_id_assign_1);
        auto check_addr_slave2_master1 = new CfgNode(if_val_1_slave_2);
        auto set_slave_id_2_master1 = new CfgNode(slave_id_assign_2);
        auto check_addr_slave3_master1 = new CfgNode(if_val_1_slave_3);
        auto set_slave_id_3_master1 = new CfgNode(slave_id_assign_3);
        auto set_req_hwdata_master1 = new CfgNode(req_assign_val1_hwdata);
        auto set_req_haddr_master1 = new CfgNode(req_assign_val1_haddr);
        auto notify_dummy_master1 = new CfgNode(master_dummy_notify);
        auto wait_dummy_master1 = new CfgNode(wait_dummy_master);
        auto check_master_id_neq_id_master1 = new CfgNode(if_master_id_neq_1);
        auto set_state_SLAVE_REQ_master1 = new CfgNode(state_assign_SLAVE_REQ);
        auto notify_master_write_master1 = new CfgNode(master_write_notify);
        auto return_write_master_master1 = new CfgNode(ret_write_master);
        auto wait_master_read_master1 = new CfgNode(wait_master_read_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapMasterWrite1.insert(std::make_pair(check_fromReset_master1->getId(),check_fromReset_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(wait_for_dummy_master1->getId(),wait_for_dummy_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(check_state_MASTER_REQ_master1->getId(),check_state_MASTER_REQ_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(wait_for_read_master1->getId(),wait_for_read_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(check_master_id_master1->getId(),check_master_id_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(set_master_id_master1->getId(),set_master_id_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(check_addr_slave0_master1->getId(),check_addr_slave0_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(set_slave_id_0_master1->getId(),set_slave_id_0_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(check_addr_slave1_master1->getId(),check_addr_slave1_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(set_slave_id_1_master1->getId(),set_slave_id_1_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(check_addr_slave2_master1->getId(),check_addr_slave2_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(set_slave_id_2_master1->getId(),set_slave_id_2_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(check_addr_slave3_master1->getId(),check_addr_slave3_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(set_slave_id_3_master1->getId(),set_slave_id_3_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(set_req_hwdata_master1->getId(),set_req_hwdata_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(set_req_haddr_master1->getId(),set_req_haddr_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(notify_dummy_master1->getId(),notify_dummy_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(wait_dummy_master1->getId(),wait_dummy_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(check_master_id_neq_id_master1->getId(),check_master_id_neq_id_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(set_state_SLAVE_REQ_master1->getId(),set_state_SLAVE_REQ_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(notify_master_write_master1->getId(),notify_master_write_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(return_write_master_master1->getId(),return_write_master_master1));
        controlFlowMapMasterWrite1.insert(std::make_pair(wait_master_read_master1->getId(),wait_master_read_master1));

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
        check_addr_slave0_master1->addSuccessor(check_addr_slave1_master1);
        set_slave_id_0_master1->addSuccessor(set_req_hwdata_master1);
        check_addr_slave1_master1->addSuccessor(set_slave_id_1_master1);
        check_addr_slave1_master1->addSuccessor(check_addr_slave2_master1);
        set_slave_id_1_master1->addSuccessor(set_req_hwdata_master1);
        check_addr_slave2_master1->addSuccessor(set_slave_id_2_master1);
        check_addr_slave2_master1->addSuccessor(check_addr_slave3_master1);
        set_slave_id_2_master1->addSuccessor(set_req_hwdata_master1);
        check_addr_slave3_master1->addSuccessor(set_slave_id_3_master1);
        check_addr_slave3_master1->addSuccessor(set_req_hwdata_master1);
        set_slave_id_3_master1->addSuccessor(set_req_hwdata_master1);
        set_req_hwdata_master1->addSuccessor(set_req_haddr_master1);
        set_req_haddr_master1->addSuccessor(notify_dummy_master1);
        notify_dummy_master1->addSuccessor(wait_dummy_master1);
        wait_dummy_master1->addSuccessor(check_master_id_neq_id_master1);
        check_master_id_neq_id_master1->addSuccessor(check_master_id_master1);
        check_master_id_neq_id_master1->addSuccessor(set_state_SLAVE_REQ_master1);
        set_state_SLAVE_REQ_master1->addSuccessor(notify_master_write_master1);
        notify_master_write_master1->addSuccessor(return_write_master_master1);
        wait_master_read_master1->addSuccessor(check_master_id_master1);

        //CFG Master Write 2
        auto check_fromReset_master2 = new CfgNode(if_fromReset);
        auto wait_for_dummy_master2 = new CfgNode(wait_dummy_master);
        auto check_state_MASTER_REQ_master2 = new CfgNode(if_state_neq_MASTER_REQ);
        auto wait_for_read_master2 = new CfgNode(wait_master_read_notify);
        auto check_master_id_master2 = new CfgNode(if_master_id_gt_2);
        auto set_master_id_master2 = new CfgNode(master_id_assign_2);
        auto check_addr_slave0_master2 = new CfgNode(if_val_2_slave_0);
        auto set_slave_id_0_master2 = new CfgNode(slave_id_assign_0);
        auto check_addr_slave1_master2 = new CfgNode(if_val_2_slave_1);
        auto set_slave_id_1_master2 = new CfgNode(slave_id_assign_1);
        auto check_addr_slave2_master2 = new CfgNode(if_val_2_slave_2);
        auto set_slave_id_2_master2 = new CfgNode(slave_id_assign_2);
        auto check_addr_slave3_master2 = new CfgNode(if_val_2_slave_3);
        auto set_slave_id_3_master2 = new CfgNode(slave_id_assign_3);
        auto set_req_hwdata_master2 = new CfgNode(req_assign_val2_hwdata);
        auto set_req_haddr_master2 = new CfgNode(req_assign_val2_haddr);
        auto notify_dummy_master2 = new CfgNode(master_dummy_notify);
        auto wait_dummy_master2 = new CfgNode(wait_dummy_master);
        auto check_master_id_neq_id_master2 = new CfgNode(if_master_id_neq_2);
        auto set_state_SLAVE_REQ_master2 = new CfgNode(state_assign_SLAVE_REQ);
        auto notify_master_write_master2 = new CfgNode(master_write_notify);
        auto return_write_master_master2 = new CfgNode(ret_write_master);
        auto wait_master_read_master2 = new CfgNode(wait_master_read_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapMasterWrite2.insert(std::make_pair(check_fromReset_master2->getId(),check_fromReset_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(wait_for_dummy_master2->getId(),wait_for_dummy_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(check_state_MASTER_REQ_master2->getId(),check_state_MASTER_REQ_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(wait_for_read_master2->getId(),wait_for_read_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(check_master_id_master2->getId(),check_master_id_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(set_master_id_master2->getId(),set_master_id_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(check_addr_slave0_master2->getId(),check_addr_slave0_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(set_slave_id_0_master2->getId(),set_slave_id_0_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(check_addr_slave1_master2->getId(),check_addr_slave1_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(set_slave_id_1_master2->getId(),set_slave_id_1_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(check_addr_slave2_master2->getId(),check_addr_slave2_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(set_slave_id_2_master2->getId(),set_slave_id_2_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(check_addr_slave3_master2->getId(),check_addr_slave3_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(set_slave_id_3_master2->getId(),set_slave_id_3_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(set_req_hwdata_master2->getId(),set_req_hwdata_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(set_req_haddr_master2->getId(),set_req_haddr_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(notify_dummy_master2->getId(),notify_dummy_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(wait_dummy_master2->getId(),wait_dummy_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(check_master_id_neq_id_master2->getId(),check_master_id_neq_id_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(set_state_SLAVE_REQ_master2->getId(),set_state_SLAVE_REQ_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(notify_master_write_master2->getId(),notify_master_write_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(return_write_master_master2->getId(),return_write_master_master2));
        controlFlowMapMasterWrite2.insert(std::make_pair(wait_master_read_master2->getId(),wait_master_read_master2));

        //Link Nodes
        check_fromReset_master2->addSuccessor(wait_for_dummy_master2);
        check_fromReset_master2->addSuccessor(check_state_MASTER_REQ_master2);
        wait_for_dummy_master2->addSuccessor(check_state_MASTER_REQ_master2);
        check_state_MASTER_REQ_master2->addSuccessor(wait_for_read_master2);
        check_state_MASTER_REQ_master2->addSuccessor(check_master_id_master2);
        wait_for_read_master2->addSuccessor(check_master_id_master2);
        check_master_id_master2->addSuccessor(set_master_id_master2);
        check_master_id_master2->addSuccessor(wait_master_read_master2);
        set_master_id_master2->addSuccessor(check_addr_slave0_master2);
        check_addr_slave0_master2->addSuccessor(set_slave_id_0_master2);
        check_addr_slave0_master2->addSuccessor(check_addr_slave1_master2);
        set_slave_id_0_master2->addSuccessor(set_req_hwdata_master2);
        check_addr_slave1_master2->addSuccessor(set_slave_id_1_master2);
        check_addr_slave1_master2->addSuccessor(check_addr_slave2_master2);
        set_slave_id_1_master2->addSuccessor(set_req_hwdata_master2);
        check_addr_slave2_master2->addSuccessor(set_slave_id_2_master2);
        check_addr_slave2_master2->addSuccessor(check_addr_slave3_master2);
        set_slave_id_2_master2->addSuccessor(set_req_hwdata_master2);
        check_addr_slave3_master2->addSuccessor(set_slave_id_3_master2);
        check_addr_slave3_master2->addSuccessor(set_req_hwdata_master2);
        set_slave_id_3_master2->addSuccessor(set_req_hwdata_master2);
        set_req_hwdata_master2->addSuccessor(set_req_haddr_master2);
        set_req_haddr_master2->addSuccessor(notify_dummy_master2);
        notify_dummy_master2->addSuccessor(wait_dummy_master2);
        wait_dummy_master2->addSuccessor(check_master_id_neq_id_master2);
        check_master_id_neq_id_master2->addSuccessor(check_master_id_master2);
        check_master_id_neq_id_master2->addSuccessor(set_state_SLAVE_REQ_master2);
        set_state_SLAVE_REQ_master2->addSuccessor(notify_master_write_master2);
        notify_master_write_master2->addSuccessor(return_write_master_master2);
        wait_master_read_master2->addSuccessor(check_master_id_master2);

        //CFG Master Write 3
        auto check_fromReset_master3 = new CfgNode(if_fromReset);
        auto wait_for_dummy_master3 = new CfgNode(wait_dummy_master);
        auto check_state_MASTER_REQ_master3 = new CfgNode(if_state_neq_MASTER_REQ);
        auto wait_for_read_master3 = new CfgNode(wait_master_read_notify);
        auto check_master_id_master3 = new CfgNode(if_master_id_gt_3);
        auto set_master_id_master3 = new CfgNode(master_id_assign_3);
        auto check_addr_slave0_master3 = new CfgNode(if_val_3_slave_0);
        auto set_slave_id_0_master3 = new CfgNode(slave_id_assign_0);
        auto check_addr_slave1_master3 = new CfgNode(if_val_3_slave_1);
        auto set_slave_id_1_master3 = new CfgNode(slave_id_assign_1);
        auto check_addr_slave2_master3 = new CfgNode(if_val_3_slave_2);
        auto set_slave_id_2_master3 = new CfgNode(slave_id_assign_2);
        auto check_addr_slave3_master3 = new CfgNode(if_val_3_slave_3);
        auto set_slave_id_3_master3 = new CfgNode(slave_id_assign_3);
        auto set_req_hwdata_master3 = new CfgNode(req_assign_val3_hwdata);
        auto set_req_haddr_master3 = new CfgNode(req_assign_val3_haddr);
        auto notify_dummy_master3 = new CfgNode(master_dummy_notify);
        auto wait_dummy_master3 = new CfgNode(wait_dummy_master);
        auto check_master_id_neq_id_master3 = new CfgNode(if_master_id_neq_3);
        auto set_state_SLAVE_REQ_master3 = new CfgNode(state_assign_SLAVE_REQ);
        auto notify_master_write_master3 = new CfgNode(master_write_notify);
        auto return_write_master_master3 = new CfgNode(ret_write_master);
        auto wait_master_read_master3 = new CfgNode(wait_master_read_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapMasterWrite3.insert(std::make_pair(check_fromReset_master3->getId(),check_fromReset_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(wait_for_dummy_master3->getId(),wait_for_dummy_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(check_state_MASTER_REQ_master3->getId(),check_state_MASTER_REQ_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(wait_for_read_master3->getId(),wait_for_read_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(check_master_id_master3->getId(),check_master_id_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(set_master_id_master3->getId(),set_master_id_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(check_addr_slave0_master3->getId(),check_addr_slave0_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(set_slave_id_0_master3->getId(),set_slave_id_0_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(check_addr_slave1_master3->getId(),check_addr_slave1_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(set_slave_id_1_master3->getId(),set_slave_id_1_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(check_addr_slave2_master3->getId(),check_addr_slave2_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(set_slave_id_2_master3->getId(),set_slave_id_2_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(check_addr_slave3_master3->getId(),check_addr_slave3_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(set_slave_id_3_master3->getId(),set_slave_id_3_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(set_req_hwdata_master3->getId(),set_req_hwdata_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(set_req_haddr_master3->getId(),set_req_haddr_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(notify_dummy_master3->getId(),notify_dummy_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(wait_dummy_master3->getId(),wait_dummy_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(check_master_id_neq_id_master3->getId(),check_master_id_neq_id_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(set_state_SLAVE_REQ_master3->getId(),set_state_SLAVE_REQ_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(notify_master_write_master3->getId(),notify_master_write_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(return_write_master_master3->getId(),return_write_master_master3));
        controlFlowMapMasterWrite3.insert(std::make_pair(wait_master_read_master3->getId(),wait_master_read_master3));

        //Link Nodes
        check_fromReset_master3->addSuccessor(wait_for_dummy_master3);
        check_fromReset_master3->addSuccessor(check_state_MASTER_REQ_master3);
        wait_for_dummy_master3->addSuccessor(check_state_MASTER_REQ_master3);
        check_state_MASTER_REQ_master3->addSuccessor(wait_for_read_master3);
        check_state_MASTER_REQ_master3->addSuccessor(check_master_id_master3);
        wait_for_read_master3->addSuccessor(check_master_id_master3);
        check_master_id_master3->addSuccessor(set_master_id_master3);
        check_master_id_master3->addSuccessor(wait_master_read_master3);
        set_master_id_master3->addSuccessor(check_addr_slave0_master3);
        check_addr_slave0_master3->addSuccessor(set_slave_id_0_master3);
        check_addr_slave0_master3->addSuccessor(check_addr_slave1_master3);
        set_slave_id_0_master3->addSuccessor(set_req_hwdata_master3);
        check_addr_slave1_master3->addSuccessor(set_slave_id_1_master3);
        check_addr_slave1_master3->addSuccessor(check_addr_slave2_master3);
        set_slave_id_1_master3->addSuccessor(set_req_hwdata_master3);
        check_addr_slave2_master3->addSuccessor(set_slave_id_2_master3);
        check_addr_slave2_master3->addSuccessor(check_addr_slave3_master3);
        set_slave_id_2_master3->addSuccessor(set_req_hwdata_master3);
        check_addr_slave3_master3->addSuccessor(set_slave_id_3_master3);
        check_addr_slave3_master3->addSuccessor(set_req_hwdata_master3);
        set_slave_id_3_master3->addSuccessor(set_req_hwdata_master3);
        set_req_hwdata_master3->addSuccessor(set_req_haddr_master3);
        set_req_haddr_master3->addSuccessor(notify_dummy_master3);
        notify_dummy_master3->addSuccessor(wait_dummy_master3);
        wait_dummy_master3->addSuccessor(check_master_id_neq_id_master3);
        check_master_id_neq_id_master3->addSuccessor(check_master_id_master3);
        check_master_id_neq_id_master3->addSuccessor(set_state_SLAVE_REQ_master3);
        set_state_SLAVE_REQ_master3->addSuccessor(notify_master_write_master3);
        notify_master_write_master3->addSuccessor(return_write_master_master3);
        wait_master_read_master3->addSuccessor(check_master_id_master3);

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

        //CFG Slave Read 2
        auto check_state_SLAVE_REQ_slave2 = new CfgNode(if_state_neq_SLAVE_REQ);
        auto wait_for_write_slave2 = new CfgNode(wait_master_write_notify);
        auto check_slave_id_slave2 = new CfgNode(if_slave_id_eq_2);
        auto set_out_hwdata_slave2 = new CfgNode(out_2_assign_req_hwdata);
        auto set_out_haddr_slave2 = new CfgNode(out_2_assign_req_haddr);
        auto set_state_SLAVE_RESP_slave2 = new CfgNode(state_assign_SLAVE_RESP);
        auto notify_slave_read_slave2 = new CfgNode(slave_read_notify);
        auto return_read_slave_slave2 = new CfgNode(ret_read_slave);
        auto wait_master_write_slave2 = new CfgNode(wait_master_write_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapSlaveRead2.insert(std::make_pair(check_state_SLAVE_REQ_slave2->getId(),check_state_SLAVE_REQ_slave2));
        controlFlowMapSlaveRead2.insert(std::make_pair(wait_for_write_slave2->getId(),wait_for_write_slave2));
        controlFlowMapSlaveRead2.insert(std::make_pair(check_slave_id_slave2->getId(),check_slave_id_slave2));
        controlFlowMapSlaveRead2.insert(std::make_pair(set_out_hwdata_slave2->getId(),set_out_hwdata_slave2));
        controlFlowMapSlaveRead2.insert(std::make_pair(set_out_haddr_slave2->getId(),set_out_haddr_slave2));
        controlFlowMapSlaveRead2.insert(std::make_pair(set_state_SLAVE_RESP_slave2->getId(),set_state_SLAVE_RESP_slave2));
        controlFlowMapSlaveRead2.insert(std::make_pair(notify_slave_read_slave2->getId(),notify_slave_read_slave2));
        controlFlowMapSlaveRead2.insert(std::make_pair(return_read_slave_slave2->getId(),return_read_slave_slave2));
        controlFlowMapSlaveRead2.insert(std::make_pair(wait_master_write_slave2->getId(),wait_master_write_slave2));

        //Link Nodes
        check_state_SLAVE_REQ_slave2->addSuccessor(wait_for_write_slave2);
        check_state_SLAVE_REQ_slave2->addSuccessor(check_slave_id_slave2);
        wait_for_write_slave2->addSuccessor(check_slave_id_slave2);
        check_slave_id_slave2->addSuccessor(set_out_hwdata_slave2);
        check_slave_id_slave2->addSuccessor(wait_master_write_slave2);
        set_out_hwdata_slave2->addSuccessor(set_out_haddr_slave2);
        set_out_haddr_slave2->addSuccessor(set_state_SLAVE_RESP_slave2);
        set_state_SLAVE_RESP_slave2->addSuccessor(notify_slave_read_slave2);
        notify_slave_read_slave2->addSuccessor(return_read_slave_slave2);
        wait_master_write_slave2->addSuccessor(check_slave_id_slave2);

        //CFG Slave Read 3
        auto check_state_SLAVE_REQ_slave3 = new CfgNode(if_state_neq_SLAVE_REQ);
        auto wait_for_write_slave3 = new CfgNode(wait_master_write_notify);
        auto check_slave_id_slave3 = new CfgNode(if_slave_id_eq_3);
        auto set_out_hwdata_slave3 = new CfgNode(out_3_assign_req_hwdata);
        auto set_out_haddr_slave3 = new CfgNode(out_3_assign_req_haddr);
        auto set_state_SLAVE_RESP_slave3 = new CfgNode(state_assign_SLAVE_RESP);
        auto notify_slave_read_slave3 = new CfgNode(slave_read_notify);
        auto return_read_slave_slave3 = new CfgNode(ret_read_slave);
        auto wait_master_write_slave3 = new CfgNode(wait_master_write_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapSlaveRead3.insert(std::make_pair(check_state_SLAVE_REQ_slave3->getId(),check_state_SLAVE_REQ_slave3));
        controlFlowMapSlaveRead3.insert(std::make_pair(wait_for_write_slave3->getId(),wait_for_write_slave3));
        controlFlowMapSlaveRead3.insert(std::make_pair(check_slave_id_slave3->getId(),check_slave_id_slave3));
        controlFlowMapSlaveRead3.insert(std::make_pair(set_out_hwdata_slave3->getId(),set_out_hwdata_slave3));
        controlFlowMapSlaveRead3.insert(std::make_pair(set_out_haddr_slave3->getId(),set_out_haddr_slave3));
        controlFlowMapSlaveRead3.insert(std::make_pair(set_state_SLAVE_RESP_slave3->getId(),set_state_SLAVE_RESP_slave3));
        controlFlowMapSlaveRead3.insert(std::make_pair(notify_slave_read_slave3->getId(),notify_slave_read_slave3));
        controlFlowMapSlaveRead3.insert(std::make_pair(return_read_slave_slave3->getId(),return_read_slave_slave3));
        controlFlowMapSlaveRead3.insert(std::make_pair(wait_master_write_slave3->getId(),wait_master_write_slave3));

        //Link Nodes
        check_state_SLAVE_REQ_slave3->addSuccessor(wait_for_write_slave3);
        check_state_SLAVE_REQ_slave3->addSuccessor(check_slave_id_slave3);
        wait_for_write_slave3->addSuccessor(check_slave_id_slave3);
        check_slave_id_slave3->addSuccessor(set_out_hwdata_slave3);
        check_slave_id_slave3->addSuccessor(wait_master_write_slave3);
        set_out_hwdata_slave3->addSuccessor(set_out_haddr_slave3);
        set_out_haddr_slave3->addSuccessor(set_state_SLAVE_RESP_slave3);
        set_state_SLAVE_RESP_slave3->addSuccessor(notify_slave_read_slave3);
        notify_slave_read_slave3->addSuccessor(return_read_slave_slave3);
        wait_master_write_slave3->addSuccessor(check_slave_id_slave3);

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

        //CFG Slave Write 2
        auto check_state_SLAVE_RESP_slave2 = new CfgNode(if_state_neq_SLAVE_RESP);
        auto wait_for_read_slave2 = new CfgNode(wait_slave_read_notify);
        auto check_slave_id_write_slave2 = new CfgNode(if_slave_id_eq_2);
        auto set_resp_hrdata_slave2 = new CfgNode(resp_assign_val_2_hrdata);
        auto set_resp_hresp_slave2 = new CfgNode(resp_assign_val_2_hresp);
        auto set_state_MASTER_RESP_slave2 = new CfgNode(state_assign_MASTER_RESP);
        auto notify_slave_write_slave2 = new CfgNode(slave_write_notify);
        auto return_write_slave_slave2 = new CfgNode(ret_write_slave);
        auto wait_slave_read_slave2 = new CfgNode(wait_slave_read_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapSlaveWrite2.insert(std::make_pair(check_state_SLAVE_RESP_slave2->getId(),check_state_SLAVE_RESP_slave2));
        controlFlowMapSlaveWrite2.insert(std::make_pair(wait_for_read_slave2->getId(),wait_for_read_slave2));
        controlFlowMapSlaveWrite2.insert(std::make_pair(check_slave_id_write_slave2->getId(),check_slave_id_write_slave2));
        controlFlowMapSlaveWrite2.insert(std::make_pair(set_resp_hrdata_slave2->getId(),set_resp_hrdata_slave2));
        controlFlowMapSlaveWrite2.insert(std::make_pair(set_resp_hresp_slave2->getId(),set_resp_hresp_slave2));
        controlFlowMapSlaveWrite2.insert(std::make_pair(set_state_MASTER_RESP_slave2->getId(),set_state_MASTER_RESP_slave2));
        controlFlowMapSlaveWrite2.insert(std::make_pair(notify_slave_write_slave2->getId(),notify_slave_write_slave2));
        controlFlowMapSlaveWrite2.insert(std::make_pair(return_write_slave_slave2->getId(),return_write_slave_slave2));
        controlFlowMapSlaveWrite2.insert(std::make_pair(wait_slave_read_slave2->getId(),wait_slave_read_slave2));

        //Link Nodes
        check_state_SLAVE_RESP_slave2->addSuccessor(wait_for_read_slave2);
        check_state_SLAVE_RESP_slave2->addSuccessor(check_slave_id_write_slave2);
        wait_for_read_slave2->addSuccessor(check_slave_id_write_slave2);
        check_slave_id_write_slave2->addSuccessor(set_resp_hrdata_slave2);
        check_slave_id_write_slave2->addSuccessor(wait_slave_read_slave2);
        set_resp_hrdata_slave2->addSuccessor(set_resp_hresp_slave2);
        set_resp_hresp_slave2->addSuccessor(set_state_MASTER_RESP_slave2);
        set_state_MASTER_RESP_slave2->addSuccessor(notify_slave_write_slave2);
        notify_slave_write_slave2->addSuccessor(return_write_slave_slave2);
        wait_slave_read_slave2->addSuccessor(check_slave_id_write_slave2);

        //CFG Slave Write 3
        auto check_state_SLAVE_RESP_slave3 = new CfgNode(if_state_neq_SLAVE_RESP);
        auto wait_for_read_slave3 = new CfgNode(wait_slave_read_notify);
        auto check_slave_id_write_slave3 = new CfgNode(if_slave_id_eq_3);
        auto set_resp_hrdata_slave3 = new CfgNode(resp_assign_val_3_hrdata);
        auto set_resp_hresp_slave3 = new CfgNode(resp_assign_val_3_hresp);
        auto set_state_MASTER_RESP_slave3 = new CfgNode(state_assign_MASTER_RESP);
        auto notify_slave_write_slave3 = new CfgNode(slave_write_notify);
        auto return_write_slave_slave3 = new CfgNode(ret_write_slave);
        auto wait_slave_read_slave3 = new CfgNode(wait_slave_read_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapSlaveWrite3.insert(std::make_pair(check_state_SLAVE_RESP_slave3->getId(),check_state_SLAVE_RESP_slave3));
        controlFlowMapSlaveWrite3.insert(std::make_pair(wait_for_read_slave3->getId(),wait_for_read_slave3));
        controlFlowMapSlaveWrite3.insert(std::make_pair(check_slave_id_write_slave3->getId(),check_slave_id_write_slave3));
        controlFlowMapSlaveWrite3.insert(std::make_pair(set_resp_hrdata_slave3->getId(),set_resp_hrdata_slave3));
        controlFlowMapSlaveWrite3.insert(std::make_pair(set_resp_hresp_slave3->getId(),set_resp_hresp_slave3));
        controlFlowMapSlaveWrite3.insert(std::make_pair(set_state_MASTER_RESP_slave3->getId(),set_state_MASTER_RESP_slave3));
        controlFlowMapSlaveWrite3.insert(std::make_pair(notify_slave_write_slave3->getId(),notify_slave_write_slave3));
        controlFlowMapSlaveWrite3.insert(std::make_pair(return_write_slave_slave3->getId(),return_write_slave_slave3));
        controlFlowMapSlaveWrite3.insert(std::make_pair(wait_slave_read_slave3->getId(),wait_slave_read_slave3));

        //Link Nodes
        check_state_SLAVE_RESP_slave3->addSuccessor(wait_for_read_slave3);
        check_state_SLAVE_RESP_slave3->addSuccessor(check_slave_id_write_slave3);
        wait_for_read_slave3->addSuccessor(check_slave_id_write_slave3);
        check_slave_id_write_slave3->addSuccessor(set_resp_hrdata_slave3);
        check_slave_id_write_slave3->addSuccessor(wait_slave_read_slave3);
        set_resp_hrdata_slave3->addSuccessor(set_resp_hresp_slave3);
        set_resp_hresp_slave3->addSuccessor(set_state_MASTER_RESP_slave3);
        set_state_MASTER_RESP_slave3->addSuccessor(notify_slave_write_slave3);
        notify_slave_write_slave3->addSuccessor(return_write_slave_slave3);
        wait_slave_read_slave3->addSuccessor(check_slave_id_write_slave3);

        //CFG Master Read 0
        auto check_state_MASTER_RESP_master0 = new CfgNode(if_state_neq_MASTER_RESP);
        auto wait_for_write_master0 = new CfgNode(wait_slave_write_notify);
        auto check_master_id_read_master0 = new CfgNode(if_master_id_eq_0);
        auto set_out_hrdata_master0 = new CfgNode(out_0_assign_resp_hrdata);
        auto set_out_hresp_master0 = new CfgNode(out_0_assign_resp_hresp);
        auto set_state_MASTER_REQ_master0 = new CfgNode(state_assign_MASTER_REQ);
        auto set_master_id_10_master0 = new CfgNode(master_id_assign_10);
        auto set_slave_id_10_master0 = new CfgNode(slave_id_assign_10);
        auto notify_master_read_master0 = new CfgNode(master_read_notify);
        auto return_read_master_master0 = new CfgNode(ret_read_master);
        auto wait_slave_write_master0 = new CfgNode(wait_slave_write_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapMasterRead0.insert(std::make_pair(check_state_MASTER_RESP_master0->getId(),check_state_MASTER_RESP_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(wait_for_write_master0->getId(),wait_for_write_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(check_master_id_read_master0->getId(),check_master_id_read_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(set_out_hrdata_master0->getId(),set_out_hrdata_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(set_out_hresp_master0->getId(),set_out_hresp_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(set_state_MASTER_REQ_master0->getId(),set_state_MASTER_REQ_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(set_master_id_10_master0->getId(),set_master_id_10_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(set_slave_id_10_master0->getId(),set_slave_id_10_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(notify_master_read_master0->getId(),notify_master_read_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(return_read_master_master0->getId(),return_read_master_master0));
        controlFlowMapMasterRead0.insert(std::make_pair(wait_slave_write_master0->getId(),wait_slave_write_master0));

        check_state_MASTER_RESP_master0->addSuccessor(wait_for_write_master0);
        check_state_MASTER_RESP_master0->addSuccessor(check_master_id_read_master0);
        wait_for_write_master0->addSuccessor(check_master_id_read_master0);
        check_master_id_read_master0->addSuccessor(set_out_hrdata_master0);
        check_master_id_read_master0->addSuccessor(wait_slave_write_master0);
        set_out_hrdata_master0->addSuccessor(set_out_hresp_master0);
        set_out_hresp_master0->addSuccessor(set_state_MASTER_REQ_master0);
        set_state_MASTER_REQ_master0->addSuccessor(set_master_id_10_master0);
        set_master_id_10_master0->addSuccessor(set_slave_id_10_master0);
        set_slave_id_10_master0->addSuccessor(notify_master_read_master0);
        notify_master_read_master0->addSuccessor(return_read_master_master0);
        wait_slave_write_master0->addSuccessor(check_master_id_read_master0);

        //CFG Master Read 1
        auto check_state_MASTER_RESP_master1 = new CfgNode(if_state_neq_MASTER_RESP);
        auto wait_for_write_master1 = new CfgNode(wait_slave_write_notify);
        auto check_master_id_read_master1 = new CfgNode(if_master_id_eq_1);
        auto set_out_hrdata_master1 = new CfgNode(out_1_assign_resp_hrdata);
        auto set_out_hresp_master1 = new CfgNode(out_1_assign_resp_hresp);
        auto set_state_MASTER_REQ_master1 = new CfgNode(state_assign_MASTER_REQ);
        auto set_master_id_10_master1 = new CfgNode(master_id_assign_10);
        auto set_slave_id_10_master1 = new CfgNode(slave_id_assign_10);
        auto notify_master_read_master1 = new CfgNode(master_read_notify);
        auto return_read_master_master1 = new CfgNode(ret_read_master);
        auto wait_slave_write_master1 = new CfgNode(wait_slave_write_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapMasterRead1.insert(std::make_pair(check_state_MASTER_RESP_master1->getId(),check_state_MASTER_RESP_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(wait_for_write_master1->getId(),wait_for_write_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(check_master_id_read_master1->getId(),check_master_id_read_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(set_out_hrdata_master1->getId(),set_out_hrdata_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(set_out_hresp_master1->getId(),set_out_hresp_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(set_state_MASTER_REQ_master1->getId(),set_state_MASTER_REQ_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(set_master_id_10_master1->getId(),set_master_id_10_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(set_slave_id_10_master1->getId(),set_slave_id_10_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(notify_master_read_master1->getId(),notify_master_read_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(return_read_master_master1->getId(),return_read_master_master1));
        controlFlowMapMasterRead1.insert(std::make_pair(wait_slave_write_master1->getId(),wait_slave_write_master1));

        check_state_MASTER_RESP_master1->addSuccessor(wait_for_write_master1);
        check_state_MASTER_RESP_master1->addSuccessor(check_master_id_read_master1);
        wait_for_write_master1->addSuccessor(check_master_id_read_master1);
        check_master_id_read_master1->addSuccessor(set_out_hrdata_master1);
        check_master_id_read_master1->addSuccessor(wait_slave_write_master1);
        set_out_hrdata_master1->addSuccessor(set_out_hresp_master1);
        set_out_hresp_master1->addSuccessor(set_state_MASTER_REQ_master1);
        set_state_MASTER_REQ_master1->addSuccessor(set_master_id_10_master1);
        set_master_id_10_master1->addSuccessor(set_slave_id_10_master1);
        set_slave_id_10_master1->addSuccessor(notify_master_read_master1);
        notify_master_read_master1->addSuccessor(return_read_master_master1);
        wait_slave_write_master1->addSuccessor(check_master_id_read_master1);

        //CFG Master Read 2
        auto check_state_MASTER_RESP_master2 = new CfgNode(if_state_neq_MASTER_RESP);
        auto wait_for_write_master2 = new CfgNode(wait_slave_write_notify);
        auto check_master_id_read_master2 = new CfgNode(if_master_id_eq_2);
        auto set_out_hrdata_master2 = new CfgNode(out_2_assign_resp_hrdata);
        auto set_out_hresp_master2 = new CfgNode(out_2_assign_resp_hresp);
        auto set_state_MASTER_REQ_master2 = new CfgNode(state_assign_MASTER_REQ);
        auto set_master_id_10_master2 = new CfgNode(master_id_assign_10);
        auto set_slave_id_10_master2 = new CfgNode(slave_id_assign_10);
        auto notify_master_read_master2 = new CfgNode(master_read_notify);
        auto return_read_master_master2 = new CfgNode(ret_read_master);
        auto wait_slave_write_master2 = new CfgNode(wait_slave_write_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapMasterRead2.insert(std::make_pair(check_state_MASTER_RESP_master2->getId(),check_state_MASTER_RESP_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(wait_for_write_master2->getId(),wait_for_write_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(check_master_id_read_master2->getId(),check_master_id_read_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(set_out_hrdata_master2->getId(),set_out_hrdata_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(set_out_hresp_master2->getId(),set_out_hresp_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(set_state_MASTER_REQ_master2->getId(),set_state_MASTER_REQ_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(set_master_id_10_master2->getId(),set_master_id_10_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(set_slave_id_10_master2->getId(),set_slave_id_10_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(notify_master_read_master2->getId(),notify_master_read_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(return_read_master_master2->getId(),return_read_master_master2));
        controlFlowMapMasterRead2.insert(std::make_pair(wait_slave_write_master2->getId(),wait_slave_write_master2));

        check_state_MASTER_RESP_master2->addSuccessor(wait_for_write_master2);
        check_state_MASTER_RESP_master2->addSuccessor(check_master_id_read_master2);
        wait_for_write_master2->addSuccessor(check_master_id_read_master2);
        check_master_id_read_master2->addSuccessor(set_out_hrdata_master2);
        check_master_id_read_master2->addSuccessor(wait_slave_write_master2);
        set_out_hrdata_master2->addSuccessor(set_out_hresp_master2);
        set_out_hresp_master2->addSuccessor(set_state_MASTER_REQ_master2);
        set_state_MASTER_REQ_master2->addSuccessor(set_master_id_10_master2);
        set_master_id_10_master2->addSuccessor(set_slave_id_10_master2);
        set_slave_id_10_master2->addSuccessor(notify_master_read_master2);
        notify_master_read_master2->addSuccessor(return_read_master_master2);
        wait_slave_write_master2->addSuccessor(check_master_id_read_master2);

        //CFG Master Read 3
        auto check_state_MASTER_RESP_master3 = new CfgNode(if_state_neq_MASTER_RESP);
        auto wait_for_write_master3 = new CfgNode(wait_slave_write_notify);
        auto check_master_id_read_master3 = new CfgNode(if_master_id_eq_3);
        auto set_out_hrdata_master3 = new CfgNode(out_3_assign_resp_hrdata);
        auto set_out_hresp_master3 = new CfgNode(out_3_assign_resp_hresp);
        auto set_state_MASTER_REQ_master3 = new CfgNode(state_assign_MASTER_REQ);
        auto set_master_id_10_master3 = new CfgNode(master_id_assign_10);
        auto set_slave_id_10_master3 = new CfgNode(slave_id_assign_10);
        auto notify_master_read_master3 = new CfgNode(master_read_notify);
        auto return_read_master_master3 = new CfgNode(ret_read_master);
        auto wait_slave_write_master3 = new CfgNode(wait_slave_write_notify);

        //Add Nodes to ControlFlowMap
        controlFlowMapMasterRead3.insert(std::make_pair(check_state_MASTER_RESP_master3->getId(),check_state_MASTER_RESP_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(wait_for_write_master3->getId(),wait_for_write_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(check_master_id_read_master3->getId(),check_master_id_read_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(set_out_hrdata_master3->getId(),set_out_hrdata_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(set_out_hresp_master3->getId(),set_out_hresp_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(set_state_MASTER_REQ_master3->getId(),set_state_MASTER_REQ_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(set_master_id_10_master3->getId(),set_master_id_10_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(set_slave_id_10_master3->getId(),set_slave_id_10_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(notify_master_read_master3->getId(),notify_master_read_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(return_read_master_master3->getId(),return_read_master_master3));
        controlFlowMapMasterRead3.insert(std::make_pair(wait_slave_write_master3->getId(),wait_slave_write_master3));

        check_state_MASTER_RESP_master3->addSuccessor(wait_for_write_master3);
        check_state_MASTER_RESP_master3->addSuccessor(check_master_id_read_master3);
        wait_for_write_master3->addSuccessor(check_master_id_read_master3);
        check_master_id_read_master3->addSuccessor(set_out_hrdata_master3);
        check_master_id_read_master3->addSuccessor(wait_slave_write_master3);
        set_out_hrdata_master3->addSuccessor(set_out_hresp_master3);
        set_out_hresp_master3->addSuccessor(set_state_MASTER_REQ_master3);
        set_state_MASTER_REQ_master3->addSuccessor(set_master_id_10_master3);
        set_master_id_10_master3->addSuccessor(set_slave_id_10_master3);
        set_slave_id_10_master3->addSuccessor(notify_master_read_master3);
        notify_master_read_master3->addSuccessor(return_read_master_master3);
        wait_slave_write_master3->addSuccessor(check_master_id_read_master3);

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
        for(auto node: controlFlowMapMasterWrite0){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapMasterWrite1){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapMasterWrite2){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapMasterWrite3){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveRead0){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveRead1){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveRead2){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveRead3){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveWrite0){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveWrite1){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveWrite2){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapSlaveWrite3){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapMasterRead0){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapMasterRead1){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapMasterRead2){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }
        for(auto node: controlFlowMapMasterRead3){
            controlFlowMap.insert(std::make_pair(node.first,node.second));
        }

//        //Print CFG for MasterWrite
//        std::cout << printCFG(controlFlowMapMasterWrite0) << std::endl;
//        std::cout << printCFG(controlFlowMapMasterWrite1) << std::endl;
//        std::cout << printCFG(controlFlowMapMasterWrite2) << std::endl;
//        std::cout << printCFG(controlFlowMapMasterWrite3) << std::endl;
//
//        //Print CFG for SlaveRead
//        std::cout << printCFG(controlFlowMapSlaveRead0) << std::endl;
//        std::cout << printCFG(controlFlowMapSlaveRead1) << std::endl;
//        std::cout << printCFG(controlFlowMapSlaveRead2) << std::endl;
//        std::cout << printCFG(controlFlowMapSlaveRead3) << std::endl;
//
//        //Print CFG for SlaveWrite
//        std::cout << printCFG(controlFlowMapSlaveWrite0) << std::endl;
//        std::cout << printCFG(controlFlowMapSlaveWrite1) << std::endl;
//        std::cout << printCFG(controlFlowMapSlaveWrite2) << std::endl;
//        std::cout << printCFG(controlFlowMapSlaveWrite3) << std::endl;
//
//        //Print CFG for MasterRead
//        std::cout << printCFG(controlFlowMapMasterRead0) << std::endl;
//        std::cout << printCFG(controlFlowMapMasterRead1) << std::endl;
//        std::cout << printCFG(controlFlowMapMasterRead2) << std::endl;
//        std::cout << printCFG(controlFlowMapMasterRead3) << std::endl;
//
//        //Print CFG Dummy
//        std::cout << printCFG(controlFlowMapDummy) << std::endl;

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

        //set start and end nodes
        eventID temp;
        temp = {4,"master0_write_sync"};
        startnodes.push_back(temp);
        temp = {27,"master1_write_sync"};
        startnodes.push_back(temp);
        temp = {50,"master2_write_sync"};
        startnodes.push_back(temp);
        temp = {73,"master3_write_sync"};
        startnodes.push_back(temp);
        temp = {96,"slave0_read_sync"};
        startnodes.push_back(temp);
        temp = {105,"slave1_read_sync"};
        startnodes.push_back(temp);
        temp = {114,"slave2_read_sync"};
        startnodes.push_back(temp);
        temp = {123,"slave3_read_sync"};
        startnodes.push_back(temp);
        temp = {132,"slave0_write_sync"};
        startnodes.push_back(temp);
        temp = {141,"slave1_write_sync"};
        startnodes.push_back(temp);
        temp = {150,"slave2_write_sync"};
        startnodes.push_back(temp);
        temp = {159,"slave3_write_sync"};
        startnodes.push_back(temp);
        temp = {168,"master0_read_sync"};
        startnodes.push_back(temp);
        temp = {179,"master1_read_sync"};
        startnodes.push_back(temp);
        temp = {190,"master2_read_sync"};
        startnodes.push_back(temp);
        temp = {201,"master3_read_sync"};
        startnodes.push_back(temp);

        temp = {25,"master0_write_notify"};
        endnodes.push_back(temp);
        temp = {48,"master1_write_notify"};
        endnodes.push_back(temp);
        temp = {71,"master2_write_notify"};
        endnodes.push_back(temp);
        temp = {94,"master3_write_notify"};
        endnodes.push_back(temp);
        temp = {103,"slave0_read_notify"};
        endnodes.push_back(temp);
        temp = {112,"slave1_read_notify"};
        endnodes.push_back(temp);
        temp = {121,"slave2_read_notify"};
        endnodes.push_back(temp);
        temp = {130,"slave3_read_notify"};
        endnodes.push_back(temp);
        temp = {139,"slave0_write_notify"};
        endnodes.push_back(temp);
        temp = {148,"slave1_write_notify"};
        endnodes.push_back(temp);
        temp = {157,"slave2_write_notify"};
        endnodes.push_back(temp);
        temp = {166,"slave3_write_notify"};
        endnodes.push_back(temp);
        temp = {177,"master0_read_notify"};
        endnodes.push_back(temp);
        temp = {188,"master1_read_notify"};
        endnodes.push_back(temp);
        temp = {199,"master2_read_notify"};
        endnodes.push_back(temp);
        temp = {210,"master3_read_notify"};
        endnodes.push_back(temp);

    }

    virtual void TearDown() {}

};

TEST_F(OperationGraphTest, ExtractPaths){
    //Find important states MasterWrite0
    std::map<int, CfgNode *> importantStatesMasterWrite0;
    findImportantStates(controlFlowMapMasterWrite0,&importantStatesMasterWrite0);

    //Find paths MasterWrite0
    auto start_MasterWrite0 = controlFlowMapMasterWrite0.begin()->second;
    findPathsfromNode(start_MasterWrite0,&pathsMasterWrite0,&pathsMasterWrite0IDs);
    for(auto const& node : importantStatesMasterWrite0) {
        findPathsfromNode(node.second,&pathsMasterWrite0,&pathsMasterWrite0IDs);
    }

    //Find important states MasterWrite1
    std::map<int, CfgNode *> importantStatesMasterWrite1;
    findImportantStates(controlFlowMapMasterWrite1,&importantStatesMasterWrite1);

    //Find paths MasterWrite1
    auto start_MasterWrite1 = controlFlowMapMasterWrite1.begin()->second;
    findPathsfromNode(start_MasterWrite1,&pathsMasterWrite1,&pathsMasterWrite1IDs);
    for(auto const& node : importantStatesMasterWrite1) {
        findPathsfromNode(node.second,&pathsMasterWrite1,&pathsMasterWrite1IDs);
    }

    //Find important states MasterWrite2
    std::map<int, CfgNode *> importantStatesMasterWrite2;
    findImportantStates(controlFlowMapMasterWrite2,&importantStatesMasterWrite2);

    //Find paths MasterWrite2
    auto start_MasterWrite2 = controlFlowMapMasterWrite2.begin()->second;
    findPathsfromNode(start_MasterWrite2,&pathsMasterWrite2,&pathsMasterWrite2IDs);
    for(auto const& node : importantStatesMasterWrite2) {
        findPathsfromNode(node.second,&pathsMasterWrite2,&pathsMasterWrite2IDs);
    }

    //Find important states MasterWrite3
    std::map<int, CfgNode *> importantStatesMasterWrite3;
    findImportantStates(controlFlowMapMasterWrite3,&importantStatesMasterWrite3);

    //Find paths MasterWrite3
    auto start_MasterWrite3 = controlFlowMapMasterWrite3.begin()->second;
    findPathsfromNode(start_MasterWrite3,&pathsMasterWrite3,&pathsMasterWrite3IDs);
    for(auto const& node : importantStatesMasterWrite3) {
        findPathsfromNode(node.second,&pathsMasterWrite3,&pathsMasterWrite3IDs);
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

    //Find important states SlaveRead2
    std::map<int, CfgNode *> importantStatesSlaveRead2;
    findImportantStates(controlFlowMapSlaveRead2,&importantStatesSlaveRead2);

    //Find paths SlaveRead2
    auto start_SlaveRead2 = controlFlowMapSlaveRead2.begin()->second;
    findPathsfromNode(start_SlaveRead2,&pathsSlaveRead2,&pathsSlaveRead2IDs);
    for(auto const& node : importantStatesSlaveRead2) {
        findPathsfromNode(node.second,&pathsSlaveRead2,&pathsSlaveRead2IDs);
    }

    //Find important states SlaveRead3
    std::map<int, CfgNode *> importantStatesSlaveRead3;
    findImportantStates(controlFlowMapSlaveRead3,&importantStatesSlaveRead3);

    //Find paths SlaveRead3
    auto start_SlaveRead3 = controlFlowMapSlaveRead3.begin()->second;
    findPathsfromNode(start_SlaveRead3,&pathsSlaveRead3,&pathsSlaveRead3IDs);
    for(auto const& node : importantStatesSlaveRead3) {
        findPathsfromNode(node.second,&pathsSlaveRead3,&pathsSlaveRead3IDs);
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

    //Find important states SlaveWrite2
    std::map<int, CfgNode *> importantStatesSlaveWrite2;
    findImportantStates(controlFlowMapSlaveWrite2,&importantStatesSlaveWrite2);

    //Find paths SlaveWrite2
    auto start_SlaveWrite2 = controlFlowMapSlaveWrite2.begin()->second;
    findPathsfromNode(start_SlaveWrite2,&pathsSlaveWrite2,&pathsSlaveWrite2IDs);
    for(auto const& node : importantStatesSlaveWrite2) {
        findPathsfromNode(node.second,&pathsSlaveWrite2,&pathsSlaveWrite2IDs);
    }

    //Find important states SlaveWrite3
    std::map<int, CfgNode *> importantStatesSlaveWrite3;
    findImportantStates(controlFlowMapSlaveWrite3,&importantStatesSlaveWrite3);

    //Find paths SlaveWrite3
    auto start_SlaveWrite3 = controlFlowMapSlaveWrite3.begin()->second;
    findPathsfromNode(start_SlaveWrite3,&pathsSlaveWrite3,&pathsSlaveWrite3IDs);
    for(auto const& node : importantStatesSlaveWrite3) {
        findPathsfromNode(node.second,&pathsSlaveWrite3,&pathsSlaveWrite3IDs);
    }

    //Find important states MasterRead0
    std::map<int, CfgNode *> importantStatesMasterRead0;
    findImportantStates(controlFlowMapMasterRead0,&importantStatesMasterRead0);

    //Find paths MasterRead0
    auto start_MasterRead0 = controlFlowMapMasterRead0.begin()->second;
    findPathsfromNode(start_MasterRead0,&pathsMasterRead0,&pathsMasterRead0IDs);
    for(auto const& node : importantStatesMasterRead0) {
        findPathsfromNode(node.second,&pathsMasterRead0,&pathsMasterRead0IDs);
    }

    //Find important states MasterRead1
    std::map<int, CfgNode *> importantStatesMasterRead1;
    findImportantStates(controlFlowMapMasterRead1,&importantStatesMasterRead1);

    //Find paths MasterRead1
    auto start_MasterRead1 = controlFlowMapMasterRead1.begin()->second;
    findPathsfromNode(start_MasterRead1,&pathsMasterRead1,&pathsMasterRead1IDs);
    for(auto const& node : importantStatesMasterRead1) {
        findPathsfromNode(node.second,&pathsMasterRead1,&pathsMasterRead1IDs);
    }

    //Find important states MasterRead2
    std::map<int, CfgNode *> importantStatesMasterRead2;
    findImportantStates(controlFlowMapMasterRead2,&importantStatesMasterRead2);

    //Find paths MasterRead2
    auto start_MasterRead2 = controlFlowMapMasterRead2.begin()->second;
    findPathsfromNode(start_MasterRead2,&pathsMasterRead2,&pathsMasterRead2IDs);
    for(auto const& node : importantStatesMasterRead2) {
        findPathsfromNode(node.second,&pathsMasterRead2,&pathsMasterRead2IDs);
    }

    //Find important states MasterRead3
    std::map<int, CfgNode *> importantStatesMasterRead3;
    findImportantStates(controlFlowMapMasterRead3,&importantStatesMasterRead3);

    //Find paths MasterRead3
    auto start_MasterRead3 = controlFlowMapMasterRead3.begin()->second;
    findPathsfromNode(start_MasterRead3,&pathsMasterRead3,&pathsMasterRead3IDs);
    for(auto const& node : importantStatesMasterRead3) {
        findPathsfromNode(node.second,&pathsMasterRead3,&pathsMasterRead3IDs);
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
    eventID MasterWrite0 = {4,"MasterWrite0"};
    eventID MasterWrite1 = {27,"MasterWrite1"};
    eventID MasterWrite2 = {50,"MasterWrite2"};
    eventID MasterWrite3 = {73,"MasterWrite3"};
    eventID SlaveRead0 = {96,"SlaveRead0"};
    eventID SlaveRead1 = {105,"SlaveRead1"};
    eventID SlaveRead2 = {114,"SlaveRead2"};
    eventID SlaveRead3 = {123,"SlaveRead3"};
    eventID SlaveWrite0 = {132,"SlaveWrite0"};
    eventID SlaveWrite1 = {141,"SlaveWrite1"};
    eventID SlaveWrite2 = {150,"SlaveWrite2"};
    eventID SlaveWrite3 = {159,"SlaveWrite3"};
    eventID MasterRead0 = {168,"MasterRead0"};
    eventID MasterRead1 = {179,"MasterRead1"};
    eventID MasterRead2 = {190,"MasterRead2"};
    eventID MasterRead3 = {201,"MasterRead3"};
    eventID dummy = {212,"dummy"};

    //vector of all functions that are always ready to execute
    std::vector<eventID> always_ready;
    always_ready.push_back(dummy);

    //Vector of all functions that can be called from modules
    std::vector<eventID> functions;
    functions.push_back(MasterWrite0);
    functions.push_back(MasterWrite1);
    functions.push_back(MasterWrite2);
    functions.push_back(MasterWrite3);
    functions.push_back(SlaveRead0);
    functions.push_back(SlaveRead1);
    functions.push_back(SlaveRead2);
    functions.push_back(SlaveRead3);
    functions.push_back(SlaveWrite0);
    functions.push_back(SlaveWrite1);
    functions.push_back(SlaveWrite2);
    functions.push_back(SlaveWrite3);
    functions.push_back(MasterRead0);
    functions.push_back(MasterRead1);
    functions.push_back(MasterRead2);
    functions.push_back(MasterRead3);

    //compute all possible permutations and store them in variable permutations
    computePermutations(functions);

    //add all functions from always_ready to all permuations
    for(auto readyFunc : always_ready){
        for(auto perm: permutations){
            perm.push_back(readyFunc);
        }
    }
    //construct a vector of all paths by pushing all paths to allPaths
    for(int i=0; i<pathsMasterWrite0IDs.size();i++){
        pathIDStmt p = {pathsMasterWrite0IDs.at(i),pathsMasterWrite0.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsMasterWrite1IDs.size();i++){
        pathIDStmt p = {pathsMasterWrite1IDs.at(i),pathsMasterWrite1.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsMasterWrite2IDs.size();i++){
        pathIDStmt p = {pathsMasterWrite2IDs.at(i),pathsMasterWrite2.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsMasterWrite3IDs.size();i++){
        pathIDStmt p = {pathsMasterWrite3IDs.at(i),pathsMasterWrite3.at(i)};
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
    for(int i=0; i<pathsSlaveRead2IDs.size();i++){
        pathIDStmt p = {pathsSlaveRead2IDs.at(i),pathsSlaveRead2.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsSlaveRead3IDs.size();i++){
        pathIDStmt p = {pathsSlaveRead3IDs.at(i),pathsSlaveRead3.at(i)};
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
    for(int i=0; i<pathsSlaveWrite2IDs.size();i++){
        pathIDStmt p = {pathsSlaveWrite2IDs.at(i),pathsSlaveWrite2.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsSlaveWrite3IDs.size();i++){
        pathIDStmt p = {pathsSlaveWrite3IDs.at(i),pathsSlaveWrite3.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsMasterRead0IDs.size();i++){
        pathIDStmt p = {pathsMasterRead0IDs.at(i),pathsMasterRead0.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsMasterRead1IDs.size();i++){
        pathIDStmt p = {pathsMasterRead1IDs.at(i),pathsMasterRead1.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsMasterRead2IDs.size();i++){
        pathIDStmt p = {pathsMasterRead2IDs.at(i),pathsMasterRead2.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsMasterRead3IDs.size();i++){
        pathIDStmt p = {pathsMasterRead3IDs.at(i),pathsMasterRead3.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsDummyIDs.size();i++){
        pathIDStmt p = {pathsDummyIDs.at(i),pathsDummy.at(i)};
        allPaths.push_back(p);
    }
    int i = 0;
    // generate all Paths combining all CFGs and store them in variable finalPaths
    for(auto perm: permutations){
        //set ready queue to current permutation and clear blocked queue
        readyQueue = perm;
        blockedFunctions.clear();
        combinePaths(readyQueue,blockedFunctions);
        i++;
        std::cout << operationsFinalOpt.size() << std::endl;
        //if(i>2) break;
    }

//    //Generate final Operations
//    //Iterate over all paths and set State, nextState and statementList
//    for(auto path = finalPaths.begin(); path != finalPaths.end(); path++){
//        auto op = new Operation();
//        if(path->idList.size()>0){
//        op->setState(start_state);
//        op->setNextState(start_state);
//        }
//        operationsFinal.push_back(op);
//    }
    int cnt = 0;
    std::vector<SCAM::Stmt*> statementList;
//    for(auto op: operationsFinal) {
//        for (auto stmt: finalPaths.at(cnt).stmtList) {
//            statementList.push_back(stmt);
//        }
//        op->setStatementsList(statementList);
//        cnt++;
//        statementList.clear();
//    }
//
    auto rOperations = new ReconstructOperations(module);
//    for(auto op: this->operationsFinal) {
//        rOperations->sortOperation(op);
//    }

//    //Debug: Print finalPaths
    int num = 0;
//    for(auto p:finalPaths){
//        std::cout << "Path " << num << ": ";
//        for(auto id:p.idList){
//            std::cout<<id<<"\t";
//        }
//        std::cout<< std::endl;
//        num++;
//    }

//    //Optimize operations: only keep reachable operations and their paths
//    for(int i=0; i<operationsFinal.size();i++){
//        if(ValidOperations::isOperationReachable(operationsFinal.at(i))){
//            operationsFinalOpt.push_back(operationsFinal.at(i));
//            finalPathsOpt.push_back(finalPaths.at(i));
//        }
//    }

//    //Debug: Print finalPathsOpt
//    num = 0;
//    for(auto p:finalPathsOpt){
//        std::cout << "Path " << num << ": ";
//        for(auto id:p.idList){
//            std::cout<<id<<"\t";
//        }
//        std::cout<< std::endl;
//        num++;
//    }

    //Set Incoming and Outgoing Operations
    for(auto op:operationsFinalOpt){
        op->getState()->addOutgoingOperation(op);
        op->getNextState()->addIncomingOperation(op);
    }

    //add reset operation
    rOperations->sortOperation(reset_op);
    operationsFinalOpt.push_back(reset_op);
    //Create empty path for reset operation
    std::vector<int> int_vec;
    std::vector<SCAM::Stmt*> stmt_vec;
    pathIDStmt temp = {int_vec,stmt_vec};
    finalPathsOpt.push_back(temp);
    reset_op->getState()->addOutgoingOperation(reset_op);
    reset_op->getNextState()->addIncomingOperation(reset_op);

    //wait operation
    auto wait_op = new Operation();
    rOperations->sortOperation(wait_op);
    operationsFinalOpt.push_back(wait_op);
    //create empty path for wait operation
    finalPathsOpt.push_back(temp);
    wait_op->setState(start_state);
    wait_op->setNextState(start_state);
    wait_op->getState()->addOutgoingOperation(wait_op);
    wait_op->getNextState()->addIncomingOperation(wait_op);

    //Debug: Print Assumptions and Commitments for operationsFinalOpt
    for(auto op: operationsFinalOpt){
        std::cout << "Assumptions Operation " << op->getId() <<std::endl;
        for(auto assump: op->getAssumptionsList()){
            std::cout << *assump << std::endl;
        }
        std::cout << std::endl;
        std::cout << "Commitments Operation" << op->getId() <<std::endl;
        for(auto commit: op->getCommitmentsList()){
            std::cout << *commit << std::endl;
        }
        std::cout << std::endl;
    }

    //Generate Property Graph
    std::stringstream ss;
    for(auto op: operationsFinalOpt){
        //Store statementList of predecessor operation in stmtList_dummy
        std::vector<SCAM::Stmt*> stmtList_dummy;
        stmtList_dummy.insert(stmtList_dummy.end(),op->getStatementsList().begin(),op->getStatementsList().end());

        for(auto succ_op: operationsFinalOpt){
            if(!succ_op->getState()->isInit()){
                std::vector<SCAM::Stmt*> comb_stmts;
                //Add statementList of predecessor operation to comb_stmts
                comb_stmts.insert(comb_stmts.end(),stmtList_dummy.begin(),stmtList_dummy.end());
                //Add statementList of successor operation to comb_stmts
                comb_stmts.insert(comb_stmts.end(),succ_op->getStatementsList().begin(),succ_op->getStatementsList().end());
                //Create a dummy Operation and check if it is reachable
                auto dummy_op = new Operation();
                dummy_op->setStatementsList(comb_stmts);
                rOperations->sortOperation(dummy_op);
                if(ValidOperations::isOperationReachable(dummy_op)){
                    //If dummy operation is reachable, create a string: predecessor->successor
                    ss << op->getState()->getName() + "_" + std::to_string(op->getId());
                    ss << " -> ";
                    ss << succ_op->getState()->getName() + "_" + std::to_string(succ_op->getId());
                    ss << ";" << std::endl;
                }
                comb_stmts.clear();
            }
        }
        stmtList_dummy.clear();
    }
    //Print PropertyGraph into a file
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Regfile_Properties/PropertyGraph.gfv");
    myfile << ss.str();
    myfile.close();

    //Define portnames for notify and sync signals
    std::vector<std::string> portnames;
    auto portMap = module->getPorts();
    for(auto port: portMap){
        portnames.push_back(port.second->getName());
    }
    //Arrays that state if sync or notify needs to be added
    bool addsync[startnodes.size()];
    bool addnoti[startnodes.size()];

    //Add sync and notify signals
    for(int i=0;i<operationsFinalOpt.size();i++){
        auto op = operationsFinalOpt.at(i);
        //Sync and Notify are unset by default
        for(int j=0;j<startnodes.size();j++){
            addsync[j] = false;
            addnoti[j] = false;
        }
        for(auto id: finalPathsOpt.at(i).idList){
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
    }

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
    myfile.open(SCAM_HOME"/tests/Regfile_Properties/" + module->getName() + "_generated.vhi");
    myfile << map.at(module->getName() + ".vhi") << std::endl;
    myfile.close();
}



#endif //DESCAM_OPERATION_GRAPH_H
