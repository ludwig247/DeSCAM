//
// Created by tobias on 11.09.15.
//

#include "ModuleInstance.h"
#include "Port.h"

SCAM::ModuleInstance::ModuleInstance(std::string name, Module *structure) :
        structure(structure),
        parentModule(nullptr),
        parentInstance(nullptr),
        AbstractNode(name) {
}

SCAM::ModuleInstance::ModuleInstance(std::string name, Module *structure, Module *parentModule, ModuleInstance *parentInstance) :
        structure(structure),
        parentModule(parentModule),
        parentInstance(parentInstance),
        AbstractNode(name) {
}

SCAM::ModuleInstance::~ModuleInstance() {
}


void SCAM::ModuleInstance::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

void SCAM::ModuleInstance::addSubmoduleInstance(SCAM::ModuleInstance *moduleInstance) {
    auto entry = std::pair<std::string, ModuleInstance *>(moduleInstance->getName(), moduleInstance);
    this->submoduleInstanceMap.insert(entry);
}

std::map<std::string, SCAM::ModuleInstance *> SCAM::ModuleInstance::getSubmoduleInstances() {
    return this->submoduleInstanceMap;
}

SCAM::Module *SCAM::ModuleInstance::getStructure() {
    return this->structure;
}

SCAM::Module *SCAM::ModuleInstance::getParent() {
    return this->parentModule;
}

SCAM::ModuleInstance *SCAM::ModuleInstance::getParentInstance() {
    return this->parentInstance;
}

void SCAM::ModuleInstance::addChannel(SCAM::Channel *channel) {
    this->channelMap.insert(std::make_pair(channel->getName(), channel));
}

std::map<std::string, SCAM::Channel *> SCAM::ModuleInstance::getChannelMap() {
    return this->channelMap;
}

SCAM::ModuleInstance::ModuleInstance() :
        structure(nullptr),
        AbstractNode("TopInstance"),
        parentModule(nullptr),
        parentInstance(nullptr) {
}

SCAM::Channel *SCAM::ModuleInstance::getChannel(SCAM::Port *port) {
    //Creat portChannelMap
    //Only possible after Channels have been fully created
    //FIXME:
    if (this->portChannelMap.empty()) {
        for (auto channel: channelMap) {
            Port *fromPort = channel.second->getFromPort();
            this->portChannelMap.insert(std::make_pair(fromPort, channel.second));

            Port *toPort = channel.second->getToPort();
            this->portChannelMap.insert(std::make_pair(toPort, channel.second));
        }
    }
    //Return port
    return this->portChannelMap.at(port);
}

void SCAM::ModuleInstance::setLevel(int level) {
    _level = level;
}

int SCAM::ModuleInstance::getLevel() {
    return _level;
}

void SCAM::ModuleInstance::setID(int id) {
    _id = id;
}

int SCAM::ModuleInstance::getID() {
    return _id;
}

std::vector<SCAM::ModuleInstance*> SCAM::ModuleInstance::getInstanceSiblings(SCAM::ModuleInstance *moduleInstance) {

    std::vector<ModuleInstance *> siblings;
    ModuleInstance *parentInstance = moduleInstance->getParentInstance();
    if (parentInstance) {
        for (auto it : parentInstance->getSubmoduleInstances()) {
            if (it.second->getID() != moduleInstance->getID()) {
                siblings.push_back(it.second);
            }
        }
    }
    return siblings;
}

std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> SCAM::ModuleInstance::getHierChannelConnectionMap() {
    return this->_hierchannelConnectionMap;
}
std::map<std::pair<std::string,std::string>, std::string> SCAM::ModuleInstance::getChannelConnectionMap() {
    return this->_channelConnectionMap;
}

void SCAM::ModuleInstance::setChannelConnectionMap(std::map<std::pair<std::string,std::string>, std::string> channelConnectionMap) {
    this->_channelConnectionMap = std::move(channelConnectionMap);
}
void SCAM::ModuleInstance::setHierChannelConnectionMap(std::map<std::pair<std::string,std::string>, std::pair<std::string,std::string>> hierChannelConnectionMap) {
    this->_hierchannelConnectionMap = std::move(hierChannelConnectionMap);
}