//
// Created by mi-alkoudsi on 10.12.19.
//

#ifndef PROJECT_OPEARTORSTRENGTHREDUCTION_TEST_H
#define PROJECT_OPEARTORSTRENGTHREDUCTION_TEST_H


#include "CreateModel.h"


class OperatorStrengthReduction_Test : public ::testing::TestWithParam<DESCAM::Module *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, OperatorStrengthReduction_Test, ::testing::ValuesIn(createModules(std::string(SCAM_HOME"/tests/Optimizer_Test/src/OperatorStrengthReduction/test_files/Tests.h"))));

TEST_P(OperatorStrengthReduction_Test, reduce_operators_strength) {
    auto module = GetParam();
    ASSERT_FALSE(module->getCFG().empty()) << "CFG of module " << module->getName() << " is empty\n";
    DESCAM::OperatorStrengthReduction operatorStrengthReduction(module->getCFG());
    ASSERT_FALSE(operatorStrengthReduction.getCFG().empty())
                                << "after operatorStrengthReduction, CFG of module " << module->getName()
                                << " is empty\n";

    std::string CFG_str = DESCAM::GlobalUtilities::printCFG(operatorStrengthReduction.getCFG());
    std::string refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/OperatorStrengthReduction/ref_files/" + GetParam()->getName() + "_out.txt";
/*
    std::ofstream oFile(refFilePath);
    oFile << CFG_str;
    oFile.close();
*/
    refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/OperatorStrengthReduction/ref_files/" + GetParam()->getName() + ".txt";

    std::ifstream refFile(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

    std::string content((std::istreambuf_iterator<char>(refFile)),
                        (std::istreambuf_iterator<char>()));
    refFile.close();
    ASSERT_EQ(content, CFG_str) << "operator strength reduction in module " << module->getName() << " failed\n";
}


#endif //PROJECT_OPEARTORSTRENGTHREDUCTION_TEST_H