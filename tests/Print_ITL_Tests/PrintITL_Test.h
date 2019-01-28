
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H


#include <gtest/gtest.h>
#include <Model.h>
#include <ModelFactory.h>
#include <PluginAction.h>
#include <ModelGlobal.h>
#include <fstream>
#include <PrintAML/PrintAML.h>
#include <PrintITL/PrintITL.h>


static std::vector<SCAM::Module *> parameter() {

    std::vector<const char *> commandLineArugmentsVector;

    //Binaray
    std::string bin = std::string(SCAM_HOME"/bin/SCAM ");
    commandLineArugmentsVector.push_back(bin.c_str());

    //SRC-File to be analyzed
    std::string file_path = std::string(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/Tests.h");
    commandLineArugmentsVector.push_back(file_path.c_str());

    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
        commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
    }
    SCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],commandLineArgumentsArray[1]);


    std::vector<SCAM::Module *> result;
    for (auto module: SCAM::ModelGlobal::getModel()->getModules()) {
        result.push_back(module.second);
    }
    return result;
}

class PrintITL_Test : public ::testing::TestWithParam<SCAM::Module *> {
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

INSTANTIATE_TEST_CASE_P(Basic, PrintITL_Test, ::testing::ValuesIn(parameter()));

TEST_P(PrintITL_Test, Basic) {

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
    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/" + GetParam()->getName() + ".vhi");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));

    ASSERT_EQ(content, printITL.print()) << "Test for module " << GetParam()->getName() << " failed\n\n" << printITL.print();
    std::cout << "" << std::endl;

}


#endif //PROJECT_PRINTITL_TEST_H
