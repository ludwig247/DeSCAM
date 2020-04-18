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

    void Model::addModuleInstance(ModuleInstance* modInstance) {
        auto entry = std::pair<std::string, ModuleInstance *>(modInstance->getName(), modInstance);
        this->moduleInstanceMap.insert(entry);
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

    void Model::removeGlobalFunction(Function * function) {
        this->globalFunctionMap.erase(function->getName());
    }

    void Model::addGlobalFunction(Function * function) {
        if(function == nullptr) throw std::runtime_error("Passing nullptr as functino");
        this->globalFunctionMap.insert(std::make_pair(function->getName(),function));
    }

    const std::map<std::string, Function *> &Model::getGlobalFunctionMap() const {
        return globalFunctionMap;
    }

    ModuleInstance* Model::findInstance(std::string name, int level) {
        std::vector<ModuleInstance*> queue;
        queue.push_back(topInstance);
        if (level == 0) {return topInstance; }
        while(!queue.empty()) {
            for (auto children: queue.front()->getSubmoduleInstances()) {
                if (children.second->getLevel() == level && children.second->getName() == name) {
                    return children.second;
                }
                if (children.second->getStructure()->isStructural()) {
                    queue.push_back(children.second);
                }
            }
            queue.erase(queue.begin());
        }
        return nullptr;
    }

    ModuleInstance* Model::findInstance(int id) {
        std::vector<ModuleInstance*> queue;
        queue.push_back(topInstance);
        if (id == 0) {return topInstance; }
        while(!queue.empty()) {
            for (auto children: queue.front()->getSubmoduleInstances()) {
                if (children.second->getID() == id) {
                    return children.second;
                }
                if (children.second->getStructure()->isStructural()) {
                    queue.push_back(children.second);
                }
            }
            queue.erase(queue.begin());
        }
        return nullptr;
    }

    std::vector<ModuleInstance*> Model::getInstancesAtLevel(int level) {
        std::vector<ModuleInstance*> queue;
        std::vector<ModuleInstance*> InstancesAtLevel;
        queue.push_back(topInstance);
        if (level == 0) {return queue; }
        while(!queue.empty()) {
            for (auto children: queue.front()->getSubmoduleInstances()) {
                if (children.second->getLevel() == level) {
                    InstancesAtLevel.push_back(children.second);
                }
                if (children.second->getStructure()->isStructural()) {
                    queue.push_back(children.second);
                }
            }
            queue.erase(queue.begin());
        }
        return InstancesAtLevel;
    }

}
