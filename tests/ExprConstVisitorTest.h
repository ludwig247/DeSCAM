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
    DESCAM::BoolValue * boolValue = new DESCAM::BoolValue(true);
    ASSERT_TRUE(DESCAM::ExprVisitor::isConstVal(boolValue));

    boolValue = new DESCAM::BoolValue(false);
    ASSERT_TRUE(DESCAM::ExprVisitor::isConstVal(boolValue));
}
TEST(ExprConstVisitor, IntegerValue) {
    DESCAM::IntegerValue * integerValue = new DESCAM::IntegerValue(1337);
    ASSERT_TRUE(DESCAM::ExprVisitor::isConstVal(integerValue));
}
TEST(ExprConstVisitor, EnumValue) {
    DESCAM::DataType * type = new DESCAM::DataType("enumType");
    type->addEnumValue("test");
    DESCAM::EnumValue * enumVal = new DESCAM::EnumValue("test", type);
    ASSERT_TRUE(DESCAM::ExprVisitor::isConstVal(enumVal));
}

TEST(ExprConstVisitor, ArithmeticVariable) {
    DESCAM::IntegerValue * integerValue1 = new DESCAM::IntegerValue(1);
    DESCAM::Variable * var = new DESCAM::Variable("foobar",DESCAM::DataTypes::getDataType("int"),integerValue1);
    DESCAM::VariableOperand * varOp = new DESCAM::VariableOperand(var);
    ASSERT_FALSE(DESCAM::ExprVisitor::isConstVal(varOp));
    std::set<DESCAM::Variable*> usedVar;
    usedVar.insert(var);
    ASSERT_EQ(usedVar,DESCAM::ExprVisitor::getUsedVariables(varOp));

}

TEST(ExprConstVisitor, ArithmeticInteger) {
    DESCAM::IntegerValue * integerValue1 = new DESCAM::IntegerValue(1);
    DESCAM::IntegerValue * integerValue2 = new DESCAM::IntegerValue(1);
    DESCAM::Arithmetic * arithmetic = new DESCAM::Arithmetic(integerValue1,"+",integerValue2);

    ASSERT_TRUE(DESCAM::ExprVisitor::isConstVal(arithmetic));
}

TEST(ExprConstVisitor, ArithmeticVariable1) {
    DESCAM::IntegerValue * integerValue1 = new DESCAM::IntegerValue(1);
    DESCAM::Variable * var = new DESCAM::Variable("foobar",DESCAM::DataTypes::getDataType("int"),integerValue1);
    DESCAM::Arithmetic * arithmetic = new DESCAM::Arithmetic(integerValue1,"+",new DESCAM::VariableOperand(var));


    ASSERT_FALSE(DESCAM::ExprVisitor::isConstVal(arithmetic));
    std::set<DESCAM::Variable*> usedVar;
    usedVar.insert(var);
    ASSERT_EQ(usedVar,DESCAM::ExprVisitor::getUsedVariables(arithmetic));
}

TEST(ExprConstVisitor, ArithmeticVariable2) {
    DESCAM::IntegerValue * integerValue1 = new DESCAM::IntegerValue(1);
    DESCAM::Variable * var = new DESCAM::Variable("foobar",DESCAM::DataTypes::getDataType("int"),integerValue1);
    DESCAM::Arithmetic * arithmetic = new DESCAM::Arithmetic(new DESCAM::VariableOperand(var),"+",integerValue1);


    ASSERT_FALSE(DESCAM::ExprVisitor::isConstVal(arithmetic));
    std::set<DESCAM::Variable*> usedVar;
    usedVar.insert(var);
    ASSERT_EQ(usedVar,DESCAM::ExprVisitor::getUsedVariables(arithmetic));

}

TEST(ExprConstVisitor, ArithmeticVariable3) {
    DESCAM::IntegerValue * integerValue1 = new DESCAM::IntegerValue(1);
    DESCAM::Variable * var1 = new DESCAM::Variable("foo",DESCAM::DataTypes::getDataType("int"),integerValue1);
    DESCAM::Variable * var2 = new DESCAM::Variable("bar",DESCAM::DataTypes::getDataType("int"),integerValue1);
    DESCAM::Arithmetic * arithmetic1 = new DESCAM::Arithmetic(new DESCAM::VariableOperand(var1),"+",integerValue1);
    DESCAM::Arithmetic * arithmetic2 = new DESCAM::Arithmetic(arithmetic1,"+",new DESCAM::VariableOperand(var2));


    ASSERT_FALSE(DESCAM::ExprVisitor::isConstVal(arithmetic2));
    std::set<DESCAM::Variable*> usedVar;
    usedVar.insert(var1);
    usedVar.insert(var2);
    ASSERT_EQ(usedVar,DESCAM::ExprVisitor::getUsedVariables(arithmetic2));
}


TEST(ExprConstVisitor, ArithmeticVariable4) {
    DESCAM::IntegerValue * integerValue1 = new DESCAM::IntegerValue(1);
    DESCAM::Variable * var1 = new DESCAM::Variable("foo",DESCAM::DataTypes::getDataType("int"),integerValue1);
    DESCAM::Arithmetic * arithmetic1 = new DESCAM::Arithmetic(new DESCAM::VariableOperand(var1),"+",integerValue1);
    DESCAM::Arithmetic * arithmetic2 = new DESCAM::Arithmetic(arithmetic1,"+",new DESCAM::VariableOperand(var1));
;
    ASSERT_FALSE(DESCAM::ExprVisitor::isConstVal(arithmetic2));
    std::set<DESCAM::Variable*> usedVar;
    usedVar.insert(var1);
    ASSERT_EQ(usedVar,DESCAM::ExprVisitor::getUsedVariables(arithmetic2));
}



#endif //PROJECT_EXPRCONSTVISITORTEST_H
