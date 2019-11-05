//
// Created by pmorku on 19.07.18.
//

#ifndef PROJECT_STMTNODEALLOC_TEST_H
#define PROJECT_STMTNODEALLOC_TEST_H


#include <gtest/gtest.h>
#include <Module.h>
#include <PrintStmt.h>
#include <StmtNodeAlloc.h>

using namespace SCAM;

class StmtNodeAlloc_Test : public ::testing::Test {
protected:
    StmtNodeAlloc_Test() : module("Test") {}

    virtual void SetUp() {
        x_var = new Variable("x", DataTypes::getDataType("unsigned"));
        y_var = new Variable("y", DataTypes::getDataType("unsigned"));
        z_var = new Variable("z", DataTypes::getDataType("unsigned"));

        x = new VariableOperand(x_var);
        y = new VariableOperand(y_var);
        z = new VariableOperand(z_var);
    }

    virtual void TearDown() {}

    Variable *x_var;
    Variable *y_var;
    Variable *z_var;

    VariableOperand *x;
    VariableOperand *y;
    VariableOperand *z;
    Module module;
};

TEST_F(StmtNodeAlloc_Test, Alloc0_Test) {
    StmtNodeAlloc::getAllocTableArithmetic().clear();
    auto node0 = new Arithmetic(x, "*", y);
    StmtNodeAlloc::allocNode(*node0, true);
    auto node1 = new Arithmetic(y, "*", x);
    StmtNodeAlloc::allocNode(*node1, true);
//    for (auto node_it : StmtNodeAlloc::getAllocTableArithmetic()) {
//        std::cout << PrintStmt::toString(node_it) << "\n";
//    }
    ASSERT_EQ(StmtNodeAlloc::getAllocTableArithmetic().size(), 1);
}

TEST_F(StmtNodeAlloc_Test, Alloc1_Test) {
    StmtNodeAlloc::getAllocTableArithmetic().clear();
    auto node0 = new Arithmetic(new VariableOperand(x_var), "*", new VariableOperand(y_var));
    StmtNodeAlloc::allocNode(*node0, true);
    auto node1 = new Arithmetic(new VariableOperand(x_var), "*", new VariableOperand(y_var));
    StmtNodeAlloc::allocNode(*node1, true);
    ASSERT_EQ(StmtNodeAlloc::getAllocTableArithmetic().size(), 1);
}

TEST_F(StmtNodeAlloc_Test, Alloc2_Test) {
    StmtNodeAlloc::getAllocTableBitwise().clear();
    auto node0 = new Bitwise(new VariableOperand(x_var), "|", new VariableOperand(y_var));
    StmtNodeAlloc::allocNode(*node0, true);
    auto node1 = new Bitwise(y, "|", x);
    StmtNodeAlloc::allocNode(*node1, true);
    ASSERT_EQ(StmtNodeAlloc::getAllocTableBitwise().size(), 1);
}

TEST_F(StmtNodeAlloc_Test, Alloc3_Test) {
    auto node0 = new Bitwise(x, "|", y);
    auto node1 = new UnaryExpr("not", x);
    auto node2 = new UnsignedValue(10);
    auto node3 = new IntegerValue(10);
    auto node4 = new VariableOperand(x_var);
    auto node5 = new BoolValue(false);
    auto node6 = new Assignment(x, y);
    ASSERT_EQ(((*node0 == *node1) || (*node0 == *node2) || (*node0 == *node3) || (*node0 == *node4) || (*node0 == *node5) || (*node0 == *node6)
               || (*node1 == *node2) || (*node1 == *node3) || (*node1 == *node4) || (*node1 == *node5) || (*node1 == *node6)
               || (*node2 == *node3) || (*node2 == *node4) || (*node2 == *node5) || (*node2 == *node6)
               || (*node3 == *node4) || (*node3 == *node5) || (*node3 == *node6)
               || (*node4 == *node5) || (*node4 == *node6)
               || (*node5 == *node6)), false);
}

TEST_F(StmtNodeAlloc_Test, Alloc5_Test) {
    StmtNodeAlloc::getAllocTableArithmetic().clear();
    auto node0 = new Arithmetic(new UnaryExpr("-", x), "-", y);
    StmtNodeAlloc::allocNode(*node0, true);
    auto node1 = new Arithmetic(new UnaryExpr("-", y), "-", x);
    StmtNodeAlloc::allocNode(*node1, true);
    ASSERT_EQ(StmtNodeAlloc::getAllocTableArithmetic().size(), 1);
    StmtNodeAlloc::getAllocTableArithmetic().clear();

    StmtNodeAlloc::getAllocTableArithmetic().clear();
    node0 = new Arithmetic(x, "-", y);
    StmtNodeAlloc::allocNode(*node0, true);
    node1 = new Arithmetic(new UnaryExpr("-", y), "-", x);
    StmtNodeAlloc::allocNode(*node1, true);
    ASSERT_EQ(StmtNodeAlloc::getAllocTableArithmetic().size(), 2);

    StmtNodeAlloc::getAllocTableArithmetic().clear();
    node0 = new Arithmetic(new UnaryExpr("-", x), "-", y);
    StmtNodeAlloc::allocNode(*node0, true);
    node1 = new Arithmetic(y, "-", x);
    StmtNodeAlloc::allocNode(*node1, true);
    ASSERT_EQ(StmtNodeAlloc::getAllocTableArithmetic().size(), 2);
}


#endif //PROJECT_STMTNODEALLOC_TEST_H
