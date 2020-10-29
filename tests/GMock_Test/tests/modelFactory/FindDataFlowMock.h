//
// Created by burr on 27.10.20.
//

#ifndef SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDDATAFLOWMOCK_H_
#define SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDDATAFLOWMOCK_H_

#include "MockIFindDataFlow.h"
#include "MockIFindDataFlowFactory.h"

TEST(TestCase1, FindDataFlow) /* NOLINT */{
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

  int expected = 850;
  int times = 0;

  DESCAM::Expr *getExpr[expected];
  DESCAM::Stmt *getStmt[expected];

  DESCAM::MOCK::MockIFindDataFlow find_data_flow;
  EXPECT_CALL(find_data_flow, setup(_, _, _, _))
      .Times(0);
  EXPECT_CALL(find_data_flow, getExpr())
      .Times(expected)
      .WillRepeatedly(Invoke([&getExpr, &times]() {
        return getExpr[times];
      }));
  EXPECT_CALL(find_data_flow, getStmt())
      .Times(expected)
      .WillRepeatedly(Invoke([&getStmt, &times]() {
        return getStmt[times];
      }));

  DESCAM::MOCK::MockIFindDataFlowFactory find_data_flow_factory;
  EXPECT_CALL(find_data_flow_factory, create_new(_, _, _, _))
      .Times(expected)
      .WillRepeatedly(Invoke([&find_data_flow, &times](Unused, Unused, Unused, Unused) {
        times++;
        return &find_data_flow;
      }));

  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>(&find_data_flow_factory);
  std::unique_ptr<IFindInitialValues>
      find_initial_values = std::make_unique<FindInitialValues>(&find_data_flow_factory);
  std::unique_ptr<IFindFunctions>
      find_functions = std::make_unique<FindFunctions>(find_new_datatype.get(), &find_data_flow_factory);
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), &find_data_flow_factory);

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_modules.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        &find_data_flow_factory);

  setup("/tests/GMock_Test/tests/", "TestCase1", model_factory);
}

#endif //SCAM_TESTS_GMOCK_TEST_TESTS_MODELFACTORY_FINDDATAFLOWMOCK_H_
