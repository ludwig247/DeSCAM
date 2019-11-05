//
// Created by ludwig on 19.01.18.
//

#ifndef PROJECT_VARIABLE_TEST_H

#include <gtest/gtest.h>

#include <Stmts/UnsignedValue.h>
#include <Variable.h>

using namespace SCAM;


class VariableTest : public ::testing::Test {
protected:
    VariableTest():
            unsigned_var(SCAM::Variable("unsigned_var",DataTypes::getDataType("unsigned"),new UnsignedValue(100))){
    }
    virtual void SetUp() {

    }

    virtual void TearDown() {}
    SCAM::Variable unsigned_var;
};

TEST_F(VariableTest,createVar){
    ASSERT_NO_THROW(SCAM::Variable("unsigned_var3",DataTypes::getDataType("unsigned"),new UnsignedValue(102)));
    ASSERT_NO_THROW(SCAM::Variable("unsigned_var2",DataTypes::getDataType("unsigned"),new UnsignedValue(101)));
    ASSERT_NO_THROW(SCAM::Variable("unsigned_var4",DataTypes::getDataType("unsigned")));
}

TEST_F(VariableTest,getValue){

    ASSERT_EQ(unsigned_var.getInitialValue()->getValueAsString(),"100");
}
TEST_F(VariableTest,getType){
    ASSERT_EQ(unsigned_var.getDataType(),DataTypes::getDataType("unsigned"));
}
TEST_F(VariableTest,getName){
    ASSERT_EQ(unsigned_var.getName(),"unsigned_var");
}
#endif //PROJECT_VARIABLE_TEST_H
