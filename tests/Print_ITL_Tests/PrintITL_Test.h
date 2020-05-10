
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H


#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>

#include <PrintITL/PrintITL.h>
//
//
//static std::vector<SCAM::Module *> parameter() {
//
//
//    return result;
//}

class ITL_Test : public ::testing::TestWithParam<SCAM::Module *> {
public:
    static void SetUpTestCase() {
    }

    static void TearDownTestCase() {
    }

    virtual void SetUp() {
    }

    virtual void TearDown() {
    }
};

INSTANTIATE_TEST_CASE_P(Basic, ITL_Test, ::testing::ValuesIn(parameter()));

TEST_P(ITL_Test, Basic) {

    PrintITL printITL;
//    SCAM::Module * module = GetParam();
    printITL.printModule(GetParam());
    ASSERT_NO_THROW(printITL.print());
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + GetParam()->getName() + ".vhi");
    myfile << printITL.print();
    myfile.close();

    ASSERT_NE(GetParam(), nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam()->getName() << std::endl;

//    std::ifstream ifs(SCAM_HOME"/example/" + GetParam()->getName() +"/RTL/properties/" + GetParam()->getName() + ".vhi");
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" + GetParam()->getName() + ".vhi");
    ASSERT_TRUE(bool(ifs)) << "Can't open file: " << SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" << GetParam()->getName()  << ".vhi";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));

    ASSERT_EQ(content, printITL.print()) << "Test for module " << GetParam()->getName() << " failed\n\n" << printITL.print();
    std::cout << "" << std::endl;

}


#endif //PROJECT_PRINTITL_TEST_H
