//
// Created by tom on 03.11.20.
//

#ifndef SCAM_PRINTSVA_TEST_H
#define SCAM_PRINTSVA_TEST_H


#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>
#include <FatalError.h>
#include "../../src/global/Logger/ConsoleSink.h"
#include "../../src/global/Logger/FileSink.h"

//#include "MockIFindSCMain.h"
//#include "MockIFindInitialValues.h"
//#include "MockIFindFunctions.h"

#include "ModelFactory.h"

#include "FindFunctions.h"
#include "FindInitialValues.h"
#include "FindModules.h"
#include "FindNewDatatype.h"
#include "FindPorts.h"
#include "FindGlobal.h"
#include "FindNetlist.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "FindSCMain.h"

#include <PrintSVA/PrintSVA.h>


struct Param
{
    std::string FilePath;
    std::string Name;
    friend std::ostream& operator<<(std::ostream& os, const Param& bar) {
        return os << bar.FilePath;
    }
};


static std::vector<Param> parameter(const char* header_list) {
    std::ifstream ifs(header_list);
    std::set<std::string> param_names;
    std::set<std::string> filepaths;

    std::string line;
    std::vector<Param> includes;
    int i = 0;

    while (std::getline(ifs, line)) {
        if (!line.empty() && (line.find("//") != 0) && (filepaths.count(line) == 0)) {
            size_t pos;

            pos = line.rfind("/ESL");
            if (line.rfind("/ESL") == std::string::npos)
                pos = line.rfind("/TestCases");

            const size_t lpos = line.find_last_of('/', pos - 1);
            std::string example_name = line.substr(lpos + 1, pos - lpos - 1);

            std::string test_name = line.substr(line.find_last_of("/\\") + 1);
            const size_t period = test_name.rfind(".");
            if (std::string::npos != period) test_name.erase(period);
            includes.push_back(Param());
            includes[i].FilePath = line;

            if (param_names.count(test_name) == 1) {
                std::cout << "Warning: possible duplicate of test name " << includes[i].Name << std::endl;
                includes[i].Name = example_name + "_" + test_name;
            }
            else {
                includes[i].Name = test_name;
            }

            param_names.insert(includes[i].Name);
            filepaths.insert(line);

            i++;
        }
    }

    ifs.close();

    return includes;
}


class SVATest : public ::testing::TestWithParam<Param> {
public:
    struct PrintToStringParamName
    {
        template <class ParamType>
        std::string operator()(const testing::TestParamInfo<ParamType>& info) const
        {
            auto Parameter = static_cast<Param>(info.param);
            return Parameter.Name;
        }
    };


    DESCAM::Model *resultModel;


    void SetUp() {
        std::unique_ptr<IFindFunctions> find_functions = std::make_unique<FindFunctions>();
        std::unique_ptr<IFindInitialValues> find_initial_values = std::make_unique<FindInitialValues>();
        std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
        std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
        std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
        std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
        std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
        std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
        std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
        std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
        std::unique_ptr<IFindVariables> find_variables =
                std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());

        auto model_factory = new ModelFactory(find_functions.get(),
                                              find_initial_values.get(),
                                              find_modules.get(),
                                              find_new_datatype.get(),
                                              find_ports.get(),
                                              find_global.get(),
                                              find_netlist.get(),
                                              find_process.get(),
                                              find_variables.get(),
                                              find_sc_main.get(),
                                              find_data_flow_factory.get());

        DataTypes::reset();

        std::vector<const char *> command_line_arguments_vector;

        const std::string bin = std::string(SCAM_HOME"/bin/DESCAM");
        command_line_arguments_vector.push_back(bin.c_str());

        const std::string file_path = GetParam().FilePath.c_str();
        command_line_arguments_vector.push_back(file_path.c_str());

        const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
        for (int i = 0; i < command_line_arguments_vector.size(); i++) {
            commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
        }

        ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                         commandLineArgumentsArray[0],
                                                         commandLineArgumentsArray[1],
                                                         model_factory));

        if (DESCAM::Logger::hasFeedback()) {
            DESCAM::Logger::log();
        }

        resultModel = ModelGlobal::getModel();
    }

    void TearDown() {
        DESCAM::Logger::clear();
    }
};


class SVATestFunctionality : public SVATest {};


INSTANTIATE_TEST_CASE_P(
        Functionality,
        SVATestFunctionality,
        testing::ValuesIn(parameter(SCAM_HOME"/tests/Print_SVA_Tests/functionality_tests.list")),
        SVATest::PrintToStringParamName()
        );


TEST_P(SVATestFunctionality, Functionality) {
    PrintSVA printSVA;

    std::map<std::basic_string<char>, std::basic_string<char>> svaOutput = printSVA.printModel(resultModel);
    for (auto module: resultModel->getModules()) {
        // Properties
        // Get generated properties
        std::map<std::basic_string<char>, std::basic_string<char>>::iterator propertiesIt = svaOutput.find(module.first + ".sva");
        ASSERT_FALSE(propertiesIt == svaOutput.end()) << "No properties file generated for module " << module.first;
        std::string generatedProperties = svaOutput[module.first + ".sva"];
        // Get properties to compare
        std::ifstream propertiesIfs(SCAM_HOME"/tests/Print_SVA_Tests/sva/" + module.first + ".sva");
        ASSERT_TRUE(bool(propertiesIfs)) << "Can't open file: " << SCAM_HOME"/tests/Print_SVA_Tests/sva/" << module.first << ".sva";
        std::string compareProperties((std::istreambuf_iterator<char>(propertiesIfs)), (std::istreambuf_iterator<char>()));
        // Compare
        ASSERT_EQ(generatedProperties, compareProperties) << "Test for module " << module.first << " failed (properties)";

        // Local types
        // Get generated local types
        std::map<std::basic_string<char>, std::basic_string<char>>::iterator typesIt = svaOutput.find(module.first + "_types.sva");
        ASSERT_FALSE(typesIt == svaOutput.end()) << "No local types file generated for module " << module.first;
        std::string generatedTypes = svaOutput[module.first + "_types.sva"];
        // Get local types to compare
        std::ifstream typesIfs(SCAM_HOME"/tests/Print_SVA_Tests/sva/" + module.first + "_types.sva");
        ASSERT_TRUE(bool(typesIfs)) << "Can't open file: " << SCAM_HOME"/tests/Print_SVA_Tests/sva/" << module.first << "_types.sva";
        std::string compareTypes((std::istreambuf_iterator<char>(typesIfs)), (std::istreambuf_iterator<char>()));
        // Compare
        ASSERT_EQ(generatedTypes, compareTypes) << "Test for module " << module.first << " failed (types)";

        // Macros
        // Get generated macros
        std::map<std::basic_string<char>, std::basic_string<char>>::iterator  macrosIt = svaOutput.find(module.first + "_macros.sva");
        ASSERT_FALSE(macrosIt == svaOutput.end()) << "No macros file generated for module " << module.first;
        std::string generatedMacros = svaOutput[module.first + "_macros.sva"];
        // Get macros to compare
        std::ifstream macrosIfs(SCAM_HOME"/tests/Print_SVA_Tests/sva/" + module.first + "_macros.sva");
        ASSERT_TRUE(bool(macrosIfs)) << "Can't open file: " << SCAM_HOME"/tests/Print_SVA_Tests/sva/" << module.first << "_macros.sva";
        std::string compareMacros((std::istreambuf_iterator<char>(macrosIfs)), (std::istreambuf_iterator<char>()));
        // Compare
        ASSERT_EQ(generatedMacros, compareMacros) << "Test for module " << module.first << " failed (macros)";

        // Functions
        // Get generated functions
        std::map<std::basic_string<char>, std::basic_string<char>>::iterator  functionsIt = svaOutput.find(module.first + "_functions.sva");
        ASSERT_FALSE(functionsIt == svaOutput.end()) << "No functions file generated for module " << module.first;
        std::string generatedFunctions = svaOutput[module.first + "_functions.sva"];
        // Get functions to compare
        std::ifstream functionsIfs(SCAM_HOME"/tests/Print_SVA_Tests/sva/" + module.first + "_functions.sva");
        ASSERT_TRUE(bool(functionsIfs)) << "Can't open file: " << SCAM_HOME"/tests/Print_SVA_Tests/sva/" << module.first << "_functions.sva";
        std::string compareFunctions((std::istreambuf_iterator<char>(functionsIfs)), (std::istreambuf_iterator<char>()));
        //Compare
        ASSERT_EQ(generatedFunctions, compareFunctions) << "Test for module " << module.first << " failed (functions)";
    }
}


#endif //SCAM_PRINTSVA_TEST_H
