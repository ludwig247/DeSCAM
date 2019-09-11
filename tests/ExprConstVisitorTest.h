//
// Created by tobias on 11.04.17.
//

#ifndef PROJECT_EXPRCONSTVISITORTEST_H
#define PROJECT_EXPRCONSTVISITORTEST_H


#include <gtest/gtest.h>
#include <Stmts/Expr.h>
#include <Stmts/IntegerValue.h>
#include <ExprVisitor.h>


TEST(ExprConstVisitor, BoolValue) {
    SCAM::BoolValue * boolValue = new SCAM::BoolValue(true);
    ASSERT_TRUE(SCAM::ExprVisitor::isConstVal(boolValue));

    boolValue = new SCAM::BoolValue(false);
    ASSERT_TRUE(SCAM::ExprVisitor::isConstVal(boolValue));
}
TEST(ExprConstVisitor, IntegerValue) {
    SCAM::IntegerValue * integerValue = new SCAM::IntegerValue(1337);
    ASSERT_TRUE(SCAM::ExprVisitor::isConstVal(integerValue));
}
TEST(ExprConstVisitor, EnumValue) {
    SCAM::DataType * type = new SCAM::DataType("enumType");
    type->addEnumValue("test");
    SCAM::EnumValue * enumVal = new SCAM::EnumValue("test", type);
    ASSERT_TRUE(SCAM::ExprVisitor::isConstVal(enumVal));
}

TEST(ExprConstVisitor, ArithmeticVariable) {
    SCAM::IntegerValue * integerValue1 = new SCAM::IntegerValue(1);
    SCAM::Variable * var = new SCAM::Variable("foobar",SCAM::DataTypes::getDataType("int"),integerValue1);
    SCAM::VariableOperand * varOp = new SCAM::VariableOperand(var);
    ASSERT_FALSE(SCAM::ExprVisitor::isConstVal(varOp));
    std::set<SCAM::Variable*> usedVar;
    usedVar.insert(var);
    ASSERT_EQ(usedVar,SCAM::ExprVisitor::getUsedVariables(varOp));

}

TEST(ExprConstVisitor, ArithmeticInteger) {
    SCAM::IntegerValue * integerValue1 = new SCAM::IntegerValue(1);
    SCAM::IntegerValue * integerValue2 = new SCAM::IntegerValue(1);
    SCAM::Arithmetic * arithmetic = new SCAM::Arithmetic(integerValue1,"+",integerValue2);

    ASSERT_TRUE(SCAM::ExprVisitor::isConstVal(arithmetic));
}

TEST(ExprConstVisitor, ArithmeticVariable1) {
    SCAM::IntegerValue * integerValue1 = new SCAM::IntegerValue(1);
    SCAM::Variable * var = new SCAM::Variable("foobar",SCAM::DataTypes::getDataType("int"),integerValue1);
    SCAM::Arithmetic * arithmetic = new SCAM::Arithmetic(integerValue1,"+",new SCAM::VariableOperand(var));


    ASSERT_FALSE(SCAM::ExprVisitor::isConstVal(arithmetic));
    std::set<SCAM::Variable*> usedVar;
    usedVar.insert(var);
    ASSERT_EQ(usedVar,SCAM::ExprVisitor::getUsedVariables(arithmetic));
}

TEST(ExprConstVisitor, ArithmeticVariable2) {
    SCAM::IntegerValue * integerValue1 = new SCAM::IntegerValue(1);
    SCAM::Variable * var = new SCAM::Variable("foobar",SCAM::DataTypes::getDataType("int"),integerValue1);
    SCAM::Arithmetic * arithmetic = new SCAM::Arithmetic(new SCAM::VariableOperand(var),"+",integerValue1);


    ASSERT_FALSE(SCAM::ExprVisitor::isConstVal(arithmetic));
    std::set<SCAM::Variable*> usedVar;
    usedVar.insert(var);
    ASSERT_EQ(usedVar,SCAM::ExprVisitor::getUsedVariables(arithmetic));

}

TEST(ExprConstVisitor, ArithmeticVariable3) {
    SCAM::IntegerValue * integerValue1 = new SCAM::IntegerValue(1);
    SCAM::Variable * var1 = new SCAM::Variable("foo",SCAM::DataTypes::getDataType("int"),integerValue1);
    SCAM::Variable * var2 = new SCAM::Variable("bar",SCAM::DataTypes::getDataType("int"),integerValue1);
    SCAM::Arithmetic * arithmetic1 = new SCAM::Arithmetic(new SCAM::VariableOperand(var1),"+",integerValue1);
    SCAM::Arithmetic * arithmetic2 = new SCAM::Arithmetic(arithmetic1,"+",new SCAM::VariableOperand(var2));


    ASSERT_FALSE(SCAM::ExprVisitor::isConstVal(arithmetic2));
    std::set<SCAM::Variable*> usedVar;
    usedVar.insert(var1);
    usedVar.insert(var2);
    ASSERT_EQ(usedVar,SCAM::ExprVisitor::getUsedVariables(arithmetic2));
}


TEST(ExprConstVisitor, ArithmeticVariable4) {
    SCAM::IntegerValue * integerValue1 = new SCAM::IntegerValue(1);
    SCAM::Variable * var1 = new SCAM::Variable("foo",SCAM::DataTypes::getDataType("int"),integerValue1);
    SCAM::Arithmetic * arithmetic1 = new SCAM::Arithmetic(new SCAM::VariableOperand(var1),"+",integerValue1);
    SCAM::Arithmetic * arithmetic2 = new SCAM::Arithmetic(arithmetic1,"+",new SCAM::VariableOperand(var1));
;
    ASSERT_FALSE(SCAM::ExprVisitor::isConstVal(arithmetic2));
    std::set<SCAM::Variable*> usedVar;
    usedVar.insert(var1);
    ASSERT_EQ(usedVar,SCAM::ExprVisitor::getUsedVariables(arithmetic2));
}



#endif //PROJECT_EXPRCONSTVISITORTEST_H
