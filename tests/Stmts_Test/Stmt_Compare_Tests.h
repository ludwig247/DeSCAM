//
// Created by ludwig on 02.08.18.
//

#ifndef PROJECT_STMT_COMPARE_TESTS_H
#define PROJECT_STMT_COMPARE_TESTS_H

#include <gtest/gtest.h>
#include <Module.h>
#include <Stmts/VariableOperand.h>
#include <Stmts/Arithmetic.h>
#include <Stmts/UnsignedValue.h>
#include <PrintStmt.h>

namespace SCAM{

class StmtCompareTest : public ::testing::Test {
protected:
    StmtCompareTest() = default;

    virtual void SetUp() {
        x = new VariableOperand(new Variable("x", DataTypes::getDataType("unsigned")));
        x2 = new VariableOperand(x->getVariable());
        y = new VariableOperand(new Variable("y", DataTypes::getDataType("unsigned")));
    }

    virtual void TearDown() {}

    VariableOperand *x;
    VariableOperand *x2;
    VariableOperand *y;
};


TEST_F(StmtCompareTest,simple){
    ASSERT_FALSE(*x==*y);
    ASSERT_TRUE(*x==*x2) << PrintStmt::toString(x) << " == " << PrintStmt::toString(x2);
    auto val = new SCAM::UnsignedValue(10);
    auto arith = new Arithmetic(x,"+",val);
    auto arith2 = new Arithmetic(x2,"+",val);
    ASSERT_TRUE(*arith==*arith2);
}
}
#endif //PROJECT_STMT_COMPARE_TESTS_H
