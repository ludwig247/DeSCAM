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
    std::map<int, CfgNode *> controlFlowMapRead;
    std::map<int, CfgNode *> controlFlowMapWrite_0;
    std::map<int, CfgNode *> controlFlowMapWrite_1;
    std::map<int, CfgNode *> controlFlowMapWrite_2;
    std::map<int, CfgNode *> controlFlowMap;
    std::vector<std::vector<SCAM::Stmt*>> pathsRead;
    std::vector<std::vector<int>> pathsReadIDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite_0;
    std::vector<std::vector<int>> pathsWriteIDs_0;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite_1;
    std::vector<std::vector<int>> pathsWriteIDs_1;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite_2;
    std::vector<std::vector<int>> pathsWriteIDs_2;
    std::vector<Operation*> operationsRead;
    std::vector<Operation*> operationsWrite_0;
    std::vector<Operation*> operationsWrite_1;
    std::vector<Operation*> operationsWrite_2;
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
        auto buffer_array = new DataType("int_32");
        buffer_array->addArray(DataTypes::getDataType("int"),3);
        auto buffer = new Variable("buffer", buffer_array);
        auto number_of_senders = new UnsignedValue(3);
        auto cnt = new Variable("cnt",DataTypes::getDataType("unsigned"));
        auto flag_array = new DataType("bool");
        flag_array->addArray(DataTypes::getDataType("bool"),3);
        auto flags = new Variable("flags", flag_array);
        auto out = new Port("out",new Interface("blocking","out"),buffer_array);
        auto val_0 = new Port("val_0",new Interface("blocking","in"), DataTypes::getDataType("int"));
        auto val_1 = new Port("val_1",new Interface("blocking","in"), DataTypes::getDataType("int"));
        auto val_2 = new Port("val_2",new Interface("blocking","in"), DataTypes::getDataType("int"));

        //add Variables to Module
        module->addVariable(buffer);
        module->addVariable(flags);
        module->addVariable(cnt);
        module->addPort(out);
        module->addPort(val_0);
        module->addPort(val_1);
        module->addPort(val_2);
        for(auto subVar:flags->getSubVarList()){
            module->addVariable(subVar);
        }
        for(auto subVar:buffer->getSubVarList()){
            module->addVariable(subVar);
        }
        //Read Statements
        //while(cnt < NUMBER_OF_SENDERS) unrolled
        auto cnt_less_NOS = new Relational(new VariableOperand(cnt),"<",number_of_senders);
        //if(cnt<NUMBER_OF_SENDERS)
        auto if_cnt_less_NOS = new If(cnt_less_NOS);
        //wait(writer_notify)
        auto writer_wait = new Wait("writer_notify");

        auto flags_0 = new VariableOperand(flags->getSubVar("0"));;
        auto flags_1 = new VariableOperand(flags->getSubVar("1"));;
        auto flags_2 = new VariableOperand(flags->getSubVar("2"));;

        //for(int i=0; i<number_of_senders; i++) unrolled
        //flags.at(i) = false;
        auto false_value = new BoolValue(false);
        auto flags_0_assign_false = new Assignment(flags_0,false_value);
        //flags[1] = false;
        auto flags_1_assign_false = new Assignment(flags_1,false_value);
        //flags[2] = false;
        auto flags_2_assign_false = new Assignment(flags_2,false_value);
        //cnt = 0
        auto cnt_assign_0 = new Assignment(new VariableOperand(cnt),new UnsignedValue(0));
        //for(int i=0; i<number_of_senders; i++) unrolled
        //out.at(0)=buffer.at(0)
        auto out_0 = new ArrayOperand(new DataSignalOperand(out->getDataSignal()),new IntegerValue(0));
        auto buffer_0 = new VariableOperand(buffer->getSubVar("0"));
        auto out_0_assign_buffer_0 = new Assignment(out_0,buffer_0);
        //out.at(1)=buffer.at(1)
        auto out_1 = new ArrayOperand(new DataSignalOperand(out->getDataSignal()),new IntegerValue(1));
        auto buffer_1 = new VariableOperand(buffer->getSubVar("1"));
        auto out_1_assign_buffer_1 = new Assignment(out_1,buffer_1);
        //out.at(2)=buffer.at(2)
        auto out_2 = new ArrayOperand(new DataSignalOperand(out->getDataSignal()),new IntegerValue(2));
        auto buffer_2 = new VariableOperand(buffer->getSubVar("2"));
        auto out_2_assign_buffer_2 = new Assignment(out_2,buffer_2);
        //reader_notify.notify()
        auto notify_reader = new Notify("reader_notify");
        //return
        auto read_return = new Return("read_return");

        //Write Expressions/Assignments id=0
        //if(flags.at(0))
        auto if_flags_0 = new If(flags_0);
        //wait(reader_notify)
        auto reader_wait = new Wait("reader_notify");
        //flags.at(0) = true
        auto true_value = new BoolValue(true);
        auto flags_0_assign_true = new Assignment(flags_0,true_value);
        //buffer.at(0)=val;
        auto port_val_0 = new DataSignalOperand(val_0->getDataSignal());
        auto buffer_0_assign_port_val_0 = new Assignment(buffer_0,port_val_0);
        //cnt++
        auto cnt_add_1 = new Arithmetic(new VariableOperand(cnt),"+",new UnsignedValue(1));
        auto cnt_inc = new Assignment(new VariableOperand(cnt),cnt_add_1);
        //writer_notify.notify()
        auto notify_writer = new Notify("writer_notify");
        //return
        auto write_return = new Return("write_return");

        //Write Expressions/Assignments id=1
        //if(flags.at(1))
        auto if_flags_1 = new If(flags_1);
        //wait(reader_notify)
        //already exists
        //flags.at(1) = true
        auto flags_1_assign_true = new Assignment(flags_1,true_value);
        //buffer.at(1)=val;
        auto port_val_1 = new DataSignalOperand(val_1->getDataSignal());
        auto buffer_1_assign_port_val_1 = new Assignment(buffer_1,port_val_1);
        //cnt++
        //already exists
        //writer_notify.notify()
        //already exists
        //return
        //already exists

        //Write Expressions/Assignments id=2
        //if(flags.at(2))
        auto if_flags_2 = new If(flags_2);
        //wait(reader_notify)
        //already exists
        //flags.at(2) = true
        auto flags_2_assign_true = new Assignment(flags_2,true_value);
        //buffer.at(2)=val;
        auto port_val_2 = new DataSignalOperand(val_2->getDataSignal());
        auto buffer_2_assign_port_val_2 = new Assignment(buffer_2,port_val_2);
        //cnt++
        //already exists
        //writer_notify.notify()
        //already exists
        // return
        //already exists

        //CFG nodes Read
        auto check_cnt_0 = new CfgNode(if_cnt_less_NOS);
        auto wait_writer_0 = new CfgNode(writer_wait);
        auto check_cnt_1 = new CfgNode(if_cnt_less_NOS);
        auto wait_writer_1 = new CfgNode(writer_wait);
        auto check_cnt_2 = new CfgNode(if_cnt_less_NOS);
        auto wait_writer_2 = new CfgNode(writer_wait);
        auto unset_flags_0 = new CfgNode(flags_0_assign_false);
        auto unset_flags_1 = new CfgNode(flags_1_assign_false);
        auto unset_flags_2 = new CfgNode(flags_2_assign_false);
        auto reset_cnt = new CfgNode(cnt_assign_0);
        auto set_output_0 = new CfgNode(out_0_assign_buffer_0);
        auto set_output_1 = new CfgNode(out_1_assign_buffer_1);
        auto set_output_2 = new CfgNode(out_2_assign_buffer_2);
        auto read_notify = new CfgNode(notify_reader);
        auto return_read = new CfgNode(read_return);

        //Link CFG nodes Read
        check_cnt_0->addSuccessor(wait_writer_0);
        check_cnt_0->addSuccessor(check_cnt_1);
        wait_writer_0->addSuccessor(check_cnt_1);
        check_cnt_1->addSuccessor(wait_writer_1);
        check_cnt_1->addSuccessor(check_cnt_2);
        wait_writer_1->addSuccessor(check_cnt_2);
        check_cnt_2->addSuccessor(wait_writer_2);
        check_cnt_2->addSuccessor(unset_flags_0);
        wait_writer_2->addSuccessor(unset_flags_0);
        unset_flags_0->addSuccessor(unset_flags_1);
        unset_flags_1->addSuccessor(unset_flags_2);
        unset_flags_2->addSuccessor(reset_cnt);
        reset_cnt->addSuccessor(set_output_0);
        set_output_0->addSuccessor(set_output_1);
        set_output_1->addSuccessor(set_output_2);
        set_output_2->addSuccessor(read_notify);
        read_notify->addSuccessor(return_read);


        //create map with CFG nodes Read
        controlFlowMapRead.insert(std::make_pair(check_cnt_0->getId(),check_cnt_0));
        controlFlowMapRead.insert(std::make_pair(wait_writer_0->getId(),wait_writer_0));
        controlFlowMapRead.insert(std::make_pair(check_cnt_1->getId(),check_cnt_1));
        controlFlowMapRead.insert(std::make_pair(wait_writer_1->getId(),wait_writer_1));
        controlFlowMapRead.insert(std::make_pair(check_cnt_2->getId(),check_cnt_2));
        controlFlowMapRead.insert(std::make_pair(wait_writer_2->getId(),wait_writer_2));
        controlFlowMapRead.insert(std::make_pair(unset_flags_0->getId(),unset_flags_0));
        controlFlowMapRead.insert(std::make_pair(unset_flags_1->getId(),unset_flags_1));
        controlFlowMapRead.insert(std::make_pair(unset_flags_2->getId(),unset_flags_2));
        controlFlowMapRead.insert(std::make_pair(reset_cnt->getId(),reset_cnt));
        controlFlowMapRead.insert(std::make_pair(set_output_0->getId(),set_output_0));
        controlFlowMapRead.insert(std::make_pair(set_output_1->getId(),set_output_1));
        controlFlowMapRead.insert(std::make_pair(set_output_2->getId(),set_output_2));
        controlFlowMapRead.insert(std::make_pair(read_notify->getId(),read_notify));
        controlFlowMapRead.insert(std::make_pair(return_read->getId(),return_read));

        //add nodes to global controlFlowMap
        controlFlowMap.insert(std::make_pair(check_cnt_0->getId(),check_cnt_0));
        controlFlowMap.insert(std::make_pair(wait_writer_0->getId(),wait_writer_0));
        controlFlowMap.insert(std::make_pair(check_cnt_1->getId(),check_cnt_1));
        controlFlowMap.insert(std::make_pair(wait_writer_1->getId(),wait_writer_1));
        controlFlowMap.insert(std::make_pair(check_cnt_2->getId(),check_cnt_2));
        controlFlowMap.insert(std::make_pair(wait_writer_2->getId(),wait_writer_2));
        controlFlowMap.insert(std::make_pair(unset_flags_0->getId(),unset_flags_0));
        controlFlowMap.insert(std::make_pair(unset_flags_1->getId(),unset_flags_1));
        controlFlowMap.insert(std::make_pair(unset_flags_2->getId(),unset_flags_2));
        controlFlowMap.insert(std::make_pair(reset_cnt->getId(),reset_cnt));
        controlFlowMap.insert(std::make_pair(set_output_0->getId(),set_output_0));
        controlFlowMap.insert(std::make_pair(set_output_1->getId(),set_output_1));
        controlFlowMap.insert(std::make_pair(set_output_2->getId(),set_output_2));
        controlFlowMap.insert(std::make_pair(read_notify->getId(),read_notify));
        controlFlowMap.insert(std::make_pair(return_read->getId(),return_read));

//        //Print CFG for Read
//        std::cout << printCFG(controlFlowMapRead) << std::endl;

        //CFG nodes Write id=0
        auto check_flags_id_0 = new CfgNode(if_flags_0);
        auto wait_reader_0 = new CfgNode(reader_wait);
        auto set_flags_id_0 = new CfgNode(flags_0_assign_true);
        auto set_buffer_id_0 = new CfgNode(buffer_0_assign_port_val_0);
        auto cnt_increment_0 = new CfgNode(cnt_inc);
        auto write_notify_0 = new CfgNode(notify_writer);
        auto return_write_0 = new CfgNode(write_return);

        //CFG nodes Write id=1
        auto check_flags_id_1 = new CfgNode(if_flags_1);
        auto wait_reader_1 = new CfgNode(reader_wait);
        auto set_flags_id_1 = new CfgNode(flags_1_assign_true);
        auto set_buffer_id_1 = new CfgNode(buffer_1_assign_port_val_1);
        auto cnt_increment_1 = new CfgNode(cnt_inc);
        auto write_notify_1 = new CfgNode(notify_writer);
        auto return_write_1 = new CfgNode(write_return);

        //CFG nodes Write id=2
        auto check_flags_id_2 = new CfgNode(if_flags_2);
        auto wait_reader_2 = new CfgNode(reader_wait);
        auto set_flags_id_2 = new CfgNode(flags_2_assign_true);
        auto set_buffer_id_2 = new CfgNode(buffer_2_assign_port_val_2);
        auto cnt_increment_2 = new CfgNode(cnt_inc);
        auto write_notify_2 = new CfgNode(notify_writer);
        auto return_write_2 = new CfgNode(write_return);

        //Connect CFG nodes Write id=0
        check_flags_id_0->addSuccessor(wait_reader_0);
        check_flags_id_0->addSuccessor(set_flags_id_0);
        wait_reader_0->addSuccessor(set_flags_id_0);
        set_flags_id_0->addSuccessor(set_buffer_id_0);
        set_buffer_id_0->addSuccessor(cnt_increment_0);
        cnt_increment_0->addSuccessor(write_notify_0);
        write_notify_0->addSuccessor(return_write_0);

        //Connect CFG nodes Write id=1
        check_flags_id_1->addSuccessor(wait_reader_1);
        check_flags_id_1->addSuccessor(set_flags_id_1);
        wait_reader_1->addSuccessor(set_flags_id_1);
        set_flags_id_1->addSuccessor(set_buffer_id_1);
        set_buffer_id_1->addSuccessor(cnt_increment_1);
        cnt_increment_1->addSuccessor(write_notify_1);
        write_notify_1->addSuccessor(return_write_1);

        //Connect CFG nodes Write id=2
        check_flags_id_2->addSuccessor(wait_reader_2);
        check_flags_id_2->addSuccessor(set_flags_id_2);
        wait_reader_2->addSuccessor(set_flags_id_2);
        set_flags_id_2->addSuccessor(set_buffer_id_2);
        set_buffer_id_2->addSuccessor(cnt_increment_2);
        cnt_increment_2->addSuccessor(write_notify_2);
        write_notify_2->addSuccessor(return_write_2);

        //Create map with CFG nodes Write id=0
        controlFlowMapWrite_0.insert(std::make_pair(check_flags_id_0->getId(),check_flags_id_0));
        controlFlowMapWrite_0.insert(std::make_pair(wait_reader_0->getId(),wait_reader_0));
        controlFlowMapWrite_0.insert(std::make_pair(set_flags_id_0->getId(),set_flags_id_0));
        controlFlowMapWrite_0.insert(std::make_pair(set_buffer_id_0->getId(),set_buffer_id_0));
        controlFlowMapWrite_0.insert(std::make_pair(cnt_increment_0->getId(),cnt_increment_0));
        controlFlowMapWrite_0.insert(std::make_pair(write_notify_0->getId(),write_notify_0));
        controlFlowMapWrite_0.insert(std::make_pair(return_write_0->getId(),return_write_0));

        //Create map with CFG nodes Write id=1
        controlFlowMapWrite_1.insert(std::make_pair(check_flags_id_1->getId(),check_flags_id_1));
        controlFlowMapWrite_1.insert(std::make_pair(wait_reader_1->getId(),wait_reader_1));
        controlFlowMapWrite_1.insert(std::make_pair(set_flags_id_1->getId(),set_flags_id_1));
        controlFlowMapWrite_1.insert(std::make_pair(set_buffer_id_1->getId(),set_buffer_id_1));
        controlFlowMapWrite_1.insert(std::make_pair(cnt_increment_1->getId(),cnt_increment_1));
        controlFlowMapWrite_1.insert(std::make_pair(write_notify_1->getId(),write_notify_1));
        controlFlowMapWrite_1.insert(std::make_pair(return_write_1->getId(),return_write_1));

        //Create map with CFG nodes Write id=2
        controlFlowMapWrite_2.insert(std::make_pair(check_flags_id_2->getId(),check_flags_id_2));
        controlFlowMapWrite_2.insert(std::make_pair(wait_reader_2->getId(),wait_reader_2));
        controlFlowMapWrite_2.insert(std::make_pair(set_flags_id_2->getId(),set_flags_id_2));
        controlFlowMapWrite_2.insert(std::make_pair(set_buffer_id_2->getId(),set_buffer_id_2));
        controlFlowMapWrite_2.insert(std::make_pair(cnt_increment_2->getId(),cnt_increment_2));
        controlFlowMapWrite_2.insert(std::make_pair(write_notify_2->getId(),write_notify_2));
        controlFlowMapWrite_2.insert(std::make_pair(return_write_2->getId(),return_write_2));

        //add nodes to global controlFlowMap
        controlFlowMap.insert(std::make_pair(check_flags_id_0->getId(),check_flags_id_0));
        controlFlowMap.insert(std::make_pair(wait_reader_0->getId(),wait_reader_0));
        controlFlowMap.insert(std::make_pair(set_flags_id_0->getId(),set_flags_id_0));
        controlFlowMap.insert(std::make_pair(set_buffer_id_0->getId(),set_buffer_id_0));
        controlFlowMap.insert(std::make_pair(cnt_increment_0->getId(),cnt_increment_0));
        controlFlowMap.insert(std::make_pair(write_notify_0->getId(),write_notify_0));
        controlFlowMap.insert(std::make_pair(return_write_0->getId(),return_write_0));
        controlFlowMap.insert(std::make_pair(check_flags_id_1->getId(),check_flags_id_1));
        controlFlowMap.insert(std::make_pair(wait_reader_1->getId(),wait_reader_1));
        controlFlowMap.insert(std::make_pair(set_flags_id_1->getId(),set_flags_id_1));
        controlFlowMap.insert(std::make_pair(set_buffer_id_1->getId(),set_buffer_id_1));
        controlFlowMap.insert(std::make_pair(cnt_increment_1->getId(),cnt_increment_1));
        controlFlowMap.insert(std::make_pair(write_notify_1->getId(),write_notify_1));
        controlFlowMap.insert(std::make_pair(return_write_1->getId(),return_write_1));
        controlFlowMap.insert(std::make_pair(check_flags_id_2->getId(),check_flags_id_2));
        controlFlowMap.insert(std::make_pair(wait_reader_2->getId(),wait_reader_2));
        controlFlowMap.insert(std::make_pair(set_flags_id_2->getId(),set_flags_id_2));
        controlFlowMap.insert(std::make_pair(set_buffer_id_2->getId(),set_buffer_id_2));
        controlFlowMap.insert(std::make_pair(cnt_increment_2->getId(),cnt_increment_2));
        controlFlowMap.insert(std::make_pair(write_notify_2->getId(),write_notify_2));
        controlFlowMap.insert(std::make_pair(return_write_2->getId(),return_write_2));

//        //Print CFG Write
//        std::cout << printCFG(controlFlowMapWrite_0) << std::endl;
//        std::cout << printCFG(controlFlowMapWrite_1) << std::endl;
//        std::cout << printCFG(controlFlowMapWrite_2) << std::endl;


        init = new State("reset");
        init->setInit();

        //Generate Reset Operation
        reset_op = new Operation();
        reset_op->addStatement(cnt_assign_0);
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
        temp = {15,"writer_0_sync"};
        startnodes.push_back(temp);
        temp = {22,"writer_1_sync"};
        startnodes.push_back(temp);
        temp = {29,"writer_2_sync"};
        startnodes.push_back(temp);

        temp = {14,"reader_notify"};
        endnodes.push_back(temp);
        temp = {21,"writer_0_notify"};
        endnodes.push_back(temp);
        temp = {28,"writer_1_notify"};
        endnodes.push_back(temp);
        temp = {35,"writer_2_notify"};
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

    //Find important states Write 0
    std::map<int, CfgNode *> importantStatesWrite_0;
    findImportantStates(controlFlowMapWrite_0,&importantStatesWrite_0);
    //Find important states Write 1
    std::map<int, CfgNode *> importantStatesWrite_1;
    findImportantStates(controlFlowMapWrite_1,&importantStatesWrite_1);
    //Find important states Write 2
    std::map<int, CfgNode *> importantStatesWrite_2;
    findImportantStates(controlFlowMapWrite_2,&importantStatesWrite_2);

    //Find operations Write 0
    auto start_write_0 = controlFlowMapWrite_0.begin()->second;
    findPathsfromNode(start_write_0,&pathsWrite_0,&pathsWriteIDs_0);
    for(auto const& node : importantStatesWrite_0) {
        findPathsfromNode(node.second,&pathsWrite_0,&pathsWriteIDs_0);
    }

    //Create a map from CfgNode Id to State Write 0
    std::map<int,State*> CfgIdToStateWrite_0;
    //If the state for the node is not yet created, create one
    for(auto path = pathsWriteIDs_0.begin(); path != pathsWriteIDs_0.end(); path++){
        if(CfgIdToStateWrite_0.find(path->front()) == CfgIdToStateWrite_0.end()){
            CfgIdToStateWrite_0.insert(std::make_pair(path->front(),new State(controlFlowMapWrite_0.at(path->front())->getName())));
        }
        if(CfgIdToStateWrite_0.find(path->back()) == CfgIdToStateWrite_0.end()){
            CfgIdToStateWrite_0.insert(std::make_pair(path->back(), new State(controlFlowMapWrite_0.at(path->back())->getName())));
        }
    }

    //Generate Operations Write 0
    //Iterate over all paths and set State, nextState and statementList
    for(auto path = pathsWriteIDs_0.begin(); path != pathsWriteIDs_0.end(); path++){
        auto op = new Operation();
        op->setState(CfgIdToStateWrite_0.at(path->front()));
        op->setNextState(CfgIdToStateWrite_0.at(path->back()));
        statementList.clear();

        operationsWrite_0.push_back(op);
    }
    cnt = 0;
    for(auto op: operationsWrite_0) {
        for (auto stmt: pathsWrite_0.at(cnt)) {
            statementList.push_back(stmt);
        }
        op->setStatementsList(statementList);
        cnt++;
        statementList.clear();
    }

    for(auto op: this->operationsWrite_0) {
        rOperations->sortOperation(op);
    }

    //Find operations Write 1
    auto start_write_1 = controlFlowMapWrite_1.begin()->second;
    findPathsfromNode(start_write_1,&pathsWrite_1,&pathsWriteIDs_1);
    for(auto const& node : importantStatesWrite_1) {
        findPathsfromNode(node.second,&pathsWrite_1,&pathsWriteIDs_1);
    }

    //Create a map from CfgNode Id to State Write 1
    std::map<int,State*> CfgIdToStateWrite_1;
    //If the state for the node is not yet created, create one
    for(auto path = pathsWriteIDs_1.begin(); path != pathsWriteIDs_1.end(); path++){
        if(CfgIdToStateWrite_1.find(path->front()) == CfgIdToStateWrite_1.end()){
            CfgIdToStateWrite_1.insert(std::make_pair(path->front(),new State(controlFlowMapWrite_1.at(path->front())->getName())));
        }
        if(CfgIdToStateWrite_1.find(path->back()) == CfgIdToStateWrite_1.end()){
            CfgIdToStateWrite_1.insert(std::make_pair(path->back(), new State(controlFlowMapWrite_1.at(path->back())->getName())));
        }
    }

    //Generate Operations Write 1
    //Iterate over all paths and set State, nextState and statementList
    for(auto path = pathsWriteIDs_1.begin(); path != pathsWriteIDs_1.end(); path++){
        auto op = new Operation();
        op->setState(CfgIdToStateWrite_1.at(path->front()));
        op->setNextState(CfgIdToStateWrite_1.at(path->back()));
        statementList.clear();

        operationsWrite_1.push_back(op);
    }
    cnt = 0;
    for(auto op: operationsWrite_1) {
        for (auto stmt: pathsWrite_1.at(cnt)) {
            statementList.push_back(stmt);
        }
        op->setStatementsList(statementList);
        cnt++;
        statementList.clear();
    }

    for(auto op: this->operationsWrite_1) {
        rOperations->sortOperation(op);
    }

    //Find operations Write 2
    auto start_write_2 = controlFlowMapWrite_2.begin()->second;
    findPathsfromNode(start_write_2,&pathsWrite_2,&pathsWriteIDs_2);
    for(auto const& node : importantStatesWrite_2) {
        findPathsfromNode(node.second,&pathsWrite_2,&pathsWriteIDs_2);
    }

    //Create a map from CfgNode Id to State Write 2
    std::map<int,State*> CfgIdToStateWrite_2;
    //If the state for the node is not yet created, create one
    for(auto path = pathsWriteIDs_2.begin(); path != pathsWriteIDs_2.end(); path++){
        if(CfgIdToStateWrite_2.find(path->front()) == CfgIdToStateWrite_2.end()){
            CfgIdToStateWrite_2.insert(std::make_pair(path->front(),new State(controlFlowMapWrite_2.at(path->front())->getName())));
        }
        if(CfgIdToStateWrite_2.find(path->back()) == CfgIdToStateWrite_2.end()){
            CfgIdToStateWrite_2.insert(std::make_pair(path->back(), new State(controlFlowMapWrite_2.at(path->back())->getName())));
        }
    }

    //Generate Operations Write 2
    //Iterate over all paths and set State, nextState and statementList
    for(auto path = pathsWriteIDs_2.begin(); path != pathsWriteIDs_2.end(); path++){
        auto op = new Operation();
        op->setState(CfgIdToStateWrite_2.at(path->front()));
        op->setNextState(CfgIdToStateWrite_2.at(path->back()));
        statementList.clear();

        operationsWrite_2.push_back(op);
    }
    cnt = 0;
    for(auto op: operationsWrite_2) {
        for (auto stmt: pathsWrite_2.at(cnt)) {
            statementList.push_back(stmt);
        }
        op->setStatementsList(statementList);
        cnt++;
        statementList.clear();
    }

    for(auto op: this->operationsWrite_2) {
        rOperations->sortOperation(op);
    }

    //Generate final FSM
    std::vector<eventID> blockedFunctions;
    std::vector<eventID> readyQueue;
    std::vector<std::vector<eventID>>permutations;
    std::vector<eventID> hv;

    eventID read = {0,"read"};
    eventID write_0 = {15,"write_0"};
    eventID write_1 = {22,"write_1"};
    eventID write_2 = {29,"write_2"};
//    //no function calls
//    permutations.push_back(hv);
    //only read call
    hv.push_back(read);
    permutations.push_back(hv);
    hv.clear();
    //only write_0 call
    hv.push_back(write_0);
    permutations.push_back(hv);
    hv.clear();
    //read and write_0 call
    hv.push_back(read);
    hv.push_back(write_0);
    permutations.push_back(hv);
    hv.clear();
    //only write_1 call
    hv.push_back(write_1);
    permutations.push_back(hv);
    hv.clear();
    //read and write_1 call
    hv.push_back(read);
    hv.push_back(write_1);
    permutations.push_back(hv);
    hv.clear();
    //write_0 and write_1 call
    hv.push_back(write_0);
    hv.push_back(write_1);
    permutations.push_back(hv);
    hv.clear();
    //read, write_0 and write_1 call
    hv.push_back(read);
    hv.push_back(write_0);
    hv.push_back(write_1);
    permutations.push_back(hv);
    hv.clear();
    //only write_2 call
    hv.push_back(write_2);
    permutations.push_back(hv);
    hv.clear();
    //read and write_2 call
    hv.push_back(read);
    hv.push_back(write_2);
    permutations.push_back(hv);
    hv.clear();
    //write_0 and write_2 call
    hv.push_back(write_0);
    hv.push_back(write_2);
    permutations.push_back(hv);
    hv.clear();
    //read,write_0 and write_2 call
    hv.push_back(read);
    hv.push_back(write_0);
    hv.push_back(write_2);
    permutations.push_back(hv);
    hv.clear();
    //write_1 and write_2 call
    hv.push_back(write_1);
    hv.push_back(write_2);
    permutations.push_back(hv);
    hv.clear();
    //read,write_1 and write_2 call
    hv.push_back(read);
    hv.push_back(write_1);
    hv.push_back(write_2);
    permutations.push_back(hv);
    hv.clear();
    //write_0, write_1 and write_2 call
    hv.push_back(write_0);
    hv.push_back(write_1);
    hv.push_back(write_2);
    permutations.push_back(hv);
    hv.clear();
    //read,write_0, write_1 and write_2 call
    hv.push_back(read);
    hv.push_back(write_0);
    hv.push_back(write_1);
    hv.push_back(write_2);
    permutations.push_back(hv);
    hv.clear();


    //construct a vector of all paths by pushing the paths from Read and Write to allPaths
    for(int i=0; i<pathsReadIDs.size();i++){
        pathIDStmt p = {pathsReadIDs.at(i),pathsRead.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWriteIDs_0.size();i++){
        pathIDStmt p = {pathsWriteIDs_0.at(i),pathsWrite_0.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWriteIDs_1.size();i++){
        pathIDStmt p = {pathsWriteIDs_1.at(i),pathsWrite_1.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWriteIDs_2.size();i++){
        pathIDStmt p = {pathsWriteIDs_2.at(i),pathsWrite_2.at(i)};
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
    for(auto i:CfgIdToStateWrite_0){
        CfgIdToState.insert(i);
    }
    for(auto i:CfgIdToStateWrite_1){
        CfgIdToState.insert(i);
    }
    for(auto i:CfgIdToStateWrite_2){
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

//    //Debug
//    int num = 0;
//    for(auto p:finalPaths){
//        std::cout << "Path " << num << ": ";
//        for(auto id:p.idList){
//            std::cout<<id<<"\t";
//        }
//        std::cout<< std::endl;
//        num++;
//    }


    //Optimize operations
    for(int i=0; i<operationsFinal.size();i++){
        if(ValidOperations::isOperationReachable(operationsFinal.at(i))){
            operationsFinalOpt.push_back(operationsFinal.at(i));
            finalPathsOpt.push_back(finalPaths.at(i));
        }
    }

//    //Debug
//    num = 0;
//    for(auto p:finalPathsOpt){
//        std::cout << "Path " << num << ": ";
//        for(auto id:p.idList){
//            std::cout<<id<<"\t";
//        }
//        std::cout<< std::endl;
//        num++;
//    }

    for(auto op:operationsFinalOpt){
        op->getState()->addOutgoingOperation(op);
        op->getNextState()->addIncomingOperation(op);
    }


    //add reset operation
    rOperations->sortOperation(reset_op);
    operationsFinalOpt.push_back(reset_op);
    std::vector<int> int_vec;
    std::vector<SCAM::Stmt*> stmt_vec;
    pathIDStmt dummy = {int_vec,stmt_vec};
    finalPathsOpt.push_back(dummy);
    reset_op->getState()->addOutgoingOperation(reset_op);
    reset_op->getNextState()->addIncomingOperation(reset_op);

    //wait operation
    auto wait_op = new Operation();
    rOperations->sortOperation(wait_op);
    operationsFinalOpt.push_back(wait_op);
    finalPathsOpt.push_back(dummy);
    wait_op->setState(start_state);
    wait_op->setNextState(start_state);
    wait_op->getState()->addOutgoingOperation(wait_op);
    wait_op->getNextState()->addIncomingOperation(wait_op);

//    //Debug
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
    myfile.open(SCAM_HOME"/tests/Bus_Properties/PropertyGraph.gfv");
    myfile << ss.str();
    myfile.close();

    std::vector<std::string> portnames;
    portnames.push_back("out");
    portnames.push_back("val_0");
    portnames.push_back("val_1");
    portnames.push_back("val_2");


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
    myfile.open(SCAM_HOME"/tests/Bus_Properties/Bus_generated.vhi");
    myfile << map.at("Bus.vhi") << std::endl;
    myfile.close();
}



#endif //DESCAM_OPERATION_GRAPH_H
