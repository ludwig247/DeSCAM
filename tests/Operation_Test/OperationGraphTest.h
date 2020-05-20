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


#include "gmock/gmock.h"
#include "Model.h"

using namespace SCAM;

class OperationGraphTest: public ::testing::Test{
public:
    OperationGraphTest():module(new SCAM::Module("TestModule")){
    }
    std::string printCFG(std::map<int,CfgNode*> controlFlowMap) {
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
    void findPathsfromNode(CfgNode* startnode, std::vector<std::vector<int>> *pathsFromStart){
        static std::vector<int> currentPath;
        currentPath.push_back(startnode->getId());
        //check if node has at least one successor and node is no wait or return
        if (startnode->getSuccessorList().size() >= 1 && (!NodePeekVisitor::nodePeekWait(startnode->getStmt()) && !NodePeekVisitor::nodePeekReturn(startnode->getStmt()) || currentPath.size() == 1)){
            for(auto succ: startnode->getSuccessorList()) {
                //recursively compute succesors
                findPathsfromNode(succ,pathsFromStart);
            }
            currentPath.pop_back();
            return;
        }
            //terminal node => creates a new path and adds it to pathsFromStart
        else{
            //only add real paths
            if(currentPath.size() > 1) {
                pathsFromStart->push_back(currentPath);
            }
            currentPath.pop_back();
            return;
        }
    }
    void generateOperations(){
        auto op = new Operation();

    }



    virtual void SetUp() {
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
        auto out = new Variable("out", DataTypes::getDataType("int"));
        auto val = new Variable("val", DataTypes::getDataType("int"));


        //add Variables to Module
        module->addVariable(buffer);
        module->addVariable(fifo_size);
        module->addVariable(state);
        module->addVariable(head);
        module->addVariable(tail);
        module->addVariable(reader_notify);
        module->addVariable(writer_notify);
        module->addVariable(out);
        module->addVariable(val);

        //Read Expressions/Assignments
        //if(state == EMPTY)
        auto empty_enum = new EnumValue("EMPTY", states);
        auto state_eq_empty = new Relational(new VariableOperand(module->getVariable("state")),"==",empty_enum);
        auto check_state_empty = new If(state_eq_empty);
        //wait(writer_notify)
        auto writer_wait = new Wait("writer_wait");
        //out = buffer[tail]
        auto variable_out = new VariableOperand(module->getVariable("out"));
        auto buffer_at_tail = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new VariableOperand(module->getVariable(("tail"))));
        auto out_assign_buffer_at_tail = new Assignment(variable_out,buffer_at_tail);
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
        std::map<int, CfgNode *> controlFlowMapRead;
        controlFlowMapRead.insert(std::make_pair(state_equal_empty->getId(),state_equal_empty));
        controlFlowMapRead.insert(std::make_pair(read_wait->getId(),read_wait));
        controlFlowMapRead.insert(std::make_pair(read_value->getId(),read_value));
        controlFlowMapRead.insert(std::make_pair(tail_incr->getId(),tail_incr));
        controlFlowMapRead.insert(std::make_pair(state_filled_read->getId(),state_filled_read));
        controlFlowMapRead.insert(std::make_pair(head_equal_tail_read->getId(),head_equal_tail_read));
        controlFlowMapRead.insert(std::make_pair(state_empty->getId(),state_empty));
        controlFlowMapRead.insert(std::make_pair(reader_noti->getId(),reader_noti));
        controlFlowMapRead.insert(std::make_pair(return_read->getId(),return_read));

        //Print CFG for Read
        //std::cout << printCFG(controlFlowMapRead) << std::endl;

        //Find important states Read
        std::map<int, CfgNode *> importantStatesRead;
        findImportantStates(controlFlowMapRead,&importantStatesRead);

        //Find operations Read
        auto start_read = controlFlowMapRead.begin()->second;
        findPathsfromNode(start_read,&pathsRead);
        for(auto const& node : importantStatesRead) {
            findPathsfromNode(node.second,&pathsRead);
        }

        //Create a map from CfgNode Id to State Read
        std::map<int,State*> CfgIdToStateRead;
        //If the state for the node is not yet created, create one
        for(auto path = pathsRead.begin(); path != pathsRead.end(); path++){
            if(CfgIdToStateRead.find(path->front()) == CfgIdToStateRead.end()){
                CfgIdToStateRead.insert(std::make_pair(path->front(),new State(controlFlowMapRead.at(path->front())->getName())));
            }
            if(CfgIdToStateRead.find(path->back()) == CfgIdToStateRead.end()){
                CfgIdToStateRead.insert(std::make_pair(path->back(), new State(controlFlowMapRead.at(path->back())->getName())));
            }
        }

        //Generate Operations Read
        std::vector<SCAM::Stmt*> statementList;
        for(auto path = pathsRead.begin(); path != pathsRead.end(); path++){
            auto op = new Operation();
            op->setState(CfgIdToStateRead.at(path->front()));
            op->setNextState(CfgIdToStateRead.at(path->back()));
            statementList.clear();
            for(auto index = path->begin(); index != path->end(); index++){
                statementList.push_back(controlFlowMapRead.at(*index)->getStmt());
            }
            op->setStatementsList(statementList);
            operationsRead.push_back(op);
        }


        for (auto val: CfgIdToStateRead){
            StateStringMapRead.insert(std::make_pair(std::to_string(val.first),val.second));
        }
        //Get Assumptions and Commitments
        SCAM::ReconstructOperations rOperations(this->StateStringMapRead,this->module);
        for(auto op: this->operationsRead) {
            rOperations.sortOperation(op);
        }



        //Write Expressions/Assignments
        //if (state == FULL)
        auto full_enum = new EnumValue("FULL", states);
        auto state_eq_full = new Relational(new VariableOperand(module->getVariable("state")),"==",full_enum);
        auto check_state_full = new If(state_eq_full);
        //wait(reader_notify);
        auto reader_wait = new Wait("reader_wait");
        //buffer[head] = val;
        auto variable_val = new VariableOperand(module->getVariable("val"));
        auto buffer_at_head = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new VariableOperand(head));
        auto buffer_at_head_assign_val = new Assignment(buffer_at_head, variable_val);
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

        //CFG nodes Write
        auto state_equal_full = new CfgNode(check_state_empty);
        auto write_wait = new CfgNode(writer_wait);
        auto write_value = new CfgNode(out_assign_buffer_at_tail);
        auto head_incr = new CfgNode(tail_assign_tail_modulo_increment);
        auto state_filled_write = new CfgNode(state_assign_filled);
        auto head_equal_tail_write = new CfgNode(if_head_eq_tail);
        auto state_full = new CfgNode(state_assign_empty);
        auto writer_noti = new CfgNode(notify_reader);
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
        std::map<int, CfgNode *> controlFlowMapWrite;
        controlFlowMapWrite.insert(std::make_pair(state_equal_full->getId(),state_equal_full));
        controlFlowMapWrite.insert(std::make_pair(write_wait->getId(),write_wait));
        controlFlowMapWrite.insert(std::make_pair(write_value->getId(),write_value));
        controlFlowMapWrite.insert(std::make_pair(head_incr->getId(),head_incr));
        controlFlowMapWrite.insert(std::make_pair(state_filled_write->getId(),state_filled_write));
        controlFlowMapWrite.insert(std::make_pair(head_equal_tail_write->getId(),head_equal_tail_write));
        controlFlowMapWrite.insert(std::make_pair(state_full->getId(),state_full));
        controlFlowMapWrite.insert(std::make_pair(writer_noti->getId(),writer_noti));
        controlFlowMapWrite.insert(std::make_pair(return_write->getId(),return_write));

        //Print CFG Write
        //std::cout << printCFG(controlFlowMapWrite) << std::endl;

        //Find important states Write
        std::map<int, CfgNode *> importantStatesWrite;
        findImportantStates(controlFlowMapWrite,&importantStatesWrite);

        //Find operations Write
        auto start_write = controlFlowMapWrite.begin()->second;
        findPathsfromNode(start_write,&pathsWrite);
        for(auto const& node : importantStatesWrite) {
            findPathsfromNode(node.second,&pathsWrite);
        }

        //Create a map from CfgNode Id to State Write
        std::map<int,State*> CfgIdToStateWrite;
        //If the state for the node is not yet created, create one
        for(auto path = pathsWrite.begin(); path != pathsWrite.end(); path++){
            if(CfgIdToStateWrite.find(path->front()) == CfgIdToStateWrite.end()){
                CfgIdToStateWrite.insert(std::make_pair(path->front(),new State(controlFlowMapWrite.at(path->front())->getName())));
            }
            if(CfgIdToStateWrite.find(path->back()) == CfgIdToStateWrite.end()){
                CfgIdToStateWrite.insert(std::make_pair(path->back(), new State(controlFlowMapWrite.at(path->back())->getName())));
            }
        }

        //Generate Operations Write

        for(auto path = pathsWrite.begin(); path != pathsWrite.end(); path++){
            auto op = new Operation();
            op->setState(CfgIdToStateWrite.at(path->front()));
            op->setNextState(CfgIdToStateWrite.at(path->back()));
            statementList.clear();
            for(auto index = path->begin(); index != path->end(); index++){
                statementList.push_back(controlFlowMapWrite.at(*index)->getStmt());
            }
            op->setStatementsList(statementList);
            operationsWrite.push_back(op);
        }

        return;
    }

    virtual void TearDown() {}

    SCAM::Module *module;
    std::vector<std::vector<int>> pathsRead;
    std::vector<std::vector<int>> pathsWrite;
    std::map<std::string, State*> StateStringMapRead;
    std::vector<Operation*> operationsRead;
    std::vector<Operation*> operationsWrite;
};

TEST_F(OperationGraphTest, ExtractPaths){
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

    ASSERT_EQ(compareVector,this->pathsRead);
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

    ASSERT_EQ(compareVector,this->pathsWrite);
    std::cout << "Write Paths are correct!" << std::endl;
}
//
TEST_F(OperationGraphTest, CheckOperations){
    ASSERT_EQ(operationsRead.at(0)->getState()->getName(), "state_0");
    ASSERT_EQ(operationsRead.at(0)->getNextState()->getName(), "state_1");
    ASSERT_EQ(operationsRead.at(0)->getStatementsList().size(), 2);
    std::cout << "First Operation is correct!" <<std::endl;
}


#endif //DESCAM_OPERATION_GRAPH_H
