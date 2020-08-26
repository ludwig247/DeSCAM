
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
#include <iostream>

#include <PrintSkeleton/PrintSkeleton.h>


struct Param
{
    std::string Name;
    SCAM::Module * result;
    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.Name;
    }
};

static std::vector<SCAM::Module *> parameter() {

    std::vector<SCAM::Module *> result;
    for (auto module: SCAM::ModelGlobal::getModel()->getModules()) {
        result.push_back(module.second);
    }
    std::cout << "Number of modules: " << result.size() << std::endl;
    return result;
}

static std::vector<Param> parameter(const char* header_list) {

    std::vector<Param> header_includes;
    int i = 0;

    for (auto module: SCAM::ModelGlobal::getModel()->getModules()) {
            header_includes.push_back(Param());
//            if(std::find(header_includes.begin()->Name, header_includes.end()->Name, test_name) != header_includes.end()->Name)
//                header_includes[i].Name = line;
            header_includes[i].Name = module.second->getName();
        std::cout<< "gets called" << header_includes[i].Name << std::endl;

            header_includes[i].result = (module.second);

            std::cout << "Number of modules: " << header_includes[i].result << std::endl;
        i++;

    }

    return header_includes;
}


class PrintSkeleton_Test : public ::testing::TestWithParam<Param>  {
public:
    std::vector<SCAM::Module *> result;
    SCAM::Module * module;
    struct PrintToStringParamName
    {
        template <class ParamType>
        std::string operator()( const testing::TestParamInfo<ParamType>& info ) const
        {
            auto Parameter = static_cast<Param>(info.param);
            return Parameter.Name;
        }
    };

    static void SetUpTestCase() {

    }

    static void TearDownTestCase() {
    }

    void SetUp() {

    }

    void TearDown() {
    }
};



INSTANTIATE_TEST_CASE_P(Basic, PrintSkeleton_Test,
        ::testing::ValuesIn(parameter(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/Tests.h")),
        ::testing::PrintToStringParamName());


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
//    ASSERT_TRUE(SCAM::ModelGlobal::getModel()->getModules().size() == 1);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    ASSERT_NE(GetParam().result, nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam().Name << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + GetParam().Name + "_types.vhdl");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" << SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + module->getName() + "_types.vhdl";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printLocalTypes(GetParam().result));
    ASSERT_EQ(content, result.second) << "Test for types " << GetParam().Name << "_types failed\n\n" << result.second;
    std::cout << "" << std::endl;
}

//TEST_P(PrintSkeleton_Test, LocalTypesSV) {
//    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
//    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
//    ASSERT_NE(module, nullptr) << "Module not found";
//    std::cout << "Instance: " << module->getName() << std::endl;
//    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/" + module->getName() + "_types.sv");
//    ASSERT_TRUE(bool(ifs)) << "Can't open file";
//
//    std::stringstream buffer;
//    std::string content((std::istreambuf_iterator<char>(ifs)),
//                        (std::istreambuf_iterator<char>()));
//    while (content[content.length()-1] == '\n') {
//        content.erase(content.length()-1);
//    }
//
//    PrintSkeleton printSkeleton;
//    std::pair<std::string, std::string> result;
//    ASSERT_NO_THROW(result = printSkeleton.printLocalTypes(module));
//    ASSERT_EQ(content, result.second) << "Test for types " << module->getName() << "_types failed\n\n" << result.second;
//    std::cout << "" << std::endl;
//}
//
//TEST_P(PrintSkeleton_Test, ModuleVHDL) {
//    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
//    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
//    ASSERT_NE(module, nullptr) << "Module not found";
//    std::cout << "Instance: " << module->getName() << std::endl;
//    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + module->getName() + ".vhdl");
//    ASSERT_TRUE(bool(ifs)) << "Can't open file" + module->getName() + ".vhdl";
//
//    std::stringstream buffer;
//    std::string content((std::istreambuf_iterator<char>(ifs)),
//                        (std::istreambuf_iterator<char>()));
//    while (content[content.length()-1] == '\n') {
//        content.erase(content.length()-1);
//    }
//
//    PrintSkeleton printSkeleton;
//    std::pair<std::string, std::string> result;
//    ASSERT_NO_THROW(result = printSkeleton.printModule(module));
//    ASSERT_EQ(content, result.second) << "Test for types " << module->getName() << " failed\n\n" << result.second;
//    std::cout << "" << std::endl;
//
//}
//TEST_P(PrintSkeleton_Test, ModuleSV) {
//    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
//    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
//
//    ASSERT_NE(module, nullptr) << "Module not found";
//    std::cout << "Instance: " << module->getName() << std::endl;
//    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/" + module->getName() + ".sv");
//    ASSERT_TRUE(bool(ifs)) << "Can't open file" + module->getName() + ".sv";
//
//    std::stringstream buffer;
//    std::string content((std::istreambuf_iterator<char>(ifs)),
//                        (std::istreambuf_iterator<char>()));
//    //std::string content(std::istreambuf_iterator<char>(ifs));
//    while (content[content.length()-1] == '\n') {
//        content.erase(content.length()-1);
//    }
//
//    PrintSkeleton printSkeleton;
//    std::pair<std::string, std::string> result;
//    ASSERT_NO_THROW(result = printSkeleton.printModule(module));
//    ASSERT_EQ(content, result.second) << "Test for types " << module->getName() << " failed\n\n" << result.second;
//    std::cout << "" << std::endl;
//
//}


#endif //PROJECT_PRINTSKELETONSV_TEST_H
