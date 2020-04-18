//
// Created by schmitz on 06.04.20.
//

#include "SVGPort.h"

SCAM::SVGPort::SVGPort(std::string name) :
        _name(name) {
}



SCAM::SVGPort::~SVGPort() {
}

std::string SCAM::SVGPort::getName() {
    return this->_name;
}

int SCAM::SVGPort::getx(){
    return this->_x;
}


int SCAM::SVGPort::gety(){
    return this->_y;
}

void SCAM::SVGPort::setx(int x){
    _x = x;
}

void SCAM::SVGPort::sety(int y){
    _y = y;
}

void SCAM::SVGPort::setChannel(std::string channel){
    _channel = channel;
}

std::string SCAM::SVGPort::getChannel() {
    return this->_channel;
}




