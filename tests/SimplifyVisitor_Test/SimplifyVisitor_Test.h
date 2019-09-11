//
// Created by pmorku on 19.01.18.
//

#ifndef PROJECT_SIMPLIFYVISITOR_TEST_H
#define PROJECT_SIMPLIFYVISITOR_TEST_H


#include <gtest/gtest.h>
#include <Module.h>
#include <PrintStmt.h>
#include <SimplifyVisitor.h>

using namespace SCAM;

class SimplifyVisitor_Test : public ::testing::Test {
protected:
    SimplifyVisitor_Test() : module("Test") {}

    virtual void SetUp() {
        x = new VariableOperand(new Variable("x", DataTypes::getDataType("unsigned")));
        y = new VariableOperand(new Variable("y", DataTypes::getDataType("unsigned")));
        z = new VariableOperand(new Variable("z", DataTypes::getDataType("unsigned")));
    }

    virtual void TearDown() {}

    VariableOperand *x;
    VariableOperand *y;
    VariableOperand *z;
    SimplifyVisitor *simplifyVisitor;
    Module module;
};

TEST_F(SimplifyVisitor_Test, SignInversion_Test) {
    auto final = new Arithmetic(new UnsignedValue(-1), "*", x);
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new UnaryExpr("-", x)));
    std::cout << "SignInversion_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
    delete final;

    // check if returned pointer is the same when no simplification is done
    final = new Arithmetic(new UnsignedValue(-2), "*", x);
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->getSimplifiedNode(), final);
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, Subtraction_Test) {
    auto final = new Arithmetic(y, "+", new Arithmetic(new UnsignedValue(-1), "*", x));
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new Arithmetic(y, "-", x)));
    std::cout << "Subtraction_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;

    simplifyVisitor = new SimplifyVisitor(new Arithmetic(y, "+", new Arithmetic(new UnsignedValue(-2), "*", x)));
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), false);
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, MultByZero_Test) {
    auto final = new Arithmetic(new UnsignedValue(0), "*", x);
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new UnsignedValue(0)));
    std::cout << "MultByZero_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, DemorgansRule_Test) {
    auto final = new UnaryExpr("not", new Bitwise(new UnaryExpr("not", x), "|", new UnaryExpr("not", y)));
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new Bitwise(x, "&", y)));
    std::cout << "MultByZero_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, ShiftZero_Test) {
    auto final = new Bitwise(new UnsignedValue(0), ">>", x);
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new UnsignedValue(0)));
    std::cout << "ShiftZero_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n";
    delete simplifyVisitor;
    delete final;

    final = new Bitwise(new UnsignedValue(0), "<<", x);
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new UnsignedValue(0)));
    std::cout << "ShiftZero_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;

    simplifyVisitor = new SimplifyVisitor(new Bitwise(new UnsignedValue(1), ">>", x));
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), false);
    delete simplifyVisitor;

    simplifyVisitor = new SimplifyVisitor(new Bitwise(new UnsignedValue(1), "<<", x));
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), false);
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, Recursive0_Test) {
    auto temp0 = new Bitwise(new UnsignedValue(0), ">>", x);
    auto final = new Arithmetic(new UnsignedValue(-1), "*", temp0);
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new UnsignedValue(0)));
    std::cout << "Recursive0_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, Recursive1_Test) {
    auto temp0 = new Arithmetic(new UnsignedValue(-1), "*", y);
    auto temp1 = new Bitwise(new UnsignedValue(0), ">>", x);
    auto final = new Arithmetic(temp0, "+", new Arithmetic(new UnsignedValue(-1), "*", temp1));
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new UnaryExpr("-", y)));
    std::cout << "Recursive1_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, Recursive2_Test) {
    auto temp0 = new Arithmetic(new UnsignedValue(-1), "*", y);
    auto temp1 = new Bitwise(new UnsignedValue(0), ">>", x);
    auto final = new Arithmetic(temp0, "+", temp1);
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new UnaryExpr("-", y)));
    std::cout << "Recursive2_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, Recursive3_Test) {
    auto temp0 = new Arithmetic(new UnsignedValue(-1), "*", y);
    auto temp1 = new Bitwise(new UnsignedValue(1), ">>", x);
    auto final = new Arithmetic(temp0, "+", temp1);
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new Arithmetic(new Bitwise(new UnsignedValue(1), ">>", x), "-", y)));
    std::cout << "Recursive3_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, Recursive4_Test) {
    auto temp0 = new Arithmetic(new UnsignedValue(-1), "*", y);
    auto temp1 = new Bitwise(new UnsignedValue(1), ">>", x);
    auto temp2 = new UnaryExpr("-", temp1);
    auto temp3 = new Arithmetic(new UnsignedValue(-1), "*", temp2);
    auto temp4 = new Bitwise(new UnsignedValue(0), ">>", temp0);
    auto final = new Arithmetic(temp4, "+", new Arithmetic(new UnsignedValue(-1), "*", temp3));
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new UnaryExpr("-", new Bitwise(new UnsignedValue(1), ">>", x))));
    std::cout << "Recursive4_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, RecursiveUnaryExpr_Test) {
    auto final = new UnaryExpr("-", new UnaryExpr("-", x));
    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(x));
    std::cout << "RecursiveUnaryExpr_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}

TEST_F(SimplifyVisitor_Test, Casting1_Test) {
    auto temp0 = new Bitwise(new UnsignedValue(0), "&", new UnsignedValue(31));
    auto temp1 = new Cast(temp0, DataTypes::getDataType("int"));
    auto temp2 = new Cast(x, DataTypes::getDataType("int"));
    auto temp3 = new Bitwise(temp2, ">>", temp1);
    auto temp4 = new Cast(temp3, DataTypes::getDataType("unsigned"));
    auto final = new Assignment(y, temp4);
    std::cout << "Casting1_Test expression: " << PrintStmt::toString(final)  << "\n\n";

    simplifyVisitor = new SimplifyVisitor(final);
    ASSERT_EQ(simplifyVisitor->isNodeSimplified(), true);
    ASSERT_EQ(PrintStmt::toString(simplifyVisitor->getSimplifiedNode()), PrintStmt::toString(new Assignment(y, x)));
    std::cout << "Casting1_Test expression: " << PrintStmt::toString(final) << " was translated to: " << PrintStmt::toString(
            simplifyVisitor->getSimplifiedNode()) << "\n\n";
    delete simplifyVisitor;
}


#endif //PROJECT_SIMPLIFYVISITOR_TEST_H
