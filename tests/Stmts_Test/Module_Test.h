//
// Created by ludwig on 19.01.18.
//

#ifndef PROJECT_MODULE_TEST_H
#define PROJECT_MODULE_TEST_H


#include <gtest/gtest.h>
#include <Module.h>
#include <Stmts/UnsignedValue.h>

using namespace SCAM;

class ModuleTest : public ::testing::Test {
protected:
    ModuleTest():module("TestModule"){
    }

    virtual void SetUp() {
        SCAM::Variable variable("unsigned_var",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100));
        module.addVariable(&variable);
    }

    virtual void TearDown() {}
    SCAM::Module module;
};

TEST_F(ModuleTest,CreateUnsignedVar){
    ASSERT_NO_THROW(SCAM::Variable variable("unsiged_Var",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100)));
}

TEST_F(ModuleTest,AddUnsignedVar){
    ASSERT_NO_THROW(module.addVariable(new SCAM::Variable("unsiged_Var",SCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100))));
}

TEST_F(ModuleTest,GetUnsignedVar){
    ASSERT_NO_THROW(module.getVariable("unsigned_var"));
}
#endif //PROJECT_MODULE_TEST_H
