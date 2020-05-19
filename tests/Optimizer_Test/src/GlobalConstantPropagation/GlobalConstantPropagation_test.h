//
// Created by mi-alkoudsi on 8.12.19.
//

#ifndef PROJECT_GLOBALCONSTANTPROPAGATION_TEST_H
#define PROJECT_GLOBALCONSTANTPROPAGATION_TEST_H


#include "Optimizer_Test/src/CreateModel.h"


class GlobalConstantPropagation_Test : public ::testing::TestWithParam<DESCAM::Module *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, GlobalConstantPropagation_Test, ::testing::ValuesIn(createModules(std::string(SCAM_HOME"/tests/Optimizer_Test/src/GlobalConstantPropagation/test_files/Tests.h"))));

TEST_P(GlobalConstantPropagation_Test, propagate_globally_constant_values) {
    auto module = GetParam();
    ASSERT_FALSE(module->getCFG().empty()) << "CFG of module " << module->getName() << " is empty\n";
    DESCAM::FindReadVariables findReadVariables(module->getCFG());
    DESCAM::FindCfgPaths findCfgPaths(module->getCFG(),0);
    DESCAM::GlobalConstantPropagation globalConstantPropagation(module->getCFG(),findCfgPaths,findReadVariables.getReadVariablesSet());
    ASSERT_FALSE(globalConstantPropagation.getCFG().empty())
                                << "After global constant propagation, CFG of module " << module->getName()
                                << " is empty\n";


    std::string CFG_str = DESCAM::GlobalUtilities::printCFG(globalConstantPropagation.getCFG());
    std::string refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/GlobalConstantPropagation/ref_files/" + GetParam()->getName() + "_out.txt";
/*
    std::ofstream oFile(refFilePath);
    oFile << CFG_str;
    oFile.close();
*/
    refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/GlobalConstantPropagation/ref_files/" + GetParam()->getName() + ".txt";

    std::ifstream refFile(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

    std::string content((std::istreambuf_iterator<char>(refFile)),
                        (std::istreambuf_iterator<char>()));
    refFile.close();
    ASSERT_EQ(content, CFG_str) << "global propagation of constant values for module " << module->getName() << " is not correct\n";
}


#endif //PROJECT_GLOBALCONSTANTPROPAGATION_TEST_H
