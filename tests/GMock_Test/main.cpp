//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>
#include "Config.h"
#include <ModelGlobal.h>
#include <FatalError.h>
#include <PrintITL/PrintITL.h>

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
#include "FindNetlist.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "FindSCMain.h"

TEST(gmock_test, TestCase1) {
  DataTypes::reset();

  std::vector<const char *> command_line_arguments_vector;

  //Binary
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase1.h");
  command_line_arguments_vector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
  for (int i = 0; i < command_line_arguments_vector.size(); i++) {
    commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
  }

  //Compositional root
  std::unique_ptr<IFindFunctions> find_functions = std::make_unique<FindFunctions>();
  std::unique_ptr<IFindInitialValues> find_initial_values = std::make_unique<FindInitialValues>();
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindVariables> find_variables = std::make_unique<FindVariables>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();

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

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                   commandLineArgumentsArray[0],
                                                   commandLineArgumentsArray[1],
                                                   model_factory));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase1");
  print_itl.printModel(ModelGlobal::getModel());
//  Only
  std::ofstream myfile;
  //myfile.open(SCAM_HOME"/tests/GMock_Test/PrintITL/TestCase1.vhi");
  //myfile << print_itl.print();
  //myfile.close();


  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << "TestCase1" << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/GMock_Test/tests/TestCase1.vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << "TestCase1" << " failed\n\n" << print_itl.print();
  std::cout << "" << std::endl;

}

/**
 * Test with Mock-Objects for TestCase1
 */
TEST(mocking_test, TestCase1) {
  using namespace ::testing;
  using ::testing::Return;

  DataTypes::reset();

  std::vector<const char *> command_line_arguments_vector;

  //Binary
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase1.h");
  command_line_arguments_vector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
  for (int i = 0; i < command_line_arguments_vector.size(); i++) {
    commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
  }

  //FindInitialValues
  DESCAM::IntegerValue integer_value(1337);
  DESCAM::MOCK::MockIFindInitialValues find_initial_values;
  EXPECT_CALL(find_initial_values, setup(_, _, _, _, _))
      .Times(1);
  EXPECT_CALL(find_initial_values, getInitValue())
      .Times(1)
      .WillOnce(Return(&integer_value));

  //FindFunctions
  std::map<std::string, clang::CXXMethodDecl *> find_functions_get_function_map_map;
  std::map<std::string, std::string> find_functions_get_function_return_type_map;
  DESCAM::MOCK::MockIFindFunctions find_functions;
  EXPECT_CALL(find_functions, setup(_))
      .Times(1);
  EXPECT_CALL(find_functions, getFunctionMap())
      .Times(2)
      .WillRepeatedly(ReturnRef(find_functions_get_function_map_map));
  EXPECT_CALL(find_functions, getFunctionReturnTypeMap())
      .Times(1)
      .WillOnce(ReturnRef(find_functions_get_function_return_type_map));
  EXPECT_CALL(find_functions, getFunctionParamNameMap())
      .Times(0);
  EXPECT_CALL(find_functions, getFunctionParamTypeMap())
      .Times(0);

  //FindModules
  /*std::map<std::string, clang::CXXRecordDecl *> find_modules_get_module_map;
  DESCAM::MOCK::MockIFindModules find_modules;
  EXPECT_CALL(find_modules, setup(_))
      .Times(1);
  EXPECT_CALL(find_modules, getModuleMap())
      .Times(1);*/

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindVariables> find_variables = std::make_unique<FindVariables>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();

  auto model_factory = new ModelFactory(&find_functions,
                                        &find_initial_values,
                                        find_modules.get(),
                                        find_new_datatype.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                   commandLineArgumentsArray[0],
                                                   commandLineArgumentsArray[1],
                                                   model_factory));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase1");
  print_itl.printModel(ModelGlobal::getModel());
//  Only
  std::ofstream myfile;
  //myfile.open(SCAM_HOME"/tests/GMock_Test/PrintITL/TestCase1.vhi");
  //myfile << print_itl.print();
  //myfile.close();


  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << "TestCase1" << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/GMock_Test/tests/TestCase1.vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << "TestCase1" << " failed\n\n" << print_itl.print();
  std::cout << "" << std::endl;

}

TEST(gmock_test, TestCase2) {

  DataTypes::reset();

  std::vector<const char *> command_line_arguments_vector;

  //Binary
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase2.h");
  command_line_arguments_vector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
  for (int i = 0; i < command_line_arguments_vector.size(); i++) {
    commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
  }

  //Compositional root
  std::unique_ptr<IFindFunctions> find_functions = std::make_unique<FindFunctions>();
  std::unique_ptr<IFindInitialValues> find_initial_values = std::make_unique<FindInitialValues>();
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindVariables> find_variables = std::make_unique<FindVariables>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();

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

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                   commandLineArgumentsArray[0],
                                                   commandLineArgumentsArray[1],
                                                   model_factory));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase2");
  ASSERT_TRUE(module);
  print_itl.printModel(ModelGlobal::getModel());

  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << "TestCase2" << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/GMock_Test/tests/TestCase2.vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << "TestCase2" << " failed\n\n" << print_itl.print();
  std::cout << "" << std::endl;

}

TEST(gmock_test, TestCase3) {

  DataTypes::reset();

  std::vector<const char *> command_line_arguments_vector;

  //Binary
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase3.h");
  command_line_arguments_vector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
  for (int i = 0; i < command_line_arguments_vector.size(); i++) {
    commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
  }

  //Compositional root
  std::unique_ptr<IFindFunctions> find_functions = std::make_unique<FindFunctions>();
  std::unique_ptr<IFindInitialValues> find_initial_values = std::make_unique<FindInitialValues>();
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindVariables> find_variables = std::make_unique<FindVariables>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();

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

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                   commandLineArgumentsArray[0],
                                                   commandLineArgumentsArray[1],
                                                   model_factory));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase3");
  ASSERT_TRUE(module);
  print_itl.printModel(ModelGlobal::getModel());

  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << "TestCase3" << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/GMock_Test/tests/TestCase3.vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << "TestCase3" << " failed\n\n" << print_itl.print();

}

int main(int argc, char **argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}