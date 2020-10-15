//
// Created by mi-alkoudsi
//


#include <iostream>
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include "CommandLineProcess.h"
#include "CommandLineParameter.h"
#include "ModelGlobal.h"
#include "FatalError.h"
#include "Logger/Logger.h"
#include "Logger/ConsoleSink.h"

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

namespace py = pybind11;

using namespace DESCAM;

int checkFile(int argc, const char *argv[]) {
  //Process commandline data
  DESCAM::CommandLineProcess cml = DESCAM::CommandLineProcess(argc, argv);
  /* Initialize logger */
  //setting sinks
  std::shared_ptr<DESCAM::LoggerSink> consoleSink = std::make_shared<DESCAM::ConsoleSink>();
  consoleSink->setFormatOption(DESCAM::LoggerFormatter::FormatOption::JSON);
  DESCAM::Logger::addSink(consoleSink);
  //setting filtering options
  DESCAM::Logger::setFilteringOptions(
      std::set<DESCAM::LoggerFilter::FilterOptions>{DESCAM::LoggerFilter::FilterOptions::showSyntaxMsgs,
                                                    DESCAM::LoggerFilter::FilterOptions::showBehaviorMsgs,
                                                    DESCAM::LoggerFilter::FilterOptions::showPortsMsgs,
                                                    DESCAM::LoggerFilter::FilterOptions::showFunctionMsgs}
  );

  // Compositional root
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

  throw std::runtime_error("NOT ALLOWED");
  // TODO Insert CheckErrors again
  /*auto check_errors = new CheckErrors(find_functions.get(),
                                      find_initial_values.get(),
                                      find_modules.get(),
                                      find_new_datatype.get(),
                                      find_ports.get(),
                                      find_global.get(),
                                      find_netlist.get(),
                                      find_process.get(),
                                      find_variables.get(),
                                      find_sc_main.get(),
                                      find_da);

  //Create model
  ASSERT_MODEL_CREATION(DESCAM::ModelGlobal::createModel(argc, "DESCAM", cml.getSourceFile(), check_errors, true))*/
  // write log messages to all sinks
  DESCAM::Logger::log();
  return 0;
}

PYBIND11_MODULE(descamCheck, pyModule) {
  pyModule.def("descamCheck", [](const std::vector<std::string> &args) {
    std::vector<const char *> cstrs;
    auto binary = "DESCAM";
    cstrs.push_back(binary);
    cstrs.reserve(args.size() + 1);
    for (auto &s : args) cstrs.push_back(s.c_str());
    return checkFile(cstrs.size(), cstrs.data());
  });
}

/*
const std::string getFileName(std::string fileDir) {
    std::string filename = "";
    int i = fileDir.length() - 1;
    while (fileDir[i] != '/' && i >= 0) {
        i--;
    }
    filename = fileDir.substr(i + 1, fileDir.length() - i);
    return filename;
}
*/