//
// Created by burr on 21.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDSTATENAMEMOCK_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDSTATENAMEMOCK_H_

#include "MockIFindStateName.h"

TEST(TestCase1, FindStateName_mocked) /* NOLINT */{
  using testing::Return;
  DataTypes::reset();

  DESCAM::MOCK::MockIFindStateName find_state_name;
  EXPECT_CALL(find_state_name, setup(_))
      .Times(0);
  EXPECT_CALL(find_state_name, getStateName())
      .Times(0);

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(&find_state_name);
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/GMock_Test/tests/", "TestCase1", model_factory);
}

TEST(TestCase2, FindStateName_mocked) /* NOLINT */{
  using testing::Return;
  DataTypes::reset();

  DESCAM::MOCK::MockIFindStateName find_state_name;
  EXPECT_CALL(find_state_name, setup(_))
      .Times(0);
  EXPECT_CALL(find_state_name, getStateName())
      .Times(0);

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(&find_state_name);
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/GMock_Test/tests/", "TestCase2", model_factory);
}

TEST(TestCase3, FindStateName_mocked) /* NOLINT */{
  using testing::Return;
  DataTypes::reset();

  std::string name1 = "idle";
  DESCAM::MOCK::MockIFindStateName find_state_name;
  EXPECT_CALL(find_state_name, setup(_))
      .Times(2);
  EXPECT_CALL(find_state_name, getStateName())
      .Times(2)
      .WillRepeatedly(ReturnRef(name1));

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(&find_state_name);
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/GMock_Test/tests/", "TestCase3", model_factory);
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDSTATENAMEMOCK_H_
