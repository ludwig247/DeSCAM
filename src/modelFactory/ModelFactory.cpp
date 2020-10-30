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
DESCAM::ModelFactory::ModelFactory(IFindModules *find_modules,
                                   IFindPorts *find_ports,
                                   IFindGlobal *find_global,
                                   IFindNetlist *find_netlist,
                                   IFindProcess *find_process,
                                   IFindSCMain *find_sc_main,
                                   IFindDataFlowFactory *find_data_flow_factory) :
    ci_(nullptr),
    context_(nullptr),
    ostream_(llvm::errs()),
    model_(nullptr),
    find_modules_(find_modules),
    find_ports_(find_ports),
    find_global_(find_global),
    find_netlist_(find_netlist),
    find_process_(find_process),
    find_sc_main_(find_sc_main),
    find_data_flow_factory_(find_data_flow_factory) {
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

  this->find_modules_->setup(decl, this->ci_, this->model_);
  auto modules = this->find_modules_->getModules();

  for (auto &module:modules) {
    model_->addModule(module);
  }

  EXECUTE_TERMINATE_IF_ERROR(this->removeUnused())
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
      auto stmts = find_global_->getFunctionBody(func.first, func.second);
      func.second->setStmtList(stmts);
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
