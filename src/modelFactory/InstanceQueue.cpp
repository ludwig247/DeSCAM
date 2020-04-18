//
// Created by schmitz on 17.04.20.
//

#include "InstanceQueue.h"


namespace SCAM {

//Constructor
    InstanceQueue::InstanceQueue() {

    }

    InstanceQueue::~InstanceQueue() {

    }

    void InstanceQueue::addToQueue(std::string name, std::string structure, std::string parentModule,
                                   std::string parentInstance, int level, int id) {
        _moduleNames.push_back(structure);
        _instanceNames.push_back(name);
        _parentInstanceNames.push_back(parentInstance);
        _parentModuleNames.push_back(parentModule);
        _level.push_back(level);
        _id.push_back(id);
    }

    void InstanceQueue::addToQueueFront(std::string name, std::string structure, std::string parentModule,
                                   std::string parentInstance, int level, int id) {
        _moduleNames.insert(_moduleNames.begin(), structure);
        _instanceNames.insert(_instanceNames.begin(), name);
        _parentInstanceNames.insert( _parentInstanceNames.begin(), parentInstance);
        _parentModuleNames.insert(_parentModuleNames.begin(), parentModule);
        _level.insert(_level.begin(), level);
        _id.insert(_id.begin(), id);
    }

    bool InstanceQueue::empty() {
        return _instanceNames.empty();
    }

    std::string InstanceQueue::getInst() {
        return _instanceNames.front();
    }
    std::string InstanceQueue::getMod() {
        return _moduleNames.front();
    }
    std::string InstanceQueue::getParentInst() {
        return _parentInstanceNames.front();
    }
    std::string InstanceQueue::getParentMod() {
        return _parentModuleNames.front();
    }

    int InstanceQueue::getLevel() {
        return _level.front();
    }

    int InstanceQueue::getID() {
        return _id.front();
    }

    void InstanceQueue::clean() {
        _instanceNames.erase(_instanceNames.begin());
        _moduleNames.erase(_moduleNames.begin());
        _parentInstanceNames.erase(_parentInstanceNames.begin());
        _parentModuleNames.erase(_parentModuleNames.begin());
        _level.erase(_level.begin());
        _id.erase(_id.begin());
    }
}