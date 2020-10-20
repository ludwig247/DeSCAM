//
// Created by ludwig on 15.09.15.
//

#include "ModelFactory.h"
#include <CFGFactory.h>
#include <Logger/Logger.h>
#include <ModelGlobal.h>
#include <FunctionFactory.h>
#include <CreateRealCFG.h>
#include "ModuleInstance.h"
#include "../parser/CommandLineParameter.h"
#include <Optimizer/Optimizer.h>
#include <OperationFactory.h>
#include <PropertyFactory.h>
#include <FatalError.h>
#include "DescamException.h"

// FindX Implementations
#include "FindNewDatatype.h"
#include "FindInitialValues.h"
#include "FindDataFlow.h"
#include "FindFunctions.h"
#include "FindGlobal.h"

//Constructor
DESCAM::ModelFactory::ModelFactory(IFindFunctions *find_functions,
                                   IFindInitialValues *find_initial_values,
                                   IFindModules *find_modules,
                                   IFindNewDatatype *find_new_datatype,
                                   IFindPorts *find_ports,
                                   IFindGlobal *find_global,
                                   IFindNetlist *find_netlist,
                                   IFindProcess *find_process,
                                   IFindVariables *find_variables,
                                   IFindSCMain *find_sc_main,
                                   IFindDataFlowFactory *find_data_flow_factory) :
    ci_(nullptr),
    context_(nullptr),
    ostream_(llvm::errs()),
    model_(nullptr),
    find_functions_(find_functions),
    find_initial_values_(find_initial_values),
    find_modules_(find_modules),
    find_new_datatype_(find_new_datatype),
    find_ports_(find_ports),
    find_global_(find_global),
    find_netlist_(find_netlist),
    find_process_(find_process),
    find_variables_(find_variables),
    find_sc_main_(find_sc_main),
    find_data_flow_factory_(find_data_flow_factory) {

  //Unimportant modules
  this->unimportant_modules_.emplace_back("sc_event_queue");//! Not important for the abstract model:
  this->unimportant_modules_.emplace_back("Testbench");//! Not important for the abstract model:
}

void DESCAM::ModelFactory::setup(CompilerInstance *ci) {
  this->ci_ = ci;
  this->context_ = &ci->getASTContext();
}

bool DESCAM::ModelFactory::preFire() {
  return !DESCAM::Logger::isTerminate();
}

bool DESCAM::ModelFactory::fire() {
  //Translation Unit
  TranslationUnitDecl *tu = context_->getTranslationUnitDecl();

  //DESCAM model
  this->model_ = new Model("top_level");
  ModelGlobal::setModel(model_);

  //Global variables
  this->addGlobalConstants(tu);

  //Modules
  this->addModules(tu);

  //Remove unused things from the model
  this->removeUnused();

  //Instances
  this->addInstances(tu);
  //sc_main
  return true;
}

/**
 * Create Module

 * Creation of all other elements(Ports,Sub-Modules,Signals, Interfaces ...)
 * is executed by the module constructor method addModule using the reference to the
 * module declaration of the ast
*/
void DESCAM::ModelFactory::addModules(clang::TranslationUnitDecl *decl) {

  this->find_modules_->setup(decl);

  //Fill the model with modules(structural description)
  for (auto &scpar_module: find_modules_->getModuleMap()) {

    //Module Name
    std::string name = scpar_module.first;
    auto module_location_info = DESCAM::GlobalUtilities::getLocationInfo<CXXRecordDecl>(scpar_module.second, ci_);

    //Module is on the unimportant module list -> skip
    if (std::find(this->unimportant_modules_.begin(), this->unimportant_modules_.end(), name) !=
        this->unimportant_modules_.end()) {
      //Skip this module
      continue;
    }
    std::cout << "############################" << std::endl;
    std::cout << "Module: " << name << std::endl;
    std::cout << "############################" << std::endl;
    //DataTypes::reset();//FIXME:
    auto module = new Module(scpar_module.first, module_location_info);
    model_->addModule(module);
    //Members
    this->addVariables(module, scpar_module.second);
    //Ports
    this->addPorts(module, scpar_module.second);
    //Combinational Functions
    this->addFunctions(module, scpar_module.second);
    //Processes
    this->addBehavior(module, scpar_module.second);
    //this->addCommunicationFSM(module);
  }
}

//! Add structure ...
void DESCAM::ModelFactory::addInstances(TranslationUnitDecl *tu) {

  find_sc_main_->setup(tu);

  //The top instance is the sc_main. It doesn't contain any ports
  //Create empty dummy module for sc_main
  auto sc_main = new Module("main");
  //this->model->addModule(sc_main);
  //Create instance for sc_main and add to model
  auto top_instance = new ModuleInstance("TopInstance", sc_main);
  //std::cout << model->getModuleInstance() << std::cout;
  model_->addTopInstance(top_instance);
  if (!find_sc_main_->isScMainFound()) {
    std::cout << "" << std::endl;
    std::cout << "======================" << std::endl;
    std::cout << "Instances:" << std::endl;
    std::cout << "----------------------" << std::endl;
    std::cout << "-I- No main found, can't create netlist" << std::endl;
    return;
  }

  find_netlist_->setup(find_sc_main_->getSCMainFunctionDecl());
  //findNetlist.getInstanceMap() = std::map<string instance_name,string sc_module>
  for (const auto &instance: find_netlist_->getInstanceMap()) {
    //Search for pointer in module map
    Module *module = model_->getModules().find(instance.second)->second;
    //In case module is not found -> error!
    if (!module) {TERMINATE("ModelFactory::addInstances module not found"); }
    //Add instance to model
    top_instance->addModuleInstance(new ModuleInstance(instance.first, module));
  }
  //ChannelMap = <<Instance,Port>, channelDecl*> >
  //Create exactly one channel for each channelDecl and attach respective ports to this channel
  for (const auto &channel: find_netlist_->getChannelMap()) {
    //Search instance in model ( instanceName = channel.first.first)
    std::string instanceName = channel.first.first;
    ModuleInstance *instance;
    instance = top_instance->getModuleInstances().find(instanceName)->second;

    //Channel name and type
    std::string channel_name = channel.second->getNameInfo().getAsString();

    //Check whether channel is already created
    //If channel does not already exist
    if (top_instance->getChannelMap().count(channel_name) == 0) {
      //Create new channel
      //Add to channelMap of instance
      top_instance->addChannel(new Channel(channel_name));
    }
    //Otherwise receive current channel
    Channel *current_channel = top_instance->getChannelMap().find(channel_name)->second;

    //Add port to channel
    //Search search port in instance.module ( portName = channel.first.second )
    std::string port_name = channel.first.second;
    Port *port = instance->getStructure()->getPorts().find(port_name)->second;

    //Differ between in/output port
    std::string direction = port->getInterface()->getDirection();
    //Bind Port to Channel
    if (direction == "in") {
      current_channel->setToPort(port);
      current_channel->setToInstance(instance);
    } else if (direction == "out") {
      current_channel->setFromPort(port);
      current_channel->setFromInstance(instance);
    } else {TERMINATE("Interface direction not supported"); }
    //Add instance to channel

  }
}

//! Use FindPorts and FindNetlist in order to add the ports to the model
void DESCAM::ModelFactory::addPorts(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Ports);
  //Parse ports from CXXRecordDecl
  //Ports are sc_in,sc_out, sc_inout (sc_port) is considers as
  //Right now, we are not interested about the direction of the port.

  //DESCAM::FindPorts this->find_ports_(this->_context, _ci);

  this->find_ports_->setup(decl, ci_);
  auto portsLocationMap = this->find_ports_->getLocationInfoMap();
  //Add Ports -> requires Name, Interface and DataType
  //Rendezvous
  //Input ports
  for (auto &port: this->find_ports_->getInPortMap()) {
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("blocking", "in"))
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE(
          "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Port *inPort = nullptr;
    DESCAM_ASSERT (if (portsLocationMap.find(port.first) != portsLocationMap.end())
                     inPort = new Port(port.first, interface,
                                       DataTypes::getDataType(
                                           port.second),
                                       portsLocationMap[port.first]);
                   else inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                       module->addPort(inPort))
  }
  //Output ports
  for (auto &port: this->find_ports_->getOutPortMap()) {
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("blocking", "out"))
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE(
          "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Port *outPort = nullptr;
    DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                    outPort = new Port(port.first, interface,
                                       DataTypes::getDataType(
                                           port.second),
                                       portsLocationMap[port.first]);
                  else outPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                      module->addPort(outPort))
  }

  //AlwaysReady
  //Input ports
  for (auto &port: this->find_ports_->getMasterInPortMap()) {
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("master", "in"))
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE(
          "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Port *inPort = nullptr;
    DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                    inPort = new Port(port.first, interface,
                                      DataTypes::getDataType(
                                          port.second),
                                      portsLocationMap[port.first]);
                  else inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                      module->addPort(inPort))

  }
  //Output ports
  for (auto &port: this->find_ports_->getMasterOutPortMap()) {
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("master", "out"))
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE(
          "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Port *outPort = nullptr;
    DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                    outPort = new Port(port.first, interface,
                                       DataTypes::getDataType(
                                           port.second),
                                       portsLocationMap[port.first]);
                  else outPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                      module->addPort(outPort))
  }

  //Input ports
  for (auto &port: this->find_ports_->getSlaveInPortMap()) {
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("slave", "in"))
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE(
          "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Port *inPort = nullptr;
    DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                    inPort = new Port(port.first, interface,
                                      DataTypes::getDataType(
                                          port.second),
                                      portsLocationMap[port.first]);
                  else inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                      module->addPort(inPort))

  }
  //Output ports
  for (auto &port: this->find_ports_->getSlaveOutPortMap()) {
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE(
          "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("slave", "out"))
    Port *outPort = nullptr;
    DESCAM_ASSERT(if (portsLocationMap.find(port.first) != portsLocationMap.end())
                    outPort = new Port(port.first, interface,
                                       DataTypes::getDataType(
                                           port.second),
                                       portsLocationMap[port.first]);
                  else outPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                      module->addPort(outPort))
  }

  //Shared ports
  //Input ports
  for (auto &port: this->find_ports_->getInSharedPortMap()) {
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE("No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("shared", "in"))
    Port *inPort = nullptr;
    DESCAM_ASSERT(inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                      module->addPort(inPort))

  }
  //Output ports
  for (auto &port: this->find_ports_->getOutSharedPortMap()) {
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE(
          "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("shared", "out"))
    Port *inPort = nullptr;
    DESCAM_ASSERT(inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                      module->addPort(inPort))
  }
  EXECUTE_TERMINATE_IF_ERROR(this->removeUnused())
}

//! Adds processes to the model
void DESCAM::ModelFactory::addBehavior(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Behavior);

  //Find the process describing the behavior
  find_process_->setup(decl);
  clang::CXXMethodDecl *methodDecl;
  if (find_process_->isValidProcess()) {
    methodDecl = find_process_->getProcess();
  }
  /*
   * TODO What happens when methodDecl is not initialized? Does it violate the contract of cfgFactory? maybe else part?
   */
  DESCAM::CFGFactory cfgFactory(methodDecl, ci_, module, find_data_flow_factory_, true);
  EXECUTE_TERMINATE_IF_ERROR(this->removeUnused())
  if (cfgFactory.getControlFlowMap().empty()) TERMINATE("CFG is empty!");
  DESCAM::CfgNode::node_cnt = 0;
  DESCAM::State::state_cnt = 0;
  DESCAM::Operation::operations_cnt = 0;
  auto optOptionsSet = CommandLineParameter::getOptimizeOptionsSet();

  if (!optOptionsSet.empty()) {
    DESCAM::Optimizer opt(cfgFactory.getControlFlowMap(), module, this->model_, optOptionsSet);
    module->setCFG(opt.getCFG());
    DESCAM::OperationFactory operationFactory(opt.getCFG(), module);
    PropertyFactory propertyFactory(module);
    module->setPropertySuite(propertyFactory.getPropertySuite());
  } else {
    DESCAM::CreateRealCFG test(cfgFactory.getControlFlowMap());
    module->setCFG(test.getCFG());
    DESCAM::OperationFactory operationFactory(test.getCFG(), module);
    PropertyFactory propertyFactory(module);
    module->setPropertySuite(propertyFactory.getPropertySuite());
  }
}

//! Adds every Member of a sc_module to the DESCAM::Module
void DESCAM::ModelFactory::addVariables(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Variables);
  //Find all Variables within the Module
  find_variables_->setup(decl, this->ci_, module);

  module->addVariables(find_variables_->getVariableMap());

  EXECUTE_TERMINATE_IF_ERROR(this->removeUnused())
}

bool DESCAM::ModelFactory::postFire() {
  return false;
}

void DESCAM::ModelFactory::HandleTranslationUnit(ASTContext &context) {
// Pass 1: Find the necessary information.
  if (!preFire()) {
    return;
  } else {
    bool f = fire();
    if (!f) {
      std::cout << "----------Fire(fail)" << std::endl;
      return;
      postFire();
    } else {
    }
  }
}

void DESCAM::ModelFactory::addFunctions(DESCAM::Module *module, CXXRecordDecl *decl) {
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

  EXECUTE_TERMINATE_IF_ERROR(this->removeUnused())
}

void DESCAM::ModelFactory::addGlobalConstants(TranslationUnitDecl *pDecl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::GlobalConstants);

  //Find all global functions and variables
  this->find_global_->setup(pDecl, ci_, find_data_flow_factory_);

  for (const auto &var: this->find_global_->getVariableMap()) {
    this->model_->addGlobalVariable(var.second);
  }

  //Add all global functions need in case of nested functions
  for (const auto &func: this->find_global_->getFunctionMap()) {
    //Add the definition to the function map
    this->model_->addGlobalFunction(func.second);
  }

  for (auto func: this->find_global_->getFunctionMap()) {
    try {
      std::string name = func.first;
      //Create blockCFG for this process
      //Active searching only for functions
      //If fails ... function is not SystemC-PPA compliant
      //don't add body to function
      // TODO: Replace type deduction through flags by strong types and overloaded function
      FindDataFlow::functionName = func.first;
      FindDataFlow::isFunction = true;
      auto module = Module("placeholder");
      DESCAM::CFGFactory
          cfgFactory(this->find_global_->getFunctionDeclMap().at(name), ci_, &module, find_data_flow_factory_);
      FindDataFlow::functionName = "";
      FindDataFlow::isFunction = false;
      //Transform blockCFG back to code
      FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), func.second, nullptr);
      func.second->setStmtList(functionFactory.getStmtList());
      Logger::tagTempMsgs(func.first);
    } catch (std::runtime_error &e) {
      this->model_->removeGlobalFunction(func.second);
      Logger::clearTempVector();
    }
  }
}

void DESCAM::ModelFactory::removeUnused() {

  //Remove unused globalVariables & globalFunctions
  std::map<Variable *, bool> removeGlobalVars;

  for (const auto &var: model_->getGlobalVariableMap()) {
    assert(var.second->isBuiltInType() && var.second->isConstant() && "Only built-in allowed as global variable");
    removeGlobalVars.insert(std::make_pair(var.second, true));
  }
  std::map<Function *, bool> removeGlobalFunctions;
  for (const auto &var: model_->getGlobalFunctionMap()) {
    //assert(var.second->isBuiltInType() && var.second->isConstant() && "Only built-in allowed as global variable");
    removeGlobalFunctions.insert(std::make_pair(var.second, true));
  }

  auto globalFunMap = this->model_->getGlobalFunctionMap();
  //Nested calls
  for (const auto &func  : globalFunMap) {
    for (const auto &retValCond  : func.second->getReturnValueConditionList()) {
      for (auto usedFunc: ExprVisitor::getUsedFunction(retValCond.first->getReturnValue())) {
        if (globalFunMap.find(usedFunc->getName()) != globalFunMap.end()) {
          removeGlobalFunctions.at(usedFunc) = false;
        }
      }
      for (auto usedVar: ExprVisitor::getUsedVariables(retValCond.first->getReturnValue())) {
        if (usedVar->isConstant()) removeGlobalVars.at(usedVar) = false;
      }
      for (auto cond: retValCond.second) {
        for (auto usedFunc: ExprVisitor::getUsedFunction(cond)) {
          if (globalFunMap.find(usedFunc->getName()) != globalFunMap.end()) {
            removeGlobalFunctions.at(usedFunc) = false;
          }
        }
        for (auto usedVar: ExprVisitor::getUsedVariables(cond)) {
          if (usedVar->isConstant()) removeGlobalVars.at(usedVar) = false;
        }
      }
    }
  }

  for (const auto &module: model_->getModules()) {
    for (auto state : module.second->getFSM()->getStateMap()) {
      for (auto op: state.second->getOutgoingOperationsList()) {
        for (auto ass: op->getAssumptionsList()) {
          for (auto usedVar: ExprVisitor::getUsedVariables(ass)) {
            if (usedVar->isConstant()) removeGlobalVars.at(usedVar) = false;
          }
          for (auto usedFunc: ExprVisitor::getUsedFunction(ass)) {
            if (globalFunMap.find(usedFunc->getName()) != globalFunMap.end()) {
              removeGlobalFunctions.at(usedFunc) = false;
            }
          }
        }
        //Check commitment for usage
        for (auto comm: op->getCommitmentsList()) {
          if (PrintStmt::toString(comm->getLhs()) == PrintStmt::toString(comm->getRhs())) {
            continue;
          }
          for (auto usedVar: ExprVisitor::getUsedVariables(comm->getRhs())) {
            if (usedVar->isConstant()) removeGlobalVars.at(usedVar) = false;
          }
          for (auto usedFunc: ExprVisitor::getUsedFunction(comm->getRhs())) {
            if (globalFunMap.find(usedFunc->getName()) != globalFunMap.end()) {
              removeGlobalFunctions.at(usedFunc) = false;
            }
          }
        }
      }
      //Check functions:
      for (const auto &func: module.second->getFunctionMap()) {
        for (const auto &retValCond  : func.second->getReturnValueConditionList()) {
          for (auto usedFunc: ExprVisitor::getUsedFunction(retValCond.first->getReturnValue())) {
            if (globalFunMap.find(usedFunc->getName()) != globalFunMap.end()) {
              removeGlobalFunctions.at(usedFunc) = false;
            }
          }
          for (auto usedVar: ExprVisitor::getUsedVariables(retValCond.first->getReturnValue())) {
            if (usedVar->isConstant()) removeGlobalVars.at(usedVar) = false;
          }
          for (auto cond: retValCond.second) {
            for (auto usedFunc: ExprVisitor::getUsedFunction(cond)) {
              if (globalFunMap.find(usedFunc->getName()) != globalFunMap.end()) {
                removeGlobalFunctions.at(usedFunc) = false;
              }
            }
            for (auto usedVar: ExprVisitor::getUsedVariables(cond)) {
              if (usedVar->isConstant()) removeGlobalVars.at(usedVar) = false;
            }
          }
        }
      }
    }
  }

  //Remove global vars
  for (auto var: removeGlobalVars) {
    if (var.second) {
      this->model_->removeGlobalVariable(var.first);
    }
  }
  //Remove global functions
  std::map<Function *, bool> newGlobalFunc;
  for (auto func: removeGlobalFunctions) {
    if (func.second) {
      this->model_->removeGlobalFunction(func.first);
      Logger::removeFromTempMap(func.first->getName());
    }
  }
}
