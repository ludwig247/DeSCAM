//
// Created by tobias on 31.01.18.
//

#ifndef PROJECT_OPERATIONSTATE_TEST_H
#define PROJECT_OPERATIONSTATE_TEST_H

#include <gtest/gtest.h>
#include <operationGraph/State.h>
#include <Stmts/BoolValue.h>
#include <operationGraph/Operation.h>
#include <Stmts/Relational.h>
#include <Stmts/SyncSignal.h>
#include <Stmts/VariableOperand.h>
#include <Stmts/DataSignalOperand.h>


using namespace SCAM;
class OperationState_Test: public ::testing::Test{
public:
    OperationState_Test(){

    }

    virtual void SetUp() {

        /* PPA for
         * while{
         *  blocking_input->read(val);
         *  master_output->write(true);
         * }
         * In this case we generate two states, the tool will generate only one state,
         * because the master_output is merged into the operation in case of active sync
         */


        //First state: blocking_input

        // Each port has an interface, interfac enames may be extraced by runing SCAM with -AML, directions are in/out
        // Furthermore, each port has a datatype: built-in types are bool,int,unsigned
        // A datatype is received by using the singleton DataTypes
        Interface interface("blocking","in");
        blocking_input= new Port("blocking_input",&interface,DataTypes::getDataType("int"));

        //A state consists of it's section, unique id and   communication stmt
        //A state is considered a PPA state
        Communication * communication= new Communication(blocking_input,false);
        state = new State("run",0,communication);

        //Second state

        Interface interface2("master","out");
        //The difference in the
        master_output= new Port("master_output",&interface2,DataTypes::getDataType("bool"));
        Communication * communication2 = new Communication(master_output,false);
        //In case of an output the value to be written needs also to be set
        writeValue = new BoolValue(true);
        state2 = new State("run",1,communication2,writeValue);

        //Now we need to create the operations
        //Common to all operations
        SCAM::SyncSignal * syncSignal= new SyncSignal(blocking_input);
        Variable * val= new Variable("val",DataTypes::getDataType("int"),DataTypes::getDataType("int")->getDefaultVal());
        VariableOperand * variableOperand = new VariableOperand(val);

        //Blocking_input if synch is high -> transition to state2
        op_read_to_master= new Operation(state,state2); //state and nextstate
        //Assumption: sync
        SCAM::Relational * synch = new Relational(syncSignal,"==",new BoolValue(true));
        op_read_to_master->addAssumption(synch);
        //Commitment: val = val;
        //Now we need a variable, each variable has a name, datatype and initialvalue
        DataSignalOperand * dataSignalOperand = new DataSignalOperand(blocking_input->getDataSignal());
        //Assignments are made of
        Assignment * take_value_from_input = new Assignment(variableOperand,dataSignalOperand);
        op_read_to_master->addCommitment(take_value_from_input);


        //Blocking_input has a wait operation and a operation ending in state 1
        op_wait= new Operation(state,state); //state and nextstate
        op_wait->setWait(true);
        //Assumption: !sync
        SCAM::Relational  * notSynch= new Relational(syncSignal,"==",new BoolValue(false));
        op_wait->addAssumption(notSynch);
        //Commitment: val = val;
        //Now we need a variable, each variable has a name, datatype and initialvalue
        //Assignments are made of
        Assignment * stay_the_same = new Assignment(variableOperand,variableOperand);
        op_wait->addCommitment(stay_the_same);

        //Blocking_input has a wait operation and a operation ending in state 1
        op_master_to_blocking= new Operation(state2,state); //state and nextstate
        op_master_to_blocking->setWait(false);
        //Assumption: no assumption for master_out just send the value
        //Commitment: master_output_sig = true;
        //Assignments are made of
        DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(master_output->getDataSignal());
        Assignment * assign_true = new Assignment(dataSignalOperand2,new BoolValue(true));
        op_master_to_blocking->addCommitment(assign_true);

    }

    virtual void TearDown() {}
    Port * master_output;
    Port * blocking_input;
    SCAM::Expr * writeValue;
    State * state;
    State * state2;
    Operation * op_wait;
    Operation * op_read_to_master;
    Operation * op_master_to_blocking;
};


TEST_F(OperationState_Test,CreateState){
    ASSERT_EQ(state->getStateId(),0);
    ASSERT_EQ(state->getName(),"run_0");
    ASSERT_EQ(state->getSection(),"run");
    ASSERT_EQ(state->getCommPort()->getName(),"blocking_input");

    ASSERT_EQ(state2->getStateId(),1);
    ASSERT_EQ(state2->getName(),"run_1");
    ASSERT_EQ(state2->getSection(),"run");
    ASSERT_EQ(state2->getCommPort()->getName(),"master_output");

}

TEST_F(OperationState_Test,Operation){
    //NO tests her
    ASSERT_TRUE(op_wait->isWait());
}

TEST_F(OperationState_Test,OperationReadToMaster){
    //NO tests her

    ASSERT_TRUE(!op_read_to_master->isWait());
    ASSERT_TRUE(!op_master_to_blocking->isWait());
}


TEST_F(OperationState_Test,PrintStateMap){
    //NO tests her
    std::cout << state->printOutgoingOperations() << std::endl;
    std::cout << state2->printOutgoingOperations() << std::endl;

    ASSERT_TRUE(true);
}

#endif //PROJECT_OPERATIONSTATE_TEST_H
