//
// Created by tobias on 07.04.20.
//


#include <ModelGlobal.h>
#include "t_TernaryOptimizer.h"


TEST_F(t_TernaryOptimizer, SyncSignalTrue) {
    std::vector<SCAM::Expr *> assumptionList;
    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    SCAM::Expr *expr = new SCAM::SyncSignal(&port);

    assumptionList.push_back(expr);
    SCAM::TernaryOptimizer ternaryOptimizer(expr, assumptionList, t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(true));
}

TEST_F(t_TernaryOptimizer, SyncSignalFalse) {
    std::vector<SCAM::Expr *> assumptionList;
    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    SCAM::Expr *expr = new SCAM::SyncSignal(&port);

    assumptionList.push_back(new SCAM::UnaryExpr("not", expr));
    SCAM::TernaryOptimizer ternaryOptimizer(expr, assumptionList, t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(false)) << *ternaryOptimizer.getExpr() << "!=false";
}

TEST_F(t_TernaryOptimizer, SyncSignalNoChange) {
    std::vector<SCAM::Expr *> assumptionList;
    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    SCAM::Expr *expr = new SCAM::SyncSignal(&port);

    SCAM::TernaryOptimizer ternaryOptimizer(expr, assumptionList, t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), *expr) << *ternaryOptimizer.getExpr() << "!=false";
}

TEST_F(t_TernaryOptimizer, LogicalWithTrue) {
    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    auto var = new SCAM::Variable("test_var", SCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = SCAM::SyncSignal(&port);
    auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), ">=", new SCAM::IntegerValue(4));

    std::vector<SCAM::Expr *> assumptionList;
    assumptionList.push_back(&rhs);

    { //AND
        SCAM::Logical logical(&lhs, "and", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }

    { //OR
        SCAM::Logical logical(&lhs, "or", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalWithFalse) {
    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    SCAM::Variable *var = new SCAM::Variable("test_var", SCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = SCAM::SyncSignal(&port);
    auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), ">=", new SCAM::IntegerValue(4));

    std::vector<SCAM::Expr *> assumptionList;
    assumptionList.push_back(new SCAM::UnaryExpr("not", &rhs));

    { //AND
        SCAM::Logical logical(&lhs, "and", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }

    { //OR
        SCAM::Logical logical(&lhs, "or", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalContradiction) {
    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    auto *var = new SCAM::Variable("test_var", SCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);


    auto rhs = SCAM::Relational(new SCAM::VariableOperand(var), "<", new SCAM::IntegerValue(3));

    std::vector<SCAM::Expr *> assumptionList;
    assumptionList.push_back(new SCAM::UnaryExpr("not", &rhs));

    { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), ">", new SCAM::IntegerValue(4));
        SCAM::Logical logical(&lhs, "and", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), "<=", new SCAM::IntegerValue(1));
        SCAM::Logical logical(&lhs, "and", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //OR
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), ">=", new SCAM::IntegerValue(3));
        SCAM::Logical logical(&lhs, "or", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalWithEnum) {
    auto enum_type = new SCAM::DataType("enum_type");
    enum_type->addEnumValue("a");
    enum_type->addEnumValue("b");
    enum_type->addEnumValue("c");
    SCAM::DataTypes::addLocalDataType("test_module", enum_type);

    auto *var = new SCAM::Variable("test_var", enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("a", enum_type));

    std::vector<SCAM::Expr *> assumptionList;
    assumptionList.push_back(new SCAM::UnaryExpr("not", &rhs));

    { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("b", enum_type));
        SCAM::Logical logical(&lhs, "and", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("c", enum_type));
        SCAM::Logical logical(&lhs, "and", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("a", enum_type));
        SCAM::Logical logical(&lhs, "and", &rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //OR
        auto subexpr = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("b", enum_type));
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("c", enum_type));
        SCAM::Logical logical(&lhs, "or", new SCAM::Logical(&rhs, "or", &subexpr));
        SCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}


TEST_F(t_TernaryOptimizer, LogicCascading) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    if (!SCAM::DataTypes::isLocalDataType("enum_type", "test_module")) {
        auto enum_type = new SCAM::DataType("enum_type");
        enum_type->addEnumValue("a");
        enum_type->addEnumValue("b");
        enum_type->addEnumValue("c");
        SCAM::DataTypes::addLocalDataType("test_module", enum_type);
    }
    auto enum_type = SCAM::DataTypes::getLocalDataType("test_module", "enum_type");

    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    t_TernaryOptimizer::module->addPort(&port);
    auto sync = port.getSynchSignal();
    auto *var = new SCAM::Variable("test_var", enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto expr1 = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("a", enum_type));
    auto expr2 = SCAM::Logical(sync, "and", &expr1);
    auto expr3 = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("b", enum_type));
    auto expr4 = SCAM::Logical(sync, "and", &expr3);
    auto expr5 = SCAM::Logical(&expr4, "and", &expr2);


    std::vector<SCAM::Expr *> assumptionList;
    assumptionList.push_back(sync);
    SCAM::TernaryOptimizer ternaryOptimizer(&expr5, assumptionList, t_TernaryOptimizer::module);
    //SCAM::TernaryOptimizer ternaryOptimizer2(ternaryOptimizer.getExpr(),  t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), SCAM::BoolValue(false)) << "\n Optimizing: " << expr5 << "\n Result:" << *ternaryOptimizer.getExpr();

}
TEST_F(t_TernaryOptimizer, LogicCascading2) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    if (!SCAM::DataTypes::isLocalDataType("enum_type", "test_module")) {
        auto enum_type = new SCAM::DataType("enum_type");
        enum_type->addEnumValue("a");
        enum_type->addEnumValue("b");
        enum_type->addEnumValue("c");
        SCAM::DataTypes::addLocalDataType("test_module", enum_type);
    }
    auto enum_type = SCAM::DataTypes::getLocalDataType("test_module", "enum_type");

    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    t_TernaryOptimizer::module->addPort(&port);
    auto sync = port.getSynchSignal();
    auto data = new SCAM::DataSignalOperand(port.getDataSignal());
    auto *var = new SCAM::Variable("test_var", enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto expr1 = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("a", enum_type));
    auto expr2 = SCAM::Logical(sync, "and", &expr1);
    auto expr3 = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("b", enum_type));
    auto expr4 = SCAM::Logical(sync, "and", &expr3);
    auto expr5 = SCAM::Logical(&expr4, "or", &expr2);
    auto expr6 = SCAM::Logical(&expr5, "and", data);

    std::vector<SCAM::Expr *> assumptionList;
    assumptionList.push_back(sync);
    SCAM::TernaryOptimizer ternaryOptimizer(&expr6, assumptionList, t_TernaryOptimizer::module);

    auto res1 = SCAM::Logical(&expr3, "or", &expr1);
    auto res2 = SCAM::Logical(&res1, "and", data);

    //SCAM::TernaryOptimizer ternaryOptimizer2(ternaryOptimizer.getExpr(),  t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), res2) << "\n Optimizing: " << expr6 << "\n Result:" << *ternaryOptimizer.getExpr();
}

TEST_F(t_TernaryOptimizer, LogicCascading3) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    if (!SCAM::DataTypes::isLocalDataType("enum_type", "test_module")) {
        auto enum_type = new SCAM::DataType("enum_type");
        enum_type->addEnumValue("a");
        enum_type->addEnumValue("b");
        enum_type->addEnumValue("c");
        SCAM::DataTypes::addLocalDataType("test_module", enum_type);
    }
    auto enum_type = SCAM::DataTypes::getLocalDataType("test_module", "enum_type");

    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    t_TernaryOptimizer::module->addPort(&port);
    auto sync = port.getSynchSignal();
    auto data = new SCAM::DataSignalOperand(port.getDataSignal());
    auto *var = new SCAM::Variable("test_var", enum_type);
    auto *var2 = new SCAM::Variable("test_var2", SCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);
    t_TernaryOptimizer::module->addVariable(var2);
    auto varOp = new SCAM::VariableOperand(var2);

    auto expr1 = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("a", enum_type));
    auto expr2 = SCAM::Logical(sync, "and", &expr1);
    auto expr3 = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("b", enum_type));
    auto expr4 = SCAM::Logical(sync, "and", &expr3);
    auto expr5 = SCAM::Logical(&expr4, "or", &expr2);
    auto expr6 = SCAM::Logical(&expr5, "and", new SCAM::Logical(sync, "and", data));
    auto expr7 = SCAM::Relational(varOp,">=",new SCAM::IntegerValue(3));
    auto expr8 = SCAM::Logical(&expr6, "and", new SCAM::Logical(sync, "and",&expr7));
    //auto expr8 = SCAM::Logical(&expr7, "and", new SCAM::Logical(sync, "and", data));

    std::vector<SCAM::Expr *> assumptionList;
    assumptionList.push_back(sync);
    SCAM::TernaryOptimizer ternaryOptimizer(&expr8, assumptionList, t_TernaryOptimizer::module);

    auto res1 = SCAM::Logical(&expr3, "or", &expr1);
    auto res2 = SCAM::Logical(&res1, "and", data);
    auto res3 = SCAM::Logical(&res2, "and", &expr7);

    //SCAM::TernaryOptimizer ternaryOptimizer2(ternaryOptimizer.getExpr(),  t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), res3) << "\n Optimizing: " << expr8 << "\n Result:" << *ternaryOptimizer.getExpr();
}


TEST_F(t_TernaryOptimizer, LogicCascadingNoChange) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    if (!SCAM::DataTypes::isLocalDataType("enum_type", "test_module")) {
        auto enum_type = new SCAM::DataType("enum_type");
        enum_type->addEnumValue("a");
        enum_type->addEnumValue("b");
        enum_type->addEnumValue("c");
        SCAM::DataTypes::addLocalDataType("test_module", enum_type);
    }
    auto enum_type = SCAM::DataTypes::getLocalDataType("test_module", "enum_type");

    SCAM::Port port("test", new SCAM::Interface("blocking", "in"), SCAM::DataTypes::getDataType("bool"));
    t_TernaryOptimizer::module->addPort(&port);
    auto sync = port.getSynchSignal();
    auto *var = new SCAM::Variable("test_var", enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto expr1 = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("a", enum_type));
    auto expr2 = SCAM::Logical(sync, "and", &expr1);
    auto expr3 = SCAM::Relational(new SCAM::VariableOperand(var), "==", new SCAM::EnumValue("b", enum_type));
    auto expr4 = SCAM::Logical(sync, "and", &expr3);
    auto expr5 = SCAM::Logical(&expr4, "or", &expr2);

    SCAM::TernaryOptimizer ternaryOptimizer(&expr5,t_TernaryOptimizer::module);

    ASSERT_EQ(*ternaryOptimizer.getExpr(), expr5) << "\n Optimizing: " << expr5 << "\n Result:" << *ternaryOptimizer.getExpr();

}


void t_TernaryOptimizer::SetUp() {
}

void t_TernaryOptimizer::TearDown() {
}

t_TernaryOptimizer::t_TernaryOptimizer() : module(new SCAM::Module("test_module")) {
    auto model = new SCAM::Model("top");
    SCAM::ModelGlobal::setModel(model);

    model->addModule(this->module);
}
