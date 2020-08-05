//
// Created by tobias on 07.04.20.
//


#include <ModelGlobal.h>
#include "t_TernaryOptimizer.h"


TEST_F(t_TernaryOptimizer, SyncSignalTrue) {
    std::vector<DESCAM::Expr *> assumptionList;
    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    DESCAM::Expr *expr = new DESCAM::SyncSignal(&port);

    assumptionList.push_back(expr);
    DESCAM::TernaryOptimizer ternaryOptimizer(expr, assumptionList, t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(true));
}

TEST_F(t_TernaryOptimizer, SyncSignalFalse) {
    std::vector<DESCAM::Expr *> assumptionList;
    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    DESCAM::Expr *expr = new DESCAM::SyncSignal(&port);

    assumptionList.push_back(new DESCAM::UnaryExpr("not", expr));
    DESCAM::TernaryOptimizer ternaryOptimizer(expr, assumptionList, t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(false)) << *ternaryOptimizer.getExpr() << "!=false";
}

TEST_F(t_TernaryOptimizer, SyncSignalNoChange) {
    std::vector<DESCAM::Expr *> assumptionList;
    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    DESCAM::Expr *expr = new DESCAM::SyncSignal(&port);

    DESCAM::TernaryOptimizer ternaryOptimizer(expr, assumptionList, t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), *expr) << *ternaryOptimizer.getExpr() << "!=false";
}

TEST_F(t_TernaryOptimizer, LogicalWithTrue) {
    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    auto var = new DESCAM::Variable("test_var", DESCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = DESCAM::SyncSignal(&port);
    auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), ">=", new DESCAM::IntegerValue(4));

    std::vector<DESCAM::Expr *> assumptionList;
    assumptionList.push_back(&rhs);

    { //AND
        DESCAM::Logical logical(&lhs, "and", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }

    { //OR
        DESCAM::Logical logical(&lhs, "or", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalWithFalse) {
    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    DESCAM::Variable *var = new DESCAM::Variable("test_var", DESCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = DESCAM::SyncSignal(&port);
    auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), ">=", new DESCAM::IntegerValue(4));

    std::vector<DESCAM::Expr *> assumptionList;
    assumptionList.push_back(new DESCAM::UnaryExpr("not", &rhs));

    { //AND
        DESCAM::Logical logical(&lhs, "and", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }

    { //OR
        DESCAM::Logical logical(&lhs, "or", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalContradiction) {
    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    auto *var = new DESCAM::Variable("test_var", DESCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);


    auto rhs = DESCAM::Relational(new DESCAM::VariableOperand(var), "<", new DESCAM::IntegerValue(3));

    std::vector<DESCAM::Expr *> assumptionList;
    assumptionList.push_back(new DESCAM::UnaryExpr("not", &rhs));

    { //AND
        auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), ">", new DESCAM::IntegerValue(4));
        DESCAM::Logical logical(&lhs, "and", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //AND
        auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), "<=", new DESCAM::IntegerValue(1));
        DESCAM::Logical logical(&lhs, "and", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //OR
        auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), ">=", new DESCAM::IntegerValue(3));
        DESCAM::Logical logical(&lhs, "or", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, assumptionList, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalWithEnum) {
    auto enum_type = new DESCAM::DataType("enum_type");
    enum_type->addEnumValue("a");
    enum_type->addEnumValue("b");
    enum_type->addEnumValue("c");
    DESCAM::DataTypes::addLocalDataType("test_module", enum_type);

    auto *var = new DESCAM::Variable("test_var", enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("a", enum_type));

    std::vector<DESCAM::Expr *> assumptionList;
    assumptionList.push_back(new DESCAM::UnaryExpr("not", &rhs));

    { //AND
        auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("b", enum_type));
        DESCAM::Logical logical(&lhs, "and", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //AND
        auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("c", enum_type));
        DESCAM::Logical logical(&lhs, "and", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //AND
        auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("a", enum_type));
        DESCAM::Logical logical(&lhs, "and", &rhs);
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
    { //OR
        auto subexpr = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("b", enum_type));
        auto lhs = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("c", enum_type));
        DESCAM::Logical logical(&lhs, "or", new DESCAM::Logical(&rhs, "or", &subexpr));
        DESCAM::TernaryOptimizer ternaryOptimizer(&logical, t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}


TEST_F(t_TernaryOptimizer, LogicCascading) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    if (!DESCAM::DataTypes::isLocalDataType("enum_type", "test_module")) {
        auto enum_type = new DESCAM::DataType("enum_type");
        enum_type->addEnumValue("a");
        enum_type->addEnumValue("b");
        enum_type->addEnumValue("c");
        DESCAM::DataTypes::addLocalDataType("test_module", enum_type);
    }
    auto enum_type = DESCAM::DataTypes::getLocalDataType("test_module", "enum_type");

    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    t_TernaryOptimizer::module->addPort(&port);
    auto sync = port.getSynchSignal();
    auto *var = new DESCAM::Variable("test_var", enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto expr1 = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("a", enum_type));
    auto expr2 = DESCAM::Logical(sync, "and", &expr1);
    auto expr3 = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("b", enum_type));
    auto expr4 = DESCAM::Logical(sync, "and", &expr3);
    auto expr5 = DESCAM::Logical(&expr4, "and", &expr2);


    std::vector<DESCAM::Expr *> assumptionList;
    assumptionList.push_back(sync);
    DESCAM::TernaryOptimizer ternaryOptimizer(&expr5, assumptionList, t_TernaryOptimizer::module);
    //DESCAM::TernaryOptimizer ternaryOptimizer2(ternaryOptimizer.getExpr(),  t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), DESCAM::BoolValue(false)) << "\n Optimizing: " << expr5 << "\n Result:" << *ternaryOptimizer.getExpr();

}
TEST_F(t_TernaryOptimizer, LogicCascading2) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    if (!DESCAM::DataTypes::isLocalDataType("enum_type", "test_module")) {
        auto enum_type = new DESCAM::DataType("enum_type");
        enum_type->addEnumValue("a");
        enum_type->addEnumValue("b");
        enum_type->addEnumValue("c");
        DESCAM::DataTypes::addLocalDataType("test_module", enum_type);
    }
    auto enum_type = DESCAM::DataTypes::getLocalDataType("test_module", "enum_type");

    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    t_TernaryOptimizer::module->addPort(&port);
    auto sync = port.getSynchSignal();
    auto data = new DESCAM::DataSignalOperand(port.getDataSignal());
    auto *var = new DESCAM::Variable("test_var", enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto expr1 = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("a", enum_type));
    auto expr2 = DESCAM::Logical(sync, "and", &expr1);
    auto expr3 = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("b", enum_type));
    auto expr4 = DESCAM::Logical(sync, "and", &expr3);
    auto expr5 = DESCAM::Logical(&expr4, "or", &expr2);
    auto expr6 = DESCAM::Logical(&expr5, "and", data);

    std::vector<DESCAM::Expr *> assumptionList;
    assumptionList.push_back(sync);
    DESCAM::TernaryOptimizer ternaryOptimizer(&expr6, assumptionList, t_TernaryOptimizer::module);

    auto res1 = DESCAM::Logical(&expr3, "or", &expr1);
    auto res2 = DESCAM::Logical(&res1, "and", data);

    //DESCAM::TernaryOptimizer ternaryOptimizer2(ternaryOptimizer.getExpr(),  t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), res2) << "\n Optimizing: " << expr6 << "\n Result:" << *ternaryOptimizer.getExpr();
}

TEST_F(t_TernaryOptimizer, LogicCascading3) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    if (!DESCAM::DataTypes::isLocalDataType("enum_type", "test_module")) {
        auto enum_type = new DESCAM::DataType("enum_type");
        enum_type->addEnumValue("a");
        enum_type->addEnumValue("b");
        enum_type->addEnumValue("c");
        DESCAM::DataTypes::addLocalDataType("test_module", enum_type);
    }
    auto enum_type = DESCAM::DataTypes::getLocalDataType("test_module", "enum_type");

    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    t_TernaryOptimizer::module->addPort(&port);
    auto sync = port.getSynchSignal();
    auto data = new DESCAM::DataSignalOperand(port.getDataSignal());
    auto *var = new DESCAM::Variable("test_var", enum_type);
    auto *var2 = new DESCAM::Variable("test_var2", DESCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);
    t_TernaryOptimizer::module->addVariable(var2);
    auto varOp = new DESCAM::VariableOperand(var2);

    auto expr1 = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("a", enum_type));
    auto expr2 = DESCAM::Logical(sync, "and", &expr1);
    auto expr3 = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("b", enum_type));
    auto expr4 = DESCAM::Logical(sync, "and", &expr3);
    auto expr5 = DESCAM::Logical(&expr4, "or", &expr2);
    auto expr6 = DESCAM::Logical(&expr5, "and", new DESCAM::Logical(sync, "and", data));
    auto expr7 = DESCAM::Relational(varOp,">=",new DESCAM::IntegerValue(3));
    auto expr8 = DESCAM::Logical(&expr6, "and", new DESCAM::Logical(sync, "and",&expr7));
    //auto expr8 = DESCAM::Logical(&expr7, "and", new DESCAM::Logical(sync, "and", data));

    std::vector<DESCAM::Expr *> assumptionList;
    assumptionList.push_back(sync);
    DESCAM::TernaryOptimizer ternaryOptimizer(&expr8, assumptionList, t_TernaryOptimizer::module);

    auto res1 = DESCAM::Logical(&expr3, "or", &expr1);
    auto res2 = DESCAM::Logical(&res1, "and", data);
    auto res3 = DESCAM::Logical(&res2, "and", &expr7);

    //DESCAM::TernaryOptimizer ternaryOptimizer2(ternaryOptimizer.getExpr(),  t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(), res3) << "\n Optimizing: " << expr8 << "\n Result:" << *ternaryOptimizer.getExpr();
}


TEST_F(t_TernaryOptimizer, LogicCascadingNoChange) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    if (!DESCAM::DataTypes::isLocalDataType("enum_type", "test_module")) {
        auto enum_type = new DESCAM::DataType("enum_type");
        enum_type->addEnumValue("a");
        enum_type->addEnumValue("b");
        enum_type->addEnumValue("c");
        DESCAM::DataTypes::addLocalDataType("test_module", enum_type);
    }
    auto enum_type = DESCAM::DataTypes::getLocalDataType("test_module", "enum_type");

    DESCAM::Port port("test", new DESCAM::Interface("blocking", "in"), DESCAM::DataTypes::getDataType("bool"));
    t_TernaryOptimizer::module->addPort(&port);
    auto sync = port.getSynchSignal();
    auto *var = new DESCAM::Variable("test_var", enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto expr1 = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("a", enum_type));
    auto expr2 = DESCAM::Logical(sync, "and", &expr1);
    auto expr3 = DESCAM::Relational(new DESCAM::VariableOperand(var), "==", new DESCAM::EnumValue("b", enum_type));
    auto expr4 = DESCAM::Logical(sync, "and", &expr3);
    auto expr5 = DESCAM::Logical(&expr4, "or", &expr2);

    DESCAM::TernaryOptimizer ternaryOptimizer(&expr5,t_TernaryOptimizer::module);

    ASSERT_EQ(*ternaryOptimizer.getExpr(), expr5) << "\n Optimizing: " << expr5 << "\n Result:" << *ternaryOptimizer.getExpr();

}


void t_TernaryOptimizer::SetUp() {
}

void t_TernaryOptimizer::TearDown() {
}

t_TernaryOptimizer::t_TernaryOptimizer() : module(new DESCAM::Module("test_module")) {
    auto model = new DESCAM::Model("top");
    DESCAM::ModelGlobal::setModel(model);

    model->addModule(this->module);
}
