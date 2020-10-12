//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>
#include "Config.h"
#include <ModelGlobal.h>
#include <fstream>
#include <FatalError.h>
#include <PrintITL/PrintITL.h>

//TODO: no need for main
TEST(gmock_test,TestCase1){
  std::vector<const char *> commandLineArugmentsVector;

  //Binaray
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  commandLineArugmentsVector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase1.h");
  commandLineArugmentsVector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
  for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
    commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
  }

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],commandLineArgumentsArray[1]));

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


TEST(gmock_test,TestCase2){

  DataTypes::reset();

  std::vector<const char *> commandLineArugmentsVector;

  //Binaray
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  commandLineArugmentsVector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase2.h");
  commandLineArugmentsVector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
  for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
    commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
  }

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],commandLineArgumentsArray[1]));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase2");
  ASSERT_TRUE(module);
  print_itl.printModel(ModelGlobal::getModel());
//  Only for generation
//  std::ofstream myfile;
//  myfile.open(SCAM_HOME"/tests/GMock_Test/tests/TestCase2.vhi");
//  myfile << print_itl.print();
//  myfile.close();


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



TEST(gmock_test,TestCase3){

  DataTypes::reset();

  std::vector<const char *> commandLineArugmentsVector;

  //Binaray
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  commandLineArugmentsVector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/GMock_Test/tests/TestCase3.h");
  commandLineArugmentsVector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
  for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
    commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
  }

  ASSERT_NO_THROW(DESCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(), commandLineArgumentsArray[0],commandLineArgumentsArray[1]));

  PrintITL print_itl;

  ASSERT_TRUE(ModelGlobal::getModel());
  ASSERT_TRUE(ModelGlobal::getModel()->getModules().size() == 1);
  auto module = ModelGlobal::getModel()->getModules().at("TestCase3");
  ASSERT_TRUE(module);
    print_itl.printModel(ModelGlobal::getModel());
//  Only for generation
//  std::ofstream myfile;
//  myfile.open(SCAM_HOME"/tests/GMock_Test/tests/TestCase3.vhi");
//  myfile << print_itl.print();
//  myfile.close();


  ASSERT_NO_THROW(print_itl.print());
  std::cout << "Instance: " << "TestCase3" << std::endl;
  std::ifstream ifs(SCAM_HOME"/tests/GMock_Test/tests/TestCase3.vhi");
  ASSERT_TRUE(bool(ifs)) << "Can't open file";

  std::stringstream buffer;
  std::string content((std::istreambuf_iterator<char>(ifs)),
                      (std::istreambuf_iterator<char>()));

  ASSERT_EQ(content, print_itl.print()) << "Test for module " << "TestCase3" << " failed\n\n" << print_itl.print();
  std::cout << "" << std::endl;

}


int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}