
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTSKELETONSV_TEST_H
#define PROJECT_PRINTSKELETONSV_TEST_H


#include <gtest/gtest.h>
#include <Model.h>
#include <ModelFactory.h>
#include <PluginAction.h>
#include <ModelGlobal.h>
#include <fstream>
#include <PrintAML/PrintAML.h>
//#include <PrintITL/PrintITL.h>
#include <PrintSkeleton/PrintSkeleton.h>
#include <iostream>


static std::vector<SCAM::Module *> parameter() {

/*    std::vector<const char *> commandLineArugmentsVector;

    //Binaray
    std::string bin = std::string(SCAM_HOME"/bin/SCAM ");
    commandLineArugmentsVector.push_back(bin.c_str());

    //SRC-File to be analyzed
    std::string file_path = std::string(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/Tests.h");
    commandLineArugmentsVector.push_back(file_path.c_str());

    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
    for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
        commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
    }
    SCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],commandLineArgumentsArray[1]);

    */

    std::vector<SCAM::Module *> result;
    for (auto module: SCAM::ModelGlobal::getModel()->getModules()) {
        result.push_back(module.second);
    }
    std::cout << "Number of modules: " << result.size() << std::endl;
    return result;
}

class PrintSkeleton_Test : public ::testing::TestWithParam<SCAM::Module *> {
public:
    PrintSkeleton_Test() {

    }
    static void SetUpTestCase() {
    }

    static void TearDownTestCase() {
    }

    virtual void SetUp() override {
        std::cout << "Setting up..." << std::endl;
    }

    virtual void TearDown() {
    }

    //std::vector<SCAM::Module *> getModules() {return result;}
//private:
    //std::vector<SCAM::Module *> result;
};

//INSTANTIATE_TEST_CASE(Basic, PrintSkeleton_Test);
//TEST(PrintSkeleton_Test, GlobalTypes) {

//}

INSTANTIATE_TEST_CASE_P(Basic, PrintSkeleton_Test, ::testing::ValuesIn(parameter()));

//TEST_P(PrintSkeleton_Test, GlobalTypes) {
//}
TEST_F(PrintSkeleton_Test, GlobalTypesVHDL) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    std::cout << "Global types " << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/globalTypes.vhdl");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printGlobalTypes(SCAM::ModelGlobal::getModel()));
    //ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << "_types failed\n\n" << result.second;
    ASSERT_EQ(content, result.second) << "Test for types " << SCAM::ModelGlobal::getModel()->getName() << " failed\n\n" << result.second;
    std::cout << "" << std::endl;
}
    
TEST_F(PrintSkeleton_Test, GlobalTypesSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
    //ASSERT_NE(GetParam(), nullptr) << "Module not found";
    //std::cout << "Global types: " << SCAM::ModelGlobal::getModel()->getName() << std::endl;
    std::cout << "Global types " << std::endl;
    //for (auto module: SCAM::ModelGlobal::getModel()->getModules()) {
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/globalTypes.sv");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printGlobalTypes(SCAM::ModelGlobal::getModel()));
    //ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << "_types failed\n\n" << result.second;
    ASSERT_EQ(content, result.second) << "Test for types " << SCAM::ModelGlobal::getModel()->getName() << " failed\n\n" << result.second;
    std::cout << "" << std::endl;
}
    
TEST_P(PrintSkeleton_Test, LocalTypesVHDL) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    ASSERT_NE(GetParam(), nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam()->getName() << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + GetParam()->getName() + "_types.vhdl");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printLocalTypes(GetParam()));
    ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << "_types failed\n\n" << result.second;
    std::cout << "" << std::endl;
}

TEST_P(PrintSkeleton_Test, LocalTypesSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
    ASSERT_NE(GetParam(), nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam()->getName() << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/" + GetParam()->getName() + "_types.sv");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printLocalTypes(GetParam()));
    ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << "_types failed\n\n" << result.second;
    std::cout << "" << std::endl;
}

TEST_P(PrintSkeleton_Test, ModuleVHDL) {

    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    ASSERT_NE(GetParam(), nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam()->getName() << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + GetParam()->getName() + ".vhdl");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" + GetParam()->getName() + ".vhdl";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printModule(GetParam()));
    ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << " failed\n\n" << result.second;
    std::cout << "" << std::endl;

}
TEST_P(PrintSkeleton_Test, ModuleSV) {

    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);

    ASSERT_NE(GetParam(), nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam()->getName() << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/" + GetParam()->getName() + ".sv");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" + GetParam()->getName() + ".sv";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    //std::string content(std::istreambuf_iterator<char>(ifs));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printModule(GetParam()));
    ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << " failed\n\n" << result.second;
    std::cout << "" << std::endl;

}


#endif //PROJECT_PRINTSKELETONSV_TEST_H
