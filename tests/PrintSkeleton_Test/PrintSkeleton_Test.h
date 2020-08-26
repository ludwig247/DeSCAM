
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
    std::string FilePath;
    std::string Name;
    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.Name;}
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


    //SRC-File to be analyzed
    std::ifstream ifs(header_list);

    std::string line;
    std::vector<Param> header_includes;
    int i = 0;

    while (std::getline(ifs, line)) {
        if (line.find("#include")== 0){
            int key1 = line.find_first_of("\"");
            int key2 = line.find_last_of("\"") - key1;
            std::string test_name = line.substr(key1+1, key2);
            const size_t period = test_name.rfind(".");
            if(std::string::npos != period) test_name.erase(period);
            std::cout<<test_name<< std::endl;
            header_includes.push_back(Param());
            header_includes[i].FilePath = line;
//            if(std::find(header_includes.begin()->Name, header_includes.end()->Name, test_name) != header_includes.end()->Name)
//                header_includes[i].Name = line;
            header_includes[i].Name = test_name;
            i++;
        }
    }
    ifs.close();

    return header_includes;
}


class PrintSkeleton_Test : public ::testing::TestWithParam<Param>  {
public:
    std::vector<SCAM::Module *> result;
    SCAM::Module * module = result.back();

    struct PrintToStringParamName
    {
        template <class ParamType>
        std::string operator()( const testing::TestParamInfo<ParamType>& info ) const
        {
            auto Parameter = static_cast<Param>(info.param);
            return Parameter.Name;
        }
    };
//    PrintSkeleton_Test() {
//
//    }
    static void SetUpTestCase() {
    std::vector<const char *> commandLineArugmentsVector;

    //Binary
    std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
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



    for(auto module: ModelGlobal::getModel()->getModules()){
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
    }
    }

    static void TearDownTestCase() {
    }

    void SetUp() {
        for (auto module: SCAM::ModelGlobal::getModel()->getModules()) {
            result.push_back(module.second);
        }
        std::cout << "Number of modules: " << result.size() << std::endl;
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
    ASSERT_NE(module, nullptr) << "Module not found";
    std::cout << "Instance: " << module->getName() << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + module->getName() + "_types.vhdl");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" << SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + module->getName() + "_types.vhdl";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printLocalTypes(module));
    ASSERT_EQ(content, result.second) << "Test for types " << module->getName() << "_types failed\n\n" << result.second;
    std::cout << "" << std::endl;
}

TEST_P(PrintSkeleton_Test, LocalTypesSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
    ASSERT_NE(module, nullptr) << "Module not found";
    std::cout << "Instance: " << module->getName() << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/" + module->getName() + "_types.sv");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printLocalTypes(module));
    ASSERT_EQ(content, result.second) << "Test for types " << module->getName() << "_types failed\n\n" << result.second;
    std::cout << "" << std::endl;
}

TEST_P(PrintSkeleton_Test, ModuleVHDL) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    ASSERT_NE(module, nullptr) << "Module not found";
    std::cout << "Instance: " << module->getName() << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/vhdl/" + module->getName() + ".vhdl");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" + module->getName() + ".vhdl";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printModule(module));
    ASSERT_EQ(content, result.second) << "Test for types " << module->getName() << " failed\n\n" << result.second;
    std::cout << "" << std::endl;

}
TEST_P(PrintSkeleton_Test, ModuleSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);

    ASSERT_NE(module, nullptr) << "Module not found";
    std::cout << "Instance: " << module->getName() << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/sv/" + module->getName() + ".sv");
    ASSERT_TRUE(bool(ifs)) << "Can't open file" + module->getName() + ".sv";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    //std::string content(std::istreambuf_iterator<char>(ifs));
    while (content[content.length()-1] == '\n') {
        content.erase(content.length()-1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printModule(module));
    ASSERT_EQ(content, result.second) << "Test for types " << module->getName() << " failed\n\n" << result.second;
    std::cout << "" << std::endl;

}


#endif //PROJECT_PRINTSKELETONSV_TEST_H
