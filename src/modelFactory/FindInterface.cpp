//
// Created by ludwig on 22.09.15.
//

#include <iostream>
#include "FindInterface.h"
#include "ModelFactory.h"

//Constructor
/*!
 * \brief portTemplateList = { sc_port, sc_fifo_in, bool } extract port describition from list
 */
SCAM::FindInterface::FindInterface(const std::vector<std::string> &portTemplateList):
        blocking(false){
    _direction="unkown";
    _interface="unkown";

    if(portTemplateList.front() == "sc_in"){
        _direction="in";
        _interface="sc_in";
    }
    else  if(portTemplateList.front() == "sc_out"){
        _direction="out";
        _interface="sc_out";
    }
    else  if(portTemplateList.front() == "sc_port"){
        if(portTemplateList.size() != 3) throw std::runtime_error("Too few or too many portTemplates Arguments");
        if(portTemplateList.at(1) == "sc_fifo_in_if"){
            _direction="in";
            _interface="sc_fifo_in_if";
            blocking = true;
        }
        else if(portTemplateList.at(1) == "sc_fifo_out_if"){
            _direction="out";
            _interface="sc_fifo_out_if";
            blocking = true;
        }
        else llvm::errs() << portTemplateList.at(1) << " unknown interface type \n";
    }
    else llvm::errs() << portTemplateList.front() << " unknown interface type \n";


}

//Destructor
SCAM::FindInterface::~FindInterface() {
}


//GETTER
//TODO: Add error in case of wrong statement
std::string SCAM::FindInterface::getDirection() {
    return _direction;
}

std::string SCAM::FindInterface::getInterface() {
    return _interface;
}

