//
// Created by ludwig on 15.09.15.
//

#include "ModelFactory.h"
#include <FindInterface.h>
#include "FindInitalValues.h"
#include <FindSections.h>
#include <CFGFactory.h>
#include <FindNewDatatype.h>
#include <ErrorMsg.h>
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


//Constructor
SCAM::ModelFactory::ModelFactory(CompilerInstance &ci) :
        _sm(ci.getSourceManager()),
        _ci(ci),
        _context(ci.getASTContext()),
        _os(llvm::errs()),
        model(nullptr) {

    //Unimportant modules
    this->unimportantModules.push_back("sc_event_queue");//! Not important for the abstract model:
    this->unimportantModules.push_back("Testbench");//! Not important for the abstract model:
}

//Destructor
SCAM::ModelFactory::~ModelFactory() {
}

bool SCAM::ModelFactory::preFire() {
    if (_context.getDiagnostics().getClient()->getNumWarnings() > 0) {
        std::cout << "Warnings: " << _context.getDiagnostics().getClient()->getNumWarnings() << std::endl;
    }
    if (_context.getDiagnostics().getClient()->getNumErrors() > 0) return false;
    return true;
}

bool SCAM::ModelFactory::fire() {

    //Translation Unit?
    TranslationUnitDecl *tu = _context.getTranslationUnitDecl();

    //Delte content of previous models
    //SCAM model
    this->model = new Model("top_level");
    ModelGlobal::setModel(model);
    //Modules
    this->addModules(tu, SCAM::Module());

    //Remove unused things from the model
    this->optimizeModel();
    for(auto func: model->getGlobalFunctionMap()){
        std::cout << func.second->getName() << std::endl;
    }
    //Instances
    this->addInstances(tu);
    //sc_main
    return true;
}


//Modules
void SCAM::ModelFactory::addModules(clang::TranslationUnitDecl *decl, SCAM::Module module) {
    FindModules modules(decl);

    //Fill the model with modules(structural describtion)
    for (auto &scparModule: modules.getModuleMap()) {

//        //Module Name
        std::string name = scparModule.first;

//        /*
//         * Create Module
//
//         * Creation of all other elements(Ports,Sub-Modules,Signals, Interfaces ...)
//         * is executed by the module constructor method addModule using the reference to the
//         * module declaration of the ast
//        */
//        //Module is on the unimportant module list -> skip
        if (std::find(this->unimportantModules.begin(), this->unimportantModules.end(), name) !=
            this->unimportantModules.end()) {
            //Skip this module
            continue;
        }
        std::cout << "############################" << std::endl;
        std::cout << "Module: " << name << std::endl;
        std::cout << "############################" << std::endl;
        //DataTypes::reset();//FIXME:
        auto module = new Module(scparModule.first);
        //INFO: this is the most important step ! Otherwise the PluginAction Object is deleted and with it the model
        model->addModule(module);

        //Global variables
        this->addGlobalVariables(decl,module);

        //Members
        this->addVariables(module, scparModule.second);
        //Ports
        this->addPorts(module, scparModule.second);
        //Combinational Functions
        this->addFunctions(module, scparModule.second);
        //States
        this->addSections(module, scparModule.second);
        //Processe
        this->addBehavior(module, scparModule.second);

        //this->addCommunicationFSM(module);
    }
}

//! Add structure ...
void SCAM::ModelFactory::addInstances(TranslationUnitDecl *tu) {
    FindSCMain scmain(tu);

    //The top instance is the sc_main. It doesn't contain any ports
    //Create empty dummy module for sc_main
    Module *sc_main = new Module("main");
    //this->model->addModule(sc_main);
    //Create instance for sc_main and add to model
    ModuleInstance *topInstance = new ModuleInstance("TopInstance", sc_main);
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
//    //findNetlist.getInstanceMap() = std::map<string instance_name,string sc_module>
    for (auto &instance: findNetlist.getInstanceMap()) {
//        //Search for pointer in modul map
        Module *module = model->getModules().find(instance.second)->second;
//        //In case module is not found -> error!
        if (!module) { throw std::runtime_error("ModelFactory::addInstances module not found"); }
//        //Add instance to model
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
        } else { throw std::runtime_error("Interface direction not supported"); }
        //Add instance to channel

    }
}

//! Use FindPorts and FindNetlist in order to add the ports to the model
void SCAM::ModelFactory::addPorts(SCAM::Module *module, clang::CXXRecordDecl *decl) {
    //Parse ports from CXXRecordDecl
    //Ports are sc_in,sc_out, sc_inout (sc_port) is consideres as
    //Right now, we are not interested about the direction of the port.

    SCAM::FindPorts findPorts(decl, this->_context);

    //Add Ports -> requires Name, Interface and DataType
    //RendezVouz
    //Input ports
    for (auto &port: findPorts.getInPortMap()) {
        Interface *interface = new Interface("blocking", "in");
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            throw std::runtime_error(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);

    }
    //Output ports
    for (auto &port: findPorts.getOutPortMap()) {
        Interface *interface = new Interface("blocking", "out");
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            throw std::runtime_error(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);
    }

    //AlwaysReady
    //Input ports
    for (auto &port: findPorts.getMasterInPortMap()) {
        Interface *interface = new Interface("master", "in");
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            throw std::runtime_error(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);

    }
    //Output ports
    for (auto &port: findPorts.getMasterOutPortMap()) {
        Interface *interface = new Interface("master", "out");
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            throw std::runtime_error(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);
    }

    //Input ports
    for (auto &port: findPorts.getSlaveInPortMap()) {
        Interface *interface = new Interface("slave", "in");
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            throw std::runtime_error(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);

    }
    //Output ports
    for (auto &port: findPorts.getSlaveOutPortMap()) {
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            throw std::runtime_error(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Interface *interface = new Interface("slave", "out");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);
    }


    //Shared ports
    //Input ports
    for (auto &port: findPorts.getInSharedPortMap()) {
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            throw std::runtime_error(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Interface *interface = new Interface("shared", "in");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);

    }
    //Output ports
    for (auto &port: findPorts.getOutSharedPortMap()) {
        if (DataTypes::isLocalDataType(port.second, module->getName())) {
            throw std::runtime_error(
                    "No local datatypes for ports allowed!\n Port: " + port.first + "\nType: " + port.second);
        }
        Interface *interface = new Interface("shared", "out");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);
    }

}

/*!
 * Adds a FSM to the Module
 */
void SCAM::ModelFactory::addSections(Module *module, clang::CXXRecordDecl *decl) {
    //Find states
    FindSections findSections(decl);
    this->moduleHasSections = findSections.hasSections();
    this->moduleHasSections = false;
    //Create Section-Datatype for this module
    //DataType *sections = new DataType(module->getName() + "_SECTIONS");
    //DataTypes::addLocalDataType(module->getName(), sections);
    //Check whether the module defines a FSM
    if (moduleHasSections) {
        //Create FSM with states
        for (auto state: findSections.getSectionList()) {
            //sections->addEnumValue(state);
        }
        //module->getFSM()->setSections(sections, findSections.getInitialState());

    } else {
        //TODO: remove
        //Create default FSM without any sections
        //sections->addEnumValue("run");
        //module->getFSM()->setSections(sections, "run");
    }
}

//! Adds processes to the model
void SCAM::ModelFactory::addBehavior(SCAM::Module *module, clang::CXXRecordDecl *decl) {
    //Find the process describing the behavior
    SCAM::FindProcess findProcess(decl);
    if (findProcess.getProcessMap().size() != 1) throw std::runtime_error("Module need exactly 1 process!");
    //Check Proces Type
    auto process = findProcess.getProcessMap().begin();
    //Process name
    std::string processName = process->first;
    if (process->second.second != SCAM::PROCESS_TYPE::THREAD) {
        throw std::runtime_error(processName + ":Only THREAD allowed as process type");
    }

    //Process declarationinde
    clang::CXXMethodDecl *methodDecl = process->second.first;
    //Create blockCFG for this process
    SCAM::CFGFactory cfgFactory(methodDecl, _ci, module, true);
    //Print out error msgs
    if (ErrorMsg::hasError()) {
        std::cout << "" << std::endl;
        std::cout << "======================" << std::endl;
        std::cout << "Errors: Translation of Stmts for module " << module->getName() << std::endl;
        std::cout << "----------------------" << std::endl;
        for (auto item: ErrorMsg::getInstance().getErrorList()) {
            std::cout << "- " << item.msg << std::endl;
            for (auto log: item.errorLog) {
                std::cout << "\t" << log << std::endl;
            }
        }
        ErrorMsg::clear();
    }
    if(cfgFactory.getControlFlowMap().empty()) throw std::runtime_error("CFG is empty!");

    SCAM::CfgNode::node_cnt = 0;
    SCAM::State2::state_cnt = 0;
    SCAM::Operation2::operations_cnt = 0;
    auto optOptionsSet = CommandLineParameter::getOptimizeOptionsSet();
    if (!optOptionsSet.empty()) {
        SCAM::Optimizer opt(cfgFactory.getControlFlowMap(), module, this->model, optOptionsSet);
        //throw std::runtime_error(" Test ");
        module->setCFG(opt.getCFG());
        SCAM::OperationFactory operationFactory(opt.getCFG(), module);
        module->setPropertySuite(operationFactory.getPropertySuite());
    } else {
        SCAM::CreateRealCFG test(cfgFactory.getControlFlowMap());
        module->setCFG(test.getCFG());
        SCAM::OperationFactory operationFactory(test.getCFG(), module);
        module->setPropertySuite(operationFactory.getPropertySuite());
    }
}

//! Adds every Member of a sc_module to the SCAM::Module
void SCAM::ModelFactory::addVariables(SCAM::Module *module, clang::CXXRecordDecl *decl) {
    //Find all Variables within the Module
    FindVariables findVariables(decl);

    //Initial Values
    //FindInitalValues findInitalValues(decl, findVariables.getVariableMap(), module);

    //Add members to module
    for (auto variable: findVariables.getVariableTypeMap()) {
        //Add Variable to Module
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
        assert(!is_local || !is_global);
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
            module->addVariable(new Variable(variable.first, type));
        } else if (type->isArrayType()) {
            module->addVariable(new Variable(variable.first, type));
        } else {
            auto fieldDecl = findVariables.getVariableMap().find(variable.first)->second;
            ConstValue *initialValue = FindInitalValues::getInitValue(decl, fieldDecl, module);
            //FindInitalValues findInitalValues(decl, findVariables.getVariableMap().find(variable.first)->second , module);
            //auto intitalValMap = findInitalValues.getVariableInitialMap();
            //Variable not initialized -> intialize with default value
            if (initialValue == nullptr) {
                if (type == DataTypes::getDataType("int")) {
                    initialValue = new IntegerValue(0);
                } else if (type == DataTypes::getDataType("bool")) {
                    initialValue = new BoolValue(false);
                } else if (type == DataTypes::getDataType("unsigned")) {
                    initialValue = new UnsignedValue(0);
                } else if (type->isEnumType()) {
                    initialValue = new EnumValue(type->getEnumValueMap().begin()->first, type);
                } else throw std::runtime_error("No initialValue for type " + type->getName());
            }

            module->addVariable(new Variable(variable.first, type, initialValue));
        }
    }

//    //All findVariables initialized?
//    if (module->getVariableMap().size() != findInitalValues.getVariableInitialMap().size()) {
//        std::cout << "-I-  Not all variables initialized" << std::endl;
//    }

}

bool SCAM::ModelFactory::postFire() {

    return 0;
}

void SCAM::ModelFactory::HandleTranslationUnit(ASTContext &context) {
// Pass 1: Find the necessary information.
    bool pre = false;
    pre = preFire();
    if (!pre) {
        std::cout << "#################################" << std::endl;
        std::cout << "######## Syntax Errors ##########" << std::endl;
        std::cout << "#################################" << std::endl;
        return;
    } else {
        bool f = false;
        f = fire();
        if (!f) {
            std::cout << "----------Fire(fail)" << std::endl;
            return;
        } else {
            postFire();
        }
    }
}

void SCAM::ModelFactory::addFunctions(SCAM::Module *module, CXXRecordDecl *pDecl) {
    FindFunctions findFunction(pDecl);
    //Add datatypes for functions

    for (auto func: findFunction.getFunctionMap()) {
        auto newType = FindNewDatatype::getDataType(func.second->getResultType());
        if (FindNewDatatype::isGlobal(func.second->getResultType())) {
            DataTypes::addDataType(newType);
        } else DataTypes::addLocalDataType(module->getName(), newType);
    }

    //Add Structural description of fucntions to module
    for (auto function: findFunction.getFunctionReturnTypeMap()) {
        DataType *datatype;
        if (DataTypes::isLocalDataType(function.second, module->getName())) {
            datatype = DataTypes::getLocalDataType(function.second, module->getName());
        } else datatype = DataTypes::getDataType(function.second);

        //Parameter
        std::map<std::string, Parameter *> paramMap;
        auto paramList = findFunction.getFunctionParamNameMap().find(function.first)->second;
        auto paramTypeList = findFunction.getFunctionParamTypeMap().find(function.first)->second;
        if (paramList.size() != paramTypeList.size())
            throw std::runtime_error("Parameter: # of names and types not equal");
        for (int i = 0; i < paramList.size(); i++) {
            auto param = new Parameter(paramList.at(i), DataTypes::getDataType(paramTypeList.at(i)));
            paramMap.insert(std::make_pair(paramList.at(i), param));
        }
        auto new_function = new Function(function.first, datatype, paramMap);
        module->addFunction(new_function);
    }
    //Add behavioral description of function to module
    for (auto function: findFunction.getFunctionMap()) {
        //Create blockCFG for this process
        //Active searching only for functions
        FindDataFlow::functionName = function.first;
        FindDataFlow::isFunction = true;
        SCAM::CFGFactory cfgFactory(function.second, _ci, module);
        FindDataFlow::functionName = "";
        FindDataFlow::isFunction = false;
        //Transfor blockCFG back to code
        FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), module->getFunction(function.first), nullptr);
        module->getFunction(function.first)->setStmtList(functionFactory.getStmtList());


        if (ErrorMsg::hasError() ) {
            std::cout << "" << std::endl;
            std::cout << "======================" << std::endl;
            std::cout << "Errors: Translation of Stmts for module " << module->getName() << std::endl;
            std::cout << "----------------------" << std::endl;
            for (auto item: ErrorMsg::getInstance().getErrorList()) {
                std::cout << "- " << item.msg << std::endl;
                for (auto log: item.errorLog) {
                    std::cout << "\t" << log << std::endl;
                }
            }
            ErrorMsg::clear();
        }
    }

}

void SCAM::ModelFactory::addGlobalVariables(TranslationUnitDecl *pDecl, SCAM::Module *pModule) {
    FindGlobal findGlobal(pDecl,_ci, pModule);
    for(auto var: findGlobal.getVariableMap()){
        this->model->addGlobalVariable(var.second);
    }

    for(auto func: findGlobal.getFunctionMap()){
        this->model->addGlobalFunction(func.second);
        std::string name = func.first;
        try {
            //Create blockCFG for this process
            //Active searching only for functions
            //If fails ... function is not SystemC-PPA compliant
            FindDataFlow::functionName = func.first;
            FindDataFlow::isFunction = true;
            SCAM::CFGFactory cfgFactory(findGlobal.getFunctionDeclMap().at(name), _ci,  pModule);
            FindDataFlow::functionName = "";
            FindDataFlow::isFunction = false;

            //Transfor blockCFG back to code
            FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), func.second, nullptr);
            func.second->setStmtList(functionFactory.getStmtList());



        }catch(std::runtime_error e){
        }

    }

}

void SCAM::ModelFactory::optimizeModel() {

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

    for(auto module: model->getModules()){
        for (auto state : module.second->getFSM()->getStateMap()) {
            for(auto op: state.second->getOutgoingOperationsList()){
                for (auto ass: op->getAssumptionsList()) {
                    for (auto usedVar: ExprVisitor::getUsedVariables(ass)) {
                        if(usedVar->isConstant()) removeGlobalVars.at(usedVar) = false;
                    }
                    for(auto usedFunc: ExprVisitor::getUsedFunction(ass)){
                        if(globalFunMap.find(usedFunc->getName()) != globalFunMap.end()){
                            removeGlobalFunctions.at(usedFunc) = false;
                        }
                        //TODO: delete unused functions ... find CFG for remaining functions ... use global for functions?
                    }
                }
                //Check commitment for usage
                for (auto comm: op->getCommitmentsList()) {
                    if (PrintStmt::toString(comm->getLhs()) == PrintStmt::toString(comm->getRhs())) {
                        continue;
                    }
                    for (auto usedVar: ExprVisitor::getUsedVariables(comm->getRhs())) {
                        if(usedVar->isConstant()) removeGlobalVars.at(usedVar) = false;
                    }
                    for(auto usedFunc: ExprVisitor::getUsedFunction(comm->getRhs())){
                        if(globalFunMap.find(usedFunc->getName()) != globalFunMap.end()){
                            removeGlobalFunctions.at(usedFunc) = false;
                        }
                    }
                }
            }
        }
    }

    //Remove global vars
    for(auto var: removeGlobalVars){
        if(var.second){
            this->model->removeGlobalVariable(var.first);
        }
    }

    //Remove global functions
    std::map<Function *, bool> newGlobalFunc;
    for(auto func: removeGlobalFunctions){
        if(func.second){
            this->model->removeGlobalFunction(func.first);
        }
    }
}





