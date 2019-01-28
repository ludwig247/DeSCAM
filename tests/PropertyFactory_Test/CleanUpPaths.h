//
// Created by tobias on 31.01.18.
//

#ifndef PROJECT_CLEANUPPATHSTEST_H
#define PROJECT_CLEANUPPATHSTEST_H


#include <gtest/gtest.h>
#include <DataTypes.h>
#include <Module.h>
#include <Stmts/UnsignedValue.h>
#include <Stmts/IntegerValue.h>
#include <Stmts/VariableOperand.h>
#include <Stmts/Arithmetic.h>
#include <PrintStmt.h>
#include <CleanUpPaths.h>

using namespace SCAM;
class CleanUpPaths_Test: public ::testing::Test{
public:
    CleanUpPaths_Test():module(new Module("TestModule")){
    }

    virtual void SetUp() {
        DataType * compound= new DataType("compound");
        compound->addSubVar("int_val",DataTypes::getDataType("int"));
        compound->addSubVar("unsigned_val",DataTypes::getDataType("unsigned"));
        DataTypes::addDataType(compound);
        //Ports
        Interface * anInterface = new Interface("blocking","out");
        Port * port = new Port("output",anInterface,DataTypes::getDataType("int"));
        module->addPort(port);
        Interface * anInterface2 = new Interface("blocking","in");
        Port * port2 = new Port("input_compound",anInterface2,DataTypes::getDataType("compound"));
        module->addPort(port2);
        module->addVariable(new Variable("compound_var",SCAM::DataTypes::getDataType("compound"),SCAM::DataTypes::getDataType("compound")->getDefaultVal()));
        module->addVariable(new Variable("unsigned_var",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100)));
        module->addVariable(new Variable("unsigned_var2",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100)));
        module->addVariable(new Variable("integer_var",SCAM::DataTypes::getDataType("int"),new IntegerValue(0)));
    }

    virtual void TearDown() {}
    SCAM::Module * module;

};


TEST_F(CleanUpPaths_Test,BasicTest){

//Assignment: unsigned_var = -1 + 10 = 9;
VariableOperand * variableOperand = new VariableOperand(module->getVariable("unsigned_var"));

Arithmetic * arithmetic = new Arithmetic(variableOperand,"%",new UnsignedValue(2));
Relational * relational = new Relational(arithmetic,"==",new UnsignedValue(0));
Path * path = new Path("foo");
    path->addCondition(relational);
    ASSERT_FALSE(CleanUpPaths::isPathUnreachable(path));



}

#endif //PROJECT_CLEANUPPATHS_H
