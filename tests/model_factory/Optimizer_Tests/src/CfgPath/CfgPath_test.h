//
// Created by mi-alkoudsi on 08.12.19.
//

#ifndef OPTIMIZER_CFGPATH_TEST_H
#define OPTIMIZER_CFGPATH_TEST_H


#include <Optimizer/Utilities/CfgPath.h>
#include <Stmts_all.h>
#include <gtest/gtest.h>

class CfgPath_test : public ::testing::Test {
public:
    CfgPath_test() = default;;

    virtual ~CfgPath_test() = default;

    DESCAM::CfgPath path;
};

TEST_F(CfgPath_test, canAddAndRemoveNode) {
    DESCAM::CfgNode node(nullptr);
    ASSERT_NO_THROW(path.insertAtEnd(&node)) << "could not add node to path\n";
    ASSERT_NO_THROW(path.deleteNodeBackward()) << "could not delete node from path\n";
    ASSERT_TRUE(path.getPath().empty()) << "path expected to be empty\n";
}

TEST_F(CfgPath_test, canGetPath) {
    DESCAM::CfgNode node1(nullptr);
    node1.replaceId(0);
    DESCAM::CfgNode node2(new DESCAM::While(new DESCAM::BoolValue(true)));
    node2.replaceId(1);
    path.insertAtEnd(&node1);
    path.insertAtEnd(&node2);
    ASSERT_NO_THROW(path.getPath()) << "could not get path\n";
    for (auto i = 0; i < 2; i++) {
        ASSERT_EQ(i, path.getPath().at(i)->getId());
    }
}

TEST_F(CfgPath_test, canMakePath) {
    for (auto i = 0; i < 3; i++) {
        auto node = new DESCAM::CfgNode(nullptr);
        node->replaceId(i);
        path.insertAtEnd(node);
    } // path has 0 1 2
    ASSERT_NO_THROW(path.makePathToNode(1)) << "could not make path\n"; //new path should have only 0
    ASSERT_EQ(1, path.makePathToNode(1).size()) << "made path is wrong\n";
}

#endif //OPTIMIZER_CFGPATH_TEST_H
