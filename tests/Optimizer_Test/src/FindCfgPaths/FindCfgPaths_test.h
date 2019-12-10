//
// Created by mi-alkoudsi on 8.12.19.
//

#ifndef PROJECT_FINDCFGPATHS_TEST_H
#define PROJECT_FINDCFGPATHS_TEST_H


#include "Optimizer_Test/src/CreateModel.h"


auto file_path = std::string(SCAM_HOME"/tests/Optimizer_Test/src/FindCfgPaths/test_files/Tests.h");

class FindCFGPaths_Test : public ::testing::TestWithParam<SCAM::Module *> {
public:
    void SetUp() override {};

    void TearDown() override {};
};

INSTANTIATE_TEST_CASE_P(Basic, FindCFGPaths_Test, ::testing::ValuesIn(createModules(file_path)));

TEST_P(FindCFGPaths_Test, find_paths) {
    auto module = GetParam();
    int entryNode = 0;
    SCAM::FindCfgPaths findCfgPaths(module->getCFG(), entryNode);
    ASSERT_FALSE(findCfgPaths.getPathsMap().empty()) << "Paths map for module " << module->getName() << " is empty\n";

    std::stringstream paths;
    for (auto path : findCfgPaths.getPathsMap()) paths << path.second.print();

    std::string refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/FindCfgPaths/ref_files/" + GetParam()->getName() + "_paths.txt";
    std::ifstream refFile(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;

    std::string content((std::istreambuf_iterator<char>(refFile)),
                        (std::istreambuf_iterator<char>()));
    refFile.close();
    ASSERT_EQ(content, paths.str()) << "finding correct paths for module " << GetParam()->getName() << " failed\n";

    std::stringstream nodePathsPairs;
    for (auto pair : findCfgPaths.getNodeAndAllPathsReachingItMap()) {
        nodePathsPairs << "Node" << pair.first << " : ";
        for (auto pathID : pair.second) {
            nodePathsPairs << "Path" << pathID;
            if (pathID != pair.second.back()) nodePathsPairs << ", ";
        }
        nodePathsPairs << std::endl;
    }
    refFilePath =
            SCAM_HOME"/tests/Optimizer_Test/src/FindCfgPaths/ref_files/" + GetParam()->getName() + "_pathsToNodes.txt";
    refFile.open(refFilePath);
    ASSERT_TRUE(bool(refFile)) << "Can't open file with path " << refFilePath;
    content.clear();
    content.assign(std::istreambuf_iterator<char>(refFile), std::istreambuf_iterator<char>());
    refFile.close();
    ASSERT_EQ(content, nodePathsPairs.str()) << "finding paths to nodes in the CFG of module " << GetParam()->getName()
                                             << " failed\n";
}


#endif //PROJECT_FINDCFGPATHS_TEST_H
