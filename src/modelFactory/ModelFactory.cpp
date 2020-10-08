//
// Created by ludwig on 15.09.15.
//

#include "ModelFactory.h"
#include "FindInitialValues.h"
#include <FindSections.h>
#include <CFGFactory.h>
#include <FindNewDatatype.h>
#include <Logger/Logger.h>
#include <ModelGlobal.h>
#include <FunctionFactory.h>
#include <CreateRealCFG.h>
#include "ModuleInstance.h"
#include "FindDataFlow.h"
#include "FindFunctions.h"
#include "FindGlobal.h"
#include "../parser/CommandLineParameter.h"
#include <Optimizer/Optimizer.h>
#include <OperationFactory.h>
#include <PropertyFactory.h>
#include <FatalError.h>
#include "DescamException.h"

//Constructor
DESCAM::ModelFactory::ModelFactory(CompilerInstance &ci) :
    _sm(ci.getSourceManager()),
    _ci(ci),
    _context(ci.getASTContext()),
    _os(llvm::errs()),
    model(nullptr) {

  //Compositional root
  this->find_functions_ = std::make_unique<FindFunctions>();
  this->find_initial_values_ = std::make_unique<FindInitialValues>();

  //Unimportant modules
  this->unimportant_modules_.emplace_back("sc_event_queue");//! Not important for the abstract model:
  this->unimportant_modules_.emplace_back("Testbench");//! Not important for the abstract model:

  this->find_modules_ = std::make_unique<FindModules>();
  this->find_ports_ = std::make_unique<FindPorts>(&_ci);
  this->find_global_ = std::make_unique<FindGlobal>(_context.getTranslationUnitDecl(), _ci);
}

bool DESCAM::ModelFactory::preFire() {
  return !DESCAM::Logger::isTerminate();
}

bool DESCAM::ModelFactory::fire() {
  //Translation Unit
  TranslationUnitDecl *tu = _context.getTranslationUnitDecl();

  //DESCAM model
  this->model = new Model("top_level");
  ModelGlobal::setModel(model);

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

  //Fill the model with modules(structural describtion)
  for (auto &scparModule: find_modules_->getModuleMap()) {

    //Module Name
    std::string name = scparModule.first;
    auto moduleLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<CXXRecordDecl>(scparModule.second, _ci);

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
    auto module = new Module(scparModule.first, moduleLocationInfo);
    model->addModule(module);
    //Members
    this->addVariables(module, scparModule.second);
    //Ports
    this->addPorts(module, scparModule.second);
    //Combinational Functions
    this->addFunctions(module, scparModule.second);
    //Processe
    this->addBehavior(module, scparModule.second);
    //this->addCommunicationFSM(module);
  }
}

//! Add structure ...
void DESCAM::ModelFactory::addInstances(TranslationUnitDecl *tu) {
  FindSCMain scmain(tu);

  //The top instance is the sc_main. It doesn't contain any ports
  //Create empty dummy module for sc_main
  auto sc_main = new Module("main");
  //this->model->addModule(sc_main);
  //Create instance for sc_main and add to model
  auto topInstance = new ModuleInstance("TopInstance", sc_main);
  //std::cout << model->getModuleInstance() << std::cout;
  model->addTopInstance(topInstance);
  if (!scmain.isScMainFound()) {
    std::cout << "" << std::endl;
    std::cout << "======================" << std::endl;
    std::cout << "Instances:" << std::endl;
    std::cout << "----------------------" << std::endl;
    std::cout << "-I- No main found, can't create netlist" << std::endl;
    return;
  }

  FindNetlist findNetlist(scmain.getSCMainFunctionDecl());
  //findNetlist.getInstanceMap() = std::map<string instance_name,string sc_module>
  for (auto &instance: findNetlist.getInstanceMap()) {
    //Search for pointer in modul map
    Module *module = model->getModules().find(instance.second)->second;
    //In case module is not found -> error!
    if (!module) {TERMINATE("ModelFactory::addInstances module not found"); }
    //Add instance to model
    topInstance->addModuleInstance(new ModuleInstance(instance.first, module));
  }
  //ChannelMap = <<Instance,Port>, channelDecl*> >
  //Create exactly one channel for each channelDecl and attach respective ports to this channel
  for (auto channel: findNetlist.getChannelMap()) {
    //Search instance in model ( instanceName = channel.first.first)
    std::string instanceName = channel.first.first;
    ModuleInstance *instance = topInstance->getModuleInstances().find(instanceName)->second;

    //Channel name and type
    std::string channelName = channel.second->getNameInfo().getAsString();
    //std::cout << channelName << "= "<< channel.first.first << ":" << channel.first.second << std::endl;

    //Check whether channel is already created
    //If channel does not already exist
    if (topInstance->getChannelMap().count(channelName) == 0) {
      //Create new channel
      //Add to channelMap of instance
      topInstance->addChannel(new Channel(channelName));
    }
    //Otherwise receive current channel
    Channel *currentChannel = topInstance->getChannelMap().find(channelName)->second;

    //Add port to channel
    //Search search port in instance.module ( portName = channel.first.second )
    std::string portName = channel.first.second;
    Port *port = instance->getStructure()->getPorts().find(portName)->second;

    //Differ between in/output port
    std::string direction = port->getInterface()->getDirection();
    //Bind Port to Channel
    if (direction == "in") {
      currentChannel->setToPort(port);
      currentChannel->setToInstance(instance);
    } else if (direction == "out") {
      currentChannel->setFromPort(port);
      currentChannel->setFromInstance(instance);
    } else {TERMINATE("Interface direction not supported"); }
    //Add instance to channel

  }
}

//! Use FindPorts and FindNetlist in order to add the ports to the model
void DESCAM::ModelFactory::addPorts(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Ports);
  //Parse ports from CXXRecordDecl
  //Ports are sc_in,sc_out, sc_inout (sc_port) is consideres as
  //Right now, we are not interested about the direction of the port.

  //DESCAM::FindPorts this->find_ports_(this->_context, _ci);

  this->find_ports_->setup(decl);
  auto portsLocationMap = this->find_ports_->getLocationInfoMap();
  //Add Ports -> requires Name, Interface and DataType
  //RendezVouz
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
  DESCAM::FindProcess findProcess(decl);
  clang::CXXMethodDecl *methodDecl;
  if (findProcess.isValidProcess()) {
    methodDecl = findProcess.getProcess();
  }
  DESCAM::CFGFactory cfgFactory(methodDecl, _ci, module, true);
  EXECUTE_TERMINATE_IF_ERROR(this->removeUnused())
  if (cfgFactory.getControlFlowMap().empty()) TERMINATE("CFG is empty!");
  DESCAM::CfgNode::node_cnt = 0;
  DESCAM::State::state_cnt = 0;
  DESCAM::Operation::operations_cnt = 0;
  auto optOptionsSet = CommandLineParameter::getOptimizeOptionsSet();

  if (!optOptionsSet.empty()) {
    DESCAM::Optimizer opt(cfgFactory.getControlFlowMap(), module, this->model, optOptionsSet);
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
  FindVariables findVariables(decl);

  //Initial Values
  //FindInitialValues findInitalValues(decl, findVariables.getVariableMap(), module);

  //Add members to module
  for (auto &&variable: findVariables.getVariableTypeMap()) {
    //Add Variable to Module
    auto fieldDecl = findVariables.getVariableMap().find(variable.first)->second;
    auto varLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<FieldDecl>(fieldDecl, _ci);

    /*
     * Disinguish between local and global DataTypes.
     * If a module declares a type within it's class, then it's a local datatype ... global otherwise
     * This toggle is in place because of some legacy plugins not beeing aware of local/global types.
     */
    DataType *type;
    std::string typeName = FindNewDatatype::getTypeName(variable.second);
    //Step 1: Check whether the DataType already exists? Set type accordingly
    bool is_local = DataTypes::isLocalDataType(typeName, module->getName());
    bool is_global = DataTypes::isDataType(typeName);
    if (is_local && is_global) TERMINATE("Variable " + variable.first + "is local and global at the same time!")
    if (is_global) {
      type = DataTypes::getDataType(typeName);
    } else if (is_local) {
      type = DataTypes::getLocalDataType(module->getName(), typeName);
    } else {
      //Step2 : Add new datatype either as local or global datatype
      type = FindNewDatatype::getDataType(variable.second);
      if (FindNewDatatype::isGlobal(variable.second)) {
        DataTypes::addDataType(type);
      } else {
        DataTypes::addLocalDataType(module->getName(), type);
      }
    }
    //Compound: add a new variable compound.subVar as Variable
    if (type->isCompoundType()) {
      DESCAM_ASSERT(module->addVariable(new Variable(variable.first, type, nullptr, nullptr, varLocationInfo)))
    } else if (type->isArrayType()) {
      DESCAM_ASSERT(module->addVariable(new Variable(variable.first, type, nullptr, nullptr, varLocationInfo)))
    } else {
      this->find_initial_values_->setup(decl, fieldDecl, module, nullptr);
      ConstValue *initialValue = this->find_initial_values_->getInitValue();
      //FindInitialValues findInitalValues(decl, findVariables.getVariableMap().find(variable.first)->second , module);
      //auto intitalValMap = findInitalValues.getVariableInitialMap();
      //Variable not initialized -> intialize with default value
      if (initialValue == nullptr) {
        if (type == DataTypes::getDataType("int")) {
          DESCAM_ASSERT(initialValue = new IntegerValue(0))
        } else if (type == DataTypes::getDataType("bool")) {
          initialValue = new BoolValue(false);
        } else if (type == DataTypes::getDataType("unsigned")) {
          DESCAM_ASSERT(initialValue = new UnsignedValue(0))
        } else if (type->isEnumType()) {
          DESCAM_ASSERT(initialValue = new EnumValue(type->getEnumValueMap().begin()->first, type))
        } else TERMINATE("No initialValue for type " + type->getName());
      }
      DESCAM_ASSERT(module->addVariable(new Variable(variable.first, type, initialValue, nullptr, varLocationInfo)))
    }
  }
  EXECUTE_TERMINATE_IF_ERROR(this->removeUnused())
}

bool DESCAM::ModelFactory::postFire() {
  return 0;
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
  find_functions_->setup(decl);
  //Add datatypes for functions
  auto functionsMap = find_functions_->getFunctionMap();
  for (const auto &func: functionsMap) {
    auto newType = FindNewDatatype::getDataType(func.second->getResultType());
    if (FindNewDatatype::isGlobal(func.second->getResultType())) {
      DataTypes::addDataType(newType);
    } else DataTypes::addLocalDataType(module->getName(), newType);
  }

  //Add Structural description of functions to module
  for (const auto &function: find_functions_->getFunctionReturnTypeMap()) {
    DataType *datatype;
    if (DataTypes::isLocalDataType(function.second, module->getName())) {
      datatype = DataTypes::getLocalDataType(function.second, module->getName());
    } else datatype = DataTypes::getDataType(function.second);

    //Parameter
    std::map<std::string, Parameter *> paramMap;
    auto paramList = find_functions_->getFunctionParamNameMap().find(function.first)->second;
    auto paramTypeList = find_functions_->getFunctionParamTypeMap().find(function.first)->second;
    if (paramList.size() != paramTypeList.size()) TERMINATE("Parameter: # of names and types not equal");
    for (int i = 0; i < paramList.size(); i++) {
      auto param = new Parameter(paramList.at(i), DataTypes::getDataType(paramTypeList.at(i)));
      paramMap.insert(std::make_pair(paramList.at(i), param));
    }
    Function *new_function = nullptr;
    DESCAM_ASSERT(if (functionsMap.find(function.first) != functionsMap.end())
                    new_function = new Function(function.first, datatype, paramMap, GlobalUtilities::getLocationInfo(
                        functionsMap[function.first], _ci));
                  else new_function = new Function(function.first, datatype, paramMap);
                      module->addFunction(new_function))
  }
  EXECUTE_TERMINATE_IF_ERROR(this->removeUnused())
  //Add behavioral description of function to module
  for (auto function: find_functions_->getFunctionMap()) {
    //Create blockCFG for this process
    //Active searching only for functions
    FindDataFlow::functionName = function.first;
    FindDataFlow::isFunction = true;
    DESCAM::CFGFactory cfgFactory(function.second, _ci, module);
    FindDataFlow::functionName = "";
    FindDataFlow::isFunction = false;
    //Transfor blockCFG back to code
    FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), module->getFunction(function.first), nullptr);
    module->getFunction(function.first)->setStmtList(functionFactory.getStmtList());
  }
}

void DESCAM::ModelFactory::addGlobalConstants(TranslationUnitDecl *pDecl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::GlobalConstants);

  //Find all global functions and variables
  this->find_global_->setup(pDecl,this->_ci);

  for (auto var: this->find_global_->getVariableMap()) {
    this->model->addGlobalVariable(var.second);
  }

  //Add all global functions need in case of nested functions
  for (auto func: this->find_global_->getFunctionMap()) {
    //Add the definition to the function map
    this->model->addGlobalFunction(func.second);
  }

  for (auto func: this->find_global_->getFunctionMap()) {
    try {
      std::string name = func.first;
      //Create blockCFG for this process
      //Active searching only for functions
      //If fails ... function is not SystemC-PPA compliant
      //don't add body to function
      FindDataFlow::functionName = func.first;
      FindDataFlow::isFunction = true;
      auto module = Module("placeholder");
      DESCAM::CFGFactory cfgFactory(this->find_global_->getFunctionDeclMap().at(name), _ci, &module);
      FindDataFlow::functionName = "";
      FindDataFlow::isFunction = false;
      //Transfor blockCFG back to code
      FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), func.second, nullptr);
      func.second->setStmtList(functionFactory.getStmtList());
      Logger::tagTempMsgs(func.first);
    } catch (std::runtime_error &e) {
      this->model->removeGlobalFunction(func.second);
      Logger::clearTempVector();
    }
  }
}

void DESCAM::ModelFactory::removeUnused() {

  //Remove unused globalVariables & globalFunctions
  std::map<Variable *, bool> removeGlobalVars;

  for (auto var: model->getGlobalVariableMap()) {
    assert(var.second->isBuiltInType() && var.second->isConstant() && "Only built-in allowed as global variable");
    removeGlobalVars.insert(std::make_pair(var.second, true));
  }
  std::map<Function *, bool> removeGlobalFunctions;
  for (auto var: model->getGlobalFunctionMap()) {
    //assert(var.second->isBuiltInType() && var.second->isConstant() && "Only built-in allowed as global variable");
    removeGlobalFunctions.insert(std::make_pair(var.second, true));
  }

  auto globalFunMap = this->model->getGlobalFunctionMap();
  //Nested calls
  for (auto func  : globalFunMap) {
    for (auto retValCond  : func.second->getReturnValueConditionList()) {
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

  for (auto module: model->getModules()) {
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
      for (auto func: module.second->getFunctionMap()) {
        for (auto retValCond  : func.second->getReturnValueConditionList()) {
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
      this->model->removeGlobalVariable(var.first);
    }
  }
  //Remove global functions
  std::map<Function *, bool> newGlobalFunc;
  for (auto func: removeGlobalFunctions) {
    if (func.second) {
      this->model->removeGlobalFunction(func.first);
      Logger::removeFromTempMap(func.first->getName());
    }
  }
}
