
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
#include "../../src/global/Logger/ConsoleSink.h"
#include "../../src/global/Logger/FileSink.h"

#include <PrintSkeleton/PrintSkeleton.h>


#include "FindFunctions.h"
#include "FindInitialValues.h"
#include "FindModules.h"
#include "FindNewDatatype.h"
#include "FindPorts.h"
#include "FindGlobal.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "FindInstances.h"
#include "FindStateName.h"

struct Param
{
    std::string Name;
    std::string FilePath;
    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.FilePath;
    }
};

static std::vector<Param> parameter(const char* header_list) {

    //SRC-File to be analyzed
    std::ifstream ifs(header_list);
    std::set<std::string> param_names;
    std::set<std::string> filepaths;

    std::string line;
    std::vector<Param> includes;
    int i = 0;

    while (std::getline(ifs, line)) {
        if (!line.empty() && (line.find("//") != 0) && (filepaths.count(line) == 0)){
            size_t pos;

            pos = line.rfind("/ESL");
            if (line.rfind("/ESL") == std::string::npos )
                pos = line.rfind("/TestCases");

            const size_t lpos = line.find_last_of('/', pos-1);
            std::string example_name = line.substr( lpos + 1, pos - lpos - 1);
//            std::cout << example_name << " at " << pos << " or " << lpos << std::endl;

            std::string test_name = line.substr(line.find_last_of("/\\") + 1);
            const size_t period = test_name.rfind(".");
            if(std::string::npos != period) test_name.erase(period);
            includes.push_back(Param());
            includes[i].FilePath = line;


            if(param_names.count(test_name) == 1){
                std::cout<< "Warning: possible duplicate of test name" << includes[i].Name << std::endl;
                includes[i].Name = example_name + "_" + test_name;
//                includes[i].Name.append("/" + test_name );
            }
            else  includes[i].Name = test_name;
            param_names.insert(includes[i].Name);
            filepaths.insert(line);

            i++;
        }
    }
    ifs.close();

    return includes;
}


class PrintSkeletonParam : public ::testing::TestWithParam<Param>  {
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
    virtual void SetUp() override {
      DESCAM::DataTypes::reset();
        const char *commandLineArgumentsArray[2];

        //Binary
        std::string bin = std::string(SCAM_HOME"/bin/SCAM");
        commandLineArgumentsArray[0] = (bin.c_str());
        commandLineArgumentsArray[1] = (GetParam().FilePath.c_str());


      //Compositional root
      std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
      std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
      std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
      std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
      std::unique_ptr<IFindDataFlowFactory>
          find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
      std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
      std::unique_ptr<IFindInitialValues>
          find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
      std::unique_ptr<IFindFunctions> find_functions =
          std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
      std::unique_ptr<IFindVariables> find_variables =
          std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());
      std::unique_ptr<IFindModules> find_modules =
          std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
      std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

      auto model_factory = new ModelFactory(
          find_modules.get(),
          find_global.get(),
          find_instances.get());

      //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
    DESCAM::ModelGlobal::createModel(2, commandLineArgumentsArray[0], commandLineArgumentsArray[1], model_factory);


    // write log messages to all sinks
    if (DESCAM::Logger::hasFeedback()) {
        DESCAM::Logger::log();}

    for(auto foo: ModelGlobal::getModel()->getModules()) {
        ASSERT_FALSE(DESCAM::Logger::hasFeedback() == true) << foo.second->getName()<< " has errors: check logger";
    }

     for (auto module: DESCAM::ModelGlobal::getModel()->getModules()) {
            {
                CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
                CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
                PrintSkeleton printSkeleton;
                auto result = printSkeleton.printModule(module.second);
                std::ofstream moduleString;
                moduleString.open(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/unsorted/vhdl/" + result.first);
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
                moduleString.open(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/unsorted/sv/" + result.first);
                moduleString << result.second;
                moduleString.close();

                result = printSkeleton.printLocalTypes(module.second);
                std::ofstream functionString;
                functionString.open(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/unsorted/sv/" + result.first);
                functionString << result.second;
                functionString.close();
            }
        }
        for (auto module: DESCAM::ModelGlobal::getModel()->getModules()) {
            results.push_back(module.second);
        }
        std::cout << "Number of modules: " << results.size() << std::endl;
        std::cout << "" << std::endl;
    }
    void TearDown() {
        DESCAM::Logger::clear();

        //DESCAM::ModelGlobal::reset();
    }
protected:    std::vector<DESCAM::Module *> results;
};

class PrintSkeletonGlobal : public ::testing::Test {
protected:
    static void SetUpTestCase() {
        const char *commandLineArgumentsArray[2];

        //Binary
        std::string bin = std::string(SCAM_HOME"/bin/SCAM");
        commandLineArgumentsArray[0] = (bin.c_str());
        commandLineArgumentsArray[1] = (SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/tests.h");


        //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
      //Compositional root
      std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
      std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
      std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
      std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
      std::unique_ptr<IFindDataFlowFactory>
          find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
      std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
      std::unique_ptr<IFindInitialValues>
          find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
      std::unique_ptr<IFindFunctions> find_functions =
          std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
      std::unique_ptr<IFindVariables> find_variables =
          std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());
      std::unique_ptr<IFindModules> find_modules =
          std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
      std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

      auto model_factory = new ModelFactory(
          find_modules.get(),
          find_global.get(),
          find_instances.get());

      DESCAM::ModelGlobal::createModel(2, commandLineArgumentsArray[0],
                                         commandLineArgumentsArray[1],model_factory);


        for (auto module: ModelGlobal::getModel()->getModules()) {
            {
                CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
                CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
                PrintSkeleton printSkeleton;
                auto result = printSkeleton.printModule(module.second);
                std::ofstream moduleString;
                moduleString.open(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/unsorted/vhdl/" + result.first);
                moduleString << result.second;
                moduleString.close();

                result = printSkeleton.printLocalTypes(module.second);
                std::ofstream functionString;
                functionString.open(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/unsorted/vhdl/" + result.first);
                functionString << result.second;
                functionString.close();
            }

            {
                CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
                CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);

                PrintSkeleton printSkeleton;
                auto result = printSkeleton.printModule(module.second);
                std::ofstream moduleString;
                moduleString.open(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/unsorted/sv/" + result.first);
                moduleString << result.second;
                moduleString.close();

                result = printSkeleton.printLocalTypes(module.second);
                std::ofstream functionString;
                functionString.open(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/unsorted/sv/" + result.first);
                functionString << result.second;
                functionString.close();
            }
        }
    }
    static void TearDownTestCase(){
                //DESCAM::ModelGlobal::reset();
    }
};


INSTANTIATE_TEST_SUITE_P(Basic, PrintSkeletonParam,
        ::testing::ValuesIn(parameter(SCAM_HOME"/tests/TestCases/functionality_tests.list")),
        ::PrintSkeletonParam::PrintToStringParamName());


TEST_F(PrintSkeletonGlobal, GlobalTypesVHDL) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    std::cout << "Global types " << std::endl;
    std::ifstream ifs(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/vhdl/globalTypes.vhdl");
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

TEST_F(PrintSkeletonGlobal, GlobalTypesSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
    //ASSERT_NE(GetParam(), nullptr) << "Module not found";
    //std::cout << "Global types: " << DESCAM::ModelGlobal::getModel()->getName() << std::endl;
    std::cout << "Global types " << std::endl;
    //for (auto module: DESCAM::ModelGlobal::getModel()->getModules()) {
    std::ifstream ifs(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/sv/globalTypes.sv");
    ASSERT_TRUE(bool(ifs)) << "Can't open file";

    std::stringstream buffer;
    std::string content((std::istreambuf_iterator<char>(ifs)),
                        (std::istreambuf_iterator<char>()));
    while (content[content.length() - 1] == '\n') {
        content.erase(content.length() - 1);
    }

    PrintSkeleton printSkeleton;
    std::pair<std::string, std::string> result;
    ASSERT_NO_THROW(result = printSkeleton.printGlobalTypes(DESCAM::ModelGlobal::getModel()));
    //ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << "_types failed\n\n" << result.second;
    ASSERT_EQ(content, result.second)
                                << "Test for types " << DESCAM::ModelGlobal::getModel()->getName() << " failed\n\n"
                                << result.second;
    std::cout << "" << std::endl;
}


TEST_F(PrintSkeletonGlobal, GlobalDefinesVHDL) {
  CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
  CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
  std::cout << "Global types " << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/vhdl/globalDefines.vhdl");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));
  while (content[content.length()-1] == '\n') {
    content.erase(content.length()-1);
  }

  PrintSkeleton printSkeleton;
  std::pair<std::string, std::string> result;
  ASSERT_NO_THROW(result = printSkeleton.printGlobalDefines(DESCAM::ModelGlobal::getModel()));
  //ASSERT_EQ(content, result.second) << "Test for types " << GetParam()->getName() << "_types failed\n\n" << result.second;
  ASSERT_EQ(content, result.second) << "Test for types " << DESCAM::ModelGlobal::getModel()->getName() << " failed\n\n" << result.second;
  std::cout << "" << std::endl;
}

    
TEST_P(PrintSkeletonParam, LocalTypesVHDL) {

    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);

    ASSERT_TRUE(results.size() != 0);
    for (auto res: results) {
        DESCAM::Module *module = res;
        ASSERT_NE(module, nullptr) << "Module not found";
        std::cout << "Instance: " << module->getName() << std::endl;
        std::ifstream ifs(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/vhdl/" + module->getName() + "_types.vhdl");
        ASSERT_TRUE(bool(ifs)) << "Can't open file"
                               << SCAM_HOME"plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/vhdl/" + module->getName() +
                                  "_types.vhdl";

        std::stringstream buffer;
        std::string content((std::istreambuf_iterator<char>(ifs)),
                            (std::istreambuf_iterator<char>()));
        while (content[content.length() - 1] == '\n') {
            content.erase(content.length() - 1);
        }

        PrintSkeleton printSkeleton;
        std::pair<std::string, std::string> result;
        ASSERT_NO_THROW(result = printSkeleton.printLocalTypes(module));
        ASSERT_EQ(content, result.second)
                                    << "Test for types " << module->getName() << "_types failed\n\n" << result.second;
        std::cout << "" << std::endl;
    }
}

TEST_P(PrintSkeletonParam, LocalTypesSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
    ASSERT_TRUE(results.size() != 0);
    for (auto res: results) {
        DESCAM::Module *module = res;
        ASSERT_NE(module, nullptr) << "Module not found";
        std::cout << "Instance: " << module->getName() << std::endl;
        std::ifstream ifs(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/sv/" + module->getName() + "_types.sv");
        ASSERT_TRUE(bool(ifs)) << "Can't open file";

        std::stringstream buffer;
        std::string content((std::istreambuf_iterator<char>(ifs)),
                            (std::istreambuf_iterator<char>()));
        while (content[content.length() - 1] == '\n') {
            content.erase(content.length() - 1);
        }

        PrintSkeleton printSkeleton;
        std::pair<std::string, std::string> result;
        ASSERT_NO_THROW(result = printSkeleton.printLocalTypes(module));
        ASSERT_EQ(content, result.second)
                                    << "Test for types " << module->getName() << "_types failed\n\n" << result.second;
        std::cout << "" << std::endl;
    }
}

TEST_P(PrintSkeletonParam, ModuleVHDL) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
    ASSERT_TRUE(results.size() != 0);
    for (auto res: results) {
        DESCAM::Module *module = res;
        ASSERT_NE(module, nullptr) << "Module not found";
        std::cout << "Instance: " << module->getName() << std::endl;
        std::ifstream ifs(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/vhdl/" + module->getName() + ".vhdl");
        ASSERT_TRUE(bool(ifs)) << "Can't open file" + module->getName() + ".vhdl";

        std::stringstream buffer;
        std::string content((std::istreambuf_iterator<char>(ifs)),
                            (std::istreambuf_iterator<char>()));
        while (content[content.length() - 1] == '\n') {
            content.erase(content.length() - 1);
        }

        PrintSkeleton printSkeleton;
        std::pair<std::string, std::string> result;
        ASSERT_NO_THROW(result = printSkeleton.printModule(module));
        ASSERT_EQ(content, result.second) << "Test for types " << module->getName() << " failed\n\n" << result.second;
        std::cout << "" << std::endl;
    }
}
TEST_P(PrintSkeletonParam, ModuleSV) {
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
    CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);
    ASSERT_TRUE(results.size() != 0);
    for (auto res: results) {
            DESCAM::Module *module = res;
            ASSERT_NE(module, nullptr) << "Module not found";
            std::cout << "Instance: " << module->getName() << std::endl;
            std::ifstream ifs(SCAM_HOME"/tests/plugin/PrintSkeleton/PrintSkeleton_Tests/TestCases/sv/" + module->getName() + ".sv");
            ASSERT_TRUE(bool(ifs)) << "Can't open file" + module->getName() + ".sv";

            std::stringstream buffer;
            std::string content((std::istreambuf_iterator<char>(ifs)),
                                (std::istreambuf_iterator<char>()));
            //std::string content(std::istreambuf_iterator<char>(ifs));
            while (content[content.length() - 1] == '\n') {
                content.erase(content.length() - 1);
            }

            PrintSkeleton printSkeleton;
            std::pair<std::string, std::string> result;
            ASSERT_NO_THROW(result = printSkeleton.printModule(module));
            ASSERT_EQ(content, result.second)
                                        << "Test for types " << module->getName() << " failed\n\n" << result.second;
            std::cout << "" << std::endl;
        }
}


#endif //PROJECT_PRINTSKELETONSV_TEST_H
