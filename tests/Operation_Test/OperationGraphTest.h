//
// Created by wezel on 23.04.20.
//

#ifndef DESCAM_OPERATION_GRAPH_H
#define DESCAM_OPERATION_GRAPH_H


#include <gtest/gtest.h>
#include <Stmts_all.h>
#include <PrintStmt.h>
#include <OperationMiscellaneous/FindCommunication2.h>
#include "gmock/gmock.h"
#include "Model.h"

using namespace SCAM;

class OperationGraphTest: public ::testing::Test{
public:
    OperationGraphTest():module(new Module("TestModule")){
}
std::string printCFG(std::map<int,CfgNode*> controlFlowMap) {
    std::stringstream ss;
    for (auto node: controlFlowMap) {
        CfgNode *sus = node.second;

        ss << "[ID" << node.first << "] [Node" << sus->getName() << "]" << "\n";
        ss << "\tStmntList: " << "\n";


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
virtual void SetUp() {
    auto *states = new DataType("states");
    states->addEnumValue("EMPTY");
    states->addEnumValue("FILLED");
    states->addEnumValue("FULL");

    auto *T_star_type = new DataType("T*");
    auto *sc_event_type = new DataType("sc_event");
    //Types of function arguments
    auto *T_and_type = new DataType("T&");
    auto *T_const_and_type = new DataType("Tconst&");

    auto test= new DataType("unsigned_8");
    test->addArray(DataTypes::getDataType("int"),8);

    auto *buffer = new Variable("buffer", test);
    auto *fifo_size = new Variable("fifo_size", DataTypes::getDataType("unsigned"));
    auto *state = new Variable("state", states);
    auto *head = new Variable("head", DataTypes::getDataType("int"));
    auto *tail = new Variable("tail", DataTypes::getDataType("int"));
    auto *reader_notify = new Variable("reader_notify", DataTypes::getDataType("bool"));
    auto *writer_notify = new Variable("writer_notify", DataTypes::getDataType("bool"));
    auto *out = new Variable("out", DataTypes::getDataType("int"));
    auto *val = new Variable("val", DataTypes::getDataType("int"));


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


    //Read States
    {read_start = new State("Start of read");
    read_wait_writer = new State("Wait for writer");
    read = new State("Perform read");
    read_end = new State("End of read");

    //Read Operations
    op_read_empty = new Operation();
    op_read_non_empty = new Operation();
    op_read_writer_notify = new Operation();
    op_read_equal_pointers = new Operation();
    op_read_non_equal_pointers = new Operation();


    op_read_empty->setState(read_start);
    op_read_empty->setNextState(read_wait_writer);

    op_read_non_empty->setState(read_start);
    op_read_non_empty->setNextState(read);

    op_read_writer_notify->setState(read_wait_writer);
    op_read_writer_notify->setNextState(read_end);

    op_read_equal_pointers->setState(read);
    op_read_equal_pointers->setNextState(read_end);

    op_read_non_equal_pointers->setState(read);
    op_read_non_equal_pointers->setNextState(read_end);

    read_start->addOutgoingOperation(op_read_empty);
    read_start->addOutgoingOperation(op_read_non_empty);

    read_wait_writer->addIncomingOperation(op_read_empty);
    read_wait_writer->addOutgoingOperation(op_read_writer_notify);

    read->addIncomingOperation(op_read_non_empty);
    read->addOutgoingOperation(op_read_equal_pointers);
    read->addOutgoingOperation(op_read_non_equal_pointers);

    read_end->addIncomingOperation(op_read_writer_notify);
    read_end->addIncomingOperation(op_read_equal_pointers);
    read_end->addIncomingOperation(op_read_non_equal_pointers);
}

    //Read Expressions/Assignments
    //if(state == EMPTY)
    auto *empty_enum = new EnumValue("EMPTY", states);
    auto *state_eq_empty = new Relational(new VariableOperand(module->getVariable("state")),"==",empty_enum);
    auto *check_state_empty = new If(state_eq_empty);
    //wait(writer_notify)
    auto *writer_wait = new Wait("writer_wait");
    //out = buffer[tail]
    auto * variable_out = new VariableOperand(module->getVariable("out"));
    auto *buffer_at_tail = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new VariableOperand(module->getVariable(("tail"))));
    auto *out_assign_buffer_at_tail = new Assignment(variable_out,buffer_at_tail);
    //tail = (tail+1)%fifo_size
    auto *tail_increment = new Arithmetic(new VariableOperand(module->getVariable("tail")),"+",new IntegerValue(1));
    auto *tail_modulo_increment = new Arithmetic(tail_increment,"%",new Cast(new VariableOperand(module->getVariable("fifo_size")),DataTypes::getDataType("int")));
    auto *tail_assign_tail_modulo_increment= new Assignment(new VariableOperand(module->getVariable("tail")),tail_modulo_increment);
    //state = FILLED
    auto *filled_enum = new EnumValue("FILLED",states);
    auto *state_assign_filled = new Assignment(new VariableOperand(module->getVariable("state")),filled_enum);
    //if(head == tail)
    auto *head_eq_tail = new Relational(new VariableOperand(module->getVariable("head")),"==",new VariableOperand(module->getVariable("tail")));
    //state = EMPTY
    auto *state_assign_empty = new Assignment(new VariableOperand(module->getVariable("state")),empty_enum);
    //reader_notify.notify()
    auto *notify_reader = new Notify("reader_notify");
    //return
    auto *read_return = new Return("read_return");

    //Read CFG
    auto *state_equal_empty = new CfgNode(check_state_empty);
    auto *read_wait = new CfgNode(writer_wait);
    auto *read_value = new CfgNode(out_assign_buffer_at_tail);
    auto *tail_incr = new CfgNode(tail_assign_tail_modulo_increment);
    auto *state_filled_read = new CfgNode(state_assign_filled);
    auto *head_equal_tail_read = new CfgNode(head_eq_tail);
    auto *state_empty = new CfgNode(state_assign_empty);
    auto *reader_noti = new CfgNode(notify_reader);
    auto *return_read = new CfgNode(read_return);

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

    std::cout << printCFG(controlFlowMapRead) << std::endl;

    //Find important states
//    std::map<int, State *> importantStatesRead;
//    for (auto node : controlFlowMapRead){
//        SCAM::FindCommunication2 findComm;
//        //nodes with wait or return statement
//        importantStatesRead.insert(std::make_pair(node.first,new State(node.second->getName())));
//    }

    //Find operations

    //Write States
    {write_start = new State("Start of write");
    write_wait_reader = new State( "Wait for reader");
    write = new State("Perform write");
    write_end = new State( "End of write");

        //Write Operations
        op_write_full = new Operation();
        op_write_non_full = new Operation();
        op_write_reader_notify = new Operation();
        op_write_equal_pointers = new Operation();
        op_write_non_equal_pointers = new Operation();


        op_write_full->setState(write_start);
        op_write_full->setNextState(write_wait_reader);

        op_write_non_full->setState(write_start);
        op_write_non_full->setNextState(write);

        op_write_reader_notify->setState(write_wait_reader);
        op_write_reader_notify->setNextState(write_end);

        op_write_equal_pointers->setState(write);
        op_write_equal_pointers->setNextState(write_end);

        op_write_non_equal_pointers->setState(write);
        op_write_non_equal_pointers->setNextState(write_end);

        write_start->addOutgoingOperation(op_write_full);
        write_start->addOutgoingOperation(op_write_non_full);

        write_wait_reader->addIncomingOperation(op_write_full);
        write_wait_reader->addOutgoingOperation(op_write_reader_notify);

        write->addIncomingOperation(op_write_non_full);
        write->addOutgoingOperation(op_write_non_equal_pointers);
        write->addOutgoingOperation(op_write_equal_pointers);

        write_end->addIncomingOperation(op_write_reader_notify);
        write_end->addIncomingOperation(op_write_non_equal_pointers);
        write_end->addIncomingOperation(op_write_equal_pointers);
    }

    //Write Expressions/Assignments
    //if (state == FULL)
    auto *full_enum = new EnumValue("FULL", states);
    auto *state_eq_full = new Relational(new VariableOperand(module->getVariable("state")),"==",full_enum);
    auto *check_state_full = new If(state_eq_full);
    //wait(reader_notify);
    auto *reader_wait = new Wait("reader_wait");
    //buffer[head] = val;
    auto *variable_val = new VariableOperand(module->getVariable("val"));
    auto *buffer_at_head = new ArrayOperand(new VariableOperand(module->getVariable("buffer")),new VariableOperand(head));
    auto *buffer_at_head_assign_val = new Assignment(buffer_at_head, variable_val);
    //head = (head+1)%fifo_size
    auto *head_increment = new Arithmetic(new VariableOperand(module->getVariable("head")),"+",new IntegerValue(1));
    auto *head_modulo_increment = new Arithmetic(tail_increment,"%",new VariableOperand(module->getVariable("fifo_size")));
    auto *head_assign_head_modulo_increment = new Assignment(new VariableOperand(module->getVariable("head")),head_modulo_increment);
    //state = FILLED
    //already exists
    //if (head==tail)
    //already exists
    //state = FULL
    auto *state_assign_full = new Assignment(new VariableOperand(module->getVariable("state")),full_enum);
    //writer_notify.notify()
    auto *notify_writer = new Notify("writer_notify");
    //return
    auto *write_return = new Return("write_return");

    //Write CFG
    auto *state_equal_full = new CfgNode(check_state_empty);
    auto *write_wait = new CfgNode(writer_wait);
    auto *write_value = new CfgNode(out_assign_buffer_at_tail);
    auto *head_incr = new CfgNode(tail_assign_tail_modulo_increment);
    auto *state_filled_write = new CfgNode(state_assign_filled);
    auto *head_equal_tail_write = new CfgNode(head_eq_tail);
    auto *state_full = new CfgNode(state_assign_empty);
    auto *writer_noti = new CfgNode(notify_reader);
    auto *return_write = new CfgNode(write_return);

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

    std::map<int, CfgNode *> controlFlowMapWrite;
    controlFlowMapWrite.insert(std::make_pair(state_equal_empty->getId(),state_equal_empty));
    controlFlowMapWrite.insert(std::make_pair(read_wait->getId(),read_wait));
    controlFlowMapWrite.insert(std::make_pair(read_value->getId(),read_value));
    controlFlowMapWrite.insert(std::make_pair(tail_incr->getId(),tail_incr));
    controlFlowMapWrite.insert(std::make_pair(state_filled_read->getId(),state_filled_read));
    controlFlowMapWrite.insert(std::make_pair(head_equal_tail_read->getId(),head_equal_tail_read));
    controlFlowMapWrite.insert(std::make_pair(state_empty->getId(),state_empty));
    controlFlowMapWrite.insert(std::make_pair(reader_noti->getId(),reader_noti));
    controlFlowMapWrite.insert(std::make_pair(return_read->getId(),return_read));

    std::cout << printCFG(controlFlowMapWrite) << std::endl;

}

virtual void TearDown() {}
SCAM::Module * module;
    //Read Function
    State *read_start;
    State *read_wait_writer;
    State *read;
    State *read_end;

    Operation *op_read_empty;
    Operation *op_read_non_empty;
    Operation *op_read_writer_notify;
    Operation *op_read_equal_pointers;
    Operation *op_read_non_equal_pointers;

    //Write Function
    State *write_start;
    State *write_wait_reader;
    State *write;
    State *write_end;

    Operation *op_write_full;
    Operation *op_write_non_full;
    Operation *op_write_reader_notify;
    Operation *op_write_equal_pointers;
    Operation *op_write_non_equal_pointers;

};

TEST_F(OperationGraphTest, CorrectConnected){
    //Read Connections
    ASSERT_EQ(read_start->getOutgoingOperationsList().front(), op_read_empty);
    ASSERT_EQ(read_start->getOutgoingOperationsList().back(), op_read_non_empty);

    ASSERT_EQ(read_wait_writer->getIncomingOperationsList().front(), op_read_empty);
    ASSERT_EQ(read_wait_writer->getOutgoingOperationsList().front(), op_read_writer_notify);

    ASSERT_EQ(read->getIncomingOperationsList().front(), op_read_non_empty);
    ASSERT_EQ(read->getOutgoingOperationsList().front(), op_read_equal_pointers);
    ASSERT_EQ(read->getOutgoingOperationsList().back(), op_read_non_equal_pointers);

    ASSERT_EQ( read_end->getIncomingOperationsList().at(0),op_read_writer_notify);
    ASSERT_EQ( read_end->getIncomingOperationsList().at(1),op_read_equal_pointers);
    ASSERT_EQ( read_end->getIncomingOperationsList().at(2),op_read_non_equal_pointers);

    //Write Connections
    ASSERT_EQ(write_start->getOutgoingOperationsList().front(), op_write_full);
    ASSERT_EQ(write_start->getOutgoingOperationsList().back(), op_write_non_full);

    ASSERT_EQ(write_wait_reader->getIncomingOperationsList().front(), op_write_full);
    ASSERT_EQ(write_wait_reader->getOutgoingOperationsList().front(), op_write_reader_notify);

    ASSERT_EQ(write->getIncomingOperationsList().front(), op_write_non_full);
    ASSERT_EQ(write->getOutgoingOperationsList().front(), op_write_non_equal_pointers);
    ASSERT_EQ(write->getOutgoingOperationsList().back(), op_write_equal_pointers);

    ASSERT_EQ( write_end->getIncomingOperationsList().at(0),op_write_reader_notify);
    ASSERT_EQ( write_end->getIncomingOperationsList().at(1),op_write_non_equal_pointers);
    ASSERT_EQ( write_end->getIncomingOperationsList().at(2),op_write_equal_pointers);
    std::cout << "Connections are correct" << std::endl;
}

#endif //DESCAM_OPERATION_GRAPH_H
