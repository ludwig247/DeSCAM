//
// Created by mi-alkoudsi on 8.12.19.
//

#ifndef PROJECT_SIMPLIFYEXPRESSIONS_TEST_H
#define PROJECT_SIMPLIFYEXPRESSIONS_TEST_H


#include "CreateModel.h"


class SimplifyExpressions_Test : public ::testing::TestWithParam<DESCAM::Module *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, SimplifyExpressions_Test, ::testing::ValuesIn(createModules(std::string(SCAM_HOME"/tests/Optimizer_Test/src/SimplifyExpressions/test_files/Tests.h"))));

TEST_P(SimplifyExpressions_Test, simplify_expressions) {
    auto module = GetParam();
    ASSERT_FALSE(module->getCFG().empty()) << "CFG of module " << module->getName() << " is empty\n";

    DESCAM::SimplifyExpressions simplifyCFGExpressions(module->getCFG(),module);
    ASSERT_FALSE(simplifyCFGExpressions.getCFG().empty())
                                << "After simplifying expressions, CFG of module " << module->getName()
                                << " is empty\n";


    std::string CFG_str = DESCAM::GlobalUtilities::printCFG(simplifyCFGExpressions.getCFG());
    std::string refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/SimplifyExpressions/ref_files/" + GetParam()->getName() + "_out.txt";
/*
    std::ofstream oFile(refFilePath);
    oFile << CFG_str;
    oFile.close();
*/
    refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/SimplifyExpressions/ref_files/" + GetParam()->getName() + ".txt";

    std::ifstream refFile(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

    std::string content((std::istreambuf_iterator<char>(refFile)),
                        (std::istreambuf_iterator<char>()));
    refFile.close();
    ASSERT_EQ(content, CFG_str) << "simplifying expressions for module " << module->getName() << " is not correct\n";
}


#endif //PROJECT_SIMPLIFYEXPRESSIONS_TEST_H
