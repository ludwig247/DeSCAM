#include "CheckErrors.h"
#include "IFindInitialValues.h"
#include "FindInitialValues.h"
#include <FindSections.h>
#include <CFGFactory.h>
#include <FindNewDatatype.h>
#include <Logger/Logger.h>
#include <ModelGlobal.h>
#include <FunctionFactory.h>
#include "ModuleInstance.h"
#include "FindDataFlow.h"
#include "FindFunctions.h"
#include "FindGlobal.h"
#include <OperationFactory.h>
#include <FatalError.h>
#include <CreateRealCFG.h>

#include <utility>
#include "DescamException.h"

//Constructor
DESCAM::CheckErrors::CheckErrors(CompilerInstance &ci) :
    _sm(ci.getSourceManager()),
    _ci(ci),
    _context(ci.getASTContext()),
    _os(llvm::errs()),
    model(nullptr) {

  //Compositional root
  this->findFunctions = std::make_unique<FindFunctions>();
  this->findInitialValues = std::make_unique<FindInitialValues>();
  //Unimportant modules
  this->unimportantModules.emplace_back("sc_event_queue");//! Not important for the abstract model:
  this->unimportantModules.emplace_back("Testbench");//! Not important for the abstract model:
}

bool DESCAM::CheckErrors::preFire() {
  return !DESCAM::Logger::isTerminate();
}

bool DESCAM::CheckErrors::fire() {
  //Translation Unit
  TranslationUnitDecl *tu = _context.getTranslationUnitDecl();

  //DESCAM model
  this->model = new Model("top_level");
  ModelGlobal::setModel(model);

  //Global variables
  this->addGlobalConstants(tu);

  //Modules
  this->addModules(tu);

  //sc_main
  return true;
}

void DESCAM::CheckErrors::addModules(clang::TranslationUnitDecl *decl) {

    FindModules modules;

  //Fill the model with modules(structural describtion)
  for (auto &scparModule: modules.getModuleMap()) {
    std::string name = scparModule.first;
    auto moduleLocationInfo = DESCAM::GlobalUtilities::getLocationInfo<CXXRecordDecl>(scparModule.second, _ci);

    //Module is on the unimportant module list -> skip
    if (std::find(this->unimportantModules.begin(), this->unimportantModules.end(), name) !=
        this->unimportantModules.end()) {
      //Skip this module
      continue;
    }
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

//! Use FindPorts and FindNetlist in order to add the ports to the model
void DESCAM::CheckErrors::addPorts(DESCAM::Module *module, clang::CXXRecordDecl *decl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::Ports);
  //Parse ports from CXXRecordDecl
  //Ports are sc_in,sc_out, sc_inout (sc_port) is consideres as
  //Right now, we are not interested about the direction of the port.

    DESCAM::FindPorts findPorts(&this->_ci);
    findPorts.setup(decl);
    auto portsLocationMap = findPorts.getLocationInfoMap();
    //Add Ports -> requires Name, Interface and DataType
    //RendezVouz
    //Input ports
    for (auto &port: findPorts.getInPortMap()) {
        Interface *interface = nullptr;
        DESCAM_ASSERT(interface = new Interface("blocking", "in"))
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            TERMINATE(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Port *inPort = nullptr;
        DESCAM_ASSERT (if(portsLocationMap.find(port.first) != portsLocationMap.end())
                           inPort = new Port(port.first, interface,
                                             DataTypes::getDataType(
                                                     port.second),
                                             portsLocationMap[port.first]);
                       else inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
                               module->addPort(inPort))
    }
    //Output ports
    for (auto &port: findPorts.getOutPortMap()) {
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
  for (auto &port: findPorts.getMasterInPortMap()) {
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
  for (auto &port: findPorts.getMasterOutPortMap()) {
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
  for (auto &port: findPorts.getSlaveInPortMap()) {
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
  for (auto &port: findPorts.getSlaveOutPortMap()) {
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
  for (auto &port: findPorts.getInSharedPortMap()) {
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
  for (auto &port: findPorts.getOutSharedPortMap()) {
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
  DESCAM::FindProcess findProcess(decl);
  if (findProcess.getProcessMap().size() != 1) TERMINATE("Module need exactly 1 process!");
  //Check Proces Type
  auto process = findProcess.getProcessMap().begin();
  //Process name
  std::string processName = process->first;
  if (process->second.second != DESCAM::PROCESS_TYPE::THREAD) {
    TERMINATE(processName + ":Only THREAD allowed as process type");
  }

  //Process declarationinde
  clang::CXXMethodDecl *methodDecl = process->second.first;
  //Create blockCFG for this process
  DESCAM::CFGFactory cfgFactory(methodDecl, _ci, module, true);
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
      this->findInitialValues->setup(decl, fieldDecl, module, &_ci);
      ConstValue *initialValue = this->findInitialValues->getInitValue();
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
  findFunctions->setup(decl);
  //Add datatypes for functions
  auto functionsMap = findFunctions->getFunctionMap();
  for (auto func: functionsMap) {
    auto newType = FindNewDatatype::getDataType(func.second->getResultType());
    if (FindNewDatatype::isGlobal(func.second->getResultType())) {
      DataTypes::addDataType(newType);
    } else DataTypes::addLocalDataType(module->getName(), newType);
  }

  //Add Structural description of fucntions to module
  for (auto function: findFunctions->getFunctionReturnTypeMap()) {
    DataType *datatype;
    if (DataTypes::isLocalDataType(function.second, module->getName())) {
      datatype = DataTypes::getLocalDataType(function.second, module->getName());
    } else datatype = DataTypes::getDataType(function.second);

    //Parameter
    std::map<std::string, Parameter *> paramMap;
    auto paramList = findFunctions->getFunctionParamNameMap().find(function.first)->second;
    auto paramTypeList = findFunctions->getFunctionParamTypeMap().find(function.first)->second;
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
                      module->addFunction(new_function);)
  }
  TERMINATE_IF_ERROR
  //Add behavioral description of function to module
  for (auto function: findFunctions->getFunctionMap()) {
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

void DESCAM::CheckErrors::addGlobalConstants(TranslationUnitDecl *pDecl) {
  Logger::setCurrentProcessedLocation(LoggerMsg::ProcessedLocation::GlobalConstants);

  //Find all global functions and variables
  FindGlobal findGlobal(pDecl, _ci);

  for (auto var: findGlobal.getVariableMap()) {
    this->model->addGlobalVariable(var.second);
  }

  //Add all global functions need in case of nested functions
  for (auto func: findGlobal.getFunctionMap()) {
    //Add the definition to the function map
    this->model->addGlobalFunction(func.second);
  }

  for (auto func: findGlobal.getFunctionMap()) {
    try {
      std::string name = func.first;
      //Create blockCFG for this process
      //Active searching only for functions
      //If fails ... function is not SystemC-PPA compliant
      //don't add body to function
      FindDataFlow::functionName = func.first;
      FindDataFlow::isFunction = true;
      auto module = Module("placeholder");
      DESCAM::CFGFactory cfgFactory(findGlobal.getFunctionDeclMap().at(name), _ci, &module);
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