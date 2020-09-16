
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H


#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>
#include <FatalError.h>
#include <PrintITL/PrintITL.h>


static std::vector<DESCAM::Module *> parameter() {

    std::vector<const char *> commandLineArugmentsVector;

    //Binaray
    std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
    commandLineArugmentsVector.push_back(bin.c_str());

    //SRC-File to be analyzed
    std::string file_path = std::string(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/Tests.h");
    commandLineArugmentsVector.push_back(file_path.c_str());

    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
        commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
    }

//    add optimizations
//    std::set<std::string> optimizeOptions = {"all"};
//    CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);
    try{DESCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],commandLineArgumentsArray[1]);
    }catch(FatalError & e){

    }

    std::vector<DESCAM::Module *> result;
    for (auto module: DESCAM::ModelGlobal::getModel()->getModules()) {
        result.push_back(module.second);
    }
    return result;
}

class ITL_Test : public ::testing::TestWithParam<DESCAM::Module *> {
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
//    DESCAM::Module * module = GetParam();
    printITL.printModule(GetParam());
    ASSERT_NO_THROW(printITL.print());
    std::ofstream myfile;
    myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + GetParam()->getName() + ".vhi");
    myfile << printITL.print();
    myfile.close();

    ASSERT_NE(GetParam(), nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam()->getName() << std::endl;

    std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" + GetParam()->getName() + ".vhi");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));

    ASSERT_EQ(content, printITL.print()) << "Test for module " << GetParam()->getName() << " failed\n\n" << printITL.print();
    std::cout << "" << std::endl;

}


#endif //PROJECT_PRINTITL_TEST_H
