//
// Created by Nawras Altaleb (nawras.altaleb89@gmail.com) on 17.04.18.
//

#include <iostream>
#include "CommandLineProcess.h"
#include "ManageOutput.h"
#include "PluginFactory.h"
#include <ModelGlobal.h>
#include <Logger/ConsoleSink.h>
#include <Logger/FileSink.h>
#include <FatalError.h>

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

int main(int argc, const char **argv) {
  //Process commandline data
  CommandLineProcess cml = CommandLineProcess(argc, argv);
  //Create model
  std::cout << "==================================================================" << std::endl;
  std::cout << "......................... Creating model ........................." << std::endl;
  std::cout << "------------------------------------------------------------------" << std::endl << std::endl;

  /* Initialize logger */
  //setting sinks
  std::shared_ptr<LoggerSink> consoleSink = std::make_shared<DESCAM::ConsoleSink>();
  consoleSink->setFormatOption(LoggerFormatter::FormatOption::TEXT);
  DESCAM::Logger::addSink(consoleSink);
  std::shared_ptr<LoggerSink> fileSink = std::make_shared<DESCAM::FileSink>(std::string(SCAM_HOME"/bin/LOGS"), true);
  fileSink->setFormatOption(LoggerFormatter::FormatOption::JSON);
  DESCAM::Logger::addSink(fileSink);
  //setting filtering options
  DESCAM::Logger::setFilteringOptions(
      std::set<LoggerFilter::FilterOptions>{LoggerFilter::FilterOptions::showAllMsgs});
  DESCAM::Logger::setPrintDecorativeFrames();

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

  //Create model
  std::string bin = std::string(SCAM_HOME"/bin/DESCAM ");
  DataTypes::reset();
  ASSERT_MODEL_CREATION(DESCAM::ModelGlobal::createModel(argc, bin, cml.getSourceFile(), model_factory))
  // write log messages to all sinks
  if (DESCAM::Logger::hasFeedback()) {
    DESCAM::Logger::log();
  }
  //Printing options according to commandline styles chosen
  if (cml.getActivePlugins().size() > 0) {
    std::cout << "==================================================================" << std::endl;
    std::cout << "......................... Printing model ........................." << std::endl;
    std::cout << "------------------------------------------------------------------" << std::endl << std::endl;

    for (auto it = cml.getActivePlugins().begin(); it != cml.getActivePlugins().end(); it++) {
      PluginFactory *style = PluginFactory::create(*it);
      if (style != nullptr) {
        std::cout << "=======================================================================\n";
        std::cout << "========================= " << *it << " =========================\n";
        std::cout << "=======================================================================\n\n";
        if (!cml.getOutputDirectory().empty()) {
          if (createDirectory(*it, cml.getOutputDirectory())) {
            std::map<std::string, std::string> pluginOutput;
            pluginOutput = style->printModel(DESCAM::ModelGlobal::getModel());
            createFiles(*it, pluginOutput, cml.getOutputDirectory());
          } else {
            std::cout << "Couldn't create directory: " << cml.getOutputDirectory() << "/" << *it << "\n";
          }
        } else {
          std::map<std::string, std::string> pluginOutput;
          pluginOutput = style->printModel(DESCAM::ModelGlobal::getModel());
          printFiles(*it, pluginOutput);
        }
      } else {
        std::cout << "**************** NO SUCH Print Style AVAILABLE !!!! (" << *it << ")\n";
        std::cout << "make sure to include your implementation in Plugin/PluginFactory.cpp\n";
        std::cout << "********************************************************************\n";
      }
    }
  }
  return 0;
}
