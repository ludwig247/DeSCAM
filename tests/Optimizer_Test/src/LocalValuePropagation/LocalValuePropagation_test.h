//
// Created by mi-alkoudsi on 8.12.19.
//

#ifndef PROJECT_LOCALCONSTANTPROPAGATION_TEST_H
#define PROJECT_LOCALCONSTANTPROPAGATION_TEST_H


#include "Optimizer_Test/src/CreateModel.h"


auto file_path = std::string(SCAM_HOME"/tests/Optimizer_Test/src/LocalValuePropagation/test_files/Tests.h");

class LocalVariablePropagation_Test : public ::testing::TestWithParam<SCAM::Module *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, LocalVariablePropagation_Test, ::testing::ValuesIn(createModules(file_path)));

TEST_P(LocalVariablePropagation_Test, propagate_locally_constant_values) {
    auto module = GetParam();
    ASSERT_FALSE(module->getCFG().empty()) << "CFG of module " << module->getName() << " is empty\n";

    SCAM::LocalValuePropagation localValuePropagation(module->getCFG());
    ASSERT_FALSE(localValuePropagation.getCFG().empty())
                                << "After local value propagation, CFG of module " << module->getName()
                                << " is empty\n";


    std::string CFG_str = SCAM::OptUtilities::printCFG(localValuePropagation.getCFG());
    std::string refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/LocalValuePropagation/ref_files/" + GetParam()->getName() + "_out.txt";
/*
    std::ofstream oFile(refFilePath);
    oFile << CFG_str;
    oFile.close();
*/
    refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/LocalValuePropagation/ref_files/" + GetParam()->getName() + ".txt";

    std::ifstream refFile(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

    std::string content((std::istreambuf_iterator<char>(refFile)),
                        (std::istreambuf_iterator<char>()));
    refFile.close();
    ASSERT_EQ(content, CFG_str) << "local propagation of constant values for module " << module->getName() << " is not correct\n";
}


#endif //PROJECT_LOCALCONSTANTPROPAGATION_TEST_H
