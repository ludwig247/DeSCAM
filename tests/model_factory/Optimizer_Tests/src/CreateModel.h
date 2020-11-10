//
// Created by mi-alkoudsi on 08.12.19.
//

#ifndef OPTIMIZER_TEST_CREATEMODEL_H
#define OPTIMIZER_TEST_CREATEMODEL_H

#include <PrintITL/PrintITL.h>
#include <Model.h>
#include <ModelFactory.h>
#include <PluginAction.h>
#include <ModelGlobal.h>
#include <fstream>
#include <gtest/gtest.h>
#include <Optimizer/Optimizer.h>

#include "FindFunctions.h"
#include "FindInitialValues.h"
#include "FindModules.h"
#include "FindNewDatatype.h"
#include "FindPorts.h"
#include "FindGlobal.h"
#include "FindProcess.h"
#include "FindVariables.h"
#include "FindInstances.h"
#include "FindStateName.h"

static std::vector<DESCAM::Module *> createModules(std::string file_path) {
  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
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
                                        find_process.get(),
                                        find_variables.get(),
                                        find_data_flow_factory.get(),
                                        find_instances.get());

  DESCAM::ModelGlobal::createModel(2, "DESCAM", file_path.c_str(),model_factory);

    std::vector<DESCAM::Module *> modulesVector;
    for (const auto &module: DESCAM::ModelGlobal::getModel()->getModules()) {
        modulesVector.push_back(module.second);
    }
    return modulesVector;
}

static std::vector<DESCAM::Model *>
createModel(std::string file_path, const std::set<std::string> &optimizeOptionsSet = {}, bool isWrapper = true) {
    if (!optimizeOptionsSet.empty()) {
        CommandLineParameter::setOptimizeOptionsSet(optimizeOptionsSet);
    }
  //Compositional root
  std::unique_ptr<IFindModules> find_modules = std::make_unique<FindModules>();
  std::unique_ptr<IFindNewDatatype> find_new_datatype = std::make_unique<FindNewDatatype>();
  std::unique_ptr<IFindPorts> find_ports = std::make_unique<FindPorts>(find_new_datatype.get());
  std::unique_ptr<IFindGlobal> find_global = std::make_unique<FindGlobal>();
  std::unique_ptr<IFindInstances> find_instances = std::make_unique<FindInstances>();
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
                                        find_process.get(),
                                        find_variables.get(),
                                        find_data_flow_factory.get(),
                                        find_instances.get());



    DESCAM::ModelGlobal::createModel(2, "DESCAM", file_path.c_str(), model_factory);

    std::vector<DESCAM::Model *> model;
    model.push_back(DESCAM::ModelGlobal::getModel());
    return model;
}

#endif //OPTIMIZER_TEST_CREATEMODEL_H
