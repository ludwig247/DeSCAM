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
    OperationGraphTest():module(new SCAM::Module("Synchronizer")){
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

    std::map<int, CfgNode *> controlFlowMapWrite0;
    std::map<int, CfgNode *> controlFlowMapWrite1;
    std::map<int, CfgNode *> controlFlowMapWrite2;
    std::map<int, CfgNode *> controlFlowMapRead;
    std::map<int, CfgNode *> controlFlowMap;

    std::vector<std::vector<SCAM::Stmt*>> pathsWrite0;
    std::vector<std::vector<int>> pathsWrite0IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite1;
    std::vector<std::vector<int>> pathsWrite1IDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite2;
    std::vector<std::vector<int>> pathsWrite2IDs;

    std::vector<std::vector<SCAM::Stmt*>> pathsRead;
    std::vector<std::vector<int>> pathsReadIDs;


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
        auto buffer_array = new DataType("int_32");
        DataTypes::addDataType(buffer_array);
        buffer_array->addArray(DataTypes::getDataType("int"),3);
        auto buffer = new Variable("buffer", buffer_array);
        auto number_of_senders = new UnsignedValue(3);
//        auto cnt = new Variable("cnt",DataTypes::getDataType("unsigned"));
        auto flag_array = new DataType("bool");
//        DataTypes::addDataType(flag_array);
//        flag_array->addArray(DataTypes::getDataType("bool"),3);
//        auto flags = new Variable("flags", flag_array);
        auto flag0 = new Variable("flag0",DataTypes::getDataType("bool"));
        auto flag1 = new Variable("flag1",DataTypes::getDataType("bool"));
        auto flag2 = new Variable("flag2",DataTypes::getDataType("bool"));
        auto out = new Port("out",new Interface("blocking","out"),buffer_array);
        auto val_0 = new Port("val_0",new Interface("blocking","in"), DataTypes::getDataType("int"));
        auto val_1 = new Port("val_1",new Interface("blocking","in"), DataTypes::getDataType("int"));
        auto val_2 = new Port("val_2",new Interface("blocking","in"), DataTypes::getDataType("int"));

        //add Variables to Module
        module->addVariable(buffer);
//        module->addVariable(flags);
//        module->addVariable(cnt);
        module->addVariable(flag0);
        module->addVariable(flag1);
        module->addVariable(flag2);
        module->addPort(out);
        module->addPort(val_0);
        module->addPort(val_1);
        module->addPort(val_2);
//        for(auto subVar:flags->getSubVarList()){
//            module->addVariable(subVar);
//        }
        for(auto subVar:buffer->getSubVarList()){
            module->addVariable(subVar);
        }
        //Read Statements
//        auto flags_0 = new ArrayOperand(new VariableOperand(module->getVariable("flags")),new UnsignedValue(0));
//        auto flags_1 = new ArrayOperand(new VariableOperand(module->getVariable("flags")),new UnsignedValue(1));
//        auto flags_2 = new ArrayOperand(new VariableOperand(module->getVariable("flags")),new UnsignedValue(2));

        //if(not(flags.at(i)))
        auto not_flags_0 = new UnaryExpr("not", new VariableOperand(flag0));
        auto not_flags_1 = new UnaryExpr("not", new VariableOperand(flag1));
        auto not_flags_2 = new UnaryExpr("not", new VariableOperand(flag2));

        //if(cnt<NUMBER_OF_SENDERS)
        auto if_not_flags_0 = new If(not_flags_0);
        auto if_not_flags_1 = new If(not_flags_1);
        auto if_not_flags_2 = new If(not_flags_2);
        //wait(writer_notify)
        auto writer_wait0 = new Wait("writer_notify0");
        auto writer_wait1 = new Wait("writer_notify1");
        auto writer_wait2 = new Wait("writer_notify2");

        //for(int i=0; i<number_of_senders; i++) unrolled
        //flags.at(i) = false;
        auto false_value = new BoolValue(false);
        auto flags_0_assign_false = new Assignment(new VariableOperand(flag0),false_value);
        //flags[1] = false;
        auto flags_1_assign_false = new Assignment(new VariableOperand(flag1),false_value);
        //flags[2] = false;
        auto flags_2_assign_false = new Assignment(new VariableOperand(flag2),false_value);
        //cnt = 0
//        auto cnt_assign_0 = new Assignment(new VariableOperand(module->getVariable("cnt")),new UnsignedValue(0));
        //for(int i=0; i<number_of_senders; i++) unrolled
        //out.at(0)=buffer.at(0)
        auto out_0 = new ArrayOperand(new DataSignalOperand(out->getDataSignal()),new IntegerValue(0));
        auto buffer_0 = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new UnsignedValue(0));//new VariableOperand(buffer->getSubVar("0"));
        auto out_0_assign_buffer_0 = new Assignment(out_0,buffer_0);
        //out.at(1)=buffer.at(1)
        auto out_1 = new ArrayOperand(new DataSignalOperand(out->getDataSignal()),new IntegerValue(1));
        auto buffer_1 = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new UnsignedValue(1));//new VariableOperand(buffer->getSubVar("1"));
        auto out_1_assign_buffer_1 = new Assignment(out_1,buffer_1);
        //out.at(2)=buffer.at(2)
        auto out_2 = new ArrayOperand(new DataSignalOperand(out->getDataSignal()),new IntegerValue(2));
        auto buffer_2 = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new UnsignedValue(2));//new VariableOperand(buffer->getSubVar("2"));
        auto out_2_assign_buffer_2 = new Assignment(out_2,buffer_2);
        //reader_notify.notify()
        auto notify_reader = new Notify("reader_notify");
        //return
        auto read_return = new Return("read_return");

        //Write Expressions/Assignments id=0
        //if(flags.at(0))
        auto if_flags_0 = new If(new VariableOperand(flag0));
        //wait(reader_notify)
        auto reader_wait = new Wait("reader_notify");
        //flags.at(0) = true
        auto true_value = new BoolValue(true);
        auto flags_0_assign_true = new Assignment(new VariableOperand(flag0),true_value);
        //buffer.at(0)=val;
        auto port_val_0 = new DataSignalOperand(val_0->getDataSignal());
        auto buffer_0_assign_port_val_0 = new Assignment(buffer_0,port_val_0);
        //cnt++
//        auto cnt_add_1 = new Arithmetic(new VariableOperand(cnt),"+",new UnsignedValue(1));
//        auto cnt_inc = new Assignment(new VariableOperand(cnt),cnt_add_1);
        //writer_notify.notify()
        auto notify_writer0 = new Notify("writer_notify0");
        //return
        auto write_return = new Return("write_return");

        //Write Expressions/Assignments id=1
        //if(flags.at(1))
        auto if_flags_1 = new If(new VariableOperand(flag1));
        //wait(reader_notify)
        //already exists
        //flags.at(1) = true
        auto flags_1_assign_true = new Assignment(new VariableOperand(flag1),true_value);
        //buffer.at(1)=val;
        auto port_val_1 = new DataSignalOperand(val_1->getDataSignal());
        auto buffer_1_assign_port_val_1 = new Assignment(buffer_1,port_val_1);
        //cnt++
        //already exists
        //writer_notify.notify()
        auto notify_writer1 = new Notify("writer_notify1");
        //return
        //already exists

        //Write Expressions/Assignments id=2
        //if(flags.at(2))
        auto if_flags_2 = new If(new VariableOperand(flag2));
        //wait(reader_notify)
        //already exists
        //flags.at(2) = true
        auto flags_2_assign_true = new Assignment(new VariableOperand(flag2),true_value);
        //buffer.at(2)=val;
        auto port_val_2 = new DataSignalOperand(val_2->getDataSignal());
        auto buffer_2_assign_port_val_2 = new Assignment(buffer_2,port_val_2);
        //cnt++
        //already exists
        //writer_notify.notify()
        auto notify_writer2 = new Notify("writer_notify2");
        // return
        //already exists

        //CFG nodes Read
        auto check_not_flag_0 = new CfgNode(if_not_flags_0);
        auto wait_writer_0 = new CfgNode(writer_wait0);
        auto check_not_flag_1 = new CfgNode(if_not_flags_1);
        auto wait_writer_1 = new CfgNode(writer_wait1);
        auto check_not_flag_2 = new CfgNode(if_not_flags_2);
        auto wait_writer_2 = new CfgNode(writer_wait2);
        auto unset_flags_0 = new CfgNode(flags_0_assign_false);
        auto unset_flags_1 = new CfgNode(flags_1_assign_false);
        auto unset_flags_2 = new CfgNode(flags_2_assign_false);
//        auto reset_cnt = new CfgNode(cnt_assign_0);
        auto set_output_0 = new CfgNode(out_0_assign_buffer_0);
        auto set_output_1 = new CfgNode(out_1_assign_buffer_1);
        auto set_output_2 = new CfgNode(out_2_assign_buffer_2);
        auto read_notify = new CfgNode(notify_reader);
        auto return_read = new CfgNode(read_return);

        //Link CFG nodes Read
        check_not_flag_0->addSuccessor(wait_writer_0);
        check_not_flag_0->addSuccessor(check_not_flag_1);
        wait_writer_0->addSuccessor(check_not_flag_1);
        check_not_flag_1->addSuccessor(wait_writer_1);
        check_not_flag_1->addSuccessor(check_not_flag_2);
        wait_writer_1->addSuccessor(check_not_flag_2);
        check_not_flag_2->addSuccessor(wait_writer_2);
        check_not_flag_2->addSuccessor(unset_flags_0);
        wait_writer_2->addSuccessor(unset_flags_0);
        unset_flags_0->addSuccessor(unset_flags_1);
        unset_flags_1->addSuccessor(unset_flags_2);
        unset_flags_2->addSuccessor(set_output_0);
        set_output_0->addSuccessor(set_output_1);
        set_output_1->addSuccessor(set_output_2);
        set_output_2->addSuccessor(read_notify);
        read_notify->addSuccessor(return_read);


        //create map with CFG nodes Read
        controlFlowMapRead.insert(std::make_pair(check_not_flag_0->getId(),check_not_flag_0));
        controlFlowMapRead.insert(std::make_pair(wait_writer_0->getId(),wait_writer_0));
        controlFlowMapRead.insert(std::make_pair(check_not_flag_1->getId(),check_not_flag_1));
        controlFlowMapRead.insert(std::make_pair(wait_writer_1->getId(),wait_writer_1));
        controlFlowMapRead.insert(std::make_pair(check_not_flag_2->getId(),check_not_flag_2));
        controlFlowMapRead.insert(std::make_pair(wait_writer_2->getId(),wait_writer_2));
        controlFlowMapRead.insert(std::make_pair(unset_flags_0->getId(),unset_flags_0));
        controlFlowMapRead.insert(std::make_pair(unset_flags_1->getId(),unset_flags_1));
        controlFlowMapRead.insert(std::make_pair(unset_flags_2->getId(),unset_flags_2));
        controlFlowMapRead.insert(std::make_pair(set_output_0->getId(),set_output_0));
        controlFlowMapRead.insert(std::make_pair(set_output_1->getId(),set_output_1));
        controlFlowMapRead.insert(std::make_pair(set_output_2->getId(),set_output_2));
        controlFlowMapRead.insert(std::make_pair(read_notify->getId(),read_notify));
        controlFlowMapRead.insert(std::make_pair(return_read->getId(),return_read));

        //add nodes to global controlFlowMap
        controlFlowMap.insert(std::make_pair(check_not_flag_0->getId(),check_not_flag_0));
        controlFlowMap.insert(std::make_pair(wait_writer_0->getId(),wait_writer_0));
        controlFlowMap.insert(std::make_pair(check_not_flag_1->getId(),check_not_flag_1));
        controlFlowMap.insert(std::make_pair(wait_writer_1->getId(),wait_writer_1));
        controlFlowMap.insert(std::make_pair(check_not_flag_2->getId(),check_not_flag_2));
        controlFlowMap.insert(std::make_pair(wait_writer_2->getId(),wait_writer_2));
        controlFlowMap.insert(std::make_pair(unset_flags_0->getId(),unset_flags_0));
        controlFlowMap.insert(std::make_pair(unset_flags_1->getId(),unset_flags_1));
        controlFlowMap.insert(std::make_pair(unset_flags_2->getId(),unset_flags_2));
        controlFlowMap.insert(std::make_pair(set_output_0->getId(),set_output_0));
        controlFlowMap.insert(std::make_pair(set_output_1->getId(),set_output_1));
        controlFlowMap.insert(std::make_pair(set_output_2->getId(),set_output_2));
        controlFlowMap.insert(std::make_pair(read_notify->getId(),read_notify));
        controlFlowMap.insert(std::make_pair(return_read->getId(),return_read));

        //Print CFG for Read
        std::cout << printCFG(controlFlowMapRead) << std::endl;

        //CFG nodes Write id=0
        auto check_flags_id_0 = new CfgNode(if_flags_0);
        auto wait_reader_0 = new CfgNode(reader_wait);
        auto set_flags_id_0 = new CfgNode(flags_0_assign_true);
        auto set_buffer_id_0 = new CfgNode(buffer_0_assign_port_val_0);
        auto write_notify_0 = new CfgNode(notify_writer0);
        auto return_write_0 = new CfgNode(write_return);

        //CFG nodes Write id=1
        auto check_flags_id_1 = new CfgNode(if_flags_1);
        auto wait_reader_1 = new CfgNode(reader_wait);
        auto set_flags_id_1 = new CfgNode(flags_1_assign_true);
        auto set_buffer_id_1 = new CfgNode(buffer_1_assign_port_val_1);
        auto write_notify_1 = new CfgNode(notify_writer1);
        auto return_write_1 = new CfgNode(write_return);

        //CFG nodes Write id=2
        auto check_flags_id_2 = new CfgNode(if_flags_2);
        auto wait_reader_2 = new CfgNode(reader_wait);
        auto set_flags_id_2 = new CfgNode(flags_2_assign_true);
        auto set_buffer_id_2 = new CfgNode(buffer_2_assign_port_val_2);
        auto write_notify_2 = new CfgNode(notify_writer2);
        auto return_write_2 = new CfgNode(write_return);

        //Connect CFG nodes Write id=0
        check_flags_id_0->addSuccessor(wait_reader_0);
        check_flags_id_0->addSuccessor(set_flags_id_0);
        wait_reader_0->addSuccessor(set_flags_id_0);
        set_flags_id_0->addSuccessor(set_buffer_id_0);
        set_buffer_id_0->addSuccessor(write_notify_0);
        write_notify_0->addSuccessor(return_write_0);

        //Connect CFG nodes Write id=1
        check_flags_id_1->addSuccessor(wait_reader_1);
        check_flags_id_1->addSuccessor(set_flags_id_1);
        wait_reader_1->addSuccessor(set_flags_id_1);
        set_flags_id_1->addSuccessor(set_buffer_id_1);
        set_buffer_id_1->addSuccessor(write_notify_1);
        write_notify_1->addSuccessor(return_write_1);

        //Connect CFG nodes Write id=2
        check_flags_id_2->addSuccessor(wait_reader_2);
        check_flags_id_2->addSuccessor(set_flags_id_2);
        wait_reader_2->addSuccessor(set_flags_id_2);
        set_flags_id_2->addSuccessor(set_buffer_id_2);
        set_buffer_id_2->addSuccessor(write_notify_2);
        write_notify_2->addSuccessor(return_write_2);

        //Create map with CFG nodes Write id=0
        controlFlowMapWrite0.insert(std::make_pair(check_flags_id_0->getId(),check_flags_id_0));
        controlFlowMapWrite0.insert(std::make_pair(wait_reader_0->getId(),wait_reader_0));
        controlFlowMapWrite0.insert(std::make_pair(set_flags_id_0->getId(),set_flags_id_0));
        controlFlowMapWrite0.insert(std::make_pair(set_buffer_id_0->getId(),set_buffer_id_0));
        controlFlowMapWrite0.insert(std::make_pair(write_notify_0->getId(),write_notify_0));
        controlFlowMapWrite0.insert(std::make_pair(return_write_0->getId(),return_write_0));

        //Create map with CFG nodes Write id=1
        controlFlowMapWrite1.insert(std::make_pair(check_flags_id_1->getId(),check_flags_id_1));
        controlFlowMapWrite1.insert(std::make_pair(wait_reader_1->getId(),wait_reader_1));
        controlFlowMapWrite1.insert(std::make_pair(set_flags_id_1->getId(),set_flags_id_1));
        controlFlowMapWrite1.insert(std::make_pair(set_buffer_id_1->getId(),set_buffer_id_1));
        controlFlowMapWrite1.insert(std::make_pair(write_notify_1->getId(),write_notify_1));
        controlFlowMapWrite1.insert(std::make_pair(return_write_1->getId(),return_write_1));

        //Create map with CFG nodes Write id=2
        controlFlowMapWrite2.insert(std::make_pair(check_flags_id_2->getId(),check_flags_id_2));
        controlFlowMapWrite2.insert(std::make_pair(wait_reader_2->getId(),wait_reader_2));
        controlFlowMapWrite2.insert(std::make_pair(set_flags_id_2->getId(),set_flags_id_2));
        controlFlowMapWrite2.insert(std::make_pair(set_buffer_id_2->getId(),set_buffer_id_2));
        controlFlowMapWrite2.insert(std::make_pair(write_notify_2->getId(),write_notify_2));
        controlFlowMapWrite2.insert(std::make_pair(return_write_2->getId(),return_write_2));

        //add nodes to global controlFlowMap
        controlFlowMap.insert(std::make_pair(check_flags_id_0->getId(),check_flags_id_0));
        controlFlowMap.insert(std::make_pair(wait_reader_0->getId(),wait_reader_0));
        controlFlowMap.insert(std::make_pair(set_flags_id_0->getId(),set_flags_id_0));
        controlFlowMap.insert(std::make_pair(set_buffer_id_0->getId(),set_buffer_id_0));
        controlFlowMap.insert(std::make_pair(write_notify_0->getId(),write_notify_0));
        controlFlowMap.insert(std::make_pair(return_write_0->getId(),return_write_0));
        controlFlowMap.insert(std::make_pair(check_flags_id_1->getId(),check_flags_id_1));
        controlFlowMap.insert(std::make_pair(wait_reader_1->getId(),wait_reader_1));
        controlFlowMap.insert(std::make_pair(set_flags_id_1->getId(),set_flags_id_1));
        controlFlowMap.insert(std::make_pair(set_buffer_id_1->getId(),set_buffer_id_1));
        controlFlowMap.insert(std::make_pair(write_notify_1->getId(),write_notify_1));
        controlFlowMap.insert(std::make_pair(return_write_1->getId(),return_write_1));
        controlFlowMap.insert(std::make_pair(check_flags_id_2->getId(),check_flags_id_2));
        controlFlowMap.insert(std::make_pair(wait_reader_2->getId(),wait_reader_2));
        controlFlowMap.insert(std::make_pair(set_flags_id_2->getId(),set_flags_id_2));
        controlFlowMap.insert(std::make_pair(set_buffer_id_2->getId(),set_buffer_id_2));
        controlFlowMap.insert(std::make_pair(write_notify_2->getId(),write_notify_2));
        controlFlowMap.insert(std::make_pair(return_write_2->getId(),return_write_2));

//        //Print CFG Write
        std::cout << printCFG(controlFlowMapWrite0) << std::endl;
        std::cout << printCFG(controlFlowMapWrite1) << std::endl;
        std::cout << printCFG(controlFlowMapWrite2) << std::endl;


        init = new State("reset");
        init->setInit();

        //Generate Reset Operation
        reset_op = new Operation();
        reset_op->addStatement(flags_0_assign_false);
        reset_op->addStatement(flags_1_assign_false);
        reset_op->addStatement(flags_2_assign_false);
        auto buffer_0_assign_0 = new Assignment(buffer_0,new IntegerValue(0));
        auto buffer_1_assign_0 = new Assignment(buffer_1,new IntegerValue(0));
        auto buffer_2_assign_0 = new Assignment(buffer_2,new IntegerValue(0));
        reset_op->addStatement(buffer_0_assign_0);
        reset_op->addStatement(buffer_1_assign_0);
        reset_op->addStatement(buffer_2_assign_0);
        reset_op->setState(init);
        start_state = new State("start_state");
        reset_op->setNextState(start_state);
        reset_op->setReset(true);

        eventID temp = {0, "reader_sync"};
        startnodes.push_back(temp);
        temp = {14,"writer_0_sync"};
        startnodes.push_back(temp);
        temp = {20,"writer_1_sync"};
        startnodes.push_back(temp);
        temp = {26,"writer_2_sync"};
        startnodes.push_back(temp);

        temp = {13,"reader_notify"};
        endnodes.push_back(temp);
        temp = {19,"writer_0_notify"};
        endnodes.push_back(temp);
        temp = {25,"writer_1_notify"};
        endnodes.push_back(temp);
        temp = {31,"writer_2_notify"};
        endnodes.push_back(temp);

        //Define portnames for notify and sync signals
        portnames.push_back("out");
        portnames.push_back("val_0");
        portnames.push_back("val_1");
        portnames.push_back("val_2");

    }

    virtual void TearDown() {}

};

TEST_F(OperationGraphTest, ExtractPaths){
    //Find important states Read
    std::map<int, CfgNode *> importantStatesRead;
    findImportantStates(controlFlowMapRead,&importantStatesRead);

    //Find subpaths Read
    auto start_read = controlFlowMapRead.begin()->second;
    findPathsfromNode(start_read,&pathsRead,&pathsReadIDs);
    for(auto const& node : importantStatesRead) {
        findPathsfromNode(node.second,&pathsRead,&pathsReadIDs);
    }

    //Find important states Write 0
    std::map<int, CfgNode *> importantStatesWrite0;
    findImportantStates(controlFlowMapWrite0,&importantStatesWrite0);
    //Find important states Write 1
    std::map<int, CfgNode *> importantStatesWrite1;
    findImportantStates(controlFlowMapWrite1,&importantStatesWrite1);
    //Find important states Write 2
    std::map<int, CfgNode *> importantStatesWrite2;
    findImportantStates(controlFlowMapWrite2,&importantStatesWrite2);

    //Find subpaths Write 0
    auto start_write0 = controlFlowMapWrite0.begin()->second;
    findPathsfromNode(start_write0,&pathsWrite0,&pathsWrite0IDs);
    for(auto const& node : importantStatesWrite0) {
        findPathsfromNode(node.second,&pathsWrite0,&pathsWrite0IDs);
    }

    //Find subpaths Write 1
    auto start_write1 = controlFlowMapWrite1.begin()->second;
    findPathsfromNode(start_write1,&pathsWrite1,&pathsWrite1IDs);
    for(auto const& node : importantStatesWrite1) {
        findPathsfromNode(node.second,&pathsWrite1,&pathsWrite1IDs);
    }

    //Find operations Write 2
    auto start_write2 = controlFlowMapWrite2.begin()->second;
    findPathsfromNode(start_write2,&pathsWrite2,&pathsWrite2IDs);
    for(auto const& node : importantStatesWrite2) {
        findPathsfromNode(node.second,&pathsWrite2,&pathsWrite2IDs);
    }

//Generate final FSM
    std::vector<eventID> blockedFunctions;
    std::vector<eventID> readyQueue;
    std::vector<eventID> hv;

    //Define all possible functions and their starting nodes
    eventID Read = {0,"Read"};
    eventID Write0 = {14,"Write0"};
    eventID Write1 = {20,"Write1"};
    eventID Write2 = {26,"Write2"};

    //vector of all functions that are always ready to execute
    std::vector<eventID> always_ready;

    //Vector of all functions that can be called from modules
    std::vector<eventID> functions;
    functions.push_back(Read);
    functions.push_back(Write0);
    functions.push_back(Write1);
    functions.push_back(Write2);

    //compute all possible permutations and store them in variable permutations
    computePermutations(functions);

    std::cout << "Number of permutations: " <<permutations.size() << std::endl;

    //add all functions from always_ready to all permuations
    for(auto readyFunc : always_ready){
        for(auto perm = permutations.begin(); perm != permutations.end(); ++perm){
            perm->push_back(readyFunc);
        }
    }
    //construct a vector of all paths by pushing all paths to allPaths
    for(int i=0; i<pathsReadIDs.size();i++){
        pathIDStmt p = {pathsReadIDs.at(i),pathsRead.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWrite0IDs.size();i++){
        pathIDStmt p = {pathsWrite0IDs.at(i),pathsWrite0.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWrite1IDs.size();i++){
        pathIDStmt p = {pathsWrite1IDs.at(i),pathsWrite1.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWrite2IDs.size();i++){
        pathIDStmt p = {pathsWrite2IDs.at(i),pathsWrite2.at(i)};
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
    //finalPathsOpt.push_back(temp);
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
    myfile.open(SCAM_HOME"/tests/Synchronizer_Properties/" + module->getName() + "_generated.vhi");
    myfile << map.at(module->getName() + ".vhi") << std::endl;
    myfile.close();
}



#endif //DESCAM_OPERATION_GRAPH_H
