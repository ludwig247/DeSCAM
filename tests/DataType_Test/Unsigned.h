//
// Created by tobias on 17.01.18.
//

#ifndef PROJECT_UNSIGNED_H
#define PROJECT_UNSIGNED_H
#include <gtest/gtest.h>
#include <DataType.h>
#include <DataTypes.h>

class Unsigned : public ::testing::Test {
protected:
    Unsigned():
            dataType("unsigned"),
            dataTypeMap(SCAM::DataTypes::getDataTypeMap()){
    }

    virtual void SetUp() {

    }

     virtual void TearDown() {}

    SCAM::DataType dataType;
    std::map<std::string, SCAM::DataType *> dataTypeMap;
};


TEST_F(Unsigned,isNamedUnsigned){
    ASSERT_EQ(dataType.getName(),"unsigned");
}

TEST_F(Unsigned,isUnsigned){
    ASSERT_TRUE(dataType.isUnsigned());
}
TEST_F(Unsigned,isBuiltIn){
    ASSERT_TRUE(dataType.isBuiltInType());
}

TEST_F(Unsigned,isNotAnythingElse){
    ASSERT_FALSE(dataType.isCompoundType());
    ASSERT_FALSE(dataType.isEnumType());
}

TEST_F(Unsigned,isDataType){
        ASSERT_TRUE(SCAM::DataTypes::isDataType("unsigned"));
}
TEST_F(Unsigned,getUnsignedDataType){
    ASSERT_NO_THROW(SCAM::DataTypes::getDataType("unsigned"));
}

#endif //PROJECT_UNSIGNED_H
