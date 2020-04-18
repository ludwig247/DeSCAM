//
// Created by schmitz on 06.04.20.
//

#include "SVGModuleInstance.h"
#include "SVGPort.h"

SCAM::SVGModuleInstance::SVGModuleInstance(std::string name):
        _name(name),
        _x(0),
        _y(0) {
}

SCAM::SVGModuleInstance::~SVGModuleInstance() {
}

std::map<std::string, SCAM::SVGChannel *> SCAM::SVGModuleInstance::getSVGChannelMap() {
    return this->channelMap;
}

void SCAM::SVGModuleInstance::addSVGChannel(SCAM::SVGChannel *channel) {
    this->channelMap.insert(std::make_pair(channel->getName(), channel));
}

void SCAM::SVGModuleInstance::addSVGModuleInstance(SCAM::SVGModuleInstance *moduleInstance) {
    auto entry = std::pair<std::string, SVGModuleInstance *>(moduleInstance->getSVGName(), moduleInstance);
    this->submoduleInstanceMap.insert(entry);
}

std::map<std::string, SCAM::SVGModuleInstance *> SCAM::SVGModuleInstance::getSVGModuleInstances() {
    return this->submoduleInstanceMap;
}

void SCAM::SVGModuleInstance::setX(int x) {
    _x = x;
}

void SCAM::SVGModuleInstance::setY(int y) {
    _y = y;
}

void SCAM::SVGModuleInstance::setWidth(int width) {
    _width = width;
}

void SCAM::SVGModuleInstance::setHeight(int height) {
    _height = height;
}

void SCAM::SVGModuleInstance::setLevel(int level) {
    _level = level;
}

void SCAM::SVGModuleInstance::setParentName(std::string name) {
    _parentname = name;
}

int SCAM::SVGModuleInstance::getX() {
    return this->_x;
}

int SCAM::SVGModuleInstance::getY() {
    return this->_y;
}

int SCAM::SVGModuleInstance::getWidth() {
    return this->_width;
}

int SCAM::SVGModuleInstance::getHeight() {
    return this->_height;
}

int SCAM::SVGModuleInstance::getLevel() {
    return this->_level;
}

std::string SCAM::SVGModuleInstance::getSVGName() {
    return this->_name;
}

std::string SCAM::SVGModuleInstance::getParentName() {
    return this->_parentname;
}

void SCAM::SVGModuleInstance::increaseWidth(int x) {
    _width += x;
}

void SCAM::SVGModuleInstance::increaseHeight(int x) {
    _height += x;
}

std::map<std::string, SCAM::SVGPort *> SCAM::SVGModuleInstance::getSVGPortMap() {
    return this->portMap;
}

void SCAM::SVGModuleInstance::addSVGPort(SVGPort *port) {
    this->portMap.insert(std::make_pair(port->getName(), port));
}

void SCAM::SVGModuleInstance::setChannelLevel(int x) {
    _channellevel = x;
}

void SCAM::SVGModuleInstance::setStructural(bool structural) {
    _structural = structural;
}

bool SCAM::SVGModuleInstance::getStructural() {
    return this->_structural;
}

int SCAM::SVGModuleInstance::getChannelLevel() {
    return this->_channellevel;
}

int SCAM::SVGModuleInstance::getLongestChannelName() {
    int helper = 0;
    for (const auto& chan: channelMap) {
        if (chan.first.length() > helper) helper = chan.first.length();
    }
    return helper;
}

std::string SCAM::SVGModuleInstance::getModuleName() {
    return this->_modulename;
}

void SCAM::SVGModuleInstance::setModuleName(std::string name) {
    _modulename = name;
}