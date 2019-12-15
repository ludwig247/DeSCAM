//
// Created by mi-alkoudsi on 9.12.19.
//

#ifndef PROJECT_REACHABILITYANALYSIS_TEST_H
#define PROJECT_REACHABILITYANALYSIS_TEST_H


#include "Optimizer_Test/src/CreateModel.h"


class ReachabilityAnalysis_Test : public ::testing::TestWithParam<SCAM::Module *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, ReachabilityAnalysis_Test, ::testing::ValuesIn(createModules(std::string(SCAM_HOME"/tests/Optimizer_Test/src/ReachabilityAnalysis/test_files/Tests.h"))));

TEST_P(ReachabilityAnalysis_Test, deleting_unreachable_paths) {
    auto module = GetParam();
    ASSERT_FALSE(module->getCFG().empty()) << "CFG of module " << module->getName() << " is empty\n";
    SCAM::FindReadVariables findReadVariables(module->getCFG());
    SCAM::LivenessAnalysis livenessAnalysis(module->getCFG(),module->getVariableMap());
    SCAM::ReachabilityAnalysis reachabilityAnalysis(livenessAnalysis.getCFG(),findReadVariables.getReadVariablesSet());
    ASSERT_FALSE(reachabilityAnalysis.getCFG().empty())
                                << "After reachability analysis, CFG of module " << module->getName()
                                << " is empty\n";


    std::string CFG_str = SCAM::OptUtilities::printCFG(reachabilityAnalysis.getCFG());
    std::string refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/ReachabilityAnalysis/ref_files/" + GetParam()->getName() + "_out.txt";
/*
    std::ofstream oFile(refFilePath);
    oFile << CFG_str;
    oFile.close();
*/
    refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/ReachabilityAnalysis/ref_files/" + GetParam()->getName() + ".txt";

    std::ifstream refFile(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

    std::string content((std::istreambuf_iterator<char>(refFile)),
                        (std::istreambuf_iterator<char>()));
    refFile.close();
    ASSERT_EQ(content, CFG_str) << "deleting unreachable paths for module " << module->getName() << " failed\n";
}


#endif //PROJECT_REACHABILITYANALYSIS_TEST_H
