//
// Created by burr on 21.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDVARIABLES_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDVARIABLES_H_

TEST(TestCase1, FindVariables) /* NOLINT*/{
  using ::testing::Return;
  DataTypes::reset();

  std::map<std::string, DESCAM::Variable *> find_variables_map;
  DESCAM::IntegerValue integer_value(1337);
  Variable var1("var", integer_value.getDataType(), &integer_value);
  find_variables_map.insert(std::make_pair("var", &var1));

  DESCAM::MOCK::MockIFindVariables find_variables;
  EXPECT_CALL(find_variables, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_variables, getVariableMap())
      .Times(1)
      .WillOnce(Return(find_variables_map));

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_initial_values.get(),
                                        find_modules.get(),
                                        find_new_datatype.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        &find_variables,
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase1", model_factory);
}

TEST(TestCase2, FindVariables) /* NOLINT*/{
  using ::testing::Return;
  DataTypes::reset();

  std::map<std::string, DESCAM::Variable *> find_variables_map;
  std::string name1 = "bar";
  std::string name2 = "foo";
  DESCAM::UnsignedValue val1(0);
  DESCAM::IntegerValue val2(0);
  Variable var1(name1, val1.getDataType(), &val1);
  Variable var2(name2, val2.getDataType(), &val2);

  find_variables_map.insert(std::make_pair(name1, &var1));
  find_variables_map.insert(std::make_pair(name2, &var2));

  DESCAM::MOCK::MockIFindVariables find_variables;
  EXPECT_CALL(find_variables, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_variables, getVariableMap())
      .Times(1)
      .WillOnce(Return(find_variables_map));

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_initial_values.get(),
                                        find_modules.get(),
                                        find_new_datatype.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        &find_variables,
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase2", model_factory);
}

TEST(TestCase3, FindVariables) /* NOLINT*/{
  using ::testing::Return;
  DataTypes::reset();

  std::map<std::string, DESCAM::Variable *> find_variables_map;
  std::string name1 = "bar";
  std::string name2 = "foo";
  std::string name3 = "list";
  DESCAM::UnsignedValue val1(0);
  DESCAM::IntegerValue val2(0);
  DataType type3("unsigned_5");
  type3.addArray(DataTypes::getDataType("unsigned"), 5);

  Variable var1(name1, val1.getDataType(), &val1);
  Variable var2(name2, val2.getDataType(), &val2);
  Variable var3(name3, &type3);

  find_variables_map.insert(std::make_pair(name1, &var1));
  find_variables_map.insert(std::make_pair(name2, &var2));
  find_variables_map.insert(std::make_pair(name3, &var3));

  DESCAM::MOCK::MockIFindVariables find_variables;
  EXPECT_CALL(find_variables, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_variables, getVariableMap())
      .Times(1)
      .WillOnce(Return(find_variables_map));

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_initial_values.get(),
                                        find_modules.get(),
                                        find_new_datatype.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        &find_variables,
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase3", model_factory);
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDVARIABLES_H_
