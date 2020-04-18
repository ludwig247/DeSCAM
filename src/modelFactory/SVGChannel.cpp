//
// Created by schmitz on 06.04.20.
//

#include "SVGChannel.h"
#include "SVGPort.h"
#include "SVGModuleInstance.h"

namespace SCAM {

    SVGChannel::SVGChannel(std::string name) :
            _name(name),
            _toPort(nullptr),
            _fromPort(nullptr),
            _toInstance(nullptr),
            _fromInstance(nullptr){
    }


    SVGChannel::~SVGChannel() {
    }

    std::string SVGChannel::getName() {
        return this->_name;
    }

    int SVGChannel::getxStart() {
        return this->_x_start;
    }

    int SVGChannel::getxEnd() {
        return this->_x_end;
    }

    int SVGChannel::gety() {
        return this->_y;
    }

    void SVGChannel::setxStart(int x) {
        _x_start = x;
    }

    void SVGChannel::setxEnd(int x) {
        _x_end = x;
    }

    void SVGChannel::sety(int y) {
        _y = y;
    }

    void SVGChannel::setChannelParent(std::string name) {
        _channelparent = name;
    }

    std::string SVGChannel::getChannelParent() {
        return this->_channelparent;
    }

    SVGPort* SVGChannel::getFromSVGPort() {
        return this->_fromPort;
    }

    SVGPort *SVGChannel::getToSVGPort() {
        return this->_toPort;
    }

    SVGModuleInstance *SVGChannel::getFromSVGInstance() {
        return this->_fromInstance;
    }

    void SVGChannel::setFromSVGPort(SCAM::SVGPort *port) {
        _fromPort = port;
    }

    void SVGChannel::setToSVGPort(SCAM::SVGPort *port) {
        _toPort = port;
    }

    void SVGChannel::setFromSVGInstance(SCAM::SVGModuleInstance *instance) {
        _fromInstance = instance;
    }

    void SVGChannel::setToSVGInstance(SCAM::SVGModuleInstance *instance) {
        _toInstance = instance;
    }


}
