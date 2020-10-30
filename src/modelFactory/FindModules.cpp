#include <iostream>
#include "FindModules.h"
#include "Logger/Logger.h"
#include "FunctionFactory.h"
#include "IFindProcess.h"
#include "FatalError.h"
#include "CommandLineParameter.h"
#include "Optimizer/Optimizer.h"
#include "OperationFactory.h"
#include "PropertyFactory.h"

namespace DESCAM {

FindModules::FindModules(IFindVariables *find_variables,
                         IFindPorts *find_ports,
                         IFindFunctions *find_functions,
                         IFindProcess *find_process) :
    ci_(nullptr),
    find_variables_(find_variables),
    find_ports_(find_ports),
    find_functions_(find_functions),
    find_process_(find_process) {
  assert(find_variables);
  assert(find_ports);
  assert(find_functions);
  assert(find_process);

  //Unimportant modules
  this->unimportant_modules_.emplace_back("sc_event_queue");//! Not important for the abstract model:
  this->unimportant_modules_.emplace_back("Testbench");//! Not important for the abstract model:
}

bool FindModules::VisitCXXRecordDecl(clang::CXXRecordDecl *cxxDecl) {
  //Checks whether the module is just a declaration and not a implementation
  if (!cxxDecl->hasDefinition()) {
    return true;
  }

  //If class is a systemC module it has to have a base class
  if (cxxDecl->getNumBases() <= 0) {
    return true;
  }
  //Assume: All user defined modules can be identified by a basename "class sc::core::sc_module"
  //Issues: doesn't filters all classes, e.g. sc_event_queue has also this basename
  //Idea: sort out those modules by hand
  for (auto bi = cxxDecl->bases_begin(), be = cxxDecl->bases_end(); bi != be; ++bi) {
    clang::QualType q = bi->getType();
    //Check basename
    std::string baseName = q.getAsString();
    if (baseName == "class sc_core::sc_module" || baseName == "::sc_core::sc_module") {
      module_map_.insert(std::pair<std::string, clang::CXXRecordDecl *>(cxxDecl->getName().str(), cxxDecl));

    }
  }
  return true;
}

void FindModules::setup(clang::TranslationUnitDecl *decl, clang::CompilerInstance *ci, DESCAM::Model *model) {
  this->module_map_.clear();
  this->modules.clear();
  this->ci_ = ci;
  this->model_ = model;
  assert(decl);
  assert(ci);
  assert(model);
  TraverseDecl(decl);

  for (auto &scpar_module: module_map_) {

    auto
        module_location_info = DESCAM::GlobalUtilities::getLocationInfo<clang::CXXRecordDecl>(scpar_module.second, ci_);

    //Module is on the unimportant module list -> skip
    if (std::find(this->unimportant_modules_.begin(), this->unimportant_modules_.end(), scpar_module.first) !=
        this->unimportant_modules_.end()) {
      //Skip this module
      continue;
    }
    std::cout << "############################" << std::endl;
    std::cout << "Module: " << scpar_module.first << std::endl;
    std::cout << "############################" << std::endl;
    auto module = new Module(scpar_module.first, module_location_info);

    //Members
    this->addVariables(module, scpar_module.second);
    //Ports
    this->addPorts(module, scpar_module.second);
    //Combinational Functions
    this->addFunctions(module, scpar_module.second);

    //Processes
    this->addBehavior(module, scpar_module.second);

    modules.push_back(module);
    //this->addCommunicationFSM(module);
  }
}

std::vector<DESCAM::Module *> FindModules::getModules() {
  return modules;
}

//! Adds every Member of a sc_module to the DESCAM::Module
void DESCAM::FindModules::addVariables(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Variables);
  //Find all Variables within the Module
  find_variables_->setup(decl, this->ci_, module);

  module->addVariables(find_variables_->getVariableMap());
}

//! Use FindPorts and FindNetlist in order to add the ports to the model
void DESCAM::FindModules::addPorts(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Ports);
  //Parse ports from CXXRecordDecl
  //Ports are sc_in,sc_out, sc_inout (sc_port) is considers as
  //Right now, we are not interested about the direction of the port.

  //DESCAM::FindPorts this->find_ports_(this->_context, _ci);

  this->find_ports_->setup(decl, ci_, module);
  module->addPorts(find_ports_->getPortMap());
}

void DESCAM::FindModules::addFunctions(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Functions);
  //std::unique_ptr<IFindFunctions> findFunctions_ = FindFunctionsFactory::create(decl);
  find_functions_->setup(decl, ci_, module);

  auto functions = find_functions_->getFunctionDecls();
  module->addFunctions(functions);

  //Add behavioral description of function to module
  for (const auto &function: functions) {
    auto body = find_functions_->getFunctionBody(function.first);

    //Transform blockCFG back to code
    FunctionFactory functionFactory(body, function.second, nullptr);
    function.second->setStmtList(functionFactory.getStmtList());
  }
}

//! Adds processes to the model
void DESCAM::FindModules::addBehavior(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Behavior);

  //Find the process describing the behavior
  find_process_->setup(decl, ci_, module, model_);
  auto cfg = find_process_->getCFG();

  if (cfg.empty()) TERMINATE("CFG is empty!");
  DESCAM::CfgNode::node_cnt = 0;
  DESCAM::State::state_cnt = 0;
  DESCAM::Operation::operations_cnt = 0;
  auto optOptionsSet = CommandLineParameter::getOptimizeOptionsSet();

  if (!optOptionsSet.empty()) {
    DESCAM::Optimizer opt(cfg, module, model_, optOptionsSet);
    module->setCFG(opt.getCFG());
    DESCAM::OperationFactory operationFactory(opt.getCFG(), module);
    PropertyFactory propertyFactory(module);
    module->setPropertySuite(propertyFactory.getPropertySuite());
  } else {
    DESCAM::CreateRealCFG test(cfg);
    module->setCFG(test.getCFG());
    DESCAM::OperationFactory operationFactory(test.getCFG(), module);
    PropertyFactory propertyFactory(module);
    module->setPropertySuite(propertyFactory.getPropertySuite());
  }
}
}