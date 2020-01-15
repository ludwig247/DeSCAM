//
// Created by mi-alkoudsi on 10.12.19.
//

#ifndef PROJECT_RANGEANALYSIS_TEST_H
#define PROJECT_RANGEANALYSIS_TEST_H


#include "Optimizer_Test/src/CreateModel.h"

class RangeAnalysis_Test : public ::testing::TestWithParam<SCAM::Model *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, RangeAnalysis_Test, ::testing::ValuesIn(createModel(std::string(SCAM_HOME
        "/tests/Optimizer_Test/src/RangeAnalysis/test_files/Tests.h"))));

TEST_P(RangeAnalysis_Test, inferring_bitwidths) {
    if (auto model = GetParam()) {
        for (auto module: model->getModules()) {
            ASSERT_FALSE(module.second->getCFG().empty()) << "before analyzing variables bitwidths, CFG of module "
                                                          << module.second->getName() << " is empty!.\n";
            SCAM::FindReadVariables findReadVariables(module.second->getCFG());
            SCAM::FunctionsOptimizer functionOptimizer(module.second->getCFG(),module.second,
                                                       model,findReadVariables.getReadVariablesSet());
            module.second->setCFG(functionOptimizer.getCFG());
            ASSERT_FALSE(module.second->getCFG().empty())
                                        << "After Optimizations, CFG of module "
                                        << module.second->getName()
                                        << " is empty\n";
            SCAM::RangeAndBitWidthAnalysis rangeAndBitWidthAnalysis(module.second);

            std::stringstream ss;
            ss << "Variables bitwidths map:\n";
            for(const auto& variableNameBitwidthPair: rangeAndBitWidthAnalysis.getVariableBitWidthMap()){
                ss << variableNameBitwidthPair.first << " : " << variableNameBitwidthPair.second << "\n";
            }
            ss << "\nOutput ports bitwidths map:\n";
            for(const auto& portNameBitwidthPair : rangeAndBitWidthAnalysis.getPortsBitWidthMap()){
                ss << portNameBitwidthPair.first->getName() << " : " << portNameBitwidthPair.second << "\n";
            }

            std::string bitwidths_str = ss.str();
            std::string refFilePath =
                    SCAM_HOME"/tests/Optimizer_Test/src/RangeAnalysis/ref_files/" + module.first +
                    "_out.txt";
/*
            std::ofstream oFile(refFilePath);
            oFile << bitwidths_str;
            oFile.close();
*/
            refFilePath =
                    SCAM_HOME"/tests/Optimizer_Test/src/RangeAnalysis/ref_files/" + module.first +
                    ".txt";

            std::ifstream refFile(refFilePath);
            ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

            std::string content((std::istreambuf_iterator<char>(refFile)),
                                (std::istreambuf_iterator<char>()));
            refFile.close();
            ASSERT_EQ(content, bitwidths_str) << "inferring bitwidths of visible registers for module " << module.first
                                        << " is not correct\n";
        }
    }
}

#endif //PROJECT_RANGEANALYSIS_TEST_H
