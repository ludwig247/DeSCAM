#include "CheckErrors.h"
#include <CFGFactory.h>
#include <Logger/Logger.h>
#include <ModelGlobal.h>
#include <FunctionFactory.h>
#include "ModuleInstance.h"
#include <OperationFactory.h>
#include <FatalError.h>
#include <CreateRealCFG.h>
#include "FindDataFlow.h"

#include <utility>
#include "DescamException.h"

//Constructor
DESCAM::CheckErrors::CheckErrors(IFindFunctions *find_functions,
                                 IFindInitialValues *find_initial_values,
                                 IFindModules *find_modules,
                                 IFindNewDatatype *find_new_datatype,
                                 IFindPorts *find_ports,
                                 IFindGlobal *find_global,
                                 IFindNetlist *find_netlist,
                                 IFindProcess *find_process,
                                 IFindVariables *find_variables,
                                 IFindSCMain *find_sc_main) :
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
    find_sc_main_(find_sc_main) {

  assert(false);
  //FIXME: add missing interfaces
  this->find_data_flow_factory_ = nullptr;

  //Unimportant modules
  this->unimportant_modules_.emplace_back("sc_event_queue");//! Not important for the abstract model:
  this->unimportant_modules_.emplace_back("Testbench");//! Not important for the abstract model:
}

void DESCAM::CheckErrors::setup(CompilerInstance *ci) {
  this->ci_ = ci;
  this->context_ = &ci_->getASTContext();
}

bool DESCAM::CheckErrors::preFire() {
  return !DESCAM::Logger::isTerminate();
}

bool DESCAM::CheckErrors::fire() {
  //Translation Unit
  TranslationUnitDecl *tu = context_->getTranslationUnitDecl();

  //DESCAM model
  this->model_ = new Model("top_level");
  ModelGlobal::setModel(model_);

  //Global variables
  this->addGlobalConstants(tu);

  //Modules
  this->addModules(tu);

  //sc_main
  return true;
}

void DESCAM::CheckErrors::addModules(clang::TranslationUnitDecl *decl) {

  FindModules modules;

  //Fill the model with modules(structural description)
  for (auto &scpar_module: modules.getModuleMap()) {
    std::string name = scpar_module.first;
    auto moduleLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<CXXRecordDecl>(scpar_module.second, ci_);

    //Module is on the unimportant module list -> skip
    if (std::find(this->unimportant_modules_.begin(), this->unimportant_modules_.end(), name) !=
        this->unimportant_modules_.end()) {
      //Skip this module
      continue;
    }
    //DataTypes::reset();//FIXME:
    auto module = new Module(scpar_module.first, moduleLocationInfo);
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

//! Use FindPorts and FindNetlist in order to add the ports to the model
void DESCAM::CheckErrors::addPorts(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Ports);
  //Parse ports from CXXRecordDecl
  //Ports are sc_in,sc_out, sc_inout (sc_port) is considers as
  //Right now, we are not interested about the direction of the port.


  find_ports_->setup(decl, this->ci_);
  auto portsLocationMap = find_ports_->getLocationInfoMap();
  //Add Ports -> requires Name, Interface and DataType
  //Rendezvous
  //Input ports
  for (auto &port: find_ports_->getInPortMap()) {
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
  for (auto &port: find_ports_->getOutPortMap()) {
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
  for (auto &port: find_ports_->getMasterInPortMap()) {
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
  for (auto &port: find_ports_->getMasterOutPortMap()) {
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
  for (auto &port: find_ports_->getSlaveInPortMap()) {
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
  for (auto &port: find_ports_->getSlaveOutPortMap()) {
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
  for (auto &port: find_ports_->getInSharedPortMap()) {
    if (DataTypes::isLocalDataType(port.second, module->getName())) {
      TERMINATE(
          "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
    }
    Interface *interface = nullptr;
    DESCAM_ASSERT(interface = new Interface("shared", "in"))
    Port *inPort = nullptr;
    DESCAM_ASSERT(inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                      module->addPort(inPort))

  }
  //Output ports
  for (auto &port: find_ports_->getOutSharedPortMap()) {
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
  TERMINATE_IF_ERROR
}

//! Adds processes to the model
void DESCAM::CheckErrors::addBehavior(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Behavior);

  //Find the process describing the behavior
  find_process_->setup(decl);
  if (find_process_->getProcessMap().size() != 1) TERMINATE("Module need exactly 1 process!");
  //Check Process Type
  auto process = find_process_->getProcessMap().begin();
  //Process name
  std::string processName = process->first;
  if (process->second.second != DESCAM::PROCESS_TYPE::THREAD) {
    TERMINATE(processName + ":Only THREAD allowed as process type");
  }

  //Process declaration
  clang::CXXMethodDecl *methodDecl = process->second.first;
  //Create blockCFG for this process
  DESCAM::CFGFactory cfgFactory(methodDecl, ci_, module,find_data_flow_factory_, true);
  TERMINATE_IF_ERROR
  DESCAM::CfgNode::node_cnt = 0;
  DESCAM::State::state_cnt = 0;
  DESCAM::Operation::operations_cnt = 0;
  DESCAM::CreateRealCFG stmtCFG(cfgFactory.getControlFlowMap());
  module->setCFG(stmtCFG.getCFG());
}

//! Adds every Member of a sc_module to the DESCAM::Module
void DESCAM::CheckErrors::addVariables(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Variables);
  //Find all Variables within the Module
  find_variables_->setup(decl);

  //Initial Values
  //FindInitialValues findInitialValues(decl, findVariables.getVariableMap(), module);

  //Add members to module
  for (auto &&variable: find_variables_->getVariableTypeMap()) {
    //Add Variable to Module
    auto fieldDecl = find_variables_->getVariableMap().find(variable.first)->second;
    auto varLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<FieldDecl>(fieldDecl, ci_);

    /*
     * Distinguish between local and global DataTypes.
     * If a module declares a type within it's class, then it's a local datatype ... global otherwise
     * This toggle is in place because of some legacy plugins not being aware of local/global types.
     */
    DataType *type;
    std::string typeName = find_new_datatype_->getTypeName(variable.second);
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
      type = find_new_datatype_->getDataType(variable.second);
      if (find_new_datatype_->isGlobal(variable.second)) {
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
      this->find_initial_values_->setup(decl, fieldDecl, module, ci_);
      ConstValue *initialValue = this->find_initial_values_->getInitValue();
      //FindInitialValues findInitialValues(decl, findVariables.getVariableMap().find(variable.first)->second , module);
      //auto initialValMap = findInitialValues.getVariableInitialMap();
      //Variable not initialized -> initialize with default value
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
  TERMINATE_IF_ERROR
}

bool DESCAM::CheckErrors::postFire() {
  return 0;
}

void DESCAM::CheckErrors::HandleTranslationUnit(ASTContext &context) {
  if (preFire() && fire()) postFire();
}

void DESCAM::CheckErrors::addFunctions(DESCAM::Module *module, CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Functions);
  find_functions_->setup(decl);
  //Add datatypes for functions
  auto functions_map = find_functions_->getFunctionMap();
  for (const auto &func: functions_map) {
    auto new_type = find_new_datatype_->getDataType(func.second->getResultType());
    if (find_new_datatype_->isGlobal(func.second->getResultType())) {
      DataTypes::addDataType(new_type);
    } else DataTypes::addLocalDataType(module->getName(), new_type);
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
    DESCAM_ASSERT(if (functions_map.find(function.first) != functions_map.end())
                    new_function = new Function(function.first, datatype, paramMap, GlobalUtilities::getLocationInfo(
                        functions_map[function.first], ci_));
                  else new_function = new Function(function.first, datatype, paramMap);
                      module->addFunction(new_function);)
  }
  TERMINATE_IF_ERROR
  //Add behavioral description of function to module
  for (const auto &function: find_functions_->getFunctionMap()) {
    //Create blockCFG for this process
    //Active searching only for functions
    FindDataFlow::functionName = function.first;
    FindDataFlow::isFunction = true;
    DESCAM::CFGFactory cfgFactory(function.second, ci_, module,find_data_flow_factory_);
    FindDataFlow::functionName = "";
    FindDataFlow::isFunction = false;
    //Transform blockCFG back to code
    FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), module->getFunction(function.first), nullptr);
    module->getFunction(function.first)->setStmtList(functionFactory.getStmtList());
  }
}

void DESCAM::CheckErrors::addGlobalConstants(TranslationUnitDecl *pDecl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::GlobalConstants);

  //Find all global functions and variables
  this->find_global_->setup(pDecl, ci_,find_data_flow_factory_);
  for (const auto &var: find_global_->getVariableMap()) {
    this->model_->addGlobalVariable(var.second);
  }

  //Add all global functions need in case of nested functions
  for (const auto &func: find_global_->getFunctionMap()) {
    //Add the definition to the function map
    this->model_->addGlobalFunction(func.second);
  }

  for (auto func: find_global_->getFunctionMap()) {
    try {
      std::string name = func.first;
      //Create blockCFG for this process
      //Active searching only for functions
      //If fails ... function is not SystemC-PPA compliant
      //don't add body to function
      FindDataFlow::functionName = func.first;
      FindDataFlow::isFunction = true;
      auto module = Module("placeholder");
      DESCAM::CFGFactory cfgFactory(find_global_->getFunctionDeclMap().at(name), ci_, &module,find_data_flow_factory_);
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
