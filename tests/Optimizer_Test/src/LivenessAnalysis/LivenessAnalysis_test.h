//
// Created by mi-alkoudsi on 8.12.19.
//

#ifndef PROJECT_LIVENESSANALYSIS_TEST_H
#define PROJECT_LIVENESSANALYSIS_TEST_H


#include "Optimizer_Test/src/CreateModel.h"


class LivenessAnalysis_Test : public ::testing::TestWithParam<SCAM::Module *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, LivenessAnalysis_Test, ::testing::ValuesIn(createModules(std::string(SCAM_HOME"/tests/Optimizer_Test/src/LivenessAnalysis/test_files/Tests.h"))));

TEST_P(LivenessAnalysis_Test, deleting_dead_assignments) {
    auto module = GetParam();
    ASSERT_FALSE(module->getCFG().empty()) << "CFG of module " << module->getName() << " is empty\n";
    SCAM::FindReadVariables findReadVariables(module->getCFG());
    SCAM::FindCfgPaths findCfgPaths(module->getCFG(),0);
    SCAM::LocalValuePropagation localValuePropagation(module->getCFG());
    SCAM::GlobalConstantPropagation globalConstantPropagation(localValuePropagation.getCFG(),findCfgPaths,findReadVariables.getReadVariablesSet());
    SCAM::LivenessAnalysis livenessAnalysis(globalConstantPropagation.getCFG(),module->getVariableMap());
    ASSERT_FALSE(livenessAnalysis.getCFG().empty())
                                << "After liveness analysis, CFG of module " << module->getName()
                                << " is empty\n";


    std::string CFG_str = SCAM::GlobalUtilities::printCFG(livenessAnalysis.getCFG());
    std::string refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/LivenessAnalysis/ref_files/" + GetParam()->getName() + "_out.txt";
/*
    std::ofstream oFile(refFilePath);
    oFile << CFG_str;
    oFile.close();
*/
    refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/LivenessAnalysis/ref_files/" + GetParam()->getName() + ".txt";

    std::ifstream refFile(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

    std::string content((std::istreambuf_iterator<char>(refFile)),
                        (std::istreambuf_iterator<char>()));
    refFile.close();
    ASSERT_EQ(content, CFG_str) << "deleting dead assignments for module " << module->getName() << " failed\n";
}


#endif //PROJECT_LIVENESSANALYSIS_TEST_H
