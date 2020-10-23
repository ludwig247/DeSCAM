//
// Created by burr on 23.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPROCESS_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPROCESS_H_

#include "MockIFindProcess.h"

TEST(DISABLED_TestCase1, FindProcess) /* NOLINT*/{
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

  std::map<int, DESCAM::CfgNode *> getCfgArg;
  CfgNode node0;
  CfgNode node1;
  CfgNode node2;
  CfgNode node3;
  CfgNode node4;
  CfgNode node5;
  node0.addSuccessor(&node1);
  node1.addPredecessor(&node0);
  node1.addSuccessor(&node2);
  node2.addPredecessor(&node1);
  node2.addPredecessor(&node5);
  node2.addSuccessor(&node3);
  node3.addPredecessor(&node2);
  node3.addSuccessor(&node4);
  node4.addPredecessor(&node3);
  node4.addSuccessor(&node5);
  node5.addPredecessor(&node4);
  node5.addSuccessor(&node2);

  getCfgArg.insert(std::make_pair(0, &node0));
  getCfgArg.insert(std::make_pair(1, &node1));
  getCfgArg.insert(std::make_pair(2, &node2));
  getCfgArg.insert(std::make_pair(3, &node3));
  getCfgArg.insert(std::make_pair(4, &node4));
  getCfgArg.insert(std::make_pair(5, &node5));

  node2.setStmt(new While(new BoolValue(true)));

  std::shared_ptr<DESCAM::PropertySuite> propertySuite = std::make_shared<DESCAM::PropertySuite>("TestCase1");

  DESCAM::MOCK::MockIFindProcess find_process;
  EXPECT_CALL(find_process, setup)
      .Times(1);
  EXPECT_CALL(find_process, getCfgArg)
      .Times(1)
      .WillOnce(Invoke([&getCfgArg, &find_variables, &find_ports, &node1]() {
        auto vars = find_variables->getVariableMap();
        auto var = vars.find("var")->second;

        auto in_port_map = find_ports->getInPortMap();
        auto out_port_map = find_ports->getMasterOutPortMap();

        auto b_in = in_port_map.find("b_in");
        auto m_out = out_port_map.find("m_out");

        node1.setStmt(new Assignment(new VariableOperand(var), new IntegerValue(1337)));

        //node3.setStmt(new Read(b_in,var));

        return getCfgArg;
      }));
  EXPECT_CALL(find_process, getPropertySuite)
      .Times(1)
      .WillOnce(Return(propertySuite));

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

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDPROCESS_H_
