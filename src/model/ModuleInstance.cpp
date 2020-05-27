//
// Created by tobias on 11.09.15.
//

#include "ModuleInstance.h"
#include "Port.h"

DESCAM::ModuleInstance::ModuleInstance(std::string name, Module *structure, LocationInfo locationInfo) :
        structure(structure),
        AbstractNode(name,locationInfo) {
}

DESCAM::ModuleInstance::~ModuleInstance() {
}


void DESCAM::ModuleInstance::accept(DESCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

void DESCAM::ModuleInstance::addModuleInstance(DESCAM::ModuleInstance *modulInstance) {
    auto entry = std::pair<std::string, ModuleInstance *>(modulInstance->getName(), modulInstance);
    this->moduleInstanceMap.insert(entry);
}

std::map<std::string, DESCAM::ModuleInstance *> DESCAM::ModuleInstance::getModuleInstances() {
    return this->moduleInstanceMap;
}

DESCAM::Module *DESCAM::ModuleInstance::getStructure() {
    return this->structure;
}

void DESCAM::ModuleInstance::addChannel(DESCAM::Channel *channel) {
    this->channelMap.insert(std::make_pair(channel->getName(), channel));


}

std::map<std::string, DESCAM::Channel *> DESCAM::ModuleInstance::getChannelMap() {
    return this->channelMap;
}

DESCAM::ModuleInstance::ModuleInstance() :
        structure(nullptr),
        AbstractNode("TopInstance") {
}

DESCAM::Channel *DESCAM::ModuleInstance::getChannel(DESCAM::Port *port) {
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

