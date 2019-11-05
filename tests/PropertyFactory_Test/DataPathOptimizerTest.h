//
// Created by tobias on 24.01.18.
//

#ifndef PROJECT_DATAPATHOPTIMIZERTEST_H
#define PROJECT_DATAPATHOPTIMIZERTEST_H


#include <gtest/gtest.h>
#include "gmock/gmock.h"
#include <Module.h>
#include "Model.h"
#include <toPPA/CreateInitSection.h>
#include <Stmts_all.h>
#include <toPPA/ValuePropagation.h>
#include <toPPA/SectionToPaths.h>
#include <toPPA/OnlyBlockingComm.h>
#include <toPPA/CommToCommNew.h>
#include <toPPA/DataPathOptimizer.h>
#include <PrintStmt.h>

using namespace SCAM;
class DataPathOptimizer_Test: public ::testing::Test{
public:
    DataPathOptimizer_Test():module(new Module("TestModule")){
    }

    virtual void SetUp() {
        DataType * compound= new DataType("compound");
        compound->addSubVar("int_val",DataTypes::getDataType("int"));
        compound->addSubVar("unsigned_val",DataTypes::getDataType("unsigned"));
        DataTypes::addDataType(compound);
        //Ports
        Interface * anInterface = new Interface("blocking","out");
        Interface * anInterface2 = new Interface("blocking","in");
        module->addPort(new Port("output",anInterface,DataTypes::getDataType("int")));
        module->addPort(new Port("input_unsigned",anInterface2,DataTypes::getDataType("unsigned")));
        module->addPort(new Port("input_unsigned2",anInterface2,DataTypes::getDataType("unsigned")));
        module->addPort(new Port("input_compound",anInterface2,DataTypes::getDataType("compound")));

        module->addVariable(new Variable("compound_var",SCAM::DataTypes::getDataType("compound"),SCAM::DataTypes::getDataType("compound")->getDefaultVal()));
        module->addVariable(new Variable("unsigned_var",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100)));
        module->addVariable(new Variable("unsigned_var2",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100)));
        module->addVariable(new Variable("integer_var",SCAM::DataTypes::getDataType("int"),new IntegerValue(0)));
    }

    virtual void TearDown() {}
    SCAM::Module * module;

};


TEST_F(DataPathOptimizer_Test,UnsignedAddition){

    //Assignment: unsigned_var = -1 + 10 = 9;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(-1),"+",new UnsignedValue(10));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"9");


}
TEST_F(DataPathOptimizer_Test,UnsignedAddition2){

    //Assignment: unsigned_var = -10 + 2 = 4294967288;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(-10),"+",new UnsignedValue(2));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);

    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"4294967288");

}

TEST_F(DataPathOptimizer_Test,UnsignedAddition3){

    //Assignment: unsigned_var = 0 - (-10) = 10;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(0),"-",new UnsignedValue(-10));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);

    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"10");

}


TEST_F(DataPathOptimizer_Test,UnsignedAddition4){
    //Assignment: unsigned_var = 0 + (-10) = 4294967286 ;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(0),"+",new UnsignedValue(-10));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"4294967286");
}

TEST_F(DataPathOptimizer_Test,UnsignedAddition5){
    //Assignment: unsigned_var = 0 - 10 = 4294967286;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(0),"-",new UnsignedValue(10));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"4294967286");

}

TEST_F(DataPathOptimizer_Test,UnsignedAddition6){
    //Assignment: unsigned_var = 4294967286 + 10;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(4294967286),"+",new UnsignedValue(10));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"0");
}


TEST_F(DataPathOptimizer_Test,UnsignedReminder){
    //Assignment: unsigned_var = 1337 % 1337 = 0;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(1337),"%",new UnsignedValue(1337));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"0");
}

TEST_F(DataPathOptimizer_Test,UnsignedReminder2){
    //Assignment: unsigned_var = 5 % 3 = 2;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(5),"%",new UnsignedValue(3));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"2");
}

TEST_F(DataPathOptimizer_Test,UnsignedReminderAdd){
    //Assignment: unsigned_var = 5 % 3 = 2;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * test = new Arithmetic(new UnsignedValue(3),"+",new UnsignedValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new UnsignedValue(2));
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"0");
}

TEST_F(DataPathOptimizer_Test,UnsignedReminderVar){
    //Assignment: unsigned_var = 5 % 3 = 2;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    VariableOperand * variableOperand2 = new VariableOperand(module->getVariable("unsigned_var2"));
    Arithmetic * unsignedRem = new Arithmetic(variableOperand, "%", variableOperand2);
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"(unsigned_var % unsigned_var2)");
}

TEST_F(DataPathOptimizer_Test,UnsignedReminderTest){
    //Assignment: unsigned_var = (2* 10) % 100 = 20;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic2 = new Arithmetic(new UnsignedValue(10),"*",new UnsignedValue(2));
    Arithmetic * arithmetic = new Arithmetic(arithmetic2,"%",new UnsignedValue(100));
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"20");
}


TEST_F(DataPathOptimizer_Test,UnsignedReminderValueVar){
    //Assignment: unsigned_var = (2* 10) % 100 = 20;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * arithmetic = new Arithmetic(new UnsignedValue(10),"%",variableOperand);
    Assignment * assignment = new Assignment(variableOperand,arithmetic);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"(10 % unsigned_var)");
}


TEST_F(DataPathOptimizer_Test,UnsignedReminderVar2){
    //Assignment: unsigned_var = 5 % 3 = 2;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * unsignedRem = new Arithmetic(variableOperand, "%", new UnsignedValue(10));
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"(unsigned_var % 10)");
}


TEST_F(DataPathOptimizer_Test,UnsignedReminderVar3){
    //Assignment: unsigned_var = 5 % 3 = 2;
//    for(unsigned int i=2;i<=std::pow(2,30);i=i*2){ //TODO: only works until 2^30 not 2^31 ...
    for(auto i=2;i<33;i++){
        VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
        Arithmetic * unsignedRem = new Arithmetic(variableOperand, "%", new UnsignedValue(i));
        Assignment * assignment = new Assignment(variableOperand,unsignedRem);

        Path * path = new Path("foo");
        std::vector<Assignment*> assignmentList;
        assignmentList.push_back(assignment);
        path->setDataPathList(assignmentList);
        DataPathOptimizer::optimize(path,module);
        auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
        ASSERT_EQ(value,"(unsigned_var % " + std::to_string(i)+ ")");
    }


}


TEST_F(DataPathOptimizer_Test,UnsignedReminderSub){
    //Assignment: unsigned_var = 5 % 3 = 2;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * test = new Arithmetic(new UnsignedValue(3),"-",new UnsignedValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new UnsignedValue(2));
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"0");
}


TEST_F(DataPathOptimizer_Test,UnsignedReminderMul){
    //Assignment: unsigned_var = 5 % 3 = 2;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * test = new Arithmetic(new UnsignedValue(3),"*",new UnsignedValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new UnsignedValue(2));
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"1");
}


TEST_F(DataPathOptimizer_Test,UnsignedReminderDiv){
    //Assignment: unsigned_var = 3/ 1 % 2 = 1;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Arithmetic * test = new Arithmetic(new UnsignedValue(3),"/",new UnsignedValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new UnsignedValue(2));
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"1");
}



TEST_F(DataPathOptimizer_Test,SingedReminderDiv){
    //Assignment: signed_var = -3/ 1 % 2 = 1;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Arithmetic * test = new Arithmetic(new IntegerValue(-3),"/",new IntegerValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new IntegerValue(2));
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);

    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"-1");
}

TEST_F(DataPathOptimizer_Test,SingedReminderDiv2){
    //Assignment: signed_var = -3/ 1 % 2 = 1;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Arithmetic * unsignedRem = new Arithmetic(new IntegerValue(-3), "%", variableOperand);
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(-3 % integer_var)");
}

TEST_F(DataPathOptimizer_Test,SingedReminderCornerCase1){
    //Assignment: signed_var = -3/ 1 % 2 = 1;
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Arithmetic * unsignedRem = new Arithmetic(new IntegerValue(-2147483648), "%", variableOperand);
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(-2147483648 % integer_var)");
}
TEST_F(DataPathOptimizer_Test,SingedReminderCornerCase2){
    //Overflow
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Arithmetic * arithmetic = new Arithmetic(new IntegerValue(2147483647), "+", new IntegerValue(1));
    Arithmetic * unsignedRem = new Arithmetic(arithmetic, "%", variableOperand);
    Assignment * assignment = new Assignment(variableOperand,unsignedRem);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(-2147483648 % integer_var)");
}
TEST_F(DataPathOptimizer_Test, BitwiseAnd) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(new IntegerValue(3), "&", new IntegerValue(1) );
    Assignment * assignment = new Assignment(variableOperand,bitwise);


    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"1");
}
TEST_F(DataPathOptimizer_Test, BitwiseAnd2) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(new IntegerValue(-1), "&", new IntegerValue(1) );
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"1");
}


TEST_F(DataPathOptimizer_Test, BitwiseAnd3) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Arithmetic * arithmetic = new Arithmetic(new IntegerValue(2), "+", new IntegerValue(1));
    Bitwise * bitwise = new Bitwise(arithmetic, "&", new IntegerValue(1) );
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"1");
}
TEST_F(DataPathOptimizer_Test, BitwiseAnd4) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Arithmetic * arithmetic = new Arithmetic(new IntegerValue(2), "+", new IntegerValue(1));
    Bitwise * bitwise = new Bitwise(arithmetic, "&",variableOperand );
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);
    //std::cout << PrintStmt::toString(assignment) << std::endl;
    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"((2 + 1) & integer_var)");
}

TEST_F(DataPathOptimizer_Test, BitwiseAnd5) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, "&", new IntegerValue(2));
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(integer_var & 2)");
}

TEST_F(DataPathOptimizer_Test, BitwiseAnd6) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, "&", new IntegerValue(0));
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"0");
}

TEST_F(DataPathOptimizer_Test, BitwiseAnd7) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(new IntegerValue(-1), "&", new IntegerValue(1));
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"1");
}

TEST_F(DataPathOptimizer_Test, BitwiseAnd8) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(new IntegerValue(-2), "&", new IntegerValue(1));
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"0");
}



TEST_F(DataPathOptimizer_Test, BitwiseAnd9) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, "&", new IntegerValue(-1));
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"integer_var");
}
TEST_F(DataPathOptimizer_Test, BitwiseAnd10) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, "&", new IntegerValue(-2));
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(integer_var & -2)");
}


TEST_F(DataPathOptimizer_Test, BitwiseAnd11) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, "&", new IntegerValue(-10));
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(integer_var & -10)");
}

TEST_F(DataPathOptimizer_Test, BitwiseAnd12) {

    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise( new IntegerValue(-10) , "&", variableOperand);
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(-10 & integer_var)");
}

TEST_F(DataPathOptimizer_Test, BitwiseAnd13) {
VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
Bitwise * bitwise = new Bitwise( new IntegerValue(2) , "&", variableOperand);
Bitwise * bitwise2 = new Bitwise( new IntegerValue(6) , "&", bitwise);
Assignment * assignment = new Assignment(variableOperand,bitwise2);

Path * path = new Path("foo");
std::vector<Assignment*> assignmentList;
assignmentList.push_back(assignment);
path->setDataPathList(assignmentList);

auto result = DataPathOptimizer::optimize(path,module);
auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

ASSERT_EQ(value,"(6 & (2 & integer_var))");
}



TEST_F(DataPathOptimizer_Test, BitwiseOr) {
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise( new IntegerValue(6) , "|", new IntegerValue(3));
    Bitwise * bitwise2 = new Bitwise( variableOperand , "|", bitwise);
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"7");
}

TEST_F(DataPathOptimizer_Test, BitwiseOr2) {
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise( new IntegerValue(6) , "|", variableOperand);
//    Bitwise * bitwise2 = new Bitwise( new IntegerValue(6) , "|", bitwise);
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(6 | integer_var)");
}

TEST_F(DataPathOptimizer_Test, BitwiseOr2a) {
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise( variableOperand , "|", new IntegerValue(6));
//    Bitwise * bitwise2 = new Bitwise( new IntegerValue(6) , "|", bitwise);
    Assignment * assignment = new Assignment(variableOperand,bitwise);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(integer_var | 6)");
}
TEST_F(DataPathOptimizer_Test, BitwiseOr3) {
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise( new IntegerValue(3) , "|", variableOperand);
    Bitwise * bitwise2 = new Bitwise( new IntegerValue(6) , "|", bitwise);
    Assignment * assignment = new Assignment(variableOperand,bitwise2);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());

    ASSERT_EQ(value,"(6 | (3 | integer_var))");
}


TEST_F(DataPathOptimizer_Test, BitwiseOr4) {
    VariableOperand * variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise = new Bitwise( new IntegerValue(3) , "|", variableOperand);
    Bitwise * bitwise2 = new Bitwise( new IntegerValue(6) , "&", bitwise);
    Assignment * assignment = new Assignment(variableOperand,bitwise2);

    Path * path = new Path("foo");
    std::vector<Assignment*> assignmentList;
    assignmentList.push_back(assignment);
    path->setDataPathList(assignmentList);

    auto result = DataPathOptimizer::optimize(path,module);
    auto value = PrintStmt::toString(path->getDataPathList().front()->getRhs());
    ASSERT_EQ(value,"(6 & (3 | integer_var))");


}

TEST_F(DataPathOptimizer_Test, BitwiseOr5) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise *bitwise = new Bitwise(new IntegerValue(4), "&", variableOperand);
    Bitwise *bitwise2 = new Bitwise(new IntegerValue(2), "|", bitwise);
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise2);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "(2 | (4 & integer_var))");
}

TEST_F(DataPathOptimizer_Test, BitShift) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise *bitwise = new Bitwise(new IntegerValue(4), "<<",new IntegerValue(2));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "16");
}

TEST_F(DataPathOptimizer_Test, BitShift2) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise *bitwise = new Bitwise(new IntegerValue(5), "<<",variableOperand);
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "(5 << integer_var)");
}

TEST_F(DataPathOptimizer_Test, BitShift3) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise *bitwise = new Bitwise(variableOperand, "<<",new IntegerValue(5));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "(integer_var << 5)");
}
TEST_F(DataPathOptimizer_Test, BitShift4) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise *bitwise = new Bitwise(new IntegerValue(4), "&", variableOperand);
    Bitwise *bitwise2 = new Bitwise(new IntegerValue(128), "|", bitwise);
    Bitwise *bitwise3 = new Bitwise(bitwise2, "<<",new IntegerValue(4));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise2);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "(128 | (4 & integer_var))");
}

TEST_F(DataPathOptimizer_Test, BitShift5) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise *bitwise = new Bitwise(new IntegerValue(4), "&", variableOperand);
    Bitwise *bitwise2 = new Bitwise(new IntegerValue(128), "|", bitwise);
    Bitwise *bitwise3 = new Bitwise(bitwise2, "<<",new IntegerValue(4));
    Bitwise *bitwise4 = new Bitwise(bitwise3, "<<",new IntegerValue(3));
    Bitwise *bitwise5 = new Bitwise(bitwise4, "<<",new IntegerValue(1));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise5);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "((((128 | (4 & integer_var)) << 4) << 3) << 1)");
}



TEST_F(DataPathOptimizer_Test, BitShiftRight) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Bitwise *bitwise = new Bitwise(new UnsignedValue(4), ">>",new UnsignedValue(2));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "1");

}TEST_F(DataPathOptimizer_Test, BitShiftRight2) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Bitwise *bitwise = new Bitwise(new UnsignedValue(2), ">>",new UnsignedValue(4));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "0");
}
TEST_F(DataPathOptimizer_Test, BitShiftRight3) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Bitwise *bitwise = new Bitwise(new UnsignedValue(4), "&", variableOperand);
    Bitwise *bitwise2 = new Bitwise(new UnsignedValue(128), "|", bitwise);
    Bitwise *bitwise3 = new Bitwise(bitwise2, ">>",new UnsignedValue(4));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise3);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "8");
}

TEST_F(DataPathOptimizer_Test, BitShiftRight4) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Bitwise *bitwise = new Bitwise(new UnsignedValue(4), "<<", new UnsignedValue(1));
    Bitwise *bitwise3 = new Bitwise(bitwise, ">>",new UnsignedValue(1));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise3);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "4");
}

TEST_F(DataPathOptimizer_Test, BitShiftRight5) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Bitwise *bitwise = new Bitwise(variableOperand, "<<", new UnsignedValue(1));
    Bitwise *bitwise3 = new Bitwise(bitwise, ">>",new UnsignedValue(1));
    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise3);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "((unsigned_var << 1) >> 1)");
}

TEST_F(DataPathOptimizer_Test, BitShiftRight6) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Bitwise *bitwise = new Bitwise(variableOperand, ">>", new UnsignedValue(3));
    Bitwise *bitwise3 = new Bitwise(bitwise, "&",new UnsignedValue(1));

    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    DataPathOptimizer::optimize(path2, module);
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2, "(unsigned_var >> 3)");
}

TEST_F(DataPathOptimizer_Test, UnsignedPortAssignment) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("compound_var")->getSubVar("unsigned_val"));
    PortOperand portOperand(module->getPort("input_compound"));
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(portOperand.getPort()->getDataSignal()->getSubSig("unsigned_val"));


    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,dataSignalOperand);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    ASSERT_NO_THROW(DataPathOptimizer::optimize(path2, module));

    auto result = path2->getDataPathList().front();
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(result->getRhs()->getDataType(),result->getLhs()->getDataType());

}


TEST_F(DataPathOptimizer_Test, RecursiveBitwise) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input_unsigned")->getDataSignal());
    Arithmetic * arithmetic = new Arithmetic(dataSignalOperand,"%",new UnsignedValue(2));
    Bitwise * bitwise = new Bitwise(arithmetic,"&",new UnsignedValue(2));
    Bitwise * bitwise2 = new Bitwise(bitwise,"|",new UnsignedValue(2));
    Bitwise * bitwise3 = new Bitwise(bitwise2,">>",new UnsignedValue(2));

    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise3);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    ASSERT_NO_THROW(DataPathOptimizer::optimize(path2, module));

    auto result = path2->getDataPathList().front();
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2,"0");
    ASSERT_EQ(result->getRhs()->getDataType(),result->getLhs()->getDataType());
}


TEST_F(DataPathOptimizer_Test, ShiftRightArithmetic) {
VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
Bitwise * bitwise3 = new Bitwise(variableOperand,">>",new IntegerValue(4));

Path *path2 = new Path("foo2");
std::vector<Assignment *> assignmentList2;
Assignment *assignment2 = new Assignment(variableOperand,bitwise3);
assignmentList2.push_back(assignment2);
path2->setDataPathList(assignmentList2);

ASSERT_NO_THROW(DataPathOptimizer::optimize(path2, module));

auto result = path2->getDataPathList().front();
auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
ASSERT_EQ(value2,"(integer_var >> 4)");
ASSERT_EQ(result->getRhs()->getDataType(),result->getLhs()->getDataType());
}


TEST_F(DataPathOptimizer_Test, ShiftRightArithmetic2) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise3 = new Bitwise(new IntegerValue(-4),">>",new IntegerValue(1));

    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise3);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    ASSERT_NO_THROW(DataPathOptimizer::optimize(path2, module));

    auto result = path2->getDataPathList().front();
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2,"-2");
    ASSERT_EQ(result->getRhs()->getDataType(),result->getLhs()->getDataType());
}


TEST_F(DataPathOptimizer_Test, Xor) {
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("integer_var"));
    Bitwise * bitwise3 = new Bitwise(new IntegerValue(2),"^",new IntegerValue(1));

    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment2 = new Assignment(variableOperand,bitwise3);
    assignmentList2.push_back(assignment2);
    path2->setDataPathList(assignmentList2);

    ASSERT_NO_THROW(DataPathOptimizer::optimize(path2, module));

    auto result = path2->getDataPathList().front();
    auto value2 = PrintStmt::toString(path2->getDataPathList().front()->getRhs());
    ASSERT_EQ(value2,"3");
    ASSERT_EQ(result->getRhs()->getDataType(),result->getLhs()->getDataType());
}


TEST_F(DataPathOptimizer_Test, SignedAfterUnsigned) {
    //Fore reset of unsigned_flag after each optimization
    std::vector<Assignment *> assignmentList2;
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));
    Bitwise *bitwise = new Bitwise(variableOperand, "<<", new UnsignedValue(1));
    Bitwise *bitwise3 = new Bitwise(bitwise, ">>",new UnsignedValue(1));
    Path *path2 = new Path("foo2");
    Assignment *assignment2 = new Assignment(variableOperand,bitwise3);
    assignmentList2.push_back(assignment2);

    VariableOperand *variableOperand2 = new VariableOperand(module->getVariable("compound_var")->getSubVar("int_val"));
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input_compound")->getDataSignal()->getSubSig("int_val"));
    UnaryExpr * mul = new UnaryExpr("-",dataSignalOperand);
    Arithmetic * arithmetic = new Arithmetic(mul,"+",variableOperand2);

    Assignment *assignment3 = new Assignment(variableOperand2,arithmetic);
    assignmentList2.push_back(assignment3);
    path2->setDataPathList(assignmentList2);

    ASSERT_NO_THROW(DataPathOptimizer::optimize(path2, module));

    auto result = path2->getDataPathList().front();
    auto value2 = PrintStmt::toString(path2->getDataPathList().back()->getRhs());
    ASSERT_EQ(value2,"(-(input_compound_sig[int_val]) + compound_var.int_val)");
    ASSERT_EQ(result->getRhs()->getDataType(),result->getLhs()->getDataType());
}


TEST_F(DataPathOptimizer_Test, UnsignedMinusUnsigned) {
    //Fore reset of unsigned_flag after each optimization
    VariableOperand *variableOperand = new VariableOperand(module->getVariable("unsigned_var"));

    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input_unsigned")->getDataSignal());
    DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(module->getPort("input_unsigned2")->getDataSignal());
    Arithmetic * arithmetic = new Arithmetic(dataSignalOperand,"-",dataSignalOperand2);

    Path *path2 = new Path("foo2");
    std::vector<Assignment *> assignmentList2;
    Assignment *assignment3 = new Assignment(variableOperand,arithmetic);
    assignmentList2.push_back(assignment3);
    path2->setDataPathList(assignmentList2);

    ASSERT_NO_THROW(DataPathOptimizer::optimize(path2, module));

    auto result = path2->getDataPathList().front();
    auto value2 = PrintStmt::toString(path2->getDataPathList().back()->getRhs());
    std::cout << value2 << std::endl;
    ASSERT_EQ(value2,"(input_unsigned_sig + (4294967295 * input_unsigned2_sig))");
    ASSERT_EQ(result->getRhs()->getDataType(),result->getLhs()->getDataType());
}

#endif
