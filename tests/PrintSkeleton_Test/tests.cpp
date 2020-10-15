//
// Created by tobias on 11.04.17.
//
#include <gtest/gtest.h>

#include "PrintSkeleton_Test.h"

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

int main(int argc, char **argv) {
  std::vector<const char *> commandLineArugmentsVector;

  //Binaray
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  commandLineArugmentsVector.push_back(bin.c_str());

  //SRC-File to be analyzed
  std::string file_path = std::string(SCAM_HOME"/tests/PrintSkeleton_Test/TestCases/Tests.h");
  commandLineArugmentsVector.push_back(file_path.c_str());

  //Creates an instance of ModelFactory and calls ModelFactory::HandleTranslationUnit
  const char *commandLineArgumentsArray[commandLineArugmentsVector.size()];
  for (int i = 0; i < commandLineArugmentsVector.size(); i++) {
    commandLineArgumentsArray[i] = commandLineArugmentsVector.at(i);
  }

  //Compositional root
  std::unique_ptr<IFindFunctions> find_functions = std::make_unique<FindFunctions>();
  std::unique_ptr<IFindInitialValues> find_initial_values = std::make_unique<FindInitialValues>();
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindNetlist> find_netlist = std::make_unique<FindNetlist>();
  std::unique_ptr<IFindProcess> find_process = std::make_unique<FindProcess>();
  std::unique_ptr<IFindVariables> find_variables = std::make_unique<FindVariables>();
  std::unique_ptr<IFindSCMain> find_sc_main = std::make_unique<FindSCMain>();
  std::unique_ptr<IFindDataFlowFactory> find_data_flow_factory = std::make_unique<FindDataFlowFactory>();

  auto model_factory = new ModelFactory(find_functions.get(),
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

  DESCAM::ModelGlobal::createModel(commandLineArugmentsVector.size(),
                                   commandLineArgumentsArray[0],
                                   commandLineArgumentsArray[1],
                                   model_factory);

  for (auto module: ModelGlobal::getModel()->getModules()) {
    {
      CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", true);
      CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", false);
      PrintSkeleton printSkeleton;
      auto result = printSkeleton.printModule(module.second);
      std::ofstream moduleString;
      moduleString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/vhdl/" + result.first);
      moduleString << result.second;
      moduleString.close();

      result = printSkeleton.printLocalTypes(module.second);
      std::ofstream functionString;
      functionString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/vhdl/" + result.first);
      functionString << result.second;
      functionString.close();
    }

    {
      CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "vhdl", false);
      CommandLineParameter::setPluginOptionParameter("PrintSkeleton", "sv", true);

      PrintSkeleton printSkeleton;
      auto result = printSkeleton.printModule(module.second);
      std::ofstream moduleString;
      moduleString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/sv/" + result.first);
      moduleString << result.second;
      moduleString.close();

      result = printSkeleton.printLocalTypes(module.second);
      std::ofstream functionString;
      functionString.open(SCAM_HOME"/tests/PrintSkeleton_Test/unsorted/sv/" + result.first);
      functionString << result.second;
      functionString.close();
    }
  }

  testing::InitGoogleTest(&argc, argv);

  return RUN_ALL_TESTS();
}
