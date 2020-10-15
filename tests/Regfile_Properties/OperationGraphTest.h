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

    std::map<int, CfgNode *> controlFlowMapWrite;
    std::map<int, CfgNode *> controlFlowMapRead;
    std::map<int, CfgNode *> controlFlowMapDummy;
    std::map<int, CfgNode *> controlFlowMap;

    std::vector<std::vector<SCAM::Stmt*>> pathsWrite;
    std::vector<std::vector<int>> pathsWriteIDs;

    std::vector<std::vector<SCAM::Stmt*>> pathsRead;
    std::vector<std::vector<int>> pathsReadIDs;

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
                    bool addsync[portnames.size()];
                    bool addnoti[portnames.size()];

                    //Sync and Notify are unset by default
                    for(int j=0;j<portnames.size();j++){
                        addsync[j] = false;
                        addnoti[j] = false;
                    }

                    for(auto id: currentPath.idList){
                        for(int j=0; j<portnames.size();j++){
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

                    for(int j=0; j<portnames.size();j++){
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
        auto regs_array = new DataType("int_32");
        DataTypes::addDataType(regs_array);
        regs_array->addArray(DataTypes::getDataType("int"),32);
        auto regs = new Variable("regs",regs_array);
        auto address = new Variable("address",DataTypes::getDataType("int"));
        auto out0 = new Port("out0",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out1 = new Port("out1",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out2 = new Port("out2",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out3 = new Port("out3",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out4 = new Port("out4",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out5 = new Port("out5",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out6 = new Port("out6",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out7 = new Port("out7",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out8 = new Port("out8",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out9 = new Port("out9",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out10 = new Port("out10",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out11 = new Port("out11",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out12 = new Port("out12",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out13 = new Port("out13",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out14 = new Port("out14",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out15 = new Port("out15",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out16 = new Port("out16",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out17 = new Port("out17",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out18 = new Port("out18",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out19 = new Port("out19",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out20 = new Port("out20",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out21 = new Port("out21",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out22 = new Port("out22",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out23 = new Port("out23",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out24 = new Port("out24",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out25 = new Port("out25",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out26 = new Port("out26",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out27 = new Port("out27",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out28 = new Port("out28",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out29 = new Port("out29",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out30 = new Port("out30",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto out31 = new Port("out31",new Interface("blocking","out"),DataTypes::getDataType("int"));
        auto val = new Port("val",new Interface("blocking","in"), DataTypes::getDataType("int"));

        //add Variables to Module
        module->addVariable(regs);
        module->addVariable(address);
        module->addPort(out0);
        module->addPort(out1);
        module->addPort(out2);
        module->addPort(out3);
        module->addPort(out4);
        module->addPort(out5);
        module->addPort(out6);
        module->addPort(out7);
        module->addPort(out8);
        module->addPort(out9);
        module->addPort(out10);
        module->addPort(out11);
        module->addPort(out12);
        module->addPort(out13);
        module->addPort(out14);
        module->addPort(out15);
        module->addPort(out16);
        module->addPort(out17);
        module->addPort(out18);
        module->addPort(out19);
        module->addPort(out20);
        module->addPort(out21);
        module->addPort(out22);
        module->addPort(out23);
        module->addPort(out24);
        module->addPort(out25);
        module->addPort(out26);
        module->addPort(out27);
        module->addPort(out28);
        module->addPort(out29);
        module->addPort(out30);
        module->addPort(out31);
        module->addPort(val);

        for(auto subVar:regs->getSubVarList()){
            module->addVariable(subVar);
        }
        //Debug
        auto noti = new Notify("Test");
        auto ret = new Return("Return");

        //Read Statements
        //out = regs
        auto out0_assign_regs = new Assignment(new DataSignalOperand(out0->getDataSignal()),new VariableOperand(regs->getSubVar("0")));
        auto out1_assign_regs = new Assignment(new DataSignalOperand(out1->getDataSignal()),new VariableOperand(regs->getSubVar("1")));
        auto out2_assign_regs = new Assignment(new DataSignalOperand(out2->getDataSignal()),new VariableOperand(regs->getSubVar("2")));
        auto out3_assign_regs = new Assignment(new DataSignalOperand(out3->getDataSignal()),new VariableOperand(regs->getSubVar("3")));
        auto out4_assign_regs = new Assignment(new DataSignalOperand(out4->getDataSignal()),new VariableOperand(regs->getSubVar("4")));
        auto out5_assign_regs = new Assignment(new DataSignalOperand(out5->getDataSignal()),new VariableOperand(regs->getSubVar("5")));
        auto out6_assign_regs = new Assignment(new DataSignalOperand(out6->getDataSignal()),new VariableOperand(regs->getSubVar("6")));
        auto out7_assign_regs = new Assignment(new DataSignalOperand(out7->getDataSignal()),new VariableOperand(regs->getSubVar("7")));
        auto out8_assign_regs = new Assignment(new DataSignalOperand(out8->getDataSignal()),new VariableOperand(regs->getSubVar("8")));
        auto out9_assign_regs = new Assignment(new DataSignalOperand(out9->getDataSignal()),new VariableOperand(regs->getSubVar("9")));
        auto out10_assign_regs = new Assignment(new DataSignalOperand(out10->getDataSignal()),new VariableOperand(regs->getSubVar("10")));
        auto out11_assign_regs = new Assignment(new DataSignalOperand(out11->getDataSignal()),new VariableOperand(regs->getSubVar("11")));
        auto out12_assign_regs = new Assignment(new DataSignalOperand(out12->getDataSignal()),new VariableOperand(regs->getSubVar("12")));
        auto out13_assign_regs = new Assignment(new DataSignalOperand(out13->getDataSignal()),new VariableOperand(regs->getSubVar("13")));
        auto out14_assign_regs = new Assignment(new DataSignalOperand(out14->getDataSignal()),new VariableOperand(regs->getSubVar("14")));
        auto out15_assign_regs = new Assignment(new DataSignalOperand(out15->getDataSignal()),new VariableOperand(regs->getSubVar("15")));
        auto out16_assign_regs = new Assignment(new DataSignalOperand(out16->getDataSignal()),new VariableOperand(regs->getSubVar("16")));
        auto out17_assign_regs = new Assignment(new DataSignalOperand(out17->getDataSignal()),new VariableOperand(regs->getSubVar("17")));
        auto out18_assign_regs = new Assignment(new DataSignalOperand(out18->getDataSignal()),new VariableOperand(regs->getSubVar("18")));
        auto out19_assign_regs = new Assignment(new DataSignalOperand(out19->getDataSignal()),new VariableOperand(regs->getSubVar("19")));
        auto out20_assign_regs = new Assignment(new DataSignalOperand(out20->getDataSignal()),new VariableOperand(regs->getSubVar("20")));
        auto out21_assign_regs = new Assignment(new DataSignalOperand(out21->getDataSignal()),new VariableOperand(regs->getSubVar("21")));
        auto out22_assign_regs = new Assignment(new DataSignalOperand(out22->getDataSignal()),new VariableOperand(regs->getSubVar("22")));
        auto out23_assign_regs = new Assignment(new DataSignalOperand(out23->getDataSignal()),new VariableOperand(regs->getSubVar("23")));
        auto out24_assign_regs = new Assignment(new DataSignalOperand(out24->getDataSignal()),new VariableOperand(regs->getSubVar("24")));
        auto out25_assign_regs = new Assignment(new DataSignalOperand(out25->getDataSignal()),new VariableOperand(regs->getSubVar("25")));
        auto out26_assign_regs = new Assignment(new DataSignalOperand(out26->getDataSignal()),new VariableOperand(regs->getSubVar("26")));
        auto out27_assign_regs = new Assignment(new DataSignalOperand(out27->getDataSignal()),new VariableOperand(regs->getSubVar("27")));
        auto out28_assign_regs = new Assignment(new DataSignalOperand(out28->getDataSignal()),new VariableOperand(regs->getSubVar("28")));
        auto out29_assign_regs = new Assignment(new DataSignalOperand(out29->getDataSignal()),new VariableOperand(regs->getSubVar("29")));
        auto out30_assign_regs = new Assignment(new DataSignalOperand(out30->getDataSignal()),new VariableOperand(regs->getSubVar("30")));
        auto out31_assign_regs = new Assignment(new DataSignalOperand(out31->getDataSignal()),new VariableOperand(regs->getSubVar("31")));
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
        auto set_out0 = new CfgNode(out0_assign_regs);
        auto set_out1 = new CfgNode(out1_assign_regs);
        auto set_out2 = new CfgNode(out2_assign_regs);
        auto set_out3 = new CfgNode(out3_assign_regs);
        auto set_out4 = new CfgNode(out4_assign_regs);
        auto set_out5 = new CfgNode(out5_assign_regs);
        auto set_out6 = new CfgNode(out6_assign_regs);
        auto set_out7 = new CfgNode(out7_assign_regs);
        auto set_out8 = new CfgNode(out8_assign_regs);
        auto set_out9 = new CfgNode(out9_assign_regs);
        auto set_out10 = new CfgNode(out10_assign_regs);
        auto set_out11 = new CfgNode(out11_assign_regs);
        auto set_out12 = new CfgNode(out12_assign_regs);
        auto set_out13 = new CfgNode(out13_assign_regs);
        auto set_out14 = new CfgNode(out14_assign_regs);
        auto set_out15 = new CfgNode(out15_assign_regs);
        auto set_out16 = new CfgNode(out16_assign_regs);
        auto set_out17 = new CfgNode(out17_assign_regs);
        auto set_out18 = new CfgNode(out18_assign_regs);
        auto set_out19 = new CfgNode(out19_assign_regs);
        auto set_out20 = new CfgNode(out20_assign_regs);
        auto set_out21 = new CfgNode(out21_assign_regs);
        auto set_out22 = new CfgNode(out22_assign_regs);
        auto set_out23 = new CfgNode(out23_assign_regs);
        auto set_out24 = new CfgNode(out24_assign_regs);
        auto set_out25 = new CfgNode(out25_assign_regs);
        auto set_out26 = new CfgNode(out26_assign_regs);
        auto set_out27 = new CfgNode(out27_assign_regs);
        auto set_out28 = new CfgNode(out28_assign_regs);
        auto set_out29 = new CfgNode(out29_assign_regs);
        auto set_out30 = new CfgNode(out30_assign_regs);
        auto set_out31 = new CfgNode(out31_assign_regs);
        auto return_read = new CfgNode(read_return);

        //Link CFG nodes Read
        set_out0->addSuccessor(set_out1);
        set_out1->addSuccessor(set_out2);
        set_out2->addSuccessor(set_out3);
        set_out3->addSuccessor(set_out4);
        set_out4->addSuccessor(set_out5);
        set_out5->addSuccessor(set_out6);
        set_out6->addSuccessor(set_out7);
        set_out7->addSuccessor(set_out8);
        set_out8->addSuccessor(set_out9);
        set_out9->addSuccessor(set_out10);
        set_out10->addSuccessor(set_out11);
        set_out11->addSuccessor(set_out12);
        set_out12->addSuccessor(set_out13);
        set_out13->addSuccessor(set_out14);
        set_out14->addSuccessor(set_out15);
        set_out15->addSuccessor(set_out16);
        set_out16->addSuccessor(set_out17);
        set_out17->addSuccessor(set_out18);
        set_out18->addSuccessor(set_out19);
        set_out19->addSuccessor(set_out20);
        set_out20->addSuccessor(set_out21);
        set_out21->addSuccessor(set_out22);
        set_out22->addSuccessor(set_out23);
        set_out23->addSuccessor(set_out24);
        set_out24->addSuccessor(set_out25);
        set_out25->addSuccessor(set_out26);
        set_out26->addSuccessor(set_out27);
        set_out27->addSuccessor(set_out28);
        set_out28->addSuccessor(set_out29);
        set_out29->addSuccessor(set_out30);
        set_out30->addSuccessor(set_out31);
        set_out31->addSuccessor(return_read);

        //create map with CFG nodes Read
        controlFlowMapRead.insert(std::make_pair(set_out0->getId(),set_out0));
        controlFlowMapRead.insert(std::make_pair(set_out1->getId(),set_out1));
        controlFlowMapRead.insert(std::make_pair(set_out2->getId(),set_out2));
        controlFlowMapRead.insert(std::make_pair(set_out3->getId(),set_out3));
        controlFlowMapRead.insert(std::make_pair(set_out4->getId(),set_out4));
        controlFlowMapRead.insert(std::make_pair(set_out5->getId(),set_out5));
        controlFlowMapRead.insert(std::make_pair(set_out6->getId(),set_out6));
        controlFlowMapRead.insert(std::make_pair(set_out7->getId(),set_out7));
        controlFlowMapRead.insert(std::make_pair(set_out8->getId(),set_out8));
        controlFlowMapRead.insert(std::make_pair(set_out9->getId(),set_out9));
        controlFlowMapRead.insert(std::make_pair(set_out10->getId(),set_out10));
        controlFlowMapRead.insert(std::make_pair(set_out11->getId(),set_out11));
        controlFlowMapRead.insert(std::make_pair(set_out12->getId(),set_out12));
        controlFlowMapRead.insert(std::make_pair(set_out13->getId(),set_out13));
        controlFlowMapRead.insert(std::make_pair(set_out14->getId(),set_out14));
        controlFlowMapRead.insert(std::make_pair(set_out15->getId(),set_out15));
        controlFlowMapRead.insert(std::make_pair(set_out16->getId(),set_out16));
        controlFlowMapRead.insert(std::make_pair(set_out17->getId(),set_out17));
        controlFlowMapRead.insert(std::make_pair(set_out18->getId(),set_out18));
        controlFlowMapRead.insert(std::make_pair(set_out19->getId(),set_out19));
        controlFlowMapRead.insert(std::make_pair(set_out20->getId(),set_out20));
        controlFlowMapRead.insert(std::make_pair(set_out21->getId(),set_out21));
        controlFlowMapRead.insert(std::make_pair(set_out22->getId(),set_out22));
        controlFlowMapRead.insert(std::make_pair(set_out23->getId(),set_out23));
        controlFlowMapRead.insert(std::make_pair(set_out24->getId(),set_out24));
        controlFlowMapRead.insert(std::make_pair(set_out25->getId(),set_out25));
        controlFlowMapRead.insert(std::make_pair(set_out26->getId(),set_out26));
        controlFlowMapRead.insert(std::make_pair(set_out27->getId(),set_out27));
        controlFlowMapRead.insert(std::make_pair(set_out28->getId(),set_out28));
        controlFlowMapRead.insert(std::make_pair(set_out29->getId(),set_out29));
        controlFlowMapRead.insert(std::make_pair(set_out30->getId(),set_out30));
        controlFlowMapRead.insert(std::make_pair(set_out31->getId(),set_out31));
        controlFlowMapRead.insert(std::make_pair(return_read->getId(),return_read));

        //add nodes to global controlFlowMap
        controlFlowMap.insert(std::make_pair(set_out0->getId(),set_out0));
        controlFlowMap.insert(std::make_pair(set_out1->getId(),set_out1));
        controlFlowMap.insert(std::make_pair(set_out2->getId(),set_out2));
        controlFlowMap.insert(std::make_pair(set_out3->getId(),set_out3));
        controlFlowMap.insert(std::make_pair(set_out4->getId(),set_out4));
        controlFlowMap.insert(std::make_pair(set_out5->getId(),set_out5));
        controlFlowMap.insert(std::make_pair(set_out6->getId(),set_out6));
        controlFlowMap.insert(std::make_pair(set_out7->getId(),set_out7));
        controlFlowMap.insert(std::make_pair(set_out8->getId(),set_out8));
        controlFlowMap.insert(std::make_pair(set_out9->getId(),set_out9));
        controlFlowMap.insert(std::make_pair(set_out10->getId(),set_out10));
        controlFlowMap.insert(std::make_pair(set_out11->getId(),set_out11));
        controlFlowMap.insert(std::make_pair(set_out12->getId(),set_out12));
        controlFlowMap.insert(std::make_pair(set_out13->getId(),set_out13));
        controlFlowMap.insert(std::make_pair(set_out14->getId(),set_out14));
        controlFlowMap.insert(std::make_pair(set_out15->getId(),set_out15));
        controlFlowMap.insert(std::make_pair(set_out16->getId(),set_out16));
        controlFlowMap.insert(std::make_pair(set_out17->getId(),set_out17));
        controlFlowMap.insert(std::make_pair(set_out18->getId(),set_out18));
        controlFlowMap.insert(std::make_pair(set_out19->getId(),set_out19));
        controlFlowMap.insert(std::make_pair(set_out20->getId(),set_out20));
        controlFlowMap.insert(std::make_pair(set_out21->getId(),set_out21));
        controlFlowMap.insert(std::make_pair(set_out22->getId(),set_out22));
        controlFlowMap.insert(std::make_pair(set_out23->getId(),set_out23));
        controlFlowMap.insert(std::make_pair(set_out24->getId(),set_out24));
        controlFlowMap.insert(std::make_pair(set_out25->getId(),set_out25));
        controlFlowMap.insert(std::make_pair(set_out26->getId(),set_out26));
        controlFlowMap.insert(std::make_pair(set_out27->getId(),set_out27));
        controlFlowMap.insert(std::make_pair(set_out28->getId(),set_out28));
        controlFlowMap.insert(std::make_pair(set_out29->getId(),set_out29));
        controlFlowMap.insert(std::make_pair(set_out30->getId(),set_out30));
        controlFlowMap.insert(std::make_pair(set_out31->getId(),set_out31));
        controlFlowMap.insert(std::make_pair(return_read->getId(),return_read));

        //Print CFG for Read
        std::cout << printCFG(controlFlowMapRead) << std::endl;

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

        //Print CFG Write
        std::cout << printCFG(controlFlowMapWrite) << std::endl;

        //Print CFG Dummy
        std::cout << printCFG(controlFlowMapDummy) << std::endl;

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

        eventID temp;
//        temp = {0, "reader_sync"};
//        startnodes.push_back(temp);
        temp = {33,"writer_sync"};
        startnodes.push_back(temp);

//        temp = {1,"reader_notify"};
//        endnodes.push_back(temp);
        temp = {67,"writer_notify"};
        endnodes.push_back(temp);

        portnames.push_back("val");


    }

    virtual void TearDown() {}

};

TEST_F(OperationGraphTest, ExtractPaths){
    //Find important states Read
    std::map<int, CfgNode *> importantStatesRead;
    findImportantStates(controlFlowMapRead,&importantStatesRead);

    //Find paths Read
    auto start_read = controlFlowMapRead.begin()->second;
    findPathsfromNode(start_read,&pathsRead,&pathsReadIDs);
    for(auto const& node : importantStatesRead) {
        findPathsfromNode(node.second,&pathsRead,&pathsReadIDs);
    }

    //Find important states Write
    std::map<int, CfgNode *> importantStatesWrite;
    findImportantStates(controlFlowMapWrite,&importantStatesWrite);

    //Find operations Write
    auto start_write = controlFlowMapWrite.begin()->second;
    findPathsfromNode(start_write,&pathsWrite,&pathsWriteIDs);
    for(auto const& node : importantStatesWrite) {
        findPathsfromNode(node.second,&pathsWrite,&pathsWriteIDs);
    }

    //Find important states Dummy
    std::map<int, CfgNode *> importantStatesDummy;
    findImportantStates(controlFlowMapDummy,&importantStatesDummy);

    //Find operations Dummy
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
    eventID read = {0,"read"};
    eventID write = {33,"write"};
    eventID dummy = {68,"dummy"};

    //vector of all functions that are always ready to execute
    std::vector<eventID> always_ready;
    always_ready.push_back(dummy);

    //Vector of all functions that can be called from modules
    std::vector<eventID> functions;
    functions.push_back(read);
    functions.push_back(write);

    //compute all possible permutations and store them in variable permutations
    computePermutations(functions);
    std::cout << "Number of permutations: " <<permutations.size() << std::endl;

    //add all functions from always_ready to all permuations
    for(auto readyFunc : always_ready){
        for(auto perm = permutations.begin(); perm != permutations.end(); ++perm){
            perm->push_back(readyFunc);
        }
    }

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
        //if(i>2) break;
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
    for(int i=0; i<portnames.size();i++){
        auto noti = new Notify(module->getPort(portnames.at(i)));
        auto assign = new Assignment(noti,new BoolValue(false));
        reset_op->addCommitment(assign);
    }
    operationsFinalOpt.push_back(reset_op);
    //Create empty path for reset operation
    std::vector<int> int_vec;
    std::vector<SCAM::Stmt*> stmt_vec;
    pathIDStmt temp = {int_vec,stmt_vec};
    //finalPathsOpt.push_back(temp);
    reset_op->getState()->addOutgoingOperation(reset_op);
    reset_op->getNextState()->addIncomingOperation(reset_op);

    //wait operation
    auto wait_op = new Operation();
    rOperations->sortOperation(wait_op);
    for(int i=0; i<portnames.size();i++){
        auto sync = new SyncSignal(module->getPort(portnames.at(i)));
        auto noti = new Notify(module->getPort(portnames.at(i)));
        wait_op->addAssumption(new UnaryExpr("not",sync));
        auto assign = new Assignment(noti,new BoolValue(false));
        wait_op->addCommitment(assign);
    }

    operationsFinalOpt.push_back(wait_op);
    //create empty path for wait operation
    //finalPathsOpt.push_back(temp);
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
    myfile.open(SCAM_HOME"/tests/Regfile_Properties/" + module->getName() + "_generated.vhi");
    myfile << map.at(module->getName() + ".vhi") << std::endl;
    myfile.close();
}



#endif //DESCAM_OPERATION_GRAPH_H
