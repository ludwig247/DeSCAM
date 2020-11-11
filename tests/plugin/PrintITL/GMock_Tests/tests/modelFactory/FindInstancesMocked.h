//
// Created by tobias on 28.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDINSTANCESMOCKED_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDINSTANCESMOCKED_H_

#include "modelFactory/MockIFindInstances.h"

TEST(TestCase1, FindInstances_mocked) /* NOLINT */{
  DataTypes::reset();

//Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
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

  //FindInitialValues

  DESCAM::MOCK::MockIFindInstances find_instances;
  EXPECT_CALL(find_instances, setup(_, _))
      .Times(1);
  EXPECT_CALL(find_instances, getModuleInstance())
      .Times(1)
      .WillOnce(testing::Return(nullptr));

  auto model_factory = new ModelFactory(find_modules.get(),
                                        find_global.get(),
                                        &find_instances);

  setup("/tests/TestCases/TestCasesForMocking/", "TestCase1", model_factory);
}

TEST(TestCase2, FindInstances_mocked) /* NOLINT */{
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
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
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  DESCAM::MOCK::MockIFindInstances find_instances;
  EXPECT_CALL(find_instances, setup(_, _))
      .Times(1);
  EXPECT_CALL(find_instances, getModuleInstance())
      .Times(1)
      .WillOnce(testing::Return(nullptr));

  auto model_factory = new ModelFactory(find_modules.get(),
                                        find_global.get(),
                                        &find_instances);

  setup("/tests/TestCases/TestCasesForMocking/", "TestCase2", model_factory);
}

TEST(TestCase3, FindInstances_mocked) /* NOLINT */{
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
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
      std::make_unique<FindModules>(find_variables.get(), find_ports.get(), find_functions.get(), find_process.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>(find_data_flow_factory.get());

  DESCAM::MOCK::MockIFindInstances find_instances;
  EXPECT_CALL(find_instances, setup(_, _))
      .Times(1);
  EXPECT_CALL(find_instances, getModuleInstance())
      .Times(1)
      .WillOnce(testing::Return(nullptr));

  auto model_factory = new ModelFactory(find_modules.get(),
                                        find_global.get(),
                                        &find_instances);

  setup("/tests/TestCases/TestCasesForMocking/", "TestCase3", model_factory);
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDINSTANCESMOCKED_H_
