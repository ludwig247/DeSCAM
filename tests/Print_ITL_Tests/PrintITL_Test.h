
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H

#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>
#include <FatalError.h>
#include "../../src/global/Logger/ConsoleSink.h"
#include "../../src/global/Logger/FileSink.h"


#include "MockIFindSCMain.h"
#include "MockIFindInitialValues.h"
#include "MockIFindFunctions.h"

#include "ModelFactory.h"

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

#include <PrintITL/PrintITL.h>

struct Param
{
    std::string FilePath;
    std::string Name;
    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.FilePath;}
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


class ITLTest : public ::testing::TestWithParam<Param> {
public:
    std::vector<DESCAM::Module *> results;
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
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());
  std::unique_ptr<IFindModules>
      find_modules =
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());

      auto model_factory = new ModelFactory(
                                            find_modules.get(),
                                            find_global.get(),
                                            find_instances.get());



      DataTypes::reset();

      std::vector<const char *> command_line_arguments_vector;

      //Binary
      const std::string bin = std::string(SCAM_HOME"/bin/DESCAM");
      command_line_arguments_vector.push_back(bin.c_str());


      //SRC-File to be analyzed
      const std::string file_path = GetParam().FilePath.c_str();
      command_line_arguments_vector.push_back(file_path.c_str());

      //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
      const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
      for (int i = 0; i < command_line_arguments_vector.size(); i++) {
        commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
      }

      ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                       commandLineArgumentsArray[0],
                                                       commandLineArgumentsArray[1],
                                                       model_factory));

        // write log messages to all sinks
        if (DESCAM::Logger::hasFeedback()) {
            DESCAM::Logger::log();
            }
    for(auto module: ModelGlobal::getModel()->getModules()) {
        results.push_back(module.second);
        ASSERT_FALSE(DESCAM::Logger::hasFeedback() == true) << module.second->getName()<< " has errors: check logger";
    }

//    add optimizations
//        std::set<std::string> optimizeOptions = {"all"};
//        CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);


    }
    void TearDown() {
        DESCAM::Logger::clear();
        //DESCAM::ModelGlobal::reset(); //TODO: needed?
    }
};


class ITLTestExamples : public ITLTest {};

class ITLTestFunctionality : public ITLTest {};

INSTANTIATE_TEST_CASE_P(
//        DISABLED_Examples,
        Examples,
        ITLTestExamples,
        testing::ValuesIn(parameter(SCAM_HOME"/tests/Print_ITL_Tests/tests.list")),
        ITLTest::PrintToStringParamName()
                );

INSTANTIATE_TEST_CASE_P(
//        DISABLED_Functionality,
        Functionality,
        ITLTestFunctionality,
        testing::ValuesIn(parameter(SCAM_HOME"/tests/Print_ITL_Tests/functionality_tests.list")),
        ITLTest::PrintToStringParamName()
        );

TEST_P(ITLTestExamples, Examples) {
    ASSERT_TRUE(DESCAM::ModelGlobal::getModel()->getModules().size() == 1);
    PrintITL printITL;
    for (auto result: results) {
        DESCAM::Module *module = result;
        printITL.printModule(module);
        printITL.print();
        ASSERT_NO_THROW(printITL.print());
        std::ofstream myfile;
        myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + module->getName() + ".vhi");
        myfile << printITL.print();
        myfile.close();

        ASSERT_NE(module, nullptr) << "Module not found";
        std::cout << "Instance: " << module->getName() << std::endl;

//    std::ifstream ifs(SCAM_HOME"/example/" + module->getName() +"/RTL/properties/" + module->getName() + ".vhi");
        std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/vhi/" + module->getName() + ".vhi");
        ASSERT_TRUE(bool(ifs)) << "Can't open file: " << SCAM_HOME"/tests/Print_ITL_Tests/vhi/"
                               << module->getName() << ".vhi";

        std::stringstream buffer;
        std::string content((std::istreambuf_iterator<char>(ifs)),
                            (std::istreambuf_iterator<char>()));

        ASSERT_EQ(content, printITL.print())
                                    << "Test for module " << module->getName() << " failed\n\n" << printITL.print();
        std::cout << "" << std::endl;
    }
}

TEST_P(ITLTestFunctionality, Functionality) {
    ASSERT_TRUE(DESCAM::ModelGlobal::getModel()->getModules().size() == 1);
    PrintITL printITL;
    for (auto result: results) {
        DESCAM::Module *module = result;
        printITL.printModule(module);
        printITL.print();
        ASSERT_NO_THROW(printITL.print());
        std::ofstream myfile;
        myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + module->getName() + ".vhi");
        myfile << printITL.print();
        myfile.close();

        ASSERT_NE(module, nullptr) << "Module not found";
        std::cout << "Instance: " << module->getName() << std::endl;

        //    std::ifstream ifs(SCAM_HOME"/example/" + module->getName() +"/RTL/properties/" + module->getName() + ".vhi");
        std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/vhi/" + module->getName() + ".vhi");
        ASSERT_TRUE(bool(ifs)) << "Can't open file: " << SCAM_HOME"/tests/Print_ITL_Tests/vhi/"
                               << module->getName() << ".vhi";

        std::stringstream buffer;
        std::string content((std::istreambuf_iterator<char>(ifs)),
                            (std::istreambuf_iterator<char>()));

        ASSERT_EQ(content, printITL.print())
                                    << "Test for module " << module->getName() << " failed\n\n" << printITL.print();
        std::cout << "" << std::endl;
    }
    }

#endif //PROJECT_PRINTITL_TEST_H
