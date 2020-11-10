//
// Created by ludwig on 19.01.18.
//

#ifndef PROJECT_INITISECTIONTEST_H
#define PROJECT_INITISECTIONTEST_H

#include <gtest/gtest.h>
#include "gmock/gmock.h"
#include <Module.h>
#include "Model.h"

#include <Stmts/UnsignedValue.h>

using namespace DESCAM;

class TestModule: public ::testing::Test{
public:
    TestModule():module("TestModule"){
    }

    virtual void SetUp() {
        //DESCAM::Variable variable("unsigned_var",DESCAM::DataTypes::getDataType("unsigned"),new UnsignedValue(100));
        //module.addVariable(&variable);
    }

    virtual void TearDown() {}
    DESCAM::Module module;
};

TEST_F(TestModule,CreateInitSection){
    //MockModule mockModule;


}


#endif //PROJECT_INITISECTIONTEST_H
