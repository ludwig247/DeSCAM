//
// Created by ludwig on 19.01.18.
//

#ifndef PROJECT_EXPRTRANSLATOR_TEST_H
#define PROJECT_EXPRTRANSLATOR_TEST_H


#include <gtest/gtest.h>
#include <Module.h>
#include <Stmts/UnsignedValue.h>
#include <ExprTranslator.h>
#include <PrintStmt.h>
#include "z3++.h"

using namespace DESCAM;

class ExprTranslator_Test : public ::testing::Test {
protected:
    ExprTranslator_Test() :
            module("Test"),
            exprTranslator(&context) {
    }

    virtual void SetUp() {
        Variable *unsigned_var = new Variable("unsigned_var", DataTypes::getDataType("unsigned"));

        module.addVariable(unsigned_var);
        Variable *signed_var = new Variable("signed_var", DataTypes::getDataType("int"));
        module.addVariable(signed_var);
        unsignedVariableOperand = new VariableOperand(unsigned_var);
        unsignedValue = new UnsignedValue(1337);
        unsignedAssignment = new Assignment(unsignedVariableOperand, unsignedValue);
        unsignedAdd = new Arithmetic(unsignedVariableOperand, "+", unsignedValue);
        unsignedDiv = new Arithmetic(unsignedVariableOperand, "/", unsignedValue);

        //Compound Type
        DataType * compound= new DataType("compound");
        compound->addSubVar("int_val",DataTypes::getDataType("int"));
        compound->addSubVar("unsigned_val",DataTypes::getDataType("unsigned"));
        DataTypes::addDataType(compound);

        DataType * arrayT = new DataType("arrayT");
        arrayT->addArray(DataTypes::getDataType("int"),5);
        DataTypes::addDataType(arrayT);

        Variable * arrayVar = new Variable("arrayVar", DataTypes::getDataType("arrayT"));
        module.addVariable(arrayVar);

        //-----------------------
        Interface anInterface("blocking","in");
        port= new Port("foo",&anInterface,compound);
        module.addPort(port);


        // Functions
        auto param = new Parameter("val",DataTypes::getDataType("unsigned"));
        auto func = new Function("return_unsigned",DataTypes::getDataType("unsigned"),{std::make_pair("val",param)});
        module.addFunction(func);

    }


    Module module;

    virtual void TearDown() {}
    Port * port;
    UnsignedValue *unsignedValue;
    DESCAM::Assignment *unsignedAssignment;
    DESCAM::Arithmetic *unsignedAdd;
    DESCAM::Arithmetic *unsignedDiv;
    DESCAM::VariableOperand *unsignedVariableOperand;
    z3::context context;
    ExprTranslator exprTranslator;
};

TEST_F(ExprTranslator_Test, TranslateUnsignedValue) {
    z3::expr expr = exprTranslator.translate(unsignedValue);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, TranslateUnsignedVariable) {
    z3::expr expr = exprTranslator.translate(unsignedVariableOperand);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, TranslateUnsignedAdd) {
    z3::expr expr = exprTranslator.translate(unsignedAdd);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, TranslateUnsignedAdd_Const) {
    z3::expr expr = exprTranslator.translate(new Arithmetic(unsignedValue, "+", unsignedValue));
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, TranslateUnsignedDiv) {
    z3::expr expr = exprTranslator.translate(unsignedDiv);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, TranslateUnsignedAssignment) {
    z3::expr expr = exprTranslator.translate(unsignedAssignment->getRhs());
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, ReminderSimple) {
    Arithmetic * unsignedRem = new Arithmetic(unsignedValue, "%", unsignedValue);
    z3::expr expr = exprTranslator.translate(unsignedRem);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(1337 % 1337)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, ReminderAdd) {
    Arithmetic * test = new Arithmetic(new UnsignedValue(3),"+",new UnsignedValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new UnsignedValue(2));
    z3::expr expr = exprTranslator.translate(unsignedRem);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("((3 + 1) % 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, ReminderAdd2) {
    Arithmetic * unsignedRem = new Arithmetic(unsignedVariableOperand, "%", new UnsignedValue(2));
    z3::expr expr = exprTranslator.translate(unsignedRem);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(unsigned_var % 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, ReminderSub) {
    Arithmetic * test = new Arithmetic(new UnsignedValue(3),"-",new UnsignedValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new UnsignedValue(2));
    z3::expr expr = exprTranslator.translate(unsignedRem);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("((3 - 1) % 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}


TEST_F(ExprTranslator_Test, ReminderMul) {
    Arithmetic * test = new Arithmetic(new UnsignedValue(3),"*",new UnsignedValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new UnsignedValue(2));
    z3::expr expr = exprTranslator.translate(unsignedRem);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("((3 * 1) % 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}

TEST_F(ExprTranslator_Test, ReminderDiv) {
    Arithmetic * test = new Arithmetic(new UnsignedValue(3),"/",new UnsignedValue(1));
    Arithmetic * unsignedRem = new Arithmetic(test, "%", new UnsignedValue(2));
    z3::expr expr = exprTranslator.translate(unsignedRem);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("((3 / 1) % 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}


TEST_F(ExprTranslator_Test, SignedReminderDiv) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("signed_var"));
    Arithmetic * unsignedRem = new Arithmetic(new IntegerValue(-3), "%", variableOperand );
    z3::expr expr = exprTranslator.translate(unsignedRem);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(-3 % signed_var)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("int")) << newExpr->getDataType()->getName() << " != int";
}


TEST_F(ExprTranslator_Test, BitwiseAnd) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("signed_var"));
    Bitwise * bitwise = new Bitwise(new IntegerValue(3), "&", new IntegerValue(0) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(3 & 0)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("int")) << newExpr->getDataType()->getName() << " != int";
}

TEST_F(ExprTranslator_Test, BitwiseOr) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("signed_var"));
    Bitwise * bitwise = new Bitwise(new IntegerValue(3), "|", new IntegerValue(0) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(3 | 0)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("int")) << newExpr->getDataType()->getName() << " != int";
}
TEST_F(ExprTranslator_Test, BitwiseOr2) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Bitwise * bitwise = new Bitwise(new UnsignedValue(3), "|", new UnsignedValue(0) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(3 | 0)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != UnsignedValue";
}


TEST_F(ExprTranslator_Test, ShiftLoglicLef) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Bitwise * bitwise = new Bitwise(new UnsignedValue(4), "<<", new UnsignedValue(2) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(4 << 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != UnsignedValue";
}


TEST_F(ExprTranslator_Test, ShiftLoglicLef2) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, "<<", new UnsignedValue(2) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(unsigned_var << 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != UnsignedValue";
}

TEST_F(ExprTranslator_Test, ShiftLoglicLef3) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Bitwise * bitwise = new Bitwise(new UnsignedValue(4), "<<", variableOperand );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(4 << unsigned_var)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != UnsignedValue";
}

TEST_F(ExprTranslator_Test, ShiftLoglicRight) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Bitwise * bitwise = new Bitwise(new UnsignedValue(2), ">>", new UnsignedValue(4) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(2 >> 4)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != UnsignedValue";
}

TEST_F(ExprTranslator_Test, ShiftLoglicRight2) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, ">>", new UnsignedValue(2) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(unsigned_var >> 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != UnsignedValue";
}

TEST_F(ExprTranslator_Test, ShiftLoglicRight3) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Bitwise * bitwise = new Bitwise(new UnsignedValue(4), ">>", variableOperand );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(4 >> unsigned_var)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != UnsignedValue";
}


TEST_F(ExprTranslator_Test, CompoundPort){

    PortOperand portOperand(port);
    DataSignalOperand * dataSignalOperand = new DataSignalOperand(portOperand.getPort()->getDataSignal()->getSubVar("unsigned_val"));
    //-----------------------
    Variable * var = new Variable("bar",DataTypes::getDataType("compound"),DataTypes::getDataType("compound")->getDefaultVal());
    module.addVariable(var);
    VariableOperand * variableOperand = new VariableOperand(var->getSubVar("unsigned_val"));
    //-----------------------



    z3::expr expr_lhs = exprTranslator.translate(variableOperand);
    z3::expr expr_rhs = exprTranslator.translate(dataSignalOperand);
    auto lhs_new = exprTranslator.translate(expr_lhs,&module);
    auto rhs_new = exprTranslator.translate(expr_rhs,&module);


    ASSERT_EQ(lhs_new->getDataType(),rhs_new->getDataType()) << "LHS("<< lhs_new->getDataType() <<") != RHS("<< rhs_new->getDataType() << ")";
    ASSERT_EQ(lhs_new->getDataType(), DataTypes::getDataType("unsigned")) << lhs_new->getDataType()->getName() << " != UnsignedValue";
    ASSERT_EQ(rhs_new->getDataType(), DataTypes::getDataType("unsigned")) << rhs_new->getDataType()->getName() << " != UnsignedValue";


}

TEST_F(ExprTranslator_Test, ShiftRightArithmetic) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("signed_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, ">>", new IntegerValue(2) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(signed_var >> 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("int")) << newExpr->getDataType()->getName() << " != int";
}


TEST_F(ExprTranslator_Test, Xor) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("signed_var"));
    Bitwise * bitwise = new Bitwise(variableOperand, "^", new IntegerValue(2) );
    z3::expr expr = exprTranslator.translate(bitwise);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(signed_var ^ 2)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("int")) << newExpr->getDataType()->getName() << " != int";
}

TEST_F(ExprTranslator_Test, Multi) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("signed_var"));
    Arithmetic * arithmetic = new Arithmetic(new IntegerValue(-1), "*", variableOperand );
    z3::expr expr = exprTranslator.translate(arithmetic);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(-1 * signed_var)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("int")) << newExpr->getDataType()->getName() << " != int";
}



TEST_F(ExprTranslator_Test, BitwiseWith0) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Bitwise * bitwise = new Bitwise(new UnsignedValue(1),"<<",new UnsignedValue(1));
    Arithmetic * arithmetic = new Arithmetic(bitwise, "-", new UnsignedValue(1) );

    z3::expr expr = exprTranslator.translate(arithmetic);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("((1 << 1) - 1)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("unsigned")) << newExpr->getDataType()->getName() << " != unsigned";
}


TEST_F(ExprTranslator_Test, unsignedGreaterThen) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Relational * relational = new Relational(new UnsignedValue(0),">",variableOperand);
    z3::expr expr = exprTranslator.translate(relational);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(0 > unsigned_var)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("bool")) << newExpr->getDataType()->getName() << " != bool";
}

TEST_F(ExprTranslator_Test, unsignedGreaterEqThen) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Relational * relational = new Relational(new UnsignedValue(0),">=",variableOperand);
    z3::expr expr = exprTranslator.translate(relational);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(0 >= unsigned_var)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("bool")) << newExpr->getDataType()->getName() << " != bool";
}

TEST_F(ExprTranslator_Test, unsignedLessThen) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Relational * relational = new Relational(new UnsignedValue(0),"<",variableOperand);
    z3::expr expr = exprTranslator.translate(relational);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(0 < unsigned_var)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("bool")) << newExpr->getDataType()->getName() << " != bool";
}

TEST_F(ExprTranslator_Test, unsignedLessEqThen) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("unsigned_var"));
    Relational * relational = new Relational(new UnsignedValue(0),"<=",variableOperand);
    z3::expr expr = exprTranslator.translate(relational);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("(0 <= unsigned_var)",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), DataTypes::getDataType("bool")) << newExpr->getDataType()->getName() << " != bool";
}

TEST_F(ExprTranslator_Test, array1) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("arrayVar")->getSubVar("0"));
    z3::expr expr = exprTranslator.translate(variableOperand);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ("arrayVar[0]",PrintStmt::toString(newExpr));
    ASSERT_EQ(newExpr->getDataType(), variableOperand->getDataType()) << newExpr->getDataType()->getName() << " != " << variableOperand->getDataType()->getName();
}

TEST_F(ExprTranslator_Test, array2) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("arrayVar")->getSubVar("0"));
    VariableOperand * variableOperand2 = new VariableOperand(module.getVariable("arrayVar")->getSubVar("0"));
    Relational * relational = new Relational(variableOperand,"<=",variableOperand2);
    z3::expr expr = exprTranslator.translate(relational);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);

    ASSERT_TRUE((*relational) == (*newExpr));
    ASSERT_EQ(newExpr->getDataType(), relational->getDataType()) << newExpr->getDataType()->getName() << " != " << relational->getDataType()->getName();
}

TEST_F(ExprTranslator_Test, array3) {
    VariableOperand * variableOperand = new VariableOperand(module.getVariable("arrayVar")->getSubVar("0"));
    VariableOperand * variableOperand2 = new VariableOperand(module.getVariable("arrayVar")->getSubVar("0"));
    Relational * relational = new Relational(variableOperand,"<=",variableOperand2);
    z3::expr expr = exprTranslator.translate(relational);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);

    ASSERT_TRUE((*relational) == (*newExpr));
    ASSERT_EQ(newExpr->getDataType(), relational->getDataType()) << newExpr->getDataType()->getName() << " != " << relational->getDataType()->getName();
}

TEST_F(ExprTranslator_Test, CompareOperatorTerminal) {

    auto valTrue =  new IntegerValue(2);
    auto valFalse = new IntegerValue(3);

    auto boolTrue = new BoolValue(true);
    auto boolFalse = new BoolValue(false);

    //Terminal true ? x : y -> return x
    auto compare = new Ternary(boolTrue,valTrue, valFalse);
    z3::expr expr = exprTranslator.translate(compare);
    DESCAM::Expr *newExpr = exprTranslator.translate(expr, &module);

    std::cout << *newExpr << std::endl;

    ASSERT_EQ((*valTrue), (*newExpr)) << PrintStmt::toString(valTrue)  << "!=" << PrintStmt::toString(newExpr);


    //Terminal false ? x : y -> return y
    auto compare2 = new Ternary(boolFalse,valTrue, valFalse);
    expr = exprTranslator.translate(compare2);
    newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ((*valFalse), (*newExpr))  <<  PrintStmt::toString(valFalse)  << " != " << PrintStmt::toString(newExpr);

    //Terminal cond ? x : x -> return x
    auto compare3 = new Ternary(new Relational(valTrue,">=", valFalse),valTrue,valTrue);
    expr = exprTranslator.translate(compare3);
    newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ((*valTrue), (*newExpr))  <<  PrintStmt::toString(valFalse)  << " != " << PrintStmt::toString(newExpr);

    //Terminal true || false ? x : y -> return x
    auto compare4 = new Ternary(new Logical(boolTrue,"or", boolFalse),valTrue,valFalse);
    expr = exprTranslator.translate(compare4);
    newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ((*valTrue), (*newExpr))  <<  PrintStmt::toString(valTrue)  << " != " << PrintStmt::toString(newExpr);

}


TEST_F(ExprTranslator_Test, CompareOperatorNonTerminal) {

    auto valTrue =  new IntegerValue(2);
    auto valFalse = new IntegerValue(3);
    auto variableOperand =  new VariableOperand(module.getVariable("signed_var"));

    auto compare3 = new Ternary(new Relational(variableOperand,">=", valFalse),valTrue,valFalse);
    z3::expr expr = exprTranslator.translate(compare3);
    auto newExpr = exprTranslator.translate(expr, &module);

    ASSERT_EQ((*compare3), (*newExpr))  <<  PrintStmt::toString(compare3)  << " != " << PrintStmt::toString(newExpr);

    compare3 = new Ternary(new Relational(valTrue,">=", valFalse),valTrue,valFalse);
    expr = exprTranslator.translate(compare3);
    newExpr = exprTranslator.translate(expr, &module);

    ASSERT_EQ((*valFalse), (*newExpr))  <<  PrintStmt::toString(valFalse)  << " != " << PrintStmt::toString(newExpr);
    ASSERT_TRUE(!((*valTrue) == (*newExpr)))  <<  PrintStmt::toString(valTrue)  << " != " << PrintStmt::toString(newExpr);
    ASSERT_TRUE(!((*compare3) == (*newExpr)))  <<  PrintStmt::toString(compare3)  << " != " << PrintStmt::toString(newExpr);
}



TEST_F(ExprTranslator_Test, CompareOperatorUnsigned) {
    //If a stmt: cond ? val : var is translated and var is an unsigned integer, then this is unknown when the visitor visits val.
    //Now we re-visit in case of different datatypes
    auto valTrue =  new UnsignedValue(2);
    auto variableOperand =  new VariableOperand(module.getVariable("unsigned_var"));

    auto compare3 = new Ternary(new Relational(variableOperand,">=", valTrue),valTrue,variableOperand);
    z3::expr expr = exprTranslator.translate(compare3);
    exprTranslator.reset();
    auto newExpr = exprTranslator.translate(expr, &module);

    ASSERT_EQ((*compare3), (*newExpr))  <<  PrintStmt::toString(compare3)  << " != " << PrintStmt::toString(newExpr);

}


TEST_F(ExprTranslator_Test, FunctionCascading) {
    // Let's assume that a function is already used in current context.
    // Make sure that back translation works correctly
    //Add  usage of a function to translator
    auto uInt = new UnsignedValue(2);
    auto funcOp_prev = new FunctionOperand(module.getFunction("return_unsigned"),{std::make_pair("val",uInt)});
    z3::expr expr_prev = exprTranslator.translate(funcOp_prev);
    auto newExpr_prev = exprTranslator.translate(expr_prev, &module);
    ASSERT_EQ((*funcOp_prev), (*newExpr_prev))  <<  PrintStmt::toString(funcOp_prev)  << " != " << PrintStmt::toString(newExpr_prev);

    //Add a second usage
    auto variableOperand =  new VariableOperand(module.getVariable("unsigned_var"));
    auto funcOp = new FunctionOperand(module.getFunction("return_unsigned"),{std::make_pair("val",variableOperand)});

    z3::expr expr = exprTranslator.translate(funcOp);
    auto newExpr = exprTranslator.translate(expr, &module);
    ASSERT_EQ((*funcOp), (*newExpr))  <<  PrintStmt::toString(funcOp)  << " != " << PrintStmt::toString(newExpr);

}






#endif //PROJECT_EXPRTRANSLATOR_TEST_H