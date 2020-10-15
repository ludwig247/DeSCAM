//
// Created by ludwig on 10.09.15.
//

#include <Stmts/EnumValue.h>
#include <cassert>
#include "Module.h"
#include "Model.h"
#include "FatalError.h"
#include "Logger/Logger.h"


namespace DESCAM {

    Module::Module(std::string name, LocationInfo locationInfo) :
            fsm(new FSM(this)),
            propertySuite(nullptr),
            AbstractNode(name,locationInfo) {

    }

    void Module::addPort(Port *port) {
        this->ports.insert(std::make_pair(port->getName(), port));
    }

    const std::map<std::string, Port *> &Module::getPorts() const {
        return this->ports;
    }

    Port *Module::getPort(const std::string &n) const {
        if (this->ports.find(n) == this->ports.end()) {
            TERMINATE("Module.cpp getPort called with \"" + n + "\", not a port name");
        }
        return this->ports.find(n)->second;
    }

    bool Module::isPort(const std::string &n) const {
        return (this->ports.find(n) != this->ports.end());
    }

    void Module::accept(AbstractVisitor &visitor) {
        visitor.visit(*this);

    }

    /*void Module::addVariable(Variable *variable) {
        this->variableMap.insert(std::make_pair(variable->getName(), variable));
    }*/

    void Module::addVariables(std::map<std::string, Variable *> variables) {
      this->variableMap = std::move(variables);
    }

    FSM *Module::getFSM() const {
        return this->fsm;
    }

    const std::map<std::string, Variable *> &Module::getVariableMap() const {
        return variableMap;
    }


    Variable *Module::getVariable(const std::string &n) const {
        //allows "parent.child", search for "parent" here, and within for "child"
        bool isCompound = (n.find('.') != std::string::npos);
        bool isArray = (n.find('[') != std::string::npos);
        //allows "parent.child", search for "parent" here, and within for "child"
        std::string::size_type pos = n.find('.');

        if (isCompound && !isArray) {
            std::string::size_type pos = n.find('.');
            //n is parent.child type name
            std::string parent_name = n.substr(0, pos);
            std::string child_name = n.substr(pos + 1);
            if (this->isVariable(parent_name)) {
                Variable *parent = this->getVariable(parent_name);
                return parent->getSubVar(child_name);
            } else {
                TERMINATE("Module.cpp getVariable called with \"" + n + "\", not a variable name");
            }
        } else if (!isCompound && isArray) {
            std::string::size_type start = n.find('[');
            std::string::size_type end = n.find(']');
            //n is parent[child]
            std::string varName = n.substr(0, start);
            std::string index = n.substr(start + 1, end - start - 1);
            if (this->isVariable(varName)) {
                auto parent = this->getVariable(varName);
                return parent->getSubVar(index);
            } else {
                TERMINATE("Module.cpp getVariable called with \"" + n + "\", not a variable name");
            }
        } else {
            //n is a regular top level name
            if (this->variableMap.find(n) != this->variableMap.end()) {
                return (this->variableMap.find(n)->second);
            } else {
                TERMINATE("Module.cpp getVariable called with \"" + n + "\", not a variable name");
                return nullptr;
            }

        }

    }

    bool Module::isVariable(const std::string &n) const {

        //allows "parent.child", search for "parent" here, and within for "child"
        bool isCompound = (n.find('.') != std::string::npos);
        bool isArray = (n.find('[') != std::string::npos);
        if (isCompound && !isArray) {
            std::string::size_type pos = n.find('.');
            //n is parent.child type name
            std::string parent_name = n.substr(0, pos);
            std::string child_name = n.substr(pos + 1);
            if (this->isVariable(parent_name)) {
                Variable *parent = this->getVariable(parent_name);
                return (parent->isCompoundType() && parent->hasSubVar(child_name));
            } else {
                return false;
            }
        } else if (!isCompound && isArray) {
            std::string::size_type start = n.find('[');
            std::string::size_type end = n.find(']');
            //n is parent[child]
            std::string varName = n.substr(0, start);
            std::string index = n.substr(start + 1, end - start - 1);
            if (this->isVariable(varName)) {
                auto parent = this->getVariable(varName);
                return (parent->isArrayType() && parent->hasSubVar(index));
            } else {
                return false;
            }
        } else {
            //n is a regular top level name
            return (this->variableMap.find(n) != this->variableMap.end());
        }
    }

    bool Module::isSlave() const {
        for (auto port: this->ports) {
            if (port.second->getInterface()->isSlaveIn() || port.second->getInterface()->isSlaveOut()) return true;
        }
        return false;
    }

    void Module::removeVariable(Variable *variable) {
        assert(false && "not allowed");
        assert(variable != nullptr);
        assert(!variable->isSubVar()); //Is not correctly implemented
        if (variable->isSubVar()) {
            auto parent = variable->getParent();
            //parent->removeSubVar(variable);
        } else {
            if (this->variableMap.find(variable->getName()) != this->variableMap.end()) {
                this->variableMap.erase(variable->getName());
            } else TERMINATE("Variable " + variable->getFullName() + " not part of module " + this->getName());
        }

    }

    const std::map<std::string, Function *> &Module::getFunctionMap() const {
        return functionMap;
    }

    void Module::addFunction(Function *function) {
        this->functionMap.insert(std::make_pair(function->getName(), function));

    }

    Function *Module::getFunction(std::string name) {
        if (functionMap.find(name) == functionMap.end()) {
            TERMINATE("Function " + name + " is not part of module " + this->getName());
        } else return functionMap.find(name)->second;
    }

    bool Module::isFunction(std::string name) const {
        return functionMap.find(name) != functionMap.end();
    }

    std::shared_ptr<PropertySuite> Module::getPropertySuite() const {
        return propertySuite;
    }

    void Module::setPropertySuite(std::shared_ptr<PropertySuite> propertySuite) {
        Module::propertySuite = propertySuite;
    }

    std::map<int, DESCAM::CfgNode *> Module::getCFG() const {
        return this->cfg;
    }

    std::multimap<std::string, std::vector<DESCAM::CfgNode *>> Module::getcommGroups() const {
        return this->commGroups;
    }

//    std::map<int, DESCAM::CfgNode *> Module::getCFG_Original() const {
//        return this->cfg_Original;
//    }
//
//    std::map<int, DESCAM::CfgNode *> Module::getCFG_Implicit() const {
//        return this->cfg_Implicit;
//    }

    void Module::setCFG(std::map<int, DESCAM::CfgNode *> cfg_arg) {
        this->cfg = std::move(cfg_arg);
    }

    void Module::setCFG(std::map<int, DESCAM::CfgNode *> cfg_arg, std::multimap<std::string, std::vector<DESCAM::CfgNode *>> commGroups_arg) {
        this->cfg = std::move(cfg_arg);
        this->commGroups = std::move(commGroups_arg);
    }

    void Module::removeFunction(std::string functionName) {
        this->functionMap.erase(functionName);
    }

    void Module::setVariableMap(const std::map<std::string, Variable *> &variableMap) {
        Module::variableMap = variableMap;
    }

//    void Module::setCFG_Original(std::map<int, DESCAM::CfgNode *> blockCFG) {
//        this->cfg_Original = std::move(blockCFG);
//    }
//
//    void Module::setCFG_Implicit(std::map<int, DESCAM::CfgNode *> blockCFG) {
//        this->cfg_Implicit = std::move(blockCFG);
//    }
}
