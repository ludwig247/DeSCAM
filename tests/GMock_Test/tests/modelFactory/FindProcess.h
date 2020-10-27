//
// Created by burr on 23.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPROCESS_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPROCESS_H_

#include "MockIFindProcess.h"

TEST(TestCase1, FindProcess) /* NOLINT*/{
  using testing::Return;
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
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());

  CfgBlock block0(0, 4);
  CfgBlock block1(1, -1);
  CfgBlock block2(2, 3);
  CfgBlock block3(3, 2);
  CfgBlock block4(4, 1);

  block0.addSuccessor(&block1);
  block1.addPredecessor(&block0);
  block1.addSuccessor(&block2);
  block2.addPredecessor(&block1);
  block2.addPredecessor(&block4);
  block2.addSuccessor(&block3);
  block3.addPredecessor(&block2);
  block3.addSuccessor(&block4);
  block4.addPredecessor(&block3);
  block4.addSuccessor(&block2);

  std::map<int, DESCAM::CfgBlock *> getCfgMap;
  getCfgMap.insert(std::make_pair(0, &block0));
  getCfgMap.insert(std::make_pair(1, &block1));
  getCfgMap.insert(std::make_pair(2, &block2));
  getCfgMap.insert(std::make_pair(3, &block3));
  getCfgMap.insert(std::make_pair(4, &block4));

  block2.addStmt(new While(new BoolValue(true)));

  DESCAM::MOCK::MockIFindProcess find_process;
  EXPECT_CALL(find_process, setup(_, _, _, _))
      .Times(1);
  EXPECT_CALL(find_process, getCFG())
      .Times(1)
      .WillOnce(Invoke([&getCfgMap, &find_variables, &find_ports, &block1, &block3]() -> const std::map<int,
                                                                                                        DESCAM::CfgBlock *> & {
        auto vari = find_variables->getVariableMap().find("var")->second;
        auto b_in = find_ports->getPortMap().find("b_in")->second;
        auto m_out = find_ports->getPortMap().find("m_out")->second;

        block1.addStmt(new Assignment(new VariableOperand(vari), new IntegerValue(1337)));
        block3.addStmt(new Read(b_in, new VariableOperand(vari)));
        block3.addStmt(new Write(m_out, new VariableOperand(vari)));

        return getCfgMap;
      }));

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_modules.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        &find_process,
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase1", model_factory);
}

TEST(TestCase2, FindProcess) /* NOLINT*/{
  using testing::Return;
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
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());

  CfgBlock block0(0, 6);
  CfgBlock block1(1, -1);
  CfgBlock block2(2, 5);
  CfgBlock block3(3, 4);
  CfgBlock block4(4, 3);
  CfgBlock block5(5, 2);
  CfgBlock block6(6, 1);

  block0.addSuccessor(&block1);
  block1.addPredecessor(&block0);
  block1.addSuccessor(&block2);
  block2.addPredecessor(&block1);
  block2.addPredecessor(&block6);
  block2.addSuccessor(&block3);
  block3.addPredecessor(&block2);
  block3.addSuccessor(&block4);
  block4.addPredecessor(&block3);
  block4.addSuccessor(&block5);
  block5.addPredecessor(&block4);
  block5.addSuccessor(&block6);
  block6.addPredecessor(&block5);
  block6.addSuccessor(&block2);

  std::map<int, DESCAM::CfgBlock *> getCfgMap;
  getCfgMap.insert(std::make_pair(0, &block0));
  getCfgMap.insert(std::make_pair(1, &block1));
  getCfgMap.insert(std::make_pair(2, &block2));
  getCfgMap.insert(std::make_pair(3, &block3));
  getCfgMap.insert(std::make_pair(4, &block4));
  getCfgMap.insert(std::make_pair(5, &block5));
  getCfgMap.insert(std::make_pair(6, &block6));

  block2.addStmt(new While(new BoolValue(true)));

  DESCAM::MOCK::MockIFindProcess find_process;
  EXPECT_CALL(find_process, setup(_, _, _, _))
      .Times(1);
  EXPECT_CALL(find_process, getCFG())
      .Times(1)
      .WillOnce(Invoke([&getCfgMap, &find_variables, &find_global, &find_ports, &find_functions, &block1, &block3, &block4]() -> const std::map<
          int,
          DESCAM::CfgBlock *> & {
        auto bar = find_variables->getVariableMap().find("bar")->second;
        auto foo = find_variables->getVariableMap().find("foo")->second;
        auto number = find_global->getVariableMap().find("number")->second;
        auto number2 = find_global->getVariableMap().find("number2")->second;
        auto number3 = find_global->getVariableMap().find("number3")->second;
        auto number4 = find_global->getVariableMap().find("number4")->second;
        auto test_var = find_functions->getFunctionDecls().find("test_var")->second;
        auto test_out = find_ports->getPortMap().find("test_out")->second;

        block1.addStmt(new Assignment(new VariableOperand(bar), new UnsignedValue(0)));
        block1.addStmt(new Assignment(new VariableOperand(foo), new IntegerValue(0)));
        block3.addStmt(new If(new VariableOperand(number4)));
        block4.addStmt(new Assignment(new VariableOperand(bar),
                                      new Arithmetic(new VariableOperand(number), "+", new VariableOperand(bar))));
        block4.addStmt(new Assignment(new VariableOperand(bar),
                                      new Arithmetic(new VariableOperand(bar), "+", new VariableOperand(number2))));
        block4.addStmt(new Assignment(new VariableOperand(bar),
                                      new Arithmetic(new VariableOperand(bar),
                                                     "+",
                                                     new Cast(new VariableOperand(number3),
                                                              DataTypes::getDataType("unsigned")))));
        std::map<std::string, DESCAM::Expr *> paramMap;
        paramMap.insert(std::make_pair("val", new VariableOperand(number2)));
        block4.addStmt((new Assignment(new VariableOperand(bar),
                                       new Arithmetic(new VariableOperand(bar),
                                                      "+",
                                                      new FunctionOperand(test_var, paramMap)))));
        block4.addStmt(new Write(test_out, new VariableOperand(bar)));
        std::cout << "getCfgMap" << "\n";
        std::cout << " | Size:" << getCfgMap.size() << "\n";
        for (auto &block:getCfgMap) {
          std::cout << " | | Int:" << block.first << ", Block:" << "\n" << block.second->print() << "\n";
        }

        return getCfgMap;
      }));

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_modules.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        &find_process,
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase2", model_factory);
}

TEST(DISABLED_TestCase3, FindProcess) /* NOLINT*/{
  using testing::Return;
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
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(find_data_flow_factory.get());
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());

  CfgBlock block0(0, 6);
  CfgBlock block1(1, -1);
  CfgBlock block2(2, 5);
  CfgBlock block3(3, 4);
  CfgBlock block4(4, 3);
  CfgBlock block5(5, 1);
  CfgBlock block6(6, 2);

  block0.addSuccessor(&block1);
  block1.addPredecessor(&block0);
  block1.addSuccessor(&block2);
  block2.addPredecessor(&block1);
  block2.addPredecessor(&block5);
  block2.addSuccessor(&block3);
  block3.addPredecessor(&block2);
  block3.addSuccessor(&block4);
  block3.addSuccessor(&block6);
  block4.addPredecessor(&block3);
  block4.addSuccessor(&block5);
  block5.addPredecessor(&block4);
  block5.addPredecessor(&block6);
  block5.addSuccessor(&block2);
  block6.addPredecessor(&block3);
  block6.addSuccessor(&block5);

  std::map<int, DESCAM::CfgBlock *> getCfgMap;
  getCfgMap.insert(std::make_pair(0, &block0));
  getCfgMap.insert(std::make_pair(1, &block1));
  getCfgMap.insert(std::make_pair(2, &block2));
  getCfgMap.insert(std::make_pair(3, &block3));
  getCfgMap.insert(std::make_pair(4, &block4));
  getCfgMap.insert(std::make_pair(5, &block5));
  getCfgMap.insert(std::make_pair(6, &block6));

  block2.addStmt(new While(new BoolValue(true)));

  DESCAM::MOCK::MockIFindProcess find_process;
  EXPECT_CALL(find_process, setup(_, _, _, _))
      .Times(1);
  EXPECT_CALL(find_process, getCFG())
      .Times(1)
      .WillOnce(Invoke([&getCfgMap, &find_variables, &find_global, &find_ports, &find_functions, &block1, &block3, &block4]() -> const std::map<
          int,
          DESCAM::CfgBlock *> & {
        auto bar = find_variables->getVariableMap().find("bar")->second;
        auto foo = find_variables->getVariableMap().find("foo")->second;
        auto list = find_variables->getVariableMap().find("list")->second;
        auto test_in = find_ports->getPortMap().find("test_in")->second;
        auto test_out = find_ports->getPortMap().find("test_out")->second;
        auto compute2 = find_functions->getFunctionDecls().find("compute2")->second;
        auto compute = find_functions->getFunctionDecls().find("compute")->second;

        block1.addStmt(new Assignment(new VariableOperand(bar), new UnsignedValue(0)));
        block1.addStmt(new Assignment(new VariableOperand(foo), new IntegerValue(0)));
        block1.addStmt(new Assignment(new ArrayOperand(list, new IntegerValue(0)), new UnsignedValue(0)));
        block1.addStmt(new Assignment(new ArrayOperand(list, new IntegerValue(1)), new UnsignedValue(0)));
        block1.addStmt(new Assignment(new ArrayOperand(list, new IntegerValue(2)), new UnsignedValue(0)));
        block1.addStmt(new Assignment(new ArrayOperand(list, new IntegerValue(3)), new UnsignedValue(0)));
        block1.addStmt(new Assignment(new ArrayOperand(list, new IntegerValue(4)), new UnsignedValue(0)));
        block3.addStmt(new Read(test_in, new VariableOperand(foo)));

        std::map<std::string, DESCAM::Expr *> functionParamMap1;
        functionParamMap1.insert(std::make_pair("param", new VariableOperand(foo)));
        functionParamMap1.insert(std::make_pair("param2", new VariableOperand(bar)));
        block3.addStmt(new Assignment(new VariableOperand(bar),
                                      new Arithmetic(new VariableOperand(bar),
                                                     "+",
                                                     new Cast(new FunctionOperand(compute2, functionParamMap1),
                                                              DataTypes::getDataType("unsigned")))));

        std::map<std::string, DESCAM::Expr *> functionParamMap2_0;
        functionParamMap2_0.insert(std::make_pair("param", new VariableOperand(foo)));
        functionParamMap2_0.insert(std::make_pair("param2", new VariableOperand(bar)));
        std::map<std::string, DESCAM::Expr *> functionParamMap2_1;
        functionParamMap2_1.insert(std::make_pair("param", new UnsignedValue(3)));
        functionParamMap2_1.insert(std::make_pair("param2", new FunctionOperand(compute2, functionParamMap2_0)));
        block3.addStmt(new Assignment(new VariableOperand(bar),new Arithmetic(new VariableOperand(bar),"+",new FunctionOperand(compute,functionParamMap2_1))));

        std::cout << "getCfgMap" << "\n";
        std::cout << " | Size:" << getCfgMap.size() << "\n";
        for (auto &block:getCfgMap) {
          std::cout << " | | Int:" << block.first << ", Block:" << "\n" << block.second->print() << "\n";
        }

        return getCfgMap;
      }));

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_modules.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        &find_process,
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

  setup("/tests/GMock_Test/tests/", "TestCase3", model_factory);
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPROCESS_H_
