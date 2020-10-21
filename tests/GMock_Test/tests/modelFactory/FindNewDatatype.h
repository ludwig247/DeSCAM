//
// Created by burr on 21.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDNEWDATATYPE_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDNEWDATATYPE_H_

#include "MockIFindNewDataType.h"

TEST(TestCase1, FindNewDatatype) /* NOLINT */{
  using testing::Return;
  DataTypes::reset();

//Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();

  DESCAM::MOCK::MockIFindNewDatatype find_new_datatype;
  EXPECT_CALL(find_new_datatype, getDataType(_))
      .Times(0);
  EXPECT_CALL(find_new_datatype, getTypeName(_))
      .Times(3)
      .WillRepeatedly(Return("int"));
  EXPECT_CALL(find_new_datatype, isGlobal(_))
      .Times(0);

  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(&find_new_datatype);
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(&find_new_datatype, find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(&find_new_datatype, find_initial_values.get(), find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_initial_values.get(),
                                        find_modules.get(),
                                        &find_new_datatype,
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase1", model_factory);
}

TEST(TestCase2, FindNewDatatype) /* NOLINT */{
  using ::testing::Return;
  DataTypes::reset();

//Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();

  DESCAM::MOCK::MockIFindNewDatatype find_new_datatype;
  EXPECT_CALL(find_new_datatype, getDataType(_))
      .Times(1)
      .WillOnce((Return(DataTypes::getDataType("unsigned"))));
  EXPECT_CALL(find_new_datatype, getTypeName(_))
      .Times(4)
      .WillOnce(Return("unsigned"))
      .WillOnce(Return("int"))
      .WillOnce(Return("int"))
      .WillOnce(Return("unsigned"));
  EXPECT_CALL(find_new_datatype, isGlobal(_))
      .Times(1)
      .WillOnce(Return(true));

  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(&find_new_datatype);
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(&find_new_datatype, find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(&find_new_datatype, find_initial_values.get(), find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_initial_values.get(),
                                        find_modules.get(),
                                        &find_new_datatype,
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase2", model_factory);
}

TEST(TestCase3, FindNewDatatype) /* NOLINT */{
  using ::testing::Return;
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();

  DESCAM::DataType type1("unsigned_5");
  type1.addArray(DataTypes::getDataType("unsigned"), 5);

  DESCAM::MOCK::MockIFindNewDatatype find_new_datatype;
  EXPECT_CALL(find_new_datatype, getDataType(_))
      .Times(1)
      .WillOnce((Return(&type1)));
  EXPECT_CALL(find_new_datatype, getTypeName(_))
      .Times(5)
      .WillOnce(Return("unsigned"))
      .WillOnce(Return("int"))
      .WillOnce(Return("unsigned_5"))
      .WillOnce(Return("int"))
      .WillOnce(Return("unsigned"));
  EXPECT_CALL(find_new_datatype, isGlobal(_))
      .Times(1)
      .WillOnce(Return(true));

  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(&find_new_datatype);
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(&find_new_datatype, find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(&find_new_datatype, find_initial_values.get(), find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_initial_values.get(),
                                        find_modules.get(),
                                        &find_new_datatype,
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase3", model_factory);
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDNEWDATATYPE_H_
