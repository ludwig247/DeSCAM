//
// Created by tobias on 11.04.17.
//
#include "Config.h"
#include <ModelGlobal.h>
#include <FatalError.h>
#include <PrintITL/PrintITL.h>
#include <gtest/gtest.h>

#include "FindFunctions.h"
#include "FindInitialValues.h"
#include "FindModules.h"
#include "FindNewDatatype.h"
#include "FindPorts.h"
#include "FindGlobal.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "FindStateName.h"
#include "ModelFactory.h"
#include "FindInstances.h"

//Tests
using namespace ::testing;
#include "tests/NoMocks.h"
#include "tests/modelFactory/FindDataFlowMock.h"
#include "tests/modelFactory/FindFunctionsMock.h"
#include "tests/modelFactory/FindGlobalMock.h"
#include "tests/modelFactory/FindInitialValuesMock.h"
#include "tests/modelFactory/FindInstancesMocked.h"
#include "tests/modelFactory/FindModulesMock.h"
#include "tests/modelFactory/FindNewDatatypeMock.h"
#include "tests/modelFactory/FindPortsMock.h"
#include "tests/modelFactory/FindProcessMock.h"
#include "tests/modelFactory/FindStateNameMock.h"
#include "tests/modelFactory/FindVariablesMock.h"

void setup(const std::string &path_to_file, const std::string &filename, IModelFactory *model_factory) {

  std::vector<const char *> command_line_arguments_vector;

  //Binary
  const std::string bin = std::string(SCAM_HOME"/bin/DESCAM");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  const std::string file_path = std::string(SCAM_HOME) + path_to_file + filename + ".h";
  command_line_arguments_vector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
  for (int i = 0; i < command_line_arguments_vector.size(); i++) {
    commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
  }

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                   commandLineArgumentsArray[0],
                                                   commandLineArgumentsArray[1],
                                                   model_factory));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at(filename);
  ASSERT_TRUE(module);
  print_itl.printModel(ModelGlobal::getModel());



  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << filename << std::endl;
  std::ifstream ifs(SCAM_HOME + std::string("/tests/plugin/PrintITL/GMock_Tests/vhi/") + filename + std::string(".vhi"));
  ASSERT_TRUE(bool(ifs)) << "Can't open file";
  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << filename << " failed\n\n" << print_itl.print();
  std::cout << "" << std::endl;

}

int main(int argc, char **argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}