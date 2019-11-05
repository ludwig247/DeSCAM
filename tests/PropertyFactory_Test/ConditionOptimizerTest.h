//
// Created by tobias on 24.01.18.
//

#ifndef PROJECT_ConditionOptinizerTest_H
#define PROJECT_ConditionOptinizerTest_H


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
#include <toPPA/ConditionOptimizer.h>

using namespace SCAM;
class ConditionOptimizer_Test: public ::testing::Test{
public:
    ConditionOptimizer_Test():module(new Module("TestModule")){
    }

    virtual void SetUp() {
        DataType * compound= new DataType("compound");
        compound->addSubVar("int_val",DataTypes::getDataType("int"));
        compound->addSubVar("unsigned_val",DataTypes::getDataType("unsigned"));
        DataTypes::addDataType(compound);
        //Ports
        Interface * anInterface = new Interface("blocking","out");
        Interface * inInterface = new Interface("blocking","in");

        module->addPort(new Port("output",anInterface,DataTypes::getDataType("int")));
        module->addPort(new Port("input_compound",inInterface,DataTypes::getDataType("compound")));
        module->addPort(new Port("input",inInterface,DataTypes::getDataType("int")));
        module->addPort(new Port("input_unsigned",inInterface,DataTypes::getDataType("unsigned")));

        module->addVariable(new Variable("compound_var",SCAM::DataTypes::getDataType("compound"),SCAM::DataTypes::getDataType("compound")->getDefaultVal()));
        module->addVariable(new Variable("unsigned_var",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100)));
        module->addVariable(new Variable("unsigned_var2",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100)));
        module->addVariable(new Variable("integer_var",SCAM::DataTypes::getDataType("int"),new IntegerValue(0)));
    }

    virtual void TearDown() {}
    SCAM::Module * module;

};


TEST_F(ConditionOptimizer_Test,BitwiseAndArithmetic){

    //Assignment: unsigned_var = -1 + 10 = 9;
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input")->getDataSignal());
    Arithmetic * arithmetic = new Arithmetic(dataSignalOperand,"%",new IntegerValue(2));
    Relational * relational = new Relational(arithmetic,"==",new IntegerValue(0));
    UnaryExpr * unaryExpr = new UnaryExpr("not",relational);

    Path * path = new Path("foo");

    path->addCondition(unaryExpr);
    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),PrintStmt::toString(unaryExpr));


}

TEST_F(ConditionOptimizer_Test,BitwiseAndArithmeticUnsigned){

    //Assignment: unsigned_var = -1 + 10 = 9;
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input_unsigned")->getDataSignal());
    Arithmetic * arithmetic = new Arithmetic(dataSignalOperand,"%",new UnsignedValue(2));
    Relational * relational = new Relational(arithmetic,"==",new UnsignedValue(0));
    UnaryExpr * unaryExpr = new UnaryExpr("not",relational);

    Path * path = new Path("foo");

    path->addCondition(unaryExpr);

    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),PrintStmt::toString(unaryExpr));

}

TEST_F(ConditionOptimizer_Test,SignedAndUnsignedCondition){

    //Assignment: unsigned_var = -1 + 10 = 9;
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input_unsigned")->getDataSignal());
    Relational * relational = new Relational(dataSignalOperand,"<=",new UnsignedValue(0));

    DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(module->getPort("input")->getDataSignal());
    Relational * relational2 = new Relational(dataSignalOperand2,">",new IntegerValue(10));

    Logical * logical = new Logical(relational,"and",relational2);

    Path * path = new Path("foo");

    path->addCondition(logical);

    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),"(input_unsigned.sig == 0)");
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().back()),"not((input.sig <= 10))");

}

TEST_F(ConditionOptimizer_Test,SignedAndUnsignedCondition2){

    //Assignment: unsigned_var = -1 + 10 = 9;
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input_unsigned")->getDataSignal());
    Relational * relational = new Relational(dataSignalOperand,"<=",new UnsignedValue(0));

    DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(module->getPort("input")->getDataSignal());
    Relational * relational2 = new Relational(dataSignalOperand2,">",new IntegerValue(10));

    Logical * logical = new Logical(relational2,"and",relational);

    Path * path = new Path("foo");

    path->addCondition(logical);

    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().back()),"(input_unsigned.sig == 0)");
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),"not((input.sig <= 10))");

}

TEST_F(ConditionOptimizer_Test,SignedAndUnsignedCondition3){

    //Assignment: unsigned_var = -1 + 10 = 9;
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input_unsigned")->getDataSignal());
    Relational * relational = new Relational(dataSignalOperand,">",new UnsignedValue(0));

    DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(module->getPort("input")->getDataSignal());
    Relational * relational2 = new Relational(dataSignalOperand2,">",new IntegerValue(10));

    Logical * logical = new Logical(relational,"and",relational2);

    Path * path = new Path("foo");

    path->addCondition(logical);

    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),"not((input_unsigned.sig == 0))");
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().back()),"not((input.sig <= 10))");

}


TEST_F(ConditionOptimizer_Test,SignedAndUnsignedCondition4){

    //Assignment: unsigned_var = -1 + 10 = 9;
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(module->getPort("input_unsigned")->getDataSignal());
    Relational * relational = new Relational(dataSignalOperand,">",new UnsignedValue(0));

    DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(module->getPort("input")->getDataSignal());
    Relational * relational2 = new Relational(dataSignalOperand2,"<",new IntegerValue(10));

    Logical * logical = new Logical(relational,"and",relational2);

    Path * path = new Path("foo");

    path->addCondition(logical);

    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),"not((input_unsigned.sig == 0))");
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().back()),"not((10 <= input.sig))");

}


TEST_F(ConditionOptimizer_Test,SignedAndUnsignedCondition5){

    //Assignment: unsigned_var = -1 + 10 = 9;
    VariableOperand * varOp = new VariableOperand(module->getVariable("unsigned_var"));
    Relational * relational = new Relational(varOp,">",new UnsignedValue(10));
    UnaryExpr * unaryExpr = new UnaryExpr("not",relational);

    DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(module->getPort("input")->getDataSignal());
    Relational * relational2 = new Relational(dataSignalOperand2,">",new IntegerValue(10));

    //Logical * logical = new Logical(relational2,"and",unaryExpr);

    Path * path = new Path("foo");

    path->addCondition(unaryExpr);
    path->addCondition(relational2);


    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),"not((unsigned_var > 10))");
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().back()),"(input.sig > 10)");

}


TEST_F(ConditionOptimizer_Test,SignedAndUnsignedCondition6){

    //Assignment: unsigned_var = -1 + 10 = 9;
    VariableOperand * varOp = new VariableOperand(module->getVariable("unsigned_var"));
    Relational * relational = new Relational(varOp,">",new UnsignedValue(10));
    UnaryExpr * unaryExpr = new UnaryExpr("not",relational);

    DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(module->getPort("input")->getDataSignal());
    Relational * relational2 = new Relational(dataSignalOperand2,">",new IntegerValue(10));

    Logical * logical = new Logical(relational2,"and",relational);

    Path * path = new Path("foo");
    std::cout << PrintStmt::toString(logical) << std::endl;
    path->addCondition(logical);
    //path->addCondition(relational2);


    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),"((input.sig > 10) and (unsigned_var > 10))");

}


TEST_F(ConditionOptimizer_Test,SignedAndUnsignedCondition7){

    //Assignment: unsigned_var = -1 + 10 = 9;
    VariableOperand * varOp = new VariableOperand(module->getVariable("unsigned_var"));
    Relational * relational = new Relational(varOp,">",new UnsignedValue(10));
    UnaryExpr * unaryExpr = new UnaryExpr("not",relational);

    DataSignalOperand * dataSignalOperand2 = new DataSignalOperand(module->getPort("input")->getDataSignal());
    Relational * relational2 = new Relational(dataSignalOperand2,">",new IntegerValue(10));

    Logical * logical = new Logical(relational,"and",relational2);

    Path * path = new Path("foo");
    std::cout << PrintStmt::toString(logical) << std::endl;
    path->addCondition(logical);
    //path->addCondition(relational2);


    auto result = ConditionOptimizer::optimize(path,module);
    ASSERT_EQ(PrintStmt::toString(path->getConditionList().front()),"((unsigned_var > 10) and (input.sig > 10))");

}

#endif
