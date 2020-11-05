//
// Created by burr on 21.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDINITIALVALUESMOCK_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDINITIALVALUESMOCK_H_

#include "MockIFindInitialValues.h"

TEST(TestCase1, FindInitialValues_mocked) /* NOLINT*/{
  using testing::Return;
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());

  //FindInitialValues
  DESCAM::IntegerValue integer_value(1337);
  DESCAM::MOCK::MockIFindInitialValues find_initial_values;
  EXPECT_CALL(find_initial_values, setup(_, _, _, _))
      .Times(1);
  EXPECT_CALL(find_initial_values, getInitValue())
      .Times(1)
      .WillOnce(Return(&integer_value));

  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), &find_initial_values, find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/GMock_Test/tests/", "TestCase1", model_factory);
}

TEST(TestCase2, FindInitialValues_mocked) /* NOLINT */{
  using ::testing::Return;

  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());

  //FindInitialValues
  DESCAM::MOCK::MockIFindInitialValues find_initial_values;
  EXPECT_CALL(find_initial_values, setup(_, _, _, _))
      .Times(2);
  EXPECT_CALL(find_initial_values, getInitValue())
      .Times(2)
      .WillRepeatedly(Return(nullptr));

  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), &find_initial_values, find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/GMock_Test/tests/", "TestCase2", model_factory);
}

TEST(TestCase3, FindInitialValues_mocked) /* NOLINT */{
  using ::testing::Return;

  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());

  //FindInitialValues
  DESCAM::MOCK::MockIFindInitialValues find_initial_values;
  EXPECT_CALL(find_initial_values, setup(_, _, _, _))
      .Times(2);
  EXPECT_CALL(find_initial_values, getInitValue())
      .Times(2)
      .WillRepeatedly(Return(nullptr));

  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), &find_initial_values, find_data_flow_factory.get());
  std::unique_ptr<IFindModules> find_modules =
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  auto model_factory = new ModelFactory(
      find_modules.get(),
      find_global.get(),
      find_instances.get());

  setup("/tests/GMock_Test/tests/", "TestCase3", model_factory);
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDINITIALVALUESMOCK_H_
