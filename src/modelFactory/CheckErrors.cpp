#include "CheckErrors.h"
#include <FindInterface.h>
#include "FindInitalValues.h"
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
#include <OperationFactory.h>

//Constructor
SCAM::CheckErrors::CheckErrors(CompilerInstance &ci) :
        _sm(ci.getSourceManager()),
        _ci(ci),
        _context(ci.getASTContext()),
        _os(llvm::errs()),
        model(nullptr) {

    //Unimportant modules
    this->unimportantModules.emplace_back("sc_event_queue");//! Not important for the abstract model:
    this->unimportantModules.emplace_back("Testbench");//! Not important for the abstract model:
}

bool SCAM::CheckErrors::preFire() {

    return !SCAM::Logger::isTerminate();
}

bool SCAM::CheckErrors::fire() {
    //Translation Unit
    TranslationUnitDecl *tu = _context.getTranslationUnitDecl();

    //SCAM model
    this->model = new Model("top_level");
    ModelGlobal::setModel(model);

    //Global variables
    this->addGlobalConstants(tu);

    //Modules
    this->addModules(tu);

    //sc_main
    return true;
}

void SCAM::CheckErrors::addModules(clang::TranslationUnitDecl *decl) {
    FindModules modules(decl);

    //Fill the model with modules(structural description)
    for (auto &scparModule: modules.getModuleMap()) {
        //Module Name
        std::string name = scparModule.first;
        if (std::find(this->unimportantModules.begin(), this->unimportantModules.end(), name) !=
            this->unimportantModules.end()) {
            continue;
        }
//      std::cout << "Module: " << name << std::endl;
        auto module = new Module(scparModule.first);
        model->addModule(module);
        //Members
        this->addVariables(module, scparModule.second);
        //Ports
        this->addPorts(module, scparModule.second);
        //Combinational Functions
        this->addFunctions(module, scparModule.second);
        //Process
        this->addBehavior(module, scparModule.second);
    }
}

//! Use FindPorts and FindNetlist in order to add the ports to the model
void SCAM::CheckErrors::addPorts(SCAM::Module *module, clang::CXXRecordDecl *decl) {
    SCAM::FindPorts findPorts(decl, this->_context);
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

//! Adds processes to the model
void SCAM::CheckErrors::addBehavior(SCAM::Module *module, clang::CXXRecordDecl *decl) {
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
   /* if (Logger::hasError()) {
        std::cout << "" << std::endl;
        std::cout << "======================" << std::endl;
        std::cout << "Errors: Translation of Stmts for module " << module->getName() << std::endl;
        std::cout << "----------------------" << std::endl;
        for (auto item: Logger::getInstance().getErrorList()) {
            std::cout << "- " << item.statement << std::endl;
            for (auto log: item.errorMsgs) {
                std::cout << "\t" << log << std::endl;
            }
        }
        Logger::clear();
    } */
}

//! Adds every Member of a sc_module to the SCAM::Module
void SCAM::CheckErrors::addVariables(SCAM::Module *module, clang::CXXRecordDecl *decl) {
    //Find all Variables within the Module
    FindVariables findVariables(decl);
    //Add members to module
    for (auto &&variable: findVariables.getVariableTypeMap()) {
        //Add Variable to Module
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
}

bool SCAM::CheckErrors::postFire() {
    return 0;
}

void SCAM::CheckErrors::HandleTranslationUnit(ASTContext &context) {
    if(preFire() && fire()) postFire();
}

void SCAM::CheckErrors::addFunctions(SCAM::Module *module, CXXRecordDecl *decl) {
    FindFunctions findFunction(decl);
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
        /*if (Logger::hasError()) {
            std::cout << "" << std::endl;
            std::cout << "======================" << std::endl;
            std::cout << "Errors: Translation of Stmts for module " << module->getName() << std::endl;
            std::cout << "----------------------" << std::endl;
            for (auto item: Logger::getInstance().getErrorList()) {
                std::cout << "- " << item.statement << std::endl;
                for (auto log: item.errorMsgs) {
                    std::cout << "\t" << log << std::endl;
                }
            }
            Logger::clear();
        }*/
    }

}

void SCAM::CheckErrors::addGlobalConstants(TranslationUnitDecl *pDecl) {
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
            SCAM::CFGFactory cfgFactory(findGlobal.getFunctionDeclMap().at(name), _ci, &module);
            FindDataFlow::functionName = "";
            FindDataFlow::isFunction = false;
            //Transfor blockCFG back to code
            FunctionFactory functionFactory(cfgFactory.getControlFlowMap(), func.second, nullptr);
            func.second->setStmtList(functionFactory.getStmtList());
        } catch (std::runtime_error &e) {
//            std::cout << e.what() << std::endl;
//            for(auto statement:  Logger::getErrorList()){
//                std::cout << statement.statement << std::endl;
//            }
           // Logger::clear();
            this->model->removeGlobalFunction(func.second);
        }
    }
}