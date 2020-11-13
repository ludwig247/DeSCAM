//
// Created by mi-alkoudsi on 9.12.19.
//

#ifndef PROJECT_FINDUNUSEDFUNCTIONS_TEST_H
#define PROJECT_FINDUNUSEDFUNCTIONS_TEST_H


#include "CreateModel.h"


class FindUnusedFunctions_Test : public ::testing::TestWithParam<DESCAM::Module *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, FindUnusedFunctions_Test, ::testing::ValuesIn(createModules(std::string(SCAM_HOME"/tests/Optimizer_Test/src/FindUnusedFunctions/test_files/Tests.h"))));

TEST_P(FindUnusedFunctions_Test, delete_unused_functions) {
    auto module = GetParam();
    ASSERT_FALSE(module->getCFG().empty()) << "CFG of module " << module->getName() << " is empty\n";

    std::set<std::string> allFunctions;
    for(auto func: module->getFunctionMap()){
        allFunctions.insert(func.first);
    }

    DESCAM::FindUnusedFunctions findUnusedFunctions(module->getCFG(), module);
    auto functionMap = module->getFunctionMap();
    std::stringstream ss;
    for(auto func: allFunctions){
        if(functionMap.find(func)==functionMap.end()){
            ss << func << std::endl;
        }
    }
    std::string unusedFunctions_str = ss.str();
    std::string refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/FindUnusedFunctions/ref_files/" + GetParam()->getName() + "_out.txt";
/*
    std::ofstream oFile(refFilePath);
    oFile << unusedFunctions_str;
    oFile.close();
*/
    refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/FindUnusedFunctions/ref_files/" + GetParam()->getName() + ".txt";

    std::ifstream refFile(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

    std::string content((std::istreambuf_iterator<char>(refFile)),
                        (std::istreambuf_iterator<char>()));
    refFile.close();
    ASSERT_EQ(content, unusedFunctions_str) << "deleting unused functions for module " << module->getName() << " failed\n";
}


#endif //PROJECT_FINDUNUSEDFUNCTIONS_TEST_H
