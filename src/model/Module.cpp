//
// Created by ludwig on 10.09.15.
//

#include <Stmts/EnumValue.h>
#include <cassert>
#include "Module.h"
#include "Model.h"

namespace SCAM {

    Module::Module() :
            fsm(new FSM(this)) {
    }

    Module::Module(std::string name) :
            fsm(new FSM(this)),
            AbstractNode(name) {

    }

    Module::~Module() {
        delete this->fsm;

    }

    void Module::addPort(Port *port) {
        this->ports.insert(std::make_pair(port->getName(), port));
    }

    const std::map<std::string, Port *> &Module::getPorts() const {
        return this->ports;
    }

    Port *Module::getPort(const std::string &n) const {
        if (this->ports.find(n) == this->ports.end()) {
            throw std::runtime_error("Module.cpp getPort called with \"" + n + "\", not a port name");
        }
        return this->ports.find(n)->second;
    }

    bool Module::isPort(const std::string &n) const {
        return (this->ports.find(n) != this->ports.end());
    }

    void Module::accept(AbstractVisitor &visitor) {
        visitor.visit(*this);

    }

    void Module::addVariable(Variable *variable) {
        this->variableMap.insert(std::make_pair(variable->getName(), variable));
    }

    FSM *Module::getFSM() const {
        return this->fsm;
    }

    const std::map<std::string, Variable *> &Module::getVariableMap() const {
        return variableMap;
    }


    Variable *Module::getVariable(const std::string &n) const {
        //allows "parent.child", search for "parent" here, and within for "child"
        std::string::size_type pos = n.find('.');
        bool IsSubVarName = (pos != std::string::npos);

        if (!IsSubVarName) {
            //n is a regular top level name
            if (this->variableMap.find(n) != this->variableMap.end()) {
                return (this->variableMap.find(n)->second);
            } else {
                throw std::runtime_error("Module.cpp getVariable called with \"" + n + "\", not a variable name");
                return nullptr;
            }

        } else {
            //n is parent.child type name
            std::string parent_name = n.substr(0, pos);
            std::string child_name = n.substr(pos + 1);
            if (this->isVariable(parent_name)) {
                Variable *parent = this->getVariable(parent_name);
                if (parent->isCompoundType() && parent->hasSubVar(child_name)) {
                    return parent->getSubVar(child_name);
                } else {
                    throw std::runtime_error("Module.cpp getVariable called with \"" + n + "\", not a variable name");
                    return nullptr;
                }
            } else {
                throw std::runtime_error("Module.cpp getVariable called with \"" + n + "\", not a variable name");
                return nullptr;
            }
        }

    }

    bool Module::isVariable(const std::string &n) const {

        //allows "parent.child", search for "parent" here, and within for "child"
        std::string::size_type pos = n.find('.');
        bool IsSubVarName = (pos != std::string::npos);

        if (!IsSubVarName) {
            //n is a regular top level name
            return (this->variableMap.find(n) != this->variableMap.end());

        } else {
            //n is parent.child type name

            std::string parent_name = n.substr(0, pos);
            std::string child_name = n.substr(pos + 1);
            if (this->isVariable(parent_name)) {
                Variable *parent = this->getVariable(parent_name);
                return (parent->isCompoundType() && parent->hasSubVar(child_name));
            } else {
                return false;
            }
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
        std::cout << "MODULE REMOVING: " << variable->getName() << std::endl;
        assert(variable != nullptr);
        assert(!variable->isSubVar()); //Is not correctly implemented
        if (variable->isSubVar()) {
            auto parent = variable->getParent();
            //parent->removeSubVar(variable);
        } else {
            if (this->variableMap.find(variable->getName()) != this->variableMap.end()) {
                this->variableMap.erase(variable->getName());
            } else throw std::runtime_error("Variable " + variable->getFullName() + " not part of module " + this->getName());
        }

    }

    const std::map<std::string, Function *> &Module::getFunctionMap() const {
        return functionMap;
    }

    void Module::addFunction(Function *function) {
        this->functionMap.insert(std::make_pair(function->getName(),function));

    }

    Function *Module::getFunction(std::string name) {
        if(functionMap.find(name) == functionMap.end()){
            throw std::runtime_error("Function " + name + " is not part of module " + this->getName());
        }else return functionMap.find(name)->second;
    }

    bool Module::isFunction(std::string name) const {
        return functionMap.find(name) != functionMap.end();
    }


}
