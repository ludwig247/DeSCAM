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


#include "gmock/gmock.h"
#include "Model.h"

using namespace SCAM;

class OperationGraphTest: public ::testing::Test{
public:
    OperationGraphTest():module(new SCAM::Module("TestModule")){
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
    std::map<int, CfgNode *> controlFlowMap;
    std::vector<std::vector<SCAM::Stmt*>> pathsRead;
    std::vector<std::vector<int>> pathsReadIDs;
    std::vector<std::vector<SCAM::Stmt*>> pathsWrite;
    std::vector<std::vector<int>> pathsWriteIDs;
    std::vector<Operation*> operationsRead;
    std::vector<Operation*> operationsWrite;
    std::vector<pathIDStmt> allPaths;
    std::vector<pathIDStmt> finalPaths;
    std::vector<Operation*> operationsFinal;
    std::vector<pathIDStmt> finalPathsOpt;
    std::vector<Operation*> operationsFinalOpt;
    std::map<int,State*> StateMap;


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
                        if(notify)
                        {
                            for(int i=0; i< blockedFunctions.size();i++){
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
    virtual void SetUp() {
        //create variables and datatypes
        auto states = new DataType("states");
        states->addEnumValue("EMPTY");
        states->addEnumValue("FILLED");
        states->addEnumValue("FULL");
        auto array= new DataType("int_8");
        array->addArray(DataTypes::getDataType("int"),8);
        auto buffer = new Variable("buffer", array);
        auto fifo_size = new Variable("fifo_size", DataTypes::getDataType("unsigned"));
        auto state = new Variable("state", states);
        auto head = new Variable("head", DataTypes::getDataType("int"));
        auto tail = new Variable("tail", DataTypes::getDataType("int"));
        auto reader_notify = new Variable("reader_notify", DataTypes::getDataType("bool"));
        auto writer_notify = new Variable("writer_notify", DataTypes::getDataType("bool"));
        auto out = new Port("out",new Interface("blocking","out"),DataTypes::getDataType(("int")));
        auto val = new Port("val",new Interface("blocking","in"), DataTypes::getDataType("int"));

        //add Variables to Module
        module->addVariable(buffer);
        module->addVariable(fifo_size);
        module->addVariable(state);
        module->addVariable(head);
        module->addVariable(tail);
        module->addVariable(reader_notify);
        module->addVariable(writer_notify);
        module->addPort(out);
        module->addPort(val);

        //Read Expressions/Assignments
        //if(state == EMPTY)
        auto empty_enum = new EnumValue("EMPTY", states);
        auto state_eq_empty = new Relational(new VariableOperand(module->getVariable("state")),"==",empty_enum);
        auto check_state_empty = new If(state_eq_empty);
        //wait(writer_notify)
        auto writer_wait = new Wait("writer_notify");
        //out = buffer[tail]
        auto port_out = new DataSignalOperand(out->getDataSignal());
        auto buffer_at_tail = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new VariableOperand(module->getVariable(("tail"))));
        auto out_assign_buffer_at_tail = new Assignment(port_out,buffer_at_tail);
        //tail = (tail+1)%fifo_size
        auto tail_increment = new Arithmetic(new VariableOperand(module->getVariable("tail")),"+",new IntegerValue(1));
        auto tail_modulo_increment = new Arithmetic(tail_increment,"%",new Cast(new VariableOperand(module->getVariable("fifo_size")),DataTypes::getDataType("int")));
        auto tail_assign_tail_modulo_increment= new Assignment(new VariableOperand(module->getVariable("tail")),tail_modulo_increment);
        //state = FILLED
        auto *filled_enum = new EnumValue("FILLED",states);
        auto *state_assign_filled = new Assignment(new VariableOperand(module->getVariable("state")),filled_enum);
        //if(head == tail)
        auto head_eq_tail = new Relational(new VariableOperand(module->getVariable("head")),"==",new VariableOperand(module->getVariable("tail")));
        auto if_head_eq_tail = new If(head_eq_tail);
        //state = EMPTY
        auto state_assign_empty = new Assignment(new VariableOperand(module->getVariable("state")),empty_enum);
        //reader_notify.notify()
        auto notify_reader = new Notify("reader_notify");
        //return
        auto read_return = new Return("read_return");

        //Write Expressions/Assignments
        //if (state == FULL)
        auto full_enum = new EnumValue("FULL", states);
        auto state_eq_full = new Relational(new VariableOperand(module->getVariable("state")),"==",full_enum);
        auto check_state_full = new If(state_eq_full);
        //wait(reader_notify);
        auto reader_wait = new Wait("reader_notify");
        //buffer[head] = val;
        auto port_val = new DataSignalOperand(val->getDataSignal());
        auto buffer_at_head = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new VariableOperand(head));
        auto buffer_at_head_assign_val = new Assignment(buffer_at_head, port_val);
        //head = (head+1)%fifo_size
        auto head_increment = new Arithmetic(new VariableOperand(module->getVariable("head")),"+",new IntegerValue(1));
        auto head_modulo_increment = new Arithmetic(head_increment,"%",new Cast(new VariableOperand(module->getVariable("fifo_size")),DataTypes::getDataType("int")));
        auto head_assign_head_modulo_increment = new Assignment(new VariableOperand(module->getVariable("head")),head_modulo_increment);
        //state = FILLED
        //already exists
        //if (head==tail)
        //already exists
        //state = FULL
        auto state_assign_full = new Assignment(new VariableOperand(module->getVariable("state")),full_enum);
        //writer_notify.notify()
        auto notify_writer = new Notify("writer_notify");
        //return
        auto write_return = new Return("write_return");

        //CFG nodes Read
        auto state_equal_empty = new CfgNode(check_state_empty);
        auto read_wait = new CfgNode(writer_wait);
        auto read_value = new CfgNode(out_assign_buffer_at_tail);
        auto tail_incr = new CfgNode(tail_assign_tail_modulo_increment);
        auto state_filled_read = new CfgNode(state_assign_filled);
        auto head_equal_tail_read = new CfgNode(if_head_eq_tail);
        auto state_empty = new CfgNode(state_assign_empty);
        auto reader_noti = new CfgNode(notify_reader);
        auto return_read = new CfgNode(read_return);

        //Link CFG nodes Read
        state_equal_empty->addSuccessor(read_wait);
        state_equal_empty->addSuccessor(read_value);
        read_wait->addSuccessor(read_value);
        read_value->addSuccessor(tail_incr);
        tail_incr->addSuccessor(state_filled_read);
        state_filled_read->addSuccessor(head_equal_tail_read);
        head_equal_tail_read->addSuccessor(state_empty);
        head_equal_tail_read->addSuccessor(reader_noti);
        state_empty->addSuccessor(reader_noti);
        reader_noti->addSuccessor(return_read);

        //create map with CFG nodes Read
        controlFlowMapRead.insert(std::make_pair(state_equal_empty->getId(),state_equal_empty));
        controlFlowMapRead.insert(std::make_pair(read_wait->getId(),read_wait));
        controlFlowMapRead.insert(std::make_pair(read_value->getId(),read_value));
        controlFlowMapRead.insert(std::make_pair(tail_incr->getId(),tail_incr));
        controlFlowMapRead.insert(std::make_pair(state_filled_read->getId(),state_filled_read));
        controlFlowMapRead.insert(std::make_pair(head_equal_tail_read->getId(),head_equal_tail_read));
        controlFlowMapRead.insert(std::make_pair(state_empty->getId(),state_empty));
        controlFlowMapRead.insert(std::make_pair(reader_noti->getId(),reader_noti));
        controlFlowMapRead.insert(std::make_pair(return_read->getId(),return_read));

        controlFlowMap.insert(std::make_pair(state_equal_empty->getId(),state_equal_empty));
        controlFlowMap.insert(std::make_pair(read_wait->getId(),read_wait));
        controlFlowMap.insert(std::make_pair(read_value->getId(),read_value));
        controlFlowMap.insert(std::make_pair(tail_incr->getId(),tail_incr));
        controlFlowMap.insert(std::make_pair(state_filled_read->getId(),state_filled_read));
        controlFlowMap.insert(std::make_pair(head_equal_tail_read->getId(),head_equal_tail_read));
        controlFlowMap.insert(std::make_pair(state_empty->getId(),state_empty));
        controlFlowMap.insert(std::make_pair(reader_noti->getId(),reader_noti));
        controlFlowMap.insert(std::make_pair(return_read->getId(),return_read));

        //Print CFG for Read
        //std::cout << printCFG(controlFlowMapRead) << std::endl;

        //CFG nodes Write
        auto state_equal_full = new CfgNode(check_state_full);
        auto write_wait = new CfgNode(reader_wait);
        auto write_value = new CfgNode(buffer_at_head_assign_val);
        auto head_incr = new CfgNode(head_assign_head_modulo_increment);
        auto state_filled_write = new CfgNode(state_assign_filled);
        auto head_equal_tail_write = new CfgNode(if_head_eq_tail);
        auto state_full = new CfgNode(state_assign_full);
        auto writer_noti = new CfgNode(notify_writer);
        auto return_write = new CfgNode(write_return);

        //Connect CFG nodes Write
        state_equal_full->addSuccessor(write_wait);
        state_equal_full->addSuccessor(write_value);
        write_wait->addSuccessor(write_value);
        write_value->addSuccessor(head_incr);
        head_incr->addSuccessor(state_filled_write);
        state_filled_write->addSuccessor(head_equal_tail_write);
        head_equal_tail_write->addSuccessor(state_full);
        head_equal_tail_write->addSuccessor(writer_noti);
        state_full->addSuccessor(writer_noti);
        writer_noti->addSuccessor(return_write);

        //Create map with CFG nodes Write
        controlFlowMapWrite.insert(std::make_pair(state_equal_full->getId(),state_equal_full));
        controlFlowMapWrite.insert(std::make_pair(write_wait->getId(),write_wait));
        controlFlowMapWrite.insert(std::make_pair(write_value->getId(),write_value));
        controlFlowMapWrite.insert(std::make_pair(head_incr->getId(),head_incr));
        controlFlowMapWrite.insert(std::make_pair(state_filled_write->getId(),state_filled_write));
        controlFlowMapWrite.insert(std::make_pair(head_equal_tail_write->getId(),head_equal_tail_write));
        controlFlowMapWrite.insert(std::make_pair(state_full->getId(),state_full));
        controlFlowMapWrite.insert(std::make_pair(writer_noti->getId(),writer_noti));
        controlFlowMapWrite.insert(std::make_pair(return_write->getId(),return_write));

        controlFlowMap.insert(std::make_pair(state_equal_full->getId(),state_equal_full));
        controlFlowMap.insert(std::make_pair(write_wait->getId(),write_wait));
        controlFlowMap.insert(std::make_pair(write_value->getId(),write_value));
        controlFlowMap.insert(std::make_pair(head_incr->getId(),head_incr));
        controlFlowMap.insert(std::make_pair(state_filled_write->getId(),state_filled_write));
        controlFlowMap.insert(std::make_pair(head_equal_tail_write->getId(),head_equal_tail_write));
        controlFlowMap.insert(std::make_pair(state_full->getId(),state_full));
        controlFlowMap.insert(std::make_pair(writer_noti->getId(),writer_noti));
        controlFlowMap.insert(std::make_pair(return_write->getId(),return_write));

        //Print CFG Write
        //std::cout << printCFG(controlFlowMapWrite) << std::endl;
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
    auto rOperations = new ReconstructOperations();
    for(auto op: this->operationsRead) {
        rOperations->sortOperation(op);
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


    std::vector<std::vector<int>> compareVector;
    std::vector<int> helpVector;
    //Path 1
    helpVector.push_back(0);
    helpVector.push_back(1);
    compareVector.push_back(helpVector);
    //Path 2
    helpVector.clear();
    helpVector.push_back(0);
    helpVector.push_back(2);
    helpVector.push_back(3);
    helpVector.push_back(4);
    helpVector.push_back(5);
    helpVector.push_back(6);
    helpVector.push_back(7);
    helpVector.push_back(8);
    compareVector.push_back(helpVector);
    //Path 3
    helpVector.clear();
    helpVector.push_back(0);
    helpVector.push_back(2);
    helpVector.push_back(3);
    helpVector.push_back(4);
    helpVector.push_back(5);
    helpVector.push_back(7);
    helpVector.push_back(8);
    compareVector.push_back(helpVector);

    //Path 4
    helpVector.clear();
    helpVector.push_back(1);
    helpVector.push_back(2);
    helpVector.push_back(3);
    helpVector.push_back(4);
    helpVector.push_back(5);
    helpVector.push_back(6);
    helpVector.push_back(7);
    helpVector.push_back(8);
    compareVector.push_back(helpVector);

    //Path 5
    helpVector.clear();
    helpVector.push_back(1);
    helpVector.push_back(2);
    helpVector.push_back(3);
    helpVector.push_back(4);
    helpVector.push_back(5);
    helpVector.push_back(7);
    helpVector.push_back(8);
    compareVector.push_back(helpVector);

    ASSERT_EQ(compareVector,this->pathsReadIDs);
    std::cout << "Read Paths are correct!" << std::endl;

    helpVector.clear();
    compareVector.clear();

    //Path 1
    helpVector.push_back(9);
    helpVector.push_back(10);
    compareVector.push_back(helpVector);
    //Path 2
    helpVector.clear();
    helpVector.push_back(9);
    helpVector.push_back(11);
    helpVector.push_back(12);
    helpVector.push_back(13);
    helpVector.push_back(14);
    helpVector.push_back(15);
    helpVector.push_back(16);
    helpVector.push_back(17);
    compareVector.push_back(helpVector);
    //Path 3
    helpVector.clear();
    helpVector.push_back(9);
    helpVector.push_back(11);
    helpVector.push_back(12);
    helpVector.push_back(13);
    helpVector.push_back(14);
    helpVector.push_back(16);
    helpVector.push_back(17);
    compareVector.push_back(helpVector);

    //Path 4
    helpVector.clear();
    helpVector.push_back(10);
    helpVector.push_back(11);
    helpVector.push_back(12);
    helpVector.push_back(13);
    helpVector.push_back(14);
    helpVector.push_back(15);
    helpVector.push_back(16);
    helpVector.push_back(17);
    compareVector.push_back(helpVector);

    //Path 5
    helpVector.clear();
    helpVector.push_back(10);
    helpVector.push_back(11);
    helpVector.push_back(12);
    helpVector.push_back(13);
    helpVector.push_back(14);
    helpVector.push_back(16);
    helpVector.push_back(17);
    compareVector.push_back(helpVector);

    ASSERT_EQ(compareVector,this->pathsWriteIDs);
    std::cout << "Write Paths are correct!" << std::endl;

    //Check Operations Read
    //#1
    ASSERT_EQ(operationsRead.at(0)->getState()->getName(), "state_0");
    ASSERT_EQ(operationsRead.at(0)->getNextState()->getName(), "state_1");
    ASSERT_EQ(operationsRead.at(0)->getStatementsList().size(), 2);
    //#2
    ASSERT_EQ(operationsRead.at(1)->getState()->getName(), "state_0");
    ASSERT_EQ(operationsRead.at(1)->getNextState()->getName(), "state_8");
    ASSERT_EQ(operationsRead.at(1)->getStatementsList().size(), 8);
    //#3
    ASSERT_EQ(operationsRead.at(2)->getState()->getName(), "state_0");
    ASSERT_EQ(operationsRead.at(2)->getNextState()->getName(), "state_8");
    ASSERT_EQ(operationsRead.at(2)->getStatementsList().size(), 7);
    //#4
    ASSERT_EQ(operationsRead.at(3)->getState()->getName(), "state_1");
    ASSERT_EQ(operationsRead.at(3)->getNextState()->getName(), "state_8");
    ASSERT_EQ(operationsRead.at(3)->getStatementsList().size(), 8);
    //#5
    ASSERT_EQ(operationsRead.at(4)->getState()->getName(), "state_1");
    ASSERT_EQ(operationsRead.at(4)->getNextState()->getName(), "state_8");
    ASSERT_EQ(operationsRead.at(4)->getStatementsList().size(), 7);

    std::cout << "Read Operations are correct!" <<std::endl;

    //Check Operations Write
    //#1
    ASSERT_EQ(operationsWrite.at(0)->getState()->getName(), "state_9");
    ASSERT_EQ(operationsWrite.at(0)->getNextState()->getName(), "state_10");
    ASSERT_EQ(operationsWrite.at(0)->getStatementsList().size(), 2);
    //#2
    ASSERT_EQ(operationsWrite.at(1)->getState()->getName(), "state_9");
    ASSERT_EQ(operationsWrite.at(1)->getNextState()->getName(), "state_17");
    ASSERT_EQ(operationsWrite.at(1)->getStatementsList().size(), 8);
    //#3
    ASSERT_EQ(operationsWrite.at(2)->getState()->getName(), "state_9");
    ASSERT_EQ(operationsWrite.at(2)->getNextState()->getName(), "state_17");
    ASSERT_EQ(operationsWrite.at(2)->getStatementsList().size(), 7);
    //#4
    ASSERT_EQ(operationsWrite.at(3)->getState()->getName(), "state_10");
    ASSERT_EQ(operationsWrite.at(3)->getNextState()->getName(), "state_17");
    ASSERT_EQ(operationsWrite.at(3)->getStatementsList().size(), 8);
    //#5
    ASSERT_EQ(operationsWrite.at(4)->getState()->getName(), "state_10");
    ASSERT_EQ(operationsWrite.at(4)->getNextState()->getName(), "state_17");
    ASSERT_EQ(operationsWrite.at(4)->getStatementsList().size(), 7);

    std::cout << "Write Operations are correct!" <<std::endl;


    //Generate final FSM
    std::vector<eventID> blockedFunctions;
    std::vector<eventID> readyQueue;
    std::vector<std::vector<eventID>>permutations;
    std::vector<eventID> hv;

//    //no function calls
//    permutations.push_back(hv);
    //only read call
    eventID read = {0,"read"};
    hv.push_back(read);
    permutations.push_back(hv);
    hv.clear();
    //only write call
    eventID write = {9,"write"};
    hv.push_back(write);
    permutations.push_back(hv);
    hv.clear();
    //read and write call
    hv.push_back(read);
    hv.push_back(write);
    permutations.push_back(hv);

    //construct a vector of all paths by pushing the paths from Read and Write to allPaths
    for(int i=0; i<pathsReadIDs.size();i++){
        pathIDStmt p = {pathsReadIDs.at(i),pathsRead.at(i)};
        allPaths.push_back(p);
    }
    for(int i=0; i<pathsWriteIDs.size();i++){
        pathIDStmt p = {pathsWriteIDs.at(i),pathsWrite.at(i)};
        allPaths.push_back(p);
    }


    pathIDStmt currentPath;
    for(auto perm: permutations){
        readyQueue = perm;
        blockedFunctions.clear();
        combinePaths(readyQueue,blockedFunctions);
    }

//    //Debug
//    for(auto p:finalPaths){
//        for(auto id:p.idList){
//            std::cout<<id<<"\t";
//        }
//        std::cout<< std::endl;
//    }

    std::map<int,State*> CfgIdToState;
    for(auto i:CfgIdToStateRead){
        CfgIdToState.insert(i);
    }
    for(auto i:CfgIdToStateWrite){
        CfgIdToState.insert(i);
    }

    //Generate final Operations
    //Iterate over all paths and set State, nextState and statementList
    for(auto path = finalPaths.begin(); path != finalPaths.end(); path++){
        auto op = new Operation();
        op->setState(CfgIdToState.at(path->idList.front()));
        op->setNextState(CfgIdToState.at(path->idList.back()));
        statementList.clear();

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

    std::vector<eventID> startnodes;
    eventID temp = {0, "reader_sync"};
    startnodes.push_back(temp);
    temp = {9,"writer_sync"};
    startnodes.push_back(temp);

    std::vector<eventID> endnodes;
    temp = {8,"reader_notify"};
    endnodes.push_back(temp);
    temp = {17,"writer_notify"};
    endnodes.push_back(temp);

    bool addsync[startnodes.size()];
    bool addnoti[startnodes.size()];

//    for(int i=0;i<operationsFinal.size();i++){
//        auto op = operationsFinal.at(i);
//        for(int j=0;j<startnodes.size();j++){
//            addsync[j] = false;
//            addnoti[j] = false;
//        }
//        for(auto id: finalPaths.at(i).idList){
//            for(int j=0; j<startnodes.size();j++){
//                if(id==startnodes.at(j).id){
//                    addsync[j]=true;
//                }
//                if(id==endnodes.at(j).id){
//                    addnoti[j]=true;
//                }
//            }
//        }
//        for(int j=0; j<startnodes.size();j++){
//            auto sync = new SyncSignal(startnodes.at(j).eventname);
//            auto noti = new Notify(endnodes.at(j).eventname);
//            if(addsync[j]){
//                op->addAssumption(sync);
//            }
//            else{
//                op->addAssumption(new UnaryExpr("not",sync));
//            }
//            if(addnoti[j]){
//                auto assign = new Assignment(noti,new BoolValue(true));
//                op->addCommitment(assign);
//            }
//            else{
//                auto assign = new Assignment(noti,new BoolValue(false));
//                op->addCommitment(assign);
//            }
//        }
//    }

    for(int i= 0; i<operationsFinal.size();i++){
        if(ValidOperations::isOperationReachable(operationsFinal.at(i))){
            operationsFinalOpt.push_back(operationsFinal.at(i));
            finalPathsOpt.push_back(finalPaths.at(i));
        }
    }

    for(auto op:operationsFinalOpt){
        op->getState()->addOutgoingOperation(op);
        op->getNextState()->addIncomingOperation(op);
    }

    module->getFSM()->setStateMap(CfgIdToState);

    PropertyFactory propertyFactory(module);
    //PrintITL::printModule(module);


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
}



#endif //DESCAM_OPERATION_GRAPH_H
