//
// Created by tobias on 07.04.20.
//

#ifndef DESCAM_T_TERNARYOPTIMIZER_H
#define DESCAM_T_TERNARYOPTIMIZER_H

#include <gtest/gtest.h>
#include <Stmts/Expr.h>
#include <Port.h>
#include <OperationOptimizations/TernaryOptimizer.h>
#include <OperationOptimizations/ConditionOptimizer2.h>
#include "SyncSignal.h"

class t_TernaryOptimizer: public ::testing::Test {
public:
    t_TernaryOptimizer();

    void SetUp() override;
    void TearDown() override;

    DESCAM::Module * module = nullptr;
};




#endif //DESCAM_T_TERNARYOPTIMIZER_H
