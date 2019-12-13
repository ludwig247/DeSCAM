//
// Created by ludwig on 10.09.15.
//


#include <DataTypes.h>
#include "Model.h"


namespace SCAM {

    Model::Model() :
            AbstractNode("Model_name_undefined"),
            topInstance(nullptr) {
    }

    Model::Model(std::string name) :
            AbstractNode(name),
            topInstance(nullptr) {
    }

    Model::~Model() {
        std::cout << "Destructing model" << std::endl;
        DataTypes::reset();
        for (auto module : moduleMap) {
            delete module.second;
        }
    }

    void Model::addModule(Module *module) {
        this->moduleMap.insert(std::make_pair(module->getName(), module));
    }

    void Model::accept(AbstractVisitor &visitor) {
        visitor.visit(*this);
    }

    std::map<std::string, Module *> Model::getModules() {
        return this->moduleMap;
    }

    void Model::addTopInstance(ModuleInstance *instance) {
        if (this->topInstance != nullptr) {
            throw std::runtime_error("model::addTopInstance: instance already set, resetting is not possbile");
        }
        this->topInstance = instance;
    }

    const std::map<std::string, ModuleInstance *> &Model::getModuleInstanceMap() const {
        return moduleInstanceMap;
    }

    ModuleInstance *Model::getTopInstance() const {
        return topInstance;
    }

    void Model::addGlobalVariable(Variable *variable) {
        if(variable == nullptr) throw std::runtime_error("Passing nullptr to var");
        this->globalVariableMap.insert(std::make_pair(variable->getName(),variable));

    }

    const std::map<std::string, Variable *> &Model::getGlobalVariableMap() const {
        return globalVariableMap;
    }

    void Model::removeGlobalVariable(Variable *variable) {
        this->globalVariableMap.erase(variable->getName());
    }

}
