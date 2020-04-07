//
// Created by tobias on 07.04.20.
//


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
    auto lhs = SCAM::Relational(new SCAM::VariableOperand(var),">",new SCAM::IntegerValue(4));
    SCAM::Logical logical(&lhs,"and",&rhs);

    std::vector<SCAM::Expr*> assumptionList;
    assumptionList.push_back(&rhs);

    SCAM::TernaryOptimizer ternaryOptimizer(&logical,assumptionList,t_TernaryOptimizer::module);

    ASSERT_EQ(*ternaryOptimizer.getExpr(),lhs) << "\n Optimizing: " << logical << "\n Result:" << *ternaryOptimizer.getExpr();
}

void t_TernaryOptimizer::SetUp() {
    SCAM::Module * module = new SCAM::Module("test_module");

}

void t_TernaryOptimizer::TearDown() {
}

t_TernaryOptimizer::t_TernaryOptimizer() : module(new SCAM::Module("test_module")) {}
