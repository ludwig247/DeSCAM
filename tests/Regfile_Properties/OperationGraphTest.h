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
    OperationGraphTest():module(new SCAM::Module("Regfile")){
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
    std::map<int, CfgNode *> controlFlowMapRead;
    std::map<int, CfgNode *> controlFlowMapWrite;
    std::map<int, CfgNode *> controlFlowMapDummy;
    std::map<int, CfgNode *> controlFlowMap;
    std::vector<std::vector<SCAM::Stmt*>> pathsRead;
    std::vector<std::vector<int>> pathsReadIDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite;
    std::vector<std::vector<int>> pathsWriteIDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsDummy;
    std::vector<std::vector<int>> pathsDummyIDs;
    std::vector<Operation*> operationsRead;
    std::vector<Operation*> operationsWrite;
    std::vector<Operation*> operationsDummy;
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


    std::string printCFG(std::map<int,CfgNode*> controlFlowMap) {
        //Print CFG for debugging
        std::stringstream ss;
        for (auto node: controlFlowMap) {
            CfgNode *sus = node.second;

            ss << "[ID" << node.first << "] [Node" << sus->getName() << "]" << "\n";
            ss << "\tStmnt: " << "\n";


            auto stmt = sus->getStmt();
            ss << "\t\t" << PrintStmt::toString(stmt) << "\n";

            ss << "\t\tPred: ";
            for (auto pred: sus->getPredecessorList()) {
                ss << "[ID" << pred->getId() << "], ";
            }
            ss << "\n";;
            ss << "\t\tSucc: ";
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
            else{
                //End of path reached
                finalPaths.push_back(currentPath);
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
    virtual void SetUp() {
        //create variables and datatypes
        auto regs_array = new DataType("int_32");
        regs_array->addArray(DataTypes::getDataType("int"),32);
        auto regs = new Variable("regs",regs_array);
        auto address = new Variable("address",DataTypes::getDataType("int"));
        auto out = new Port("out",new Interface("blocking","out"),regs_array);
        auto val = new Port("val",new Interface("blocking","in"), DataTypes::getDataType("int"));

        //add Variables to Module
        module->addVariable(regs);
        module->addVariable(address);
        module->addPort(out);
        module->addPort(val);

        for(auto subVar:regs->getSubVarList()){
            module->addVariable(subVar);
        }
        auto noti = new Notify("Test");
        auto noti_cfg = new CfgNode(noti);
        auto ret = new Return("Return");


        //Read Statements
        //out = regs
        auto out_assign_regs = new Assignment(new DataSignalOperand(out->getDataSignal()),new VariableOperand(regs));
        auto read_return = new Return("read_return");

        //Write Statements
        auto write_dummy_notify = new Notify("write_dummy_notify");
        auto wait_dummy_write = new Wait("dummy_write_notify");
        auto regs_at_0 = new VariableOperand(regs->getSubVar("0"));
        auto regs_at_1 = new VariableOperand(regs->getSubVar("1"));
        auto regs_at_2 = new VariableOperand(regs->getSubVar("2"));
        auto regs_at_3 = new VariableOperand(regs->getSubVar("3"));
        auto regs_at_4 = new VariableOperand(regs->getSubVar("4"));
        auto regs_at_5 = new VariableOperand(regs->getSubVar("5"));
        auto regs_at_6 = new VariableOperand(regs->getSubVar("6"));
        auto regs_at_7 = new VariableOperand(regs->getSubVar("7"));
        auto regs_at_8 = new VariableOperand(regs->getSubVar("8"));
        auto regs_at_9 = new VariableOperand(regs->getSubVar("9"));
        auto regs_at_10 = new VariableOperand(regs->getSubVar("10"));
        auto regs_at_11 = new VariableOperand(regs->getSubVar("11"));
        auto regs_at_12 = new VariableOperand(regs->getSubVar("12"));
        auto regs_at_13 = new VariableOperand(regs->getSubVar("13"));
        auto regs_at_14 = new VariableOperand(regs->getSubVar("14"));
        auto regs_at_15 = new VariableOperand(regs->getSubVar("15"));
        auto regs_at_16 = new VariableOperand(regs->getSubVar("16"));
        auto regs_at_17 = new VariableOperand(regs->getSubVar("17"));
        auto regs_at_18 = new VariableOperand(regs->getSubVar("18"));
        auto regs_at_19 = new VariableOperand(regs->getSubVar("19"));
        auto regs_at_20 = new VariableOperand(regs->getSubVar("20"));
        auto regs_at_21 = new VariableOperand(regs->getSubVar("21"));
        auto regs_at_22 = new VariableOperand(regs->getSubVar("22"));
        auto regs_at_23 = new VariableOperand(regs->getSubVar("23"));
        auto regs_at_24 = new VariableOperand(regs->getSubVar("24"));
        auto regs_at_25 = new VariableOperand(regs->getSubVar("25"));
        auto regs_at_26 = new VariableOperand(regs->getSubVar("26"));
        auto regs_at_27 = new VariableOperand(regs->getSubVar("27"));
        auto regs_at_28 = new VariableOperand(regs->getSubVar("28"));
        auto regs_at_29 = new VariableOperand(regs->getSubVar("29"));
        auto regs_at_30 = new VariableOperand(regs->getSubVar("30"));
        auto regs_at_31 = new VariableOperand(regs->getSubVar("31"));

        auto address_eq_0 = new Relational(new VariableOperand(address),"==",new IntegerValue(0));
        auto address_eq_1 = new Relational(new VariableOperand(address),"==",new IntegerValue(1));
        auto address_eq_2 = new Relational(new VariableOperand(address),"==",new IntegerValue(2));
        auto address_eq_3 = new Relational(new VariableOperand(address),"==",new IntegerValue(3));
        auto address_eq_4 = new Relational(new VariableOperand(address),"==",new IntegerValue(4));
        auto address_eq_5 = new Relational(new VariableOperand(address),"==",new IntegerValue(5));
        auto address_eq_6 = new Relational(new VariableOperand(address),"==",new IntegerValue(6));
        auto address_eq_7 = new Relational(new VariableOperand(address),"==",new IntegerValue(7));
        auto address_eq_8 = new Relational(new VariableOperand(address),"==",new IntegerValue(8));
        auto address_eq_9 = new Relational(new VariableOperand(address),"==",new IntegerValue(9));
        auto address_eq_10 = new Relational(new VariableOperand(address),"==",new IntegerValue(10));
        auto address_eq_11 = new Relational(new VariableOperand(address),"==",new IntegerValue(11));
        auto address_eq_12 = new Relational(new VariableOperand(address),"==",new IntegerValue(12));
        auto address_eq_13 = new Relational(new VariableOperand(address),"==",new IntegerValue(13));
        auto address_eq_14 = new Relational(new VariableOperand(address),"==",new IntegerValue(14));
        auto address_eq_15 = new Relational(new VariableOperand(address),"==",new IntegerValue(15));
        auto address_eq_16 = new Relational(new VariableOperand(address),"==",new IntegerValue(16));
        auto address_eq_17 = new Relational(new VariableOperand(address),"==",new IntegerValue(17));
        auto address_eq_18 = new Relational(new VariableOperand(address),"==",new IntegerValue(18));
        auto address_eq_19 = new Relational(new VariableOperand(address),"==",new IntegerValue(19));
        auto address_eq_20 = new Relational(new VariableOperand(address),"==",new IntegerValue(20));
        auto address_eq_21 = new Relational(new VariableOperand(address),"==",new IntegerValue(21));
        auto address_eq_22 = new Relational(new VariableOperand(address),"==",new IntegerValue(22));
        auto address_eq_23 = new Relational(new VariableOperand(address),"==",new IntegerValue(23));
        auto address_eq_24 = new Relational(new VariableOperand(address),"==",new IntegerValue(24));
        auto address_eq_25 = new Relational(new VariableOperand(address),"==",new IntegerValue(25));
        auto address_eq_26 = new Relational(new VariableOperand(address),"==",new IntegerValue(26));
        auto address_eq_27 = new Relational(new VariableOperand(address),"==",new IntegerValue(27));
        auto address_eq_28 = new Relational(new VariableOperand(address),"==",new IntegerValue(28));
        auto address_eq_29 = new Relational(new VariableOperand(address),"==",new IntegerValue(29));
        auto address_eq_30 = new Relational(new VariableOperand(address),"==",new IntegerValue(30));
        auto address_eq_31 = new Relational(new VariableOperand(address),"==",new IntegerValue(31));

        auto assign_regs_at_0 = new Assignment(regs_at_0,new Ternary(address_eq_0,new DataSignalOperand(val->getDataSignal()),regs_at_0));
        auto assign_regs_at_1 = new Assignment(regs_at_1,new Ternary(address_eq_1,new DataSignalOperand(val->getDataSignal()),regs_at_1));
        auto assign_regs_at_2 = new Assignment(regs_at_2,new Ternary(address_eq_2,new DataSignalOperand(val->getDataSignal()),regs_at_2));
        auto assign_regs_at_3 = new Assignment(regs_at_3,new Ternary(address_eq_3,new DataSignalOperand(val->getDataSignal()),regs_at_3));
        auto assign_regs_at_4 = new Assignment(regs_at_4,new Ternary(address_eq_4,new DataSignalOperand(val->getDataSignal()),regs_at_4));
        auto assign_regs_at_5 = new Assignment(regs_at_5,new Ternary(address_eq_5,new DataSignalOperand(val->getDataSignal()),regs_at_5));
        auto assign_regs_at_6 = new Assignment(regs_at_6,new Ternary(address_eq_6,new DataSignalOperand(val->getDataSignal()),regs_at_6));
        auto assign_regs_at_7 = new Assignment(regs_at_7,new Ternary(address_eq_7,new DataSignalOperand(val->getDataSignal()),regs_at_7));
        auto assign_regs_at_8 = new Assignment(regs_at_8,new Ternary(address_eq_8,new DataSignalOperand(val->getDataSignal()),regs_at_8));
        auto assign_regs_at_9 = new Assignment(regs_at_9,new Ternary(address_eq_9,new DataSignalOperand(val->getDataSignal()),regs_at_9));
        auto assign_regs_at_10 = new Assignment(regs_at_10,new Ternary(address_eq_10,new DataSignalOperand(val->getDataSignal()),regs_at_10));
        auto assign_regs_at_11 = new Assignment(regs_at_11,new Ternary(address_eq_11,new DataSignalOperand(val->getDataSignal()),regs_at_11));
        auto assign_regs_at_12 = new Assignment(regs_at_12,new Ternary(address_eq_12,new DataSignalOperand(val->getDataSignal()),regs_at_12));
        auto assign_regs_at_13 = new Assignment(regs_at_13,new Ternary(address_eq_13,new DataSignalOperand(val->getDataSignal()),regs_at_13));
        auto assign_regs_at_14 = new Assignment(regs_at_14,new Ternary(address_eq_14,new DataSignalOperand(val->getDataSignal()),regs_at_14));
        auto assign_regs_at_15 = new Assignment(regs_at_15,new Ternary(address_eq_15,new DataSignalOperand(val->getDataSignal()),regs_at_15));
        auto assign_regs_at_16 = new Assignment(regs_at_16,new Ternary(address_eq_16,new DataSignalOperand(val->getDataSignal()),regs_at_16));
        auto assign_regs_at_17 = new Assignment(regs_at_17,new Ternary(address_eq_17,new DataSignalOperand(val->getDataSignal()),regs_at_17));
        auto assign_regs_at_18 = new Assignment(regs_at_18,new Ternary(address_eq_18,new DataSignalOperand(val->getDataSignal()),regs_at_18));
        auto assign_regs_at_19 = new Assignment(regs_at_19,new Ternary(address_eq_19,new DataSignalOperand(val->getDataSignal()),regs_at_19));
        auto assign_regs_at_20 = new Assignment(regs_at_20,new Ternary(address_eq_20,new DataSignalOperand(val->getDataSignal()),regs_at_20));
        auto assign_regs_at_21 = new Assignment(regs_at_21,new Ternary(address_eq_21,new DataSignalOperand(val->getDataSignal()),regs_at_21));
        auto assign_regs_at_22 = new Assignment(regs_at_22,new Ternary(address_eq_22,new DataSignalOperand(val->getDataSignal()),regs_at_22));
        auto assign_regs_at_23 = new Assignment(regs_at_23,new Ternary(address_eq_23,new DataSignalOperand(val->getDataSignal()),regs_at_23));
        auto assign_regs_at_24 = new Assignment(regs_at_24,new Ternary(address_eq_24,new DataSignalOperand(val->getDataSignal()),regs_at_24));
        auto assign_regs_at_25 = new Assignment(regs_at_25,new Ternary(address_eq_25,new DataSignalOperand(val->getDataSignal()),regs_at_25));
        auto assign_regs_at_26 = new Assignment(regs_at_26,new Ternary(address_eq_26,new DataSignalOperand(val->getDataSignal()),regs_at_26));
        auto assign_regs_at_27 = new Assignment(regs_at_27,new Ternary(address_eq_27,new DataSignalOperand(val->getDataSignal()),regs_at_27));
        auto assign_regs_at_28 = new Assignment(regs_at_28,new Ternary(address_eq_28,new DataSignalOperand(val->getDataSignal()),regs_at_28));
        auto assign_regs_at_29 = new Assignment(regs_at_29,new Ternary(address_eq_29,new DataSignalOperand(val->getDataSignal()),regs_at_29));
        auto assign_regs_at_30 = new Assignment(regs_at_30,new Ternary(address_eq_30,new DataSignalOperand(val->getDataSignal()),regs_at_30));
        auto assign_regs_at_31 = new Assignment(regs_at_31,new Ternary(address_eq_31,new DataSignalOperand(val->getDataSignal()),regs_at_31));

        auto write_return = new Return("write_return");

        //Dummy Statements
        auto dummy_write_notify = new Notify("dummy_write_notify");
        auto wait_write_dummy = new Wait("write_dummy_notify");

        //CFG nodes Read
        auto set_out = new CfgNode(out_assign_regs);
        auto return_read = new CfgNode(read_return);

        //Link CFG nodes Read
        set_out->addSuccessor(return_read);

        //create map with CFG nodes Read
        controlFlowMapRead.insert(std::make_pair(set_out->getId(),set_out));
        controlFlowMapRead.insert(std::make_pair(return_read->getId(),return_read));

        //add nodes to global controlFlowMap
        controlFlowMap.insert(std::make_pair(set_out->getId(),set_out));
        controlFlowMap.insert(std::make_pair(return_read->getId(),return_read));

//        //Print CFG for Read
//        std::cout << printCFG(controlFlowMapRead) << std::endl;

        //CFG nodes Write
        auto write_to_dummy = new CfgNode(write_dummy_notify);
        auto wait_for_dummy = new CfgNode(wait_dummy_write);
        auto reg_assign_0 = new CfgNode(assign_regs_at_0);
        auto reg_assign_1 = new CfgNode(assign_regs_at_1);
        auto reg_assign_2 = new CfgNode(assign_regs_at_2);
        auto reg_assign_3 = new CfgNode(assign_regs_at_3);
        auto reg_assign_4 = new CfgNode(assign_regs_at_4);
        auto reg_assign_5 = new CfgNode(assign_regs_at_5);
        auto reg_assign_6 = new CfgNode(assign_regs_at_6);
        auto reg_assign_7 = new CfgNode(assign_regs_at_7);
        auto reg_assign_8 = new CfgNode(assign_regs_at_8);
        auto reg_assign_9 = new CfgNode(assign_regs_at_9);
        auto reg_assign_10 = new CfgNode(assign_regs_at_10);
        auto reg_assign_11 = new CfgNode(assign_regs_at_11);
        auto reg_assign_12 = new CfgNode(assign_regs_at_12);
        auto reg_assign_13 = new CfgNode(assign_regs_at_13);
        auto reg_assign_14 = new CfgNode(assign_regs_at_14);
        auto reg_assign_15 = new CfgNode(assign_regs_at_15);
        auto reg_assign_16 = new CfgNode(assign_regs_at_16);
        auto reg_assign_17 = new CfgNode(assign_regs_at_17);
        auto reg_assign_18 = new CfgNode(assign_regs_at_18);
        auto reg_assign_19 = new CfgNode(assign_regs_at_19);
        auto reg_assign_20 = new CfgNode(assign_regs_at_20);
        auto reg_assign_21 = new CfgNode(assign_regs_at_21);
        auto reg_assign_22 = new CfgNode(assign_regs_at_22);
        auto reg_assign_23 = new CfgNode(assign_regs_at_23);
        auto reg_assign_24 = new CfgNode(assign_regs_at_24);
        auto reg_assign_25 = new CfgNode(assign_regs_at_25);
        auto reg_assign_26 = new CfgNode(assign_regs_at_26);
        auto reg_assign_27 = new CfgNode(assign_regs_at_27);
        auto reg_assign_28 = new CfgNode(assign_regs_at_28);
        auto reg_assign_29 = new CfgNode(assign_regs_at_29);
        auto reg_assign_30 = new CfgNode(assign_regs_at_30);
        auto reg_assign_31 = new CfgNode(assign_regs_at_31);
        auto return_write = new CfgNode(write_return);

        //Connect CFG nodes Write
        write_to_dummy->addSuccessor(wait_for_dummy);
        wait_for_dummy->addSuccessor(reg_assign_0);
        reg_assign_0->addSuccessor(reg_assign_1);
        reg_assign_1->addSuccessor(reg_assign_2);
        reg_assign_2->addSuccessor(reg_assign_3);
        reg_assign_3->addSuccessor(reg_assign_4);
        reg_assign_4->addSuccessor(reg_assign_5);
        reg_assign_5->addSuccessor(reg_assign_6);
        reg_assign_6->addSuccessor(reg_assign_7);
        reg_assign_7->addSuccessor(reg_assign_8);
        reg_assign_8->addSuccessor(reg_assign_9);
        reg_assign_9->addSuccessor(reg_assign_10);
        reg_assign_10->addSuccessor(reg_assign_11);
        reg_assign_11->addSuccessor(reg_assign_12);
        reg_assign_12->addSuccessor(reg_assign_13);
        reg_assign_13->addSuccessor(reg_assign_14);
        reg_assign_14->addSuccessor(reg_assign_15);
        reg_assign_15->addSuccessor(reg_assign_16);
        reg_assign_16->addSuccessor(reg_assign_17);
        reg_assign_17->addSuccessor(reg_assign_18);
        reg_assign_18->addSuccessor(reg_assign_19);
        reg_assign_19->addSuccessor(reg_assign_20);
        reg_assign_20->addSuccessor(reg_assign_21);
        reg_assign_21->addSuccessor(reg_assign_22);
        reg_assign_22->addSuccessor(reg_assign_23);
        reg_assign_23->addSuccessor(reg_assign_24);
        reg_assign_24->addSuccessor(reg_assign_25);
        reg_assign_25->addSuccessor(reg_assign_26);
        reg_assign_26->addSuccessor(reg_assign_27);
        reg_assign_27->addSuccessor(reg_assign_28);
        reg_assign_28->addSuccessor(reg_assign_29);
        reg_assign_29->addSuccessor(reg_assign_30);
        reg_assign_30->addSuccessor(reg_assign_31);
        reg_assign_31->addSuccessor(return_write);

        //Create map with CFG nodes Write
        controlFlowMapWrite.insert(std::make_pair(write_to_dummy->getId(),write_to_dummy));
        controlFlowMapWrite.insert(std::make_pair(wait_for_dummy->getId(),wait_for_dummy));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_0->getId(),reg_assign_0));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_1->getId(),reg_assign_1));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_2->getId(),reg_assign_2));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_3->getId(),reg_assign_3));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_4->getId(),reg_assign_4));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_5->getId(),reg_assign_4));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_6->getId(),reg_assign_4));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_7->getId(),reg_assign_4));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_8->getId(),reg_assign_4));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_9->getId(),reg_assign_4));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_10->getId(),reg_assign_10));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_11->getId(),reg_assign_11));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_12->getId(),reg_assign_12));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_13->getId(),reg_assign_13));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_14->getId(),reg_assign_14));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_15->getId(),reg_assign_15));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_16->getId(),reg_assign_16));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_17->getId(),reg_assign_17));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_18->getId(),reg_assign_18));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_19->getId(),reg_assign_19));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_20->getId(),reg_assign_20));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_21->getId(),reg_assign_21));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_22->getId(),reg_assign_22));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_23->getId(),reg_assign_23));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_24->getId(),reg_assign_24));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_25->getId(),reg_assign_25));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_26->getId(),reg_assign_26));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_27->getId(),reg_assign_27));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_28->getId(),reg_assign_28));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_29->getId(),reg_assign_29));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_30->getId(),reg_assign_30));
        controlFlowMapWrite.insert(std::make_pair(reg_assign_31->getId(),reg_assign_31));
        controlFlowMapWrite.insert(std::make_pair(return_write->getId(),return_write));

        //add nodes to global controlFlowMap
        controlFlowMap.insert(std::make_pair(write_to_dummy->getId(),write_to_dummy));
        controlFlowMap.insert(std::make_pair(wait_for_dummy->getId(),wait_for_dummy));
        controlFlowMap.insert(std::make_pair(reg_assign_0->getId(),reg_assign_0));
        controlFlowMap.insert(std::make_pair(reg_assign_1->getId(),reg_assign_1));
        controlFlowMap.insert(std::make_pair(reg_assign_2->getId(),reg_assign_2));
        controlFlowMap.insert(std::make_pair(reg_assign_3->getId(),reg_assign_3));
        controlFlowMap.insert(std::make_pair(reg_assign_4->getId(),reg_assign_4));
        controlFlowMap.insert(std::make_pair(reg_assign_5->getId(),reg_assign_4));
        controlFlowMap.insert(std::make_pair(reg_assign_6->getId(),reg_assign_4));
        controlFlowMap.insert(std::make_pair(reg_assign_7->getId(),reg_assign_4));
        controlFlowMap.insert(std::make_pair(reg_assign_8->getId(),reg_assign_4));
        controlFlowMap.insert(std::make_pair(reg_assign_9->getId(),reg_assign_4));
        controlFlowMap.insert(std::make_pair(reg_assign_10->getId(),reg_assign_10));
        controlFlowMap.insert(std::make_pair(reg_assign_11->getId(),reg_assign_11));
        controlFlowMap.insert(std::make_pair(reg_assign_12->getId(),reg_assign_12));
        controlFlowMap.insert(std::make_pair(reg_assign_13->getId(),reg_assign_13));
        controlFlowMap.insert(std::make_pair(reg_assign_14->getId(),reg_assign_14));
        controlFlowMap.insert(std::make_pair(reg_assign_15->getId(),reg_assign_15));
        controlFlowMap.insert(std::make_pair(reg_assign_16->getId(),reg_assign_16));
        controlFlowMap.insert(std::make_pair(reg_assign_17->getId(),reg_assign_17));
        controlFlowMap.insert(std::make_pair(reg_assign_18->getId(),reg_assign_18));
        controlFlowMap.insert(std::make_pair(reg_assign_19->getId(),reg_assign_19));
        controlFlowMap.insert(std::make_pair(reg_assign_20->getId(),reg_assign_20));
        controlFlowMap.insert(std::make_pair(reg_assign_21->getId(),reg_assign_21));
        controlFlowMap.insert(std::make_pair(reg_assign_22->getId(),reg_assign_22));
        controlFlowMap.insert(std::make_pair(reg_assign_23->getId(),reg_assign_23));
        controlFlowMap.insert(std::make_pair(reg_assign_24->getId(),reg_assign_24));
        controlFlowMap.insert(std::make_pair(reg_assign_25->getId(),reg_assign_25));
        controlFlowMap.insert(std::make_pair(reg_assign_26->getId(),reg_assign_26));
        controlFlowMap.insert(std::make_pair(reg_assign_27->getId(),reg_assign_27));
        controlFlowMap.insert(std::make_pair(reg_assign_28->getId(),reg_assign_28));
        controlFlowMap.insert(std::make_pair(reg_assign_29->getId(),reg_assign_29));
        controlFlowMap.insert(std::make_pair(reg_assign_30->getId(),reg_assign_30));
        controlFlowMap.insert(std::make_pair(reg_assign_31->getId(),reg_assign_31));
        controlFlowMap.insert(std::make_pair(return_write->getId(),return_write));

        //CFG nodes Dummy
        auto dummy_to_write = new CfgNode(dummy_write_notify);
        auto wait_for_write = new CfgNode(wait_write_dummy);

        //Connect CFG nodes Dummy
        dummy_to_write->addSuccessor(wait_for_write);
        wait_for_write->addSuccessor(dummy_to_write);

        //Create map with CFG nodes Dummy
        controlFlowMapDummy.insert(std::make_pair(dummy_to_write->getId(),dummy_to_write));
        controlFlowMapDummy.insert(std::make_pair(wait_for_write->getId(),wait_for_write));

        //add nodes to global controlFlowMap
        controlFlowMap.insert(std::make_pair(dummy_to_write->getId(),dummy_to_write));
        controlFlowMap.insert(std::make_pair(wait_for_write->getId(),wait_for_write));

//        //Print CFG Write
//        std::cout << printCFG(controlFlowMapWrite) << std::endl;
//
//        //Print CFG Dummy
//        std::cout << printCFG(controlFlowMapDummy) << std::endl;


        init = new State("reset");
        init->setInit();

        //Generate Reset Operation
        reset_op = new Operation();
        auto regs_0_assign_0 = new Assignment(regs_at_0,new IntegerValue(0));
        auto regs_1_assign_0 = new Assignment(regs_at_1,new IntegerValue(0));
        auto regs_2_assign_0 = new Assignment(regs_at_2,new IntegerValue(0));
        auto regs_3_assign_0 = new Assignment(regs_at_3,new IntegerValue(0));
        auto regs_4_assign_0 = new Assignment(regs_at_4,new IntegerValue(0));
        auto regs_5_assign_0 = new Assignment(regs_at_5,new IntegerValue(0));
        auto regs_6_assign_0 = new Assignment(regs_at_6,new IntegerValue(0));
        auto regs_7_assign_0 = new Assignment(regs_at_7,new IntegerValue(0));
        auto regs_8_assign_0 = new Assignment(regs_at_8,new IntegerValue(0));
        auto regs_9_assign_0 = new Assignment(regs_at_9,new IntegerValue(0));
        auto regs_10_assign_0 = new Assignment(regs_at_10,new IntegerValue(0));
        auto regs_11_assign_0 = new Assignment(regs_at_11,new IntegerValue(0));
        auto regs_12_assign_0 = new Assignment(regs_at_12,new IntegerValue(0));
        auto regs_13_assign_0 = new Assignment(regs_at_13,new IntegerValue(0));
        auto regs_14_assign_0 = new Assignment(regs_at_14,new IntegerValue(0));
        auto regs_15_assign_0 = new Assignment(regs_at_15,new IntegerValue(0));
        auto regs_16_assign_0 = new Assignment(regs_at_16,new IntegerValue(0));
        auto regs_17_assign_0 = new Assignment(regs_at_17,new IntegerValue(0));
        auto regs_18_assign_0 = new Assignment(regs_at_18,new IntegerValue(0));
        auto regs_19_assign_0 = new Assignment(regs_at_19,new IntegerValue(0));
        auto regs_20_assign_0 = new Assignment(regs_at_20,new IntegerValue(0));
        auto regs_21_assign_0 = new Assignment(regs_at_21,new IntegerValue(0));
        auto regs_22_assign_0 = new Assignment(regs_at_22,new IntegerValue(0));
        auto regs_23_assign_0 = new Assignment(regs_at_23,new IntegerValue(0));
        auto regs_24_assign_0 = new Assignment(regs_at_24,new IntegerValue(0));
        auto regs_25_assign_0 = new Assignment(regs_at_25,new IntegerValue(0));
        auto regs_26_assign_0 = new Assignment(regs_at_26,new IntegerValue(0));
        auto regs_27_assign_0 = new Assignment(regs_at_27,new IntegerValue(0));
        auto regs_28_assign_0 = new Assignment(regs_at_28,new IntegerValue(0));
        auto regs_29_assign_0 = new Assignment(regs_at_29,new IntegerValue(0));
        auto regs_30_assign_0 = new Assignment(regs_at_30,new IntegerValue(0));
        auto regs_31_assign_0 = new Assignment(regs_at_31,new IntegerValue(0));
        reset_op->addStatement(regs_0_assign_0);
        reset_op->addStatement(regs_1_assign_0);
        reset_op->addStatement(regs_2_assign_0);
        reset_op->addStatement(regs_3_assign_0);
        reset_op->addStatement(regs_4_assign_0);
        reset_op->addStatement(regs_5_assign_0);
        reset_op->addStatement(regs_6_assign_0);
        reset_op->addStatement(regs_7_assign_0);
        reset_op->addStatement(regs_8_assign_0);
        reset_op->addStatement(regs_9_assign_0);
        reset_op->addStatement(regs_2_assign_0);
        reset_op->addStatement(regs_10_assign_0);
        reset_op->addStatement(regs_11_assign_0);
        reset_op->addStatement(regs_12_assign_0);
        reset_op->addStatement(regs_13_assign_0);
        reset_op->addStatement(regs_14_assign_0);
        reset_op->addStatement(regs_15_assign_0);
        reset_op->addStatement(regs_16_assign_0);
        reset_op->addStatement(regs_17_assign_0);
        reset_op->addStatement(regs_18_assign_0);
        reset_op->addStatement(regs_19_assign_0);
        reset_op->addStatement(regs_20_assign_0);
        reset_op->addStatement(regs_21_assign_0);
        reset_op->addStatement(regs_22_assign_0);
        reset_op->addStatement(regs_23_assign_0);
        reset_op->addStatement(regs_24_assign_0);
        reset_op->addStatement(regs_25_assign_0);
        reset_op->addStatement(regs_26_assign_0);
        reset_op->addStatement(regs_27_assign_0);
        reset_op->addStatement(regs_28_assign_0);
        reset_op->addStatement(regs_29_assign_0);
        reset_op->addStatement(regs_30_assign_0);
        reset_op->addStatement(regs_31_assign_0);

        reset_op->setState(init);
        start_state = new State("start_state");
        reset_op->setNextState(start_state);
        reset_op->setReset(true);

        eventID temp = {1, "reader_sync"};
        startnodes.push_back(temp);
        temp = {3,"writer_sync"};
        startnodes.push_back(temp);

        temp = {2,"reader_notify"};
        endnodes.push_back(temp);
        temp = {37,"writer_notify"};
        endnodes.push_back(temp);

    }

    virtual void TearDown() {}

};

TEST_F(OperationGraphTest, ExtractPaths){
    //Find important states Read
    std::map<int, CfgNode *> importantStatesRead;
    findImportantStates(controlFlowMapRead,&importantStatesRead);

    //Find operations Read
    auto start_read = controlFlowMapRead.begin()->second;
    findPathsfromNode(start_read,&pathsRead,&pathsReadIDs);
    for(auto const& node : importantStatesRead) {
        findPathsfromNode(node.second,&pathsRead,&pathsReadIDs);
    }

    //Create a map from CfgNode Id to State Read
    std::map<int,State*> CfgIdToStateRead;
    //If the state for the node is not yet created, create one
    for(auto path = pathsReadIDs.begin(); path != pathsReadIDs.end(); path++){
        if(CfgIdToStateRead.find(path->front()) == CfgIdToStateRead.end()){
            CfgIdToStateRead.insert(std::make_pair(path->front(),new State(controlFlowMapRead.at(path->front())->getName())));
        }
        if(CfgIdToStateRead.find(path->back()) == CfgIdToStateRead.end()){
            CfgIdToStateRead.insert(std::make_pair(path->back(), new State(controlFlowMapRead.at(path->back())->getName())));
        }
    }

    //Generate Operations Read
    //Iterate over all paths and set State, nextState and statementList
    for(auto path = pathsReadIDs.begin(); path != pathsReadIDs.end(); path++){
        auto op = new Operation();
        op->setState(CfgIdToStateRead.at(path->front()));
        op->setNextState(CfgIdToStateRead.at(path->back()));
        operationsRead.push_back(op);
    }
    int cnt = 0;
    std::vector<SCAM::Stmt*> statementList;
    for(auto op: operationsRead) {
        for (auto stmt: pathsRead.at(cnt)) {
            statementList.push_back(stmt);
        }
        op->setStatementsList(statementList);
        cnt++;
        statementList.clear();
    }

    //Get Assumptions and Commitments
    auto rOperations = new ReconstructOperations(module);
    for(auto op: this->operationsRead) {
        rOperations->sortOperation(op);
    }

    //Find important states Write
    std::map<int, CfgNode *> importantStatesWrite;
    findImportantStates(controlFlowMapWrite,&importantStatesWrite);
    //Find important states Write 1
    std::map<int, CfgNode *> importantStatesDummy;
    findImportantStates(controlFlowMapDummy,&importantStatesDummy);

    //Find operations Write
    auto start_write = controlFlowMapWrite.begin()->second;
    findPathsfromNode(start_write,&pathsWrite,&pathsWriteIDs);
    for(auto const& node : importantStatesWrite) {
        findPathsfromNode(node.second,&pathsWrite,&pathsWriteIDs);
    }

    //Create a map from CfgNode Id to State Write
    std::map<int,State*> CfgIdToStateWrite;
    //If the state for the node is not yet created, create one
    for(auto path = pathsWriteIDs.begin(); path != pathsWriteIDs.end(); path++){
        if(CfgIdToStateWrite.find(path->front()) == CfgIdToStateWrite.end()){
            CfgIdToStateWrite.insert(std::make_pair(path->front(),new State(controlFlowMapWrite.at(path->front())->getName())));
        }
        if(CfgIdToStateWrite.find(path->back()) == CfgIdToStateWrite.end()){
            CfgIdToStateWrite.insert(std::make_pair(path->back(), new State(controlFlowMapWrite.at(path->back())->getName())));
        }
    }

    //Generate Operations Write
    //Iterate over all paths and set State, nextState and statementList
    for(auto path = pathsWriteIDs.begin(); path != pathsWriteIDs.end(); path++){
        auto op = new Operation();
        op->setState(CfgIdToStateWrite.at(path->front()));
        op->setNextState(CfgIdToStateWrite.at(path->back()));
        statementList.clear();

        operationsWrite.push_back(op);
    }
    cnt = 0;
    for(auto op: operationsWrite) {
        for (auto stmt: pathsWrite.at(cnt)) {
            statementList.push_back(stmt);
        }
        op->setStatementsList(statementList);
        cnt++;
        statementList.clear();
    }

    for(auto op: this->operationsWrite) {
        rOperations->sortOperation(op);
    }

    //Find operations Dummy
    auto start_dummy = controlFlowMapDummy.begin()->second;
    findPathsfromNode(start_dummy,&pathsDummy,&pathsDummyIDs);
    for(auto const& node : importantStatesDummy) {
        findPathsfromNode(node.second,&pathsDummy,&pathsDummyIDs);
    }

    //Create a map from CfgNode Id to State Dummy
    std::map<int,State*> CfgIdToStateDummy;
    //If the state for the node is not yet created, create one
    for(auto path = pathsDummyIDs.begin(); path != pathsDummyIDs.end(); path++){
        if(CfgIdToStateDummy.find(path->front()) == CfgIdToStateDummy.end()){
            CfgIdToStateDummy.insert(std::make_pair(path->front(),new State(controlFlowMapDummy.at(path->front())->getName())));
        }
        if(CfgIdToStateDummy.find(path->back()) == CfgIdToStateDummy.end()){
            CfgIdToStateDummy.insert(std::make_pair(path->back(), new State(controlFlowMapDummy.at(path->back())->getName())));
        }
    }

    //Generate Operations Dummy
    //Iterate over all paths and set State, nextState and statementList
    for(auto path = pathsDummyIDs.begin(); path != pathsDummyIDs.end(); path++){
        auto op = new Operation();
        op->setState(CfgIdToStateDummy.at(path->front()));
        op->setNextState(CfgIdToStateDummy.at(path->back()));
        statementList.clear();

        operationsDummy.push_back(op);
    }
    cnt = 0;
    for(auto op: operationsDummy) {
        for (auto stmt: pathsDummy.at(cnt)) {
            statementList.push_back(stmt);
        }
        op->setStatementsList(statementList);
        cnt++;
        statementList.clear();
    }

    for(auto op: this->operationsDummy) {
        rOperations->sortOperation(op);
    }

    //Generate final FSM
    std::vector<eventID> blockedFunctions;
    std::vector<eventID> readyQueue;
    std::vector<std::vector<eventID>>permutations;
    std::vector<eventID> hv;

    eventID read = {1,"read"};
    eventID write = {3,"write"};
    eventID dummy = {38,"dummy"};
//    //no function calls
//    permutations.push_back(hv);
    //only read call
    hv.push_back(read);
    permutations.push_back(hv);
    hv.clear();
    //only write call
    hv.push_back(write);
    permutations.push_back(hv);
    hv.clear();
    //read and write call
    hv.push_back(read);
    hv.push_back(write);
    permutations.push_back(hv);
    hv.clear();
    //only dummy call
    hv.push_back(dummy);
    permutations.push_back(hv);
    hv.clear();
    //read and dummy call
    hv.push_back(read);
    hv.push_back(dummy);
    permutations.push_back(hv);
    hv.clear();
    //write and dummy call
    hv.push_back(write);
    hv.push_back(dummy);
    permutations.push_back(hv);
    hv.clear();
    //read, write and dummy call
    hv.push_back(read);
    hv.push_back(write);
    hv.push_back(dummy);
    permutations.push_back(hv);
    hv.clear();


    //construct a vector of all paths by pushing the paths from Read and Write to allPaths
    for(int i=0; i<pathsReadIDs.size();i++){
        pathIDStmt p = {pathsReadIDs.at(i),pathsRead.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWriteIDs.size();i++){
        pathIDStmt p = {pathsWriteIDs.at(i),pathsWrite.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsDummyIDs.size();i++){
        pathIDStmt p = {pathsDummyIDs.at(i),pathsDummy.at(i)};
        allPaths.push_back(p);
    }

    pathIDStmt currentPath;

    // generate all Paths combining all CFGs
    for(auto perm: permutations){
        readyQueue = perm;
        blockedFunctions.clear();
        combinePaths(readyQueue,blockedFunctions);
    }

    std::map<int,State*> CfgIdToState;
    for(auto i:CfgIdToStateRead){
        CfgIdToState.insert(i);
    }
    for(auto i:CfgIdToStateWrite){
        CfgIdToState.insert(i);
    }
    for(auto i:CfgIdToStateDummy){
        CfgIdToState.insert(i);
    }


    //Generate final Operations
    //Iterate over all paths and set State, nextState and statementList
    for(auto path = finalPaths.begin(); path != finalPaths.end(); path++){
        auto op = new Operation();
        if(path->idList.size()>0){
        op->setState(start_state);
        op->setNextState(start_state);
        }
        operationsFinal.push_back(op);
    }
    cnt = 0;
    for(auto op: operationsFinal) {
        for (auto stmt: finalPaths.at(cnt).stmtList) {
            statementList.push_back(stmt);
        }
        op->setStatementsList(statementList);
        cnt++;
        statementList.clear();
    }

    for(auto op: this->operationsFinal) {
        rOperations->sortOperation(op);
    }

    //Debug
    int num = 0;
    for(auto p:finalPaths){
        std::cout << "Path " << num << ": ";
        for(auto id:p.idList){
            std::cout<<id<<"\t";
        }
        std::cout<< std::endl;
        num++;
    }


    //Optimize operations
    for(int i=0; i<operationsFinal.size();i++){
        if(ValidOperations::isOperationReachable(operationsFinal.at(i))){
            operationsFinalOpt.push_back(operationsFinal.at(i));
            finalPathsOpt.push_back(finalPaths.at(i));
        }
    }

    //Debug
    num = 0;
    for(auto p:finalPathsOpt){
        std::cout << "Path " << num << ": ";
        for(auto id:p.idList){
            std::cout<<id<<"\t";
        }
        std::cout<< std::endl;
        num++;
    }

    for(auto op:operationsFinalOpt){
        op->getState()->addOutgoingOperation(op);
        op->getNextState()->addIncomingOperation(op);
    }


    //add reset operation
    rOperations->sortOperation(reset_op);
    operationsFinalOpt.push_back(reset_op);
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
    finalPathsOpt.push_back(temp);
    wait_op->setState(start_state);
    wait_op->setNextState(start_state);
    wait_op->getState()->addOutgoingOperation(wait_op);
    wait_op->getNextState()->addIncomingOperation(wait_op);

    //Debug
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
        std::vector<SCAM::Stmt*> stmtList_dummy;
        stmtList_dummy.insert(stmtList_dummy.end(),op->getStatementsList().begin(),op->getStatementsList().end());

        for(auto succ_op: operationsFinalOpt){
            if(!succ_op->getState()->isInit()){
                std::vector<SCAM::Stmt*> comb_stmts;
                comb_stmts.insert(comb_stmts.end(),stmtList_dummy.begin(),stmtList_dummy.end());
                comb_stmts.insert(comb_stmts.end(),succ_op->getStatementsList().begin(),succ_op->getStatementsList().end());
                auto dummy_op = new Operation();
                dummy_op->setStatementsList(comb_stmts);
                rOperations->sortOperation(dummy_op);
                if(ValidOperations::isOperationReachable(dummy_op)){
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

    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Regfile_Properties/PropertyGraph.gfv");
    myfile << ss.str();
    myfile.close();

    std::vector<std::string> portnames;
    portnames.push_back("out");
    portnames.push_back("val");


    bool addsync[startnodes.size()];
    bool addnoti[startnodes.size()];

    //Add sync and notify signals
    for(int i=0;i<operationsFinalOpt.size();i++){
        auto op = operationsFinalOpt.at(i);
        for(int j=0;j<startnodes.size();j++){
            addsync[j] = false;
            addnoti[j] = false;
        }
        for(auto id: finalPathsOpt.at(i).idList){
            for(int j=0; j<startnodes.size();j++){
                if(id==startnodes.at(j).id){
                    addsync[j]=true;
                }
                if(id==endnodes.at(j).id){
                    addnoti[j]=true;
                }
            }
        }
        for(int j=0; j<startnodes.size();j++){
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

    std::map<int,State*> stateMap;
    stateMap.insert(std::make_pair(init->getStateId(),init ));
    stateMap.insert(std::make_pair(start_state->getStateId(),start_state));

    module->getFSM()->setStateMap(stateMap);

    PropertyFactory propertyFactory(module);
    module->setPropertySuite(propertyFactory.getPropertySuite());
    PrintITL printITL;
    auto map = printITL.printModule(module);
    myfile.open(SCAM_HOME"/tests/Regfile_Properties/Regfile_generated.vhi");
    myfile << map.at("Regfile.vhi") << std::endl;
    myfile.close();
}



#endif //DESCAM_OPERATION_GRAPH_H
