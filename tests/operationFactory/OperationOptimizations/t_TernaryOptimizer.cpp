//
// Created by tobias on 07.04.20.
//


#include <ModelGlobal.h>
#include "t_TernaryOptimizer.h"


TEST_F(t_TernaryOptimizer, SyncSignalTrue) {
    std::vector<SCAM::Expr*> assumptionList;
    SCAM::Port port("test",new SCAM::Interface("blocking","in"),SCAM::DataTypes::getDataType("bool"));
    SCAM::Expr * expr =  new SCAM::SyncSignal(&port);

    assumptionList.push_back(expr);
   SCAM::TernaryOptimizer ternaryOptimizer(expr,assumptionList,t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(true));
}

TEST_F(t_TernaryOptimizer, SyncSignalFalse) {
    std::vector<SCAM::Expr*> assumptionList;
    SCAM::Port port("test",new SCAM::Interface("blocking","in"),SCAM::DataTypes::getDataType("bool"));
    SCAM::Expr * expr =  new SCAM::SyncSignal(&port);

    assumptionList.push_back(new SCAM::UnaryExpr("not",expr));
    SCAM::TernaryOptimizer ternaryOptimizer(expr,assumptionList,t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(false)) << *ternaryOptimizer.getExpr() << "!=false" ;
}

TEST_F(t_TernaryOptimizer, SyncSignalNoChange) {
    std::vector<SCAM::Expr*> assumptionList;
    SCAM::Port port("test",new SCAM::Interface("blocking","in"),SCAM::DataTypes::getDataType("bool"));
    SCAM::Expr * expr =  new SCAM::SyncSignal(&port);

    SCAM::TernaryOptimizer ternaryOptimizer(expr,assumptionList,t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(),*expr) << *ternaryOptimizer.getExpr() << "!=false" ;
}

TEST_F(t_TernaryOptimizer, LogicalWithTrue) {
    SCAM::Port port("test",new SCAM::Interface("blocking","in"),SCAM::DataTypes::getDataType("bool"));
    SCAM::Variable * var = new SCAM::Variable("test_var",SCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs =  SCAM::SyncSignal(&port);
    auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),">=",new SCAM::IntegerValue(4));

    std::vector<SCAM::Expr*> assumptionList;
    assumptionList.push_back(&rhs);

    { //AND
    SCAM::Logical logical(&lhs,"and",&rhs);
    SCAM::TernaryOptimizer ternaryOptimizer(&logical,assumptionList,t_TernaryOptimizer::module);
    ASSERT_EQ(*ternaryOptimizer.getExpr(),lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }

    { //OR
        SCAM::Logical logical(&lhs,"or",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,assumptionList,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalWithFalse) {
    SCAM::Port port("test",new SCAM::Interface("blocking","in"),SCAM::DataTypes::getDataType("bool"));
    SCAM::Variable * var = new SCAM::Variable("test_var",SCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = SCAM::SyncSignal(&port);
    auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),">=",new SCAM::IntegerValue(4));

    std::vector<SCAM::Expr*> assumptionList;
    assumptionList.push_back(new SCAM::UnaryExpr("not",&rhs));

    { //AND
        SCAM::Logical logical(&lhs,"and",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,assumptionList,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }

    { //OR
        SCAM::Logical logical(&lhs,"or",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,assumptionList,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalContradiction) {
    SCAM::Port port("test",new SCAM::Interface("blocking","in"),SCAM::DataTypes::getDataType("bool"));
    auto * var = new SCAM::Variable("test_var",SCAM::DataTypes::getDataType("int"));
    t_TernaryOptimizer::module->addVariable(var);


    auto rhs = SCAM::Relational(new SCAM::VariableOperand(var),"<",new SCAM::IntegerValue(3));

    std::vector<SCAM::Expr*> assumptionList;
    assumptionList.push_back(new SCAM::UnaryExpr("not",&rhs));

    { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),">",new SCAM::IntegerValue(4));
        SCAM::Logical logical(&lhs,"and",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }{ //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),"<=",new SCAM::IntegerValue(1));
        SCAM::Logical logical(&lhs,"and",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }{ //OR
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),">=",new SCAM::IntegerValue(3));
        SCAM::Logical logical(&lhs,"or",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,assumptionList,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}

TEST_F(t_TernaryOptimizer, LogicalWithEnum) {
    auto enum_type = new SCAM::DataType("enum_type");
    enum_type->addEnumValue("a");
    enum_type->addEnumValue("b");
    enum_type->addEnumValue("c");
    SCAM::DataTypes::addLocalDataType("test_module",enum_type);

    SCAM::Port port("test",new SCAM::Interface("blocking","in"),SCAM::DataTypes::getDataType("bool"));
    auto * var = new SCAM::Variable("test_var",enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = SCAM::Relational(new SCAM::VariableOperand(var),"==",new SCAM::EnumValue("a",enum_type));

    std::vector<SCAM::Expr*> assumptionList;
    assumptionList.push_back(new SCAM::UnaryExpr("not",&rhs));

    { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),"==",new SCAM::EnumValue("b",enum_type));
        SCAM::Logical logical(&lhs,"and",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    } { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),"==",new SCAM::EnumValue("c",enum_type));
        SCAM::Logical logical(&lhs,"and",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    } { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),"==",new SCAM::EnumValue("a",enum_type));
        SCAM::Logical logical(&lhs,"and",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }{ //OR
        auto subexpr = SCAM::Relational(new SCAM::VariableOperand(var),"==",new SCAM::EnumValue("b",enum_type));
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),"==",new SCAM::EnumValue("c",enum_type));
        SCAM::Logical logical(&lhs,"or",new SCAM::Logical(&rhs,"or",&subexpr));
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(true)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
}


TEST_F(t_TernaryOptimizer, LogicCascading) {
    /*
     * assume: sync
     * prove:
     * x = (sync and ( var == a ) and ( sync and ( var == b))
     * => x = false;
     */
    auto enum_type = new SCAM::DataType("enum_type");
    enum_type->addEnumValue("a");
    enum_type->addEnumValue("b");
    enum_type->addEnumValue("c");
    SCAM::DataTypes::addLocalDataType("test_module",enum_type);

    SCAM::Port port("test",new SCAM::Interface("blocking","in"),SCAM::DataTypes::getDataType("bool"));
    auto * var = new SCAM::Variable("test_var",enum_type);
    t_TernaryOptimizer::module->addVariable(var);

    auto rhs = SCAM::Relational(new SCAM::VariableOperand(var),"==",new SCAM::EnumValue("a",enum_type));

    std::vector<SCAM::Expr*> assumptionList;
    assumptionList.push_back(new SCAM::UnaryExpr("not",&rhs));

    { //AND
        auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),"==",new SCAM::EnumValue("b",enum_type));
        SCAM::Logical logical(&lhs,"and",&rhs);
        SCAM::TernaryOptimizer ternaryOptimizer(&logical,t_TernaryOptimizer::module);
        ASSERT_EQ(*ternaryOptimizer.getExpr(),SCAM::BoolValue(false)) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
    }
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
