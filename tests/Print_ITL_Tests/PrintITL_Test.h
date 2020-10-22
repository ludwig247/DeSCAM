
// Created by tobias on 30.10.17.
//

#ifndef PROJECT_PRINTITL_TEST_H
#define PROJECT_PRINTITL_TEST_H

#include <gtest/gtest.h>

#include <ModelGlobal.h>
#include <fstream>
#include <FatalError.h>
#include <PrintITL/PrintITL.h>

#include "ModelFactory.h"

#include "FindFunctions.h"
#include "FindInitialValues.h"
#include "FindModules.h"
#include "FindNewDatatype.h"
#include "FindPorts.h"
#include "FindGlobal.h"
#include "FindNetlist.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "FindSCMain.h"
#include "FindStateName.h"

static std::vector<DESCAM::Module *> parameter() {

  std::vector<const char *> commandLineArugmentsVector;

  //Binaray
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  commandLineArugmentsVector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/Tests.h");
  commandLineArugmentsVector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
  for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
    commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
  }


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
  std::unique_ptr<IFindFunctions> find_functions =
      std::make_unique<FindFunctions>(find_new_datatype.get(), find_data_flow_factory.get());
  std::unique_ptr<IFindVariables> find_variables =
      std::make_unique<FindVariables>(find_new_datatype.get(), find_initial_values.get(), find_data_flow_factory.get());

  auto model_factory = new ModelFactory(find_functions.get(),
                                        find_modules.get(),
                                        find_ports.get(),
                                        find_global.get(),
                                        find_netlist.get(),
                                        find_process.get(),
                                        find_variables.get(),
                                        find_sc_main.get(),
                                        find_data_flow_factory.get());

//    add optimizations
//    std::set<std::string> optimizeOptions = {"all"};
//    CommandLineParameter::setOptimizeOptionsSet(optimizeOptions);
  try {
    DESCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(),
                                     commandLineArgumentsArray[0],
                                     commandLineArgumentsArray[1], model_factory);
  } catch (FatalError &e) {

  }

  std::vector<DESCAM::Module *> result;
  for (auto module: DESCAM::ModelGlobal::getModel()->getModules()) {
    result.push_back(module.second);
  }
  return result;
}

class ITL_Test : public ::testing::TestWithParam<DESCAM::Module *> {
 public:
  static void SetUpTestCase() {
  }

  static void TearDownTestCase() {
  }

  virtual void SetUp() {
  }

  virtual void TearDown() {
  }
};

INSTANTIATE_TEST_CASE_P
(Basic, ITL_Test, ::testing::ValuesIn(parameter()));

TEST_P(ITL_Test, Basic) {

  PrintITL printITL;
//    DESCAM::Module * module = GetParam();
  printITL.printModule(GetParam());
  ASSERT_NO_THROW(printITL.print());
  std::ofstream myfile;
  myfile.open(SCAM_HOME"/tests/Print_ITL_Tests/unsorted/" + GetParam()->getName() + ".vhi");
  myfile << printITL.print();
  myfile.close();

  ASSERT_NE(GetParam(), nullptr) << "Module not found";
  std::cout << "Instance: " << GetParam()->getName() << std::endl;

  std::ifstream ifs(SCAM_HOME"/tests/Print_ITL_Tests/TestCases/vhi/" + GetParam()->getName() + ".vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, printITL.print())
                << "Test for module " << GetParam()->getName() << " failed\n\n" << printITL.print();
  std::cout << "" << std::endl;

}

#endif //PROJECT_PRINTITL_TEST_H
