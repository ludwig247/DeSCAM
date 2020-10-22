//
// Created by burr on 21.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDFUNCTIONS_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDFUNCTIONS_H_

#include "MockIFindFunctions.h"

TEST(TestCase1, FindFunctions) /* NOLINT */{
  using testing::Return;
  DataTypes::reset();

  std::map<std::string, Function *> getFunctionDecls;

  DESCAM::MOCK::MockIFindFunctions find_functions;
  EXPECT_CALL(find_functions, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_functions, getFunctionDecls())
      .Times(1)
      .WillOnce(Return(getFunctionDecls));
  EXPECT_CALL(find_functions, getFunctionBody(_))
      .Times(0);

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());

  auto model_factory = new ModelFactory(&find_functions,
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

TEST(TestCase2, FindFunctions) /* NOLINT */{
  using ::testing::Return;
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());

  std::map<std::string, Function *> getFunctionDecls;
  std::string name1 = "test_var";
  auto type1 = DataTypes::getDataType("unsigned");
  std::map<std::string, Parameter *> paramMap1;
  std::string paraName1 = "val";
  Parameter para1(paraName1, type1);
  paramMap1.insert(std::make_pair(paraName1, &para1));
  Function func1(name1, type1, paramMap1);
  getFunctionDecls.insert(std::make_pair(name1, &func1));

  std::map<int, CfgBlock *> getFunctionBody;
  int int1 = 0;
  int int2 = 1;
  CfgBlock block1(int1, 2);
  CfgBlock block2(int2, 1);
  block1.addSuccessor(&block2);
  block2.addPredecessor(&block1);
  getFunctionBody.insert(std::make_pair(int1, &block1));
  getFunctionBody.insert(std::make_pair(int2, &block2));

  DESCAM::MOCK::MockIFindFunctions find_functions;
  EXPECT_CALL(find_functions, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_functions, getFunctionDecls())
      .Times(1)
      .WillOnce(Return(getFunctionDecls));
  EXPECT_CALL(find_functions, getFunctionBody(name1))
      .Times(1)
      .WillOnce(Invoke([getFunctionBody, &block2, &para1, &find_global](Unused) -> std::map<int, CfgBlock *> {
        auto constval = find_global->getVariableMap().find("number");
        block2.addStmt(new DESCAM::Return(new Arithmetic(new Arithmetic(new ParamOperand(&para1),
                                                                        "+",
                                                                        new UnsignedValue(3)),
                                                         "+",
                                                         new VariableOperand(constval->second))));
        return getFunctionBody;
      }));

  auto model_factory = new ModelFactory(&find_functions,
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

TEST(TestCase3, FindFunctions) /* NOLINT */{
  using ::testing::Return;
  DataTypes::reset();

  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindStateName> find_state_name = std::make_unique<FindStateName>();
  std::unique_ptr<IFindDataFlowFactory>
      find_data_flow_factory = std::make_unique<FindDataFlowFactory>(find_state_name.get());
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(find_data_flow_factory.get());
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());

  std::map<std::string, Function *> getFunctionDecls;

  DESCAM::MOCK::MockIFindFunctions find_functions;
  EXPECT_CALL(find_functions, setup(_, _, _))
      .Times(1);
  EXPECT_CALL(find_functions, getFunctionDecls())
      .Times(1)
      .WillOnce(Return(getFunctionDecls));
  EXPECT_CALL(find_functions, getFunctionBody(_))
      .Times(0);

  auto model_factory = new ModelFactory(&find_functions,
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

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDFUNCTIONS_H_
