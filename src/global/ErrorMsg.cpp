//
// Created by tobias on 10.06.16.
//

#include "ErrorMsg.h"

SCAM::ErrorMsg &SCAM::ErrorMsg::getInstance() {
    static ErrorMsg instance;
    return instance;
}

std::vector<SCAM::ErrorMsg::Error> SCAM::ErrorMsg::getErrorList() {
    return ErrorMsg::getInstance().errorList;
}

void SCAM::ErrorMsg::addError(std::string msg, std::string astMsg, std::string file, std::string loc) {
    //Add new error to errorMsgs
    ErrorMsg::getInstance().errorList.emplace_back(msg, astMsg, file, loc, ErrorMsg::getInstance().errorMsgs);
    //Remove old errorMsg from the log
    ErrorMsg::getInstance().errorMsgs.clear();
}

bool SCAM::ErrorMsg::hasError() {
    return !ErrorMsg::getInstance().errorList.empty();
}

void SCAM::ErrorMsg::addErrorLog(std::string errorMsg, std::string severityLevel) {
    ErrorMsg::getInstance().errorMsgs.insert(std::make_pair(errorMsg,severityLevel));
}

void SCAM::ErrorMsg::clear() {
    ErrorMsg::getInstance().errorMsgs.clear();
    ErrorMsg::getInstance().errorList.clear();
}

