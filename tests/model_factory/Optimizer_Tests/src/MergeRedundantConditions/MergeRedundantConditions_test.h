//
// Created by mi-alkoudsi on 10.12.19.
//

#ifndef PROJECT_MERGEREDUNDANTCONDITIONS_TEST_H
#define PROJECT_MERGEREDUNDANTCONDITIONS_TEST_H


#include "CreateModel.h"

class MergeRedundantConditions_Test : public ::testing::TestWithParam<DESCAM::Model *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, MergeRedundantConditions_Test, ::testing::ValuesIn(createModel(std::string(SCAM_HOME"/tests/Optimizer_Test/src/MergeRedundantConditions/test_files/Tests.h"),std::set<std::string>{"mrc"},false)));

TEST_P(MergeRedundantConditions_Test, merging_redundant_conditions) {
    if (auto model = GetParam()) {
        for (auto module: model->getModules()) {
            ASSERT_FALSE(module.second->getCFG().empty())
                                        << "After merging redundant conditions, CFG of module "
                                        << module.second->getName()
                                        << " is empty\n";


            std::string CFG_str = DESCAM::GlobalUtilities::printCFG(module.second->getCFG());
            std::string refFilePath =
                    SCAM_HOME"/tests/Optimizer_Test/src/MergeRedundantConditions/ref_files/" + module.first +
                    "_out.txt";
/*
            std::ofstream oFile(refFilePath);
            oFile << CFG_str;
            oFile.close();
*/
            refFilePath =
                    SCAM_HOME"/tests/Optimizer_Test/src/MergeRedundantConditions/ref_files/" + module.first +
                    ".txt";

            std::ifstream refFile(refFilePath);
            ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

            std::string content((std::istreambuf_iterator<char>(refFile)),
                                (std::istreambuf_iterator<char>()));
            refFile.close();
            ASSERT_EQ(content, CFG_str) << "merging redundant conditions for module " << module.first
                                        << " is not correct\n";
        }
    }
}

#endif //PROJECT_MERGEREDUNDANTCONDITIONS_TEST_H
