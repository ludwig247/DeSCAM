//
// Created by ludwig on 15.09.15.
#include "ModelFactory.h"
//
#include <FindInterface.h>
#include "FindInitalValues.h"
#include <FindSections.h>
#include <CFGFactory.h>
#include <FindNewDatatype.h>
#include <SectionFactory.h>
#include <ErrorMsg.h>
#include <PrintAML/PrintAML.h>
#include <ModelGlobal.h>
#include <PropertyFactory.h>
#include <CFG/FunctionFactory.h>
#include "ModuleInstance.h"

#include "FindDataFlow.h"
#include "FindFunctions.h"


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
    model = new Model("SCAM_Model");
    //Modules
    this->addModules(tu);

    //Instances
    this->addInstances(tu);
    //sc_main

    //Instances

//        for(auto channel: model->getTopInstance()->getChannelMap() ){
//            std::cout <<  channel.first << ": "<< channel.second->getFromPort()->getName() << "->"  << channel.second->getToPort()->getName()  << std::endl;
//        }
//        for(auto instance: model->getTopInstance()->getModuleInstances()){
//            std::cout << instance.first << " S:" << instance.second->getStructure()->getName() << std::endl;
//        }

    return true;
}


//Modules
void SCAM::ModelFactory::addModules(clang::TranslationUnitDecl *decl) {
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
//
//
//        //Module is on the unimportant module list -> skip
        if (std::find(this->unimportantModules.begin(), this->unimportantModules.end(), name) != this->unimportantModules.end()) {
            //Skip this module
            continue;
        }
        std::cout << "############################" << std::endl;
        std::cout << "Module: " << name << std::endl;
        std::cout << "############################" << std::endl;
        Module *module = new Module(scparModule.first);
        model->addModule(module);
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

        this->addCommunicationFSM(module);
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
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);

    }
    //Output ports
    for (auto &port: findPorts.getOutPortMap()) {
        Interface *interface = new Interface("blocking", "out");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);
    }

    //AlwaysReady
    //Input ports
    for (auto &port: findPorts.getMasterInPortMap()) {
        Interface *interface = new Interface("master", "in");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);

    }
    //Output ports
    for (auto &port: findPorts.getMasterOutPortMap()) {
        Interface *interface = new Interface("master", "out");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);
    }

    //Input ports
    for (auto &port: findPorts.getSlaveInPortMap()) {
        Interface *interface = new Interface("slave", "in");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);

    }
    //Output ports
    for (auto &port: findPorts.getSlaveOutPortMap()) {
        Interface *interface = new Interface("slave", "out");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);
    }


    //Shared ports
    //Input ports
    for (auto &port: findPorts.getInSharedPortMap()) {
        Interface *interface = new Interface("shared", "in");
        Port *inPort = new Port(port.first, interface, DataTypes::getDataType(port.second));
        module->addPort(inPort);

    }
    //Output ports
    for (auto &port: findPorts.getOutSharedPortMap()) {
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
    //Create Section-Datatype for this module
    DataType *sections = new DataType(module->getName() + "_SECTIONS");
    DataTypes::addDataType(sections);
    //Check whether the module defines a FSM
    if (moduleHasSections) {
        //Create FSM with states
        for (auto state: findSections.getSectionList()) {
            sections->addEnumValue(state);
        }
        module->getFSM()->setSections(sections, findSections.getInitialState());

    } else {
        //Create default FSM without any sections
        sections->addEnumValue("run");
        module->getFSM()->setSections(sections, "run");
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

    //Process declaration
    clang::CXXMethodDecl *methodDecl = process->second.first;
    //Create CFG for this process
    SCAM::CFGFactory cfgFactory(methodDecl, _ci, module);

    //Print out error msgs
    //if (ErrorMsg::hasError() && !CommandLineParameter::getMap()["HideErrors"]) {
    if (ErrorMsg::hasError() && true) {
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

    //Print-out for debugging?
    if (false) {
        std::cout << "----------------------" << std::endl;
        std::cout << "ControlFlowGraph" << std::endl;
        std::cout << "----------------------" << std::endl;
        std::cout << cfgFactory.print() << std::endl; //Prints out controlFlowGraph
    }
    //Transfer the controlFlowGraph into a SectionMap

    SCAM::SectionFactory sectionFactory(module, cfgFactory.getControlFlowMap(), moduleHasSections);
    //Printout for debugging
    if (false) {
        std::cout << "----------------------" << std::endl;
        std::cout << "FSM" << std::endl;
        std::cout << "----------------------" << std::endl;
        std::cout << " " << std::endl;
        sectionFactory.print();
    }
    //For each state defined in States enum, a entry in the sectionPathMap is required
    if (sectionFactory.getSectionPathMap().size() == module->getFSM()->getSectionList().size()) {
        module->getFSM()->setSectionMap(sectionFactory.getSectionPathMap());
    } else throw std::runtime_error("-E- More sections declared as used. Please either adjust section enum or behavior description");

}

//! Adds every Member of a sc_module to the SCAM::Module
void SCAM::ModelFactory::addVariables(SCAM::Module *module, clang::CXXRecordDecl *decl) {
    //Find all Variables within the Module
    FindVariables findVariables(decl);

    //Initial Values
    FindInitalValues findInitalValues(decl, findVariables.getVariableMap(), module);

    //Add members to module
    for (auto variable: findVariables.getVariableTypeMap()) {
        //Add Variable to Module
        auto type = FindNewDatatype::getDataType(variable.second);
        //Compound: add a new variable compound.subVar as Variable
        if (type->isCompoundType()) {
            module->addVariable(new Variable(variable.first, type, type->getDefaultVal()));
        } else {
            ConstValue *initialValue;
            auto intitalValMap = findInitalValues.getVariableInitialMap();
            //Variable not initialized -> intialize with default value
            if (intitalValMap.find(variable.first) == intitalValMap.end()) {
                if (type == DataTypes::getDataType("int")) {
                    initialValue = new IntegerValue(0);
                } else if (type == DataTypes::getDataType("bool")) {
                    initialValue = new BoolValue(false);
                } else if (type == DataTypes::getDataType("unsigned")) {
                    initialValue = new UnsignedValue(0);
                } else if (type->isEnumType()) {
                    initialValue = new EnumValue(type->getEnumValueMap().begin()->first, type);
                } else throw std::runtime_error("No initialValue for type " + type->getName());
            } else {
                initialValue = intitalValMap.at(variable.first);
            }
            module->addVariable(new Variable(variable.first, type, initialValue));
        }

    }
    //All findVariables initialized?
    if (module->getVariableMap().size() != findInitalValues.getVariableInitialMap().size()) {
        std::cout << "-I-  Not all variables initialized" << std::endl;
    }

}


bool SCAM::ModelFactory::postFire() {
    //INFO: this is the most important step ! Otherwise the PluginAction Object is deleted and with it the model
    ModelGlobal::setModel(model);
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

void SCAM::ModelFactory::addCommunicationFSM(SCAM::Module *pModule) {
    SCAM::PropertyFactory propertyFactory(pModule);
}

void SCAM::ModelFactory::addFunctions(SCAM::Module *module, CXXRecordDecl *pDecl) {
    FindFunctions findFunction(pDecl);
    //Add datatypes for functions
    for (auto func: findFunction.getFunctionMap()) {
        FindNewDatatype::getDataType(func.second->getResultType());
    }

    //Add Structural description of fucntions to module
    for (auto function: findFunction.getFunctionReturnTypeMap()) {
        auto datatype = DataTypes::getDataType(function.second);

        //Parameter
        std::map<std::string, Parameter *> paramMap;
        auto paramList = findFunction.getFunctionParamNameMap().find(function.first)->second;
        auto paramTypeList = findFunction.getFunctionParamTypeMap().find(function.first)->second;
        if (paramList.size() != paramTypeList.size()) throw std::runtime_error("Parameter: # of names and types not equal");
        for (int i = 0; i < paramList.size(); i++) {
            auto param = new Parameter(paramList.at(i), DataTypes::getDataType(paramTypeList.at(i)));
            paramMap.insert(std::make_pair(paramList.at(i), param));
        }
        auto new_function = new Function(function.first, datatype, paramMap);
        module->addFunction(new_function);
    }
    //Add behavioral description of function to module
    for (auto function: findFunction.getFunctionMap()) {
        //Create CFG for this process
        //Active searching only for functions
        FindDataFlow::functionName = function.first;
        FindDataFlow::isFunction = true;
        SCAM::CFGFactory cfgFactory(function.second, _ci, module);
        FindDataFlow::functionName = "";
        FindDataFlow::isFunction = false;
        //Transfor CFG back to code
        FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), module->getFunction(function.first));
        module->getFunction(function.first)->setStmtList(functionFactory.getStmtList());


        if (ErrorMsg::hasError() && true) {
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
    //throw std::runtime_error(" Throw ");
}





