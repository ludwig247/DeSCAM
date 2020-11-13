//
// Created by burr on 27.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPORTSMOCK_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPORTSMOCK_H_

#include "modelFactory/MockIFindPorts.h"

TEST(TestCase1, FindPorts_mocked) /* NOLINT*/{
  using testing::Return;
  DataTypes::reset();

  std::map<std::string, Port *> getPortMap;
  DESCAM::Interface interface1("blocking", "in");
  DESCAM::Interface interface2("master", "out");
  DESCAM::Port port1("b_in", &interface1, DataTypes::getDataType("int"));
  DESCAM::Port port2("m_out", &interface2, DataTypes::getDataType("int"));
  getPortMap.insert(std::make_pair("b_in", &port1));
  getPortMap.insert(std::make_pair("m_out", &port2));

  DESCAM::MOCK::MockIFindPorts find_ports;
  EXPECT_CALL(find_ports, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_ports, getPortMap())
      .Times(1)
      .WillOnce(Return(getPortMap));

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), &find_ports, find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/TestCases/TestCasesForMocking/", "TestCase1", model_factory);
}

TEST(TestCase2, FindPorts_mocked) /* NOLINT*/{
  using testing::Return;
  DataTypes::reset();

  std::map<std::string, Port *> getPortMap;
  DESCAM::Interface interface1("blocking", "in");
  DESCAM::Interface interface2("blocking", "out");
  DESCAM::Port port1("test_in", &interface1, DataTypes::getDataType("int"));
  DESCAM::Port port2("test_out", &interface2, DataTypes::getDataType("unsigned"));
  getPortMap.insert(std::make_pair("test_in", &port1));
  getPortMap.insert(std::make_pair("test_out", &port2));

  DESCAM::MOCK::MockIFindPorts find_ports;
  EXPECT_CALL(find_ports, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_ports, getPortMap())
      .Times(1)
      .WillOnce(Return(getPortMap));

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), &find_ports, find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/TestCases/TestCasesForMocking/", "TestCase2", model_factory);
}

TEST(TestCase3, FindPorts_mocked) /* NOLINT*/{
  using testing::Return;
  DataTypes::reset();

  std::map<std::string, Port *> getPortMap;
  DESCAM::Interface interface1("blocking", "in");
  DESCAM::Interface interface2("blocking", "out");
  DESCAM::Port port1("test_in", &interface1, DataTypes::getDataType("int"));
  DESCAM::Port port2("test_out", &interface2, DataTypes::getDataType("unsigned"));
  getPortMap.insert(std::make_pair("test_in", &port1));
  getPortMap.insert(std::make_pair("test_out", &port2));

  DESCAM::MOCK::MockIFindPorts find_ports;
  EXPECT_CALL(find_ports, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_ports, getPortMap())
      .Times(1)
      .WillOnce(Return(getPortMap));

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), &find_ports, find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/TestCases/TestCasesForMocking/", "TestCase3", model_factory);
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPORTSMOCK_H_
