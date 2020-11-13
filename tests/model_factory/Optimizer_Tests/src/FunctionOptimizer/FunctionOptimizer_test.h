//
// Created by mi-alkoudsi on 9.12.19.
//

#ifndef PROJECT_FUNCTIONOPTIMIZER_TEST_H
#define PROJECT_FUNCTIONOPTIMIZER_TEST_H

#include "CreateModel.h"

class FunctionOptimizer_Test : public ::testing::TestWithParam<DESCAM::Model *> {
public:
    void SetUp() override {};
    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, FunctionOptimizer_Test, ::testing::ValuesIn(createModel(std::string(SCAM_HOME"/tests/Optimizer_Test/src/FunctionOptimizer/test_files/Tests.h"))));

TEST_P(FunctionOptimizer_Test, optimizing_functions) {
    if (auto model = GetParam()) {
        for (auto module: model->getModules()) {
            ASSERT_FALSE(module.second->getCFG().empty()) << "CFG of module " << module.first << " is empty\n";
            DESCAM::FindReadVariables findReadVariables(module.second->getCFG());
            DESCAM::FunctionsOptimizer functionOptimizer(module.second->getCFG(),module.second,

                                                                              model,findReadVariables.getReadVariablesSet());

            ASSERT_FALSE(functionOptimizer.getCFG().empty())
                                        << "After optimizing functions, CFG of module "
                                        << module.second->getName()
                                        << " is empty\n";


            std::string CFG_str = DESCAM::GlobalUtilities::printCFG(functionOptimizer.getCFG());
            std::string refFilePath =
                    SCAM_HOME"/tests/Optimizer_Test/src/FunctionOptimizer/ref_files/" + module.first +
                    "_out.txt";
/*
            std::ofstream oFile(refFilePath);
            oFile << CFG_str;
            oFile.close();
*/
            refFilePath =
                    SCAM_HOME"/tests/Optimizer_Test/src/FunctionOptimizer/ref_files/" + module.first +
                    ".txt";

            std::ifstream refFile(refFilePath);
            ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

            std::string content((std::istreambuf_iterator<char>(refFile)),
                                (std::istreambuf_iterator<char>()));
            refFile.close();
            ASSERT_EQ(content, CFG_str) << "Optimizing functions for module " << module.first
                                        << " is not correct\n";
        }
    }
}

#endif //PROJECT_FUNCTIONOPTIMIZER_TEST_H
