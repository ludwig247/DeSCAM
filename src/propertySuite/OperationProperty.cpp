//
// Created by deutschmann on 20.11.18.
//

#include "OperationProperty.h"

SCAM::OperationProperty::OperationProperty(const std::string &name) : AbstractProperty(name) {

}

void SCAM::OperationProperty::addTiming(Port* port, NotifyTiming t){
    this->notifyTimingMap[port] = t;
}


/** \brief Returns timing information for the given port
 *
 * NotifyTiming specifies the timing behaviour of the notify signals
 * - TT_1: at t+1: myPort_notify = true;
 * - FF_1: at t+1: myPort_notify = false;
 * - FF_e: during[t+1, t_end]: myPort_notify = false;
 * - FT_e: during[t+1, t_end-1]: myPort_notify = false;
 *         at t_end: myPort_notify = true;
 */
SCAM::NotifyTiming SCAM::OperationProperty::getTiming(SCAM::Port *port) {
    return this->notifyTimingMap[port];
}
