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

using namespace ::testing;

void setup(const std::string &path_to_file, const std::string &filename, IModelFactory *model_factory) {

  std::vector<const char *> command_line_arguments_vector;

  //Binary
  const std::string bin = std::string(SCAM_HOME"/bin/DESCAM");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  const std::string file_path = std::string(SCAM_HOME) + path_to_file + filename + ".h";
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

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at(filename);
  ASSERT_TRUE(module);
  print_itl.printModel(ModelGlobal::getModel());

  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << filename << std::endl;
  std::ifstream ifs(SCAM_HOME + path_to_file + filename + ".vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";
  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << filename << " failed\n\n" << print_itl.print();
  std::cout << "" << std::endl;

}

/**
 * Test without any Mock-Objects for TestCase1
 */
TEST(TestCase1, no_mock) /* NOLINT */{
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindInitialValues> find_initial_values = std::make_unique<FindInitialValues>();
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
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

  setup("/tests/GMock_Test/tests/", "TestCase1", model_factory);
}

/**
 * Test with FindInitialValues Mocked for TestCase1
 */
TEST(TestCase1, FindInitialValuesMock) /* NOLINT*/{
  using ::testing::Return;

  DataTypes::reset();

  //FindInitialValues
  DESCAM::IntegerValue integer_value(1337);
  DESCAM::MOCK::MockIFindInitialValues find_initial_values;
  EXPECT_CALL(find_initial_values, setup(_, _, _, _, _))
      .Times(1);
  EXPECT_CALL(find_initial_values, getInitValue())
      .Times(1)
      .WillOnce(Return(&integer_value));

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), &find_initial_values, find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
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

  setup("/tests/GMock_Test/tests/", "TestCase1", model_factory);
}


/**
 * Test without any Mock-Objects for TestCase2
 */
TEST(TestCase2, no_mock) /* NOLINT */{
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindInitialValues> find_initial_values = std::make_unique<FindInitialValues>();
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
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

  setup("/tests/GMock_Test/tests/", "TestCase2", model_factory);
}

/**
 * Test with FindInitialValues Mocked for TestCase2
 */
TEST(TestCase2, FindInitialValuesMock) /* NOLINT */{
  using ::testing::Return;

  DataTypes::reset();

  //FindInitialValues
  DESCAM::MOCK::MockIFindInitialValues find_initial_values;
  EXPECT_CALL(find_initial_values, setup(_, _, _, _, _))
      .Times(2);
  EXPECT_CALL(find_initial_values, getInitValue())
      .Times(2)
      .WillRepeatedly(Return(nullptr));

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), &find_initial_values, find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
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

  setup("/tests/GMock_Test/tests/", "TestCase2", model_factory);
}

/**
 * Test without any Mock-Objects for TestCase3
 */
TEST(TestCase3, no_mock) /* NOLINT */{
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindInitialValues> find_initial_values = std::make_unique<FindInitialValues>();
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
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

  setup("/tests/GMock_Test/tests/", "TestCase3", model_factory);
}

TEST(TestCase3, FindInitialValuesMock) /* NOLINT */{
  using ::testing::Return;

  DataTypes::reset();

  //FindInitialValues
  DESCAM::MOCK::MockIFindInitialValues find_initial_values;
  EXPECT_CALL(find_initial_values, setup(_, _, _, _, _))
      .Times(2);
  EXPECT_CALL(find_initial_values, getInitValue())
      .Times(2)
      .WillRepeatedly(Return(nullptr));

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), &find_initial_values, find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
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

  setup("/tests/GMock_Test/tests/", "TestCase3", model_factory);
}

int main(int argc, char **argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}