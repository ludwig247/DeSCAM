//
// Created by tobias on 31.01.20.
//

#include "TrueOperation.h"


SCAM::TrueOperation::TrueOperation(SCAM::Module const *  module):
    stateMap(module->getFSM()->getStateMap()),
    module(module) {
    //TODO: next steps: apply find cycles
    //TODO: add "composed" operations to PropertySuite
    //TODO: check output with hardware
}

void SCAM::TrueOperation::setStartState() {

}

void SCAM::TrueOperation::setRightHook() {

}
