//
// Created by tobias on 11.09.15.
//

#include "ModuleInstance.h"
#include "Port.h"

SCAM::ModuleInstance::ModuleInstance(std::string name, Module* structure):
    structure(structure),
    AbstractNode(name){
}

SCAM::ModuleInstance::~ModuleInstance() {
}


void SCAM::ModuleInstance::accept(SCAM::AbstractVisitor &visitor) {
    visitor.visit(*this);
}

void SCAM::ModuleInstance::addModuleInstance(SCAM::ModuleInstance *modulInstance) {
    auto entry = std::pair<std::string, ModuleInstance*>(modulInstance->getName(),modulInstance);
    this->moduleInstanceMap.insert(entry);
}

std::map<std::string,SCAM::ModuleInstance *> SCAM::ModuleInstance::getModuleInstances() {
    return this->moduleInstanceMap;
}

SCAM::Module *SCAM::ModuleInstance::getStructure() {
    return this->structure;
}

void SCAM::ModuleInstance::addChannel(SCAM::Channel* channel) {
    this->channelMap.insert(std::make_pair(channel->getName(),channel));


}

std::map<std::string,SCAM::Channel *> SCAM::ModuleInstance::getChannelMap() {
    return this->channelMap;
}

SCAM::ModuleInstance::ModuleInstance():
    structure(nullptr),
    AbstractNode("TopInstance"){
}

SCAM::Channel * SCAM::ModuleInstance::getChannel(SCAM::Port *port) {
    //Creat portChannelMap
    //Only possible after Channels have been fully created
    //FIXME:
    if(this->portChannelMap.empty()){
        for(auto channel: channelMap){
            Port * fromPort = channel.second->getFromPort();
            this->portChannelMap.insert(std::make_pair(fromPort,channel.second));

            Port * toPort = channel.second->getToPort();
            this->portChannelMap.insert(std::make_pair(toPort,channel.second));
        }
    }
    //Return port
    return this->portChannelMap.at(port);
}

