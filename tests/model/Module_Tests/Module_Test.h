//
// Created by ludwig on 19.01.18.
//

#ifndef PROJECT_MODULE_TEST_H
#define PROJECT_MODULE_TEST_H


#include <gtest/gtest.h>
#include <Module.h>


using namespace DESCAM;

class ModuleTest : public ::testing::Test {
protected:
    ModuleTest():module("TestModule"){
    }

    virtual void SetUp() {
        variable_ = new Variable("unsigned_var",DESCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100));
        std::map<std::string, DESCAM::Variable*> var_map;
        var_map.insert(std::make_pair("unsigned_var", variable_));
        module.addVariables(var_map);
    }

    virtual void TearDown() {
      delete variable_;
    }

    std::map<std::string, DESCAM::Variable*> var_map;
    DESCAM::Variable *variable_;
    DESCAM::Module module;
};

TEST_F(ModuleTest,CreateUnsignedVar){
    ASSERT_NO_THROW(DESCAM::Variable variable("unsiged_Var",DESCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100)));
}

TEST_F(ModuleTest,AddUnsignedVar){
    ASSERT_NO_THROW(module.addVariables(var_map));
}

TEST_F(ModuleTest,GetUnsignedVar){
    ASSERT_NO_THROW(module.getVariable("unsigned_var"));
}
#endif //PROJECT_MODULE_TEST_H
