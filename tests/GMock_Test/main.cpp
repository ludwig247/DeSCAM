//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>
#include "Config.h"
#include <ModelGlobal.h>
#include <fstream>
#include <FatalError.h>
#include <PrintITL/PrintITL.h>

#include "MockIFindSCMain.h"
/**
 * Test/Stub for using mock object
 */
TEST(mock_objects, MockIFindSCMainCall) {
  using ::testing::Return;
  using ::testing::_;

  DESCAM::MOCK::MockIFindSCMain mock;
//
//  ON_CALL(mock, setup(_)).WillByDefault(Return(false));
//  ON_CALL(mock, isScMainFound).WillByDefault(Return(false));
//  ON_CALL(mock, setup(_)).WillByDefault(Return(false));
//  EXPECT_CALL(mock, setup(_)).WillOnce(Return(true));

 // EXPECT_TRUE(mock.setup(nullptr));

}

TEST(gmock_test, TestCase1) {
  std::vector<const char *> command_line_arguments_vector;

  //Binary
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase1.h");
  command_line_arguments_vector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
  for (int i = 0; i < command_line_arguments_vector.size(); i++) {
    commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
  }

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                   commandLineArgumentsArray[0],
                                                   commandLineArgumentsArray[1]));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase1");
  print_itl.printModel(ModelGlobal::getModel());
//  Only
  std::ofstream myfile;
  //myfile.open(SCAM_HOME"/tests/GMock_Test/PrintITL/TestCase1.vhi");
  //myfile << print_itl.print();
  //myfile.close();


  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << "TestCase1" << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/GMock_Test/tests/TestCase1.vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << "TestCase1" << " failed\n\n" << print_itl.print();
  std::cout << "" << std::endl;

}

TEST(gmock_test, TestCase2) {

  DataTypes::reset();

  std::vector<const char *> command_line_arguments_vector;

  //Binary
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase2.h");
  command_line_arguments_vector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
  for (int i = 0; i < command_line_arguments_vector.size(); i++) {
    commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
  }

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                   commandLineArgumentsArray[0],
                                                   commandLineArgumentsArray[1]));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase2");
  ASSERT_TRUE(module);
  print_itl.printModel(ModelGlobal::getModel());

  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << "TestCase2" << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/GMock_Test/tests/TestCase2.vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << "TestCase2" << " failed\n\n" << print_itl.print();
  std::cout << "" << std::endl;

}

TEST(gmock_test, TestCase3) {

  DataTypes::reset();

  std::vector<const char *> command_line_arguments_vector;

  //Binary
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  command_line_arguments_vector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase3.h");
  command_line_arguments_vector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[command_line_arguments_vector.size()];
  for (int i = 0; i < command_line_arguments_vector.size(); i++) {
    commandLineArgumentsArray[i] = command_line_arguments_vector.at(i);
  }

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(command_line_arguments_vector.size(),
                                                   commandLineArgumentsArray[0],
                                                   commandLineArgumentsArray[1]));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase3");
  ASSERT_TRUE(module);
    print_itl.printModel(ModelGlobal::getModel());

  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << "TestCase3" << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/GMock_Test/tests/TestCase3.vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << "TestCase3" << " failed\n\n" << print_itl.print();

}

int main(int argc, char **argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}