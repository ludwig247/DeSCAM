//
// Created by mi-alkoudsi on 8.12.19.
//

#ifndef PROJECT_GLOBALVARIABLEPROPAGATION_TEST_H
#define PROJECT_GLOBALVARIABLEPROPAGATION_TEST_H


#include "Optimizer_Test/src/CreateModel.h"

class GlobalVariablePropagation_Test : public ::testing::TestWithParam<SCAM::Model *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, GlobalVariablePropagation_Test, ::testing::ValuesIn(createModel(std::string(SCAM_HOME"/tests/Optimizer_Test/src/GlobalVariablePropagation/test_files/Tests.h"))));

TEST_P(GlobalVariablePropagation_Test, propagate_constant_global_variables) {
    if (auto model = GetParam()) {
        for (auto module: model->getModules()) {
            ASSERT_FALSE(module.second->getCFG().empty()) << "CFG of module " << module.first << " is empty\n";
            SCAM::GlobalConstantVariablePropagation globalVariablePropagation(module.second->getCFG(),
                                                                              model->getGlobalVariableMap());
            ASSERT_FALSE(globalVariablePropagation.getCFG().empty())
                                        << "After global variable propagation, CFG of module "
                                        << module.second->getName()
                                        << " is empty\n";


            std::string CFG_str = SCAM::OptUtilities::printCFG(globalVariablePropagation.getCFG());
            std::string refFilePath =
                    SCAM_HOME"/tests/Optimizer_Test/src/GlobalVariablePropagation/ref_files/" + module.first +
                    "_out.txt";

            std::ofstream oFile(refFilePath);
            oFile << CFG_str;
            oFile.close();

            refFilePath =
                    SCAM_HOME"/tests/Optimizer_Test/src/GlobalVariablePropagation/ref_files/" + module.first +
                    ".txt";

            std::ifstream refFile(refFilePath);
            ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

            std::string content((std::istreambuf_iterator<char>(refFile)),
                                (std::istreambuf_iterator<char>()));
            refFile.close();
            ASSERT_EQ(content, CFG_str) << "propagation of constant global variables for module " << module.first
                                        << " is not correct\n";
        }
    }
}

#endif //PROJECT_GLOBALVARIABLEPROPAGATION_TEST_H
