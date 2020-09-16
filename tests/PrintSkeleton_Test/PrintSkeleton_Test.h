
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
    DESCAM::Module * result;
//    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
//        return os << bar.Name;
//    }
};

static std::vector<DESCAM::Module *> parameter() {

    std::vector<DESCAM::Module *> result;
    for (auto module: DESCAM::ModelGlobal::getModel()->getModules()) {
        result.push_back(module.second);
    }
    std::cout << "Number of modules: " << result.size() << std::endl;
    return result;
}

static std::vector<Param> parameter(const char* header_list) {

    std::vector<Param> includes;
    int i = 0;
    std::ifstream ifs(header_list);

    std::string line;


//    while (std::getline(ifs, line)) {
//        if (line.size() > 0 && !(line.find("//") == 0)) {

    const char *commandLineArgumentsArray[2];

    //Binary
    std::string bin = std::string(SCAM_HOME"/bin/SCAM");
    commandLineArgumentsArray[0] = (bin.c_str());
    commandLineArgumentsArray[1] = (header_list);


    //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    DESCAM::ModelGlobal::createModel(2, commandLineArgumentsArray[0],
                                   commandLineArgumentsArray[1]);

            for (auto module: ModelGlobal::getModel()->getModules()) {
                {
                    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
                    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
                    PrintSkeleton printSkeleton;
                    auto result = printSkeleton.printModule(module.second);
                    std::ofstream moduleString;
                    moduleString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/vhdl/" + result.first);
                    moduleString << result.second;
                    moduleString.close();

                    result = printSkeleton.printLocalTypes(module.second);
                    std::ofstream functionString;
                    functionString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/vhdl/" + result.first);
                    functionString << result.second;
                    functionString.close();
                }

                {
                    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
                    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);

                    PrintSkeleton printSkeleton;
                    auto result = printSkeleton.printModule(module.second);
                    std::ofstream moduleString;
                    moduleString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/sv/" + result.first);
                    moduleString << result.second;
                    moduleString.close();

                    result = printSkeleton.printLocalTypes(module.second);
                    std::ofstream functionString;
                    functionString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/sv/" + result.first);
                    functionString << result.second;
                    functionString.close();
                }
                includes.push_back(Param());
//            if(std::find(header_includes.begin()->Name, header_includes.end()->Name, test_name) != header_includes.end()->Name)
//                includes[i].FilePath = line;
                includes[i].Name = module.second->getName();
                includes[i].result = (module.second);
//                std::cout << "gets called" << includes[i].Name << std::endl;

                i++;
            }

//        }
//    }
//    ifs.close();
        std::cout << "Number of modules: " << includes.size() << std::endl;
        std::cout << "" << std::endl;
    return includes;
}


class PrintSkeleton_Test : public ::testing::TestWithParam<Param>  {
public:

    struct PrintToStringParamName
    {
        template <class ParamType>
        std::string operator()( const testing::TestParamInfo<ParamType>& info ) const
        {
            auto Parameter = static_cast<Param>(info.param);
            return Parameter.Name;
        }
    };


    void SetUp() {

    }

    void TearDown() {
    }
};

std::vector<Param> test_includes;

INSTANTIATE_TEST_CASE_P(Basic, PrintSkeleton_Test,
        ::testing::ValuesIn(test_includes),
        ::PrintSkeleton_Test::PrintToStringParamName());


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
    ASSERT_NO_THROW(result = printSkeleton.printGlobalTypes(DESCAM::ModelGlobal::getModel()));
    //ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << "_types failed\n\n" << result.second;
    ASSERT_EQ(content, result.second) << "Test for types " << DESCAM::ModelGlobal::getModel()->getName() << " failed\n\n" << result.second;
    std::cout << "" << std::endl;
}
    
TEST_F(PrintSkeleton_Test, GlobalTypesSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
    //ASSERT_NE(GetParam(), nullptr) << "Module not found";
    //std::cout << "Global types: " << DESCAM::ModelGlobal::getModel()->getName() << std::endl;
    std::cout << "Global types " << std::endl;
    //for (auto module: DESCAM::ModelGlobal::getModel()->getModules()) {
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
    ASSERT_NO_THROW(result = printSkeleton.printGlobalTypes(DESCAM::ModelGlobal::getModel()));
    //ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << "_types failed\n\n" << result.second;
    ASSERT_EQ(content, result.second) << "Test for types " << DESCAM::ModelGlobal::getModel()->getName() << " failed\n\n" << result.second;
    std::cout << "" << std::endl;
}
    
TEST_P(PrintSkeleton_Test, LocalTypesVHDL) {
//    ASSERT_TRUE(SCAM::ModelGlobal::getModel()->getModules().size() == 1);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    ASSERT_NE(GetParam().result, nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam().Name << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + GetParam().Name + "_types.vhdl");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" << SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + GetParam().Name + "_types.vhdl";

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

TEST_P(PrintSkeleton_Test, LocalTypesSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
    ASSERT_NE(GetParam().result, nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam().Name << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/" + GetParam().Name + "_types.sv");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

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

TEST_P(PrintSkeleton_Test, ModuleVHDL) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    ASSERT_NE(GetParam().result, nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam().Name << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + GetParam().Name + ".vhdl");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" + GetParam().Name + ".vhdl";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printModule(GetParam().result));
    ASSERT_EQ(content, result.second) << "Test for types " << GetParam().Name << " failed\n\n" << result.second;
    std::cout << "" << std::endl;

}
TEST_P(PrintSkeleton_Test, ModuleSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);

    ASSERT_NE(GetParam().result, nullptr) << "Module not found";
    std::cout << "Instance: " << GetParam().Name << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/" + GetParam().Name + ".sv");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" + GetParam().Name + ".sv";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    //std::string content(std::istreambuf_iterator<char>(ifs));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printModule(GetParam().result));
    ASSERT_EQ(content, result.second) << "Test for types " << GetParam().Name << " failed\n\n" << result.second;
    std::cout << "" << std::endl;

}


#endif //PROJECT_PRINTSKELETONSV_TEST_H
